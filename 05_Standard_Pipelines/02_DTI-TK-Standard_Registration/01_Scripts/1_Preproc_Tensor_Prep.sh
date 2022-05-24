##################################################
#
# Prep Processed Tensors for DTI-TK Registration
# Kayti Keith - 11/10/20
#
##################################################
export base=/path/to/study
export pyd=$base/path/to/pydesigner/outputs
export tensorp=$base/03_Analysis/01_Tensor_Prep
export thr=0.4

ids=("subj1" "subj2" "subj3")

mkdir $base/03_Analysis
mkdir $tensorp

##########################################
# 1. After preprocessing file organization
##########################################

for i in ${ids[@]} ; do 
  mkdir $tensorp/${i}
  for ft in nii bvec bval nii ; do
    cp $pyd/${i}/dwi_preprocessed.${ft} $tensorp/${i}/dwi_preprocessed.${ft}
  done
done

##########################################
# 2. BET and BET QC
##########################################

for i in ${ids[@]} ; do 
  bet $tensorp/${i}/dwi_preprocessed.nii $tensorp/${i}/dwi_preprocessed_bet.nii -f $thr
  fslmaths $tensorp/${i}/dwi_preprocessed_bet.nii -bin $tensorp/${i}/dwi_preprocessed_mask.nii
done

# 2.a QC BET
mkdir $tensorp/BET_QC
for i in ${ids[@]} ; do 
  cp $tensorp/${i}/dwi_preprocessed_bet.nii.gz $tensorp/BET_QC/${i}_dwi_preprocessed_bet.nii.gz
  cp $tensorp/${i}/dwi_preprocessed_mask.nii.gz $tensorp/BET_QC/${i}_dwi_preprocessed_mask.nii.gz
done

############# QC BET outputs and rerun if need be; change threshold (thr) above if need be

gunzip $tensorp/*/*.nii.gz

# 2.b Delete BET_QC folder if desired
rm -r $tensorp/BET_QC

##########################################
# 3. Skull Stripped Tensor Prep
##########################################

# 3.a dtifit
for i in ${ids[@]} ; do 
  dtifit --data=$tensorp/${i}/dwi_preprocessed.nii --out=$tensorp/${i}/dti --mask=$tensorp/${i}/dwi_preprocessed_mask.nii --bvecs=$tensorp/${i}/dwi_preprocessed.bvec --bvals=$tensorp/${i}/dwi_preprocessed.bval --save_tensor
done


# 3.b fsl_to_dtitk
for i in ${ids[@]} ; do 
  cd $tensorp/${i}/
  fsl_to_dtitk dti
done

gunzip $tensorp/*/*.nii.gz 


##########################################
# 4. Delete extraneous files
##########################################

for i in ${ids[@]} ; do 
  for f in L1 L2 L3 MD MO S0 V1 V2 V3 FA ; do
    rm $tensorp/${i}/dti_${f}.nii*
  done
done
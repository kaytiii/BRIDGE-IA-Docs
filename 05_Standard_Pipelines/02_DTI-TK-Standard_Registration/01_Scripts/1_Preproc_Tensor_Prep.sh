##################################################
#
# Prep Processed Tensors for DTI-TK Registration
# Kayti Keith - 11/10/20
#
##################################################
export base=/home/kak240/Desktop/IAM_PyDesigner
export ID_file=/home/kak240/Desktop/IAM_PyDesigner/IDs.txt
SUBJ_IDs=$(cat $ID_file)

mkdir $base/03_Analysis
mkdir $base/03_Analysis/01_Tensor_Prep

##########################################
# 1. After preprocessing file organization
##########################################

for i in $SUBJ_IDs ; do 
  mkdir $base/03_Analysis/01_Tensor_Prep/${i}
  for ft in nii bvec bval nii ; do
    cp $base/02_Data/${i}/dwi_preprocessed.${ft} $base/03_Analysis/01_Tensor_Prep/${i}/dwi_preprocessed.${ft}
  done
done

##########################################
# 2. BET and BET QC
##########################################

export tensors=$base/03_Analysis/01_Tensor_Prep
for i in $SUBJ_IDs ; do 
  bet $tensors/${i}/dwi_preprocessed.nii $tensors/${i}/dwi_preprocessed_bet.nii -f 0.4
  fslmaths $tensors/${i}/dwi_preprocessed_bet.nii -bin $tensors/${i}/dwi_preprocessed_mask.nii
done

gunzip $tensors/*/*.nii.gz

# 2.a QC BET
mkdir $tensors/BET_QC
for i in $SUBJ_IDs ; do 
  cp $tensors/${i}/dwi_preprocessed_bet.nii $tensors/BET_QC/${i}_dwi_preprocessed_bet.nii
  cp $tensors/${i}/dwi_preprocessed_mask.nii $tensors/BET_QC/${i}_dwi_preprocessed_mask.nii
done

# 2.b Delete BET_QC folder if desired
rm -r $tensors/BET_QC

##########################################
# 3. Skull Stripped Tensor Prep
##########################################

# 3.a dtifit
export tensors=$base/03_Analysis/01_Tensor_Prep
for i in $SUBJ_IDs ; do 
  dtifit --data=$tensors/${i}/dwi_preprocessed.nii --out=$tensors/${i}/dti --mask=$tensors/${i}/dwi_preprocessed_mask.nii --bvecs=$tensors/${i}/dwi_preprocessed.bvec --bvals=$tensors/${i}/dwi_preprocessed.bval --save_tensor
done


# 3.b fsl_to_dtitk
for i in $SUBJ_IDs ; do 
  cd $base/03_Analysis/01_Tensor_Prep/${i}/
  fsl_to_dtitk dti
done

gunzip $tensors/*/*.nii.gz 


##########################################
# 4. Delete extraneous files
##########################################

for i in $SUBJ_IDs ; do 
  for f in L1 L2 L3 MD MO S0 V1 V2 V3 FA ; do
    rm $tensors/${i}/dti_${f}.nii*
  done
done

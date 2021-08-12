##################################################
#
# Prep Processed Tensors for DTI-TK Registration
# Kayti Keith - 11/10/20
#
##################################################
export base=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL
mkdir $base/03_Analysis
mkdir $base/03_Analysis/01_Tensor_Prep

##########################################
# 1. After preprocessing file organization
##########################################

for ID in ID1 ID2 ID3 ... IDn ; do
  mkdir $base/03_Analysis/01_Tensor_Prep/${ID}
  #cp $base/02_Data/01_DKE/${ID}/4d.nii $base/03_Analysis/01_Tensor_Prep/${ID}/dwi_preprocessed.nii
  for ft in bvec bval nii ; do
    cp $base/02_Data/01_DKE/${ID}/dwi_preprocessed.${ft} $base/03_Analysis/01_Tensor_Prep/${ID}/dwi_preprocessed.${ft}
  done
done

rm $base/03_Analysis/01_Tensor_Prep/*/*30dir*

for ID in ID1 ID2 ID3 ... IDn ; do
  for ft in bvec bval ; do
    mv $base/03_Analysis/01_Tensor_Prep/${ID}/DKI1_2.5mm_15cm.${ft} $base/03_Analysis/01_Tensor_Prep/${ID}/dwi_preprocessed.${ft}
    mv $base/03_Analysis/01_Tensor_Prep/${ID}/DKI_BIPOLAR_2.5mm_64dir_Trio.${ft} $base/03_Analysis/01_Tensor_Prep/${ID}/dwi_preprocessed.${ft}
  done
done

##########################################
# 2. BET and BET QC
##########################################

export tensors=$base/03_Analysis/01_Tensor_Prep
for ID in ID1 ID2 ID3 ... IDn ; do
  bet $tensors/${ID}/dwi_preprocessed.nii $tensors/${ID}/dwi_preprocessed_bet.nii -f 0.75
  fslmaths $tensors/${ID}/dwi_preprocessed_bet.nii -bin $tensors/${ID}/dwi_preprocessed_mask.nii
done

gunzip $tensors/*/*.nii.gz

# 2.a QC BET
mkdir $tensors/BET_QC
for ID in ID1 ID2 ID3 ... IDn ; do
  cp $tensors/${ID}/dwi_preprocessed_bet.nii $tensors/BET_QC/${ID}_dwi_preprocessed_bet.nii
  cp $tensors/${ID}/dwi_preprocessed_mask.nii $tensors/BET_QC/${ID}_dwi_preprocessed_mask.nii
done

# 2.b Delete BET_QC folder if desired
rm -r $tensors/BET_QC

##########################################
# 3. Skull Stripped Tensor Prep
##########################################

# 3.a dtifit
export tensors=$base/03_Analysis/01_Tensor_Prep
for ID in ID1 ID2 ID3 ... IDn ; do
  dtifit --data=$tensors/${ID}/dwi_preprocessed.nii --out=$tensors/${ID}/dti --mask=$tensors/${ID}/dwi_preprocessed_mask.nii --bvecs=$tensors/${ID}/dwi_preprocessed.bvec --bvals=$tensors/${ID}/dwi_preprocessed.bval --save_tensor
done


# 3.b fsl_to_dtitk
for ID in ID1 ID2 ID3 ... IDn ; do
  cd $base/03_Analysis/01_Tensor_Prep/${ID}/
  fsl_to_dtitk dti
done

gunzip $tensors/*/*.nii.gz 

##########################################
# 4. Delete extraneous files
##########################################

for ID in $SUBJ_IDs ; do
  for f in L1 L2 L3 MD MO S0 V1 V2 V3 FA ; do
    rm $tensors/${ID}/dti_${f}.nii*
  done
done
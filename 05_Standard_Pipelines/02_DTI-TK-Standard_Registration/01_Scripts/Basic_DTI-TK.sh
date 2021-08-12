####################################
#	DTI-TK Registration
####################################

# Typically I work in two different folders, a folder in which I prep tensors before 
#     registration ('Tensor_Prep') and one folder in which I do the registration itself
#     ('Registration').

mkdir Tensor_Prep
mkdir Registration

# Tensor Preparation 
for i in Subj1 Subj2 Subj3 ; do
  mkdir Tensor_Prep/${i}
  bet preprocessed_B0.nii preprocessed_B0_ss.nii -f 0.2 -m # Creates a skull stripped diffusion space mask for next step
  gunzip preprocessed_B0_ss_mask.nii.gz # Unzips mask
  dtifit --data=dwi_preprocessed.nii --out=Tensor_Prep/${i}/dti --mask=preprocessed_B0_ss_mask.nii --bvecs=dwi_preprocessed.bvec --bvals=dwi_preprocessed.bval --save_tensor # FSL's dtifit used to calculate tensor from preprocessed data
  cd Tensor_Prep/${i}
  fsl_to_dtitk dti # DTI-TK's fsl_to_dtitk converts tensor into correct format for DTI-TK
  cd ~
  for f in L1 L2 L3 MD MO S0 V1 V2 V3 FA ; do
    rm Tensor_Prep/${i}/dti_${f}.nii* # Removes all extraneous files created by dtifit
  done
  mv Tensor_Prep/${i}/dti_dtitk.nii Tensor_Prep/${i}/${i}_dti_dtitk.nii # Renames prepped tensor so that filename includes subject ID
  cp Tensor_Prep/${i}/${i}_dti_dtitk.nii  Registration/${i}_dti_dtitk.nii # Moves prepped tensors to new folder for registration 
done

# Registration
cd Registration

ls * > subjs.txt # Creates ID file 
TVMean -in subjs.txt -out mean_initial.nii.gz # Creates bootstrapped population specific template
TVResample -in mean_initial.nii.gz -align center -size 128 128 64 -vsize 1.5 1.75 2.25 # Resamples the template from previous step 
dti_affine_population mean_initial.nii.gz subjs.txt EDS 3 # Affine registration
TVtool -in mean_affine3.nii.gz -tr # Computes trace map
BinaryThresholdImageFilter mean_affine3_tr.nii.gz mask.nii.gz 0.01 100 1 0 # Creates mask
time dti_diffeomorphic_population mean_affine3.nii.gz subjs_aff.txt mask.nii.gz 0.002 # Diffeomorphic registration
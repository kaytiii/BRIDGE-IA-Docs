################################################
#    										     
# DTI-TK Spatial Normalization Prep for TBSS   
# Kayti Keith - 11/10/20				 
#    										     
################################################

export tensors=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/03_Analysis/02_Tensors
export ID_file_nfu=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/01_Protocols/IDs.txt
SUBJ_IDs_nfu=$(cat $ID_file_nfu)
mkdir $tensors

# File Org
cd /Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/03_Analysis/01_Tensor_Prep

for ID in $SUBJ_IDs_all ; do
  mv ${ID}/dti_dtitk.nii ${ID}/${ID}_dti_dtitk.nii 
done

cd /Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/03_Analysis/01_Tensor_Prep

for ID in $SUBJ_IDs_nfu ; do
  cp ${ID}/${ID}_dti_dtitk.nii  $tensors
done

# Registration
cd $tensors

ls A* > subjs.txt

#######################################################################################
# Step 2: Bootstrapping
#######################################################################################

TVMean -in subjs.txt -out mean_initial.nii.gz
 
TVResample -in mean_initial.nii.gz -align center -size 128 128 64 -vsize 1.5 1.75 2.25

#######################################################################################
# Step 3: Affine alignment
#######################################################################################

dti_affine_population mean_initial.nii.gz subjs.txt EDS 3

#######################################################################################
# Step 4: Deformable alignment
#######################################################################################

TVtool -in mean_affine3.nii.gz -tr

BinaryThresholdImageFilter mean_affine3_tr.nii.gz mask.nii.gz 0.01 100 1 0

dti_diffeomorphic_population mean_affine3.nii.gz subjs_aff.txt mask.nii.gz 0.002

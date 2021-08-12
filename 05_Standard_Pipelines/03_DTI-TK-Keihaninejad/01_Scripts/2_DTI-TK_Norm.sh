################################################
#    										     
# DTI-TK Spatial Normalization Prep for TBSS   
# Kayti Keith - 11/10/20				 
#    										     
################################################

export tensors=/Path/to/study/03_Analysis/02_Tensors
export ID_file_all=/Path/to/ID_file/IDs_all.txt #file containing all IDs
export ID_file=/Path/to/ID_file/IDs.txt #file containing only BL IDs

SUBJ_IDs_all=$(cat $ID_file_all)
SUBJ_IDs=$(cat $ID_file)

# Within-Subjects
cd /Path/to/study/03_Analysis/03_Analysis/01_Tensor_Prep

for ID in $SUBJ_IDs_all ; do
  mv ${ID}/dti_dtitk.nii ${ID}/${ID}_dti_dtitk.nii 
done

mkdir Within-Subject

for ID in $SUBJ_IDs ; do
  mkdir Within-Subject/${ID}
  cp ${ID}*/${ID}*_dti_dtitk.nii Within-Subject/${ID}
  printf "${ID}_dti_dtitk.nii\n${ID}_FU_dti_dtitk.nii" > Within-Subject/${ID}/subjs.txt
done

########## W/I subject registration for subjs with BL and FU

for ID in $SUBJ_IDs ; do

  cd /Path/to/study/03_Analysis/01_Tensor_Prep/Within-Subject/${ID}

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
  
done

# File prep for between subj reg

mkdir $tensors
cd /Path/to/study/03_Analysis/03_Analysis/01_Tensor_Prep

for ID in $SUBJ_IDs ; do
  cp Within-Subject/${ID}/${ID}*_dti_dtitk_aff_diffeo.nii.gz $tensors
done

gunzip $tensors/*.nii.gz

for ID in $SUBJ_IDs_all ; do
  mv $tensors/${ID}_dti_dtitk_aff_diffeo.nii $tensors/${ID}_wi_subj.nii
done


# Between-Subjects
cd $tensors

ls * > subjs.txt


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
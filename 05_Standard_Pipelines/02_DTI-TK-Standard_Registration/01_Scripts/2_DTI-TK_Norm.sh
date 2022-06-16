################################################
#    										     
# DTI-TK Spatial Normalization Prep for TBSS   
# Kayti Thorn - 11/10/20				 
#    										     
################################################

export base=/path/to/study
export tensors=$base/03_Analysis/02_Tensors
export tensorp=$base/03_Analysis/01_Tensor_Prep

ids=("subj1" "subj2" "subj3")

mkdir $tensors

#######################################################################################
# 1. File Organization
#######################################################################################
cd $tensorp

for i in ${ids[@]} ; do 
  mv ${i}/dti_dtitk.nii ${i}/${i}_dti_dtitk.nii 
done

for i in ${ids[@]} ; do 
  cp ${i}/${i}_dti_dtitk.nii $tensors
done

#######################################################################################
# 2. Registration
#######################################################################################
cd $tensors

ls * > subjs.txt

########### Check to make sure that subjs.txt lists only actual subjects

# Bootstrapping

TVMean -in subjs.txt -out mean_initial.nii.gz
 
TVResample -in mean_initial.nii.gz -align center -size 128 128 64 -vsize 1.5 1.75 2.25

# Affine alignment

dti_affine_population mean_initial.nii.gz subjs.txt EDS 3

# Deformable alignment

TVtool -in mean_affine3.nii.gz -tr

BinaryThresholdImageFilter mean_affine3_tr.nii.gz mask.nii.gz 0.01 100 1 0

dti_diffeomorphic_population mean_affine3.nii.gz subjs_aff.txt mask.nii.gz 0.002
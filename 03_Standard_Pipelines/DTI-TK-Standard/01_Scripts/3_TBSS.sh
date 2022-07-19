###################################
#    							  
#   Metric Prep for DTI_TK-TBSS   
#      Kayti Thorn - 11/10/20	 	  
#    							  
###################################

export base=/path/to/study
export scalar=$base/03_Analysis/01_Scalar_Prep
export tensors=$base/03_Analysis/02_Tensors
export data=$base/02_Data
export ana=$base/03_Analysis

ids=("subj1" "subj2" "subj3")
dmets=("dti_ad" "dti_rd" "dti_md" "dti_fa" "dki_ak" "dki_rk" "dki_mk")
wmmets=("wmti_eas_rd" "wmti_awf")

mkdir $scalar

#######################################################################################
# 1. File Organization
#######################################################################################
for i in ${ids[@]} ; do 
  mkdir $scalar/${i}
  for m in ${dmets[@]} ; do
    cp $data/${i}/metrics/${m}.nii $scalar/${i}/${m}.nii
  done
  for m in ${wmmets[@]} ; do
    cp $data/${i}/metrics/${m}.nii $scalar/${i}/${m}.nii
  done
done

#######################################################################################
# 2. Combine transformations
#######################################################################################
for i in ${ids[@]} ; do 
  dfRightComposeAffine -aff $tensors/${i}_dti_dtitk.aff -df $tensors/${i}_dti_dtitk_aff_diffeo.df.nii.gz -out $tensors/${i}_combined.df.nii.gz
done

#######################################################################################
# 3. Set metric origin to 0 0 0
#######################################################################################
for i in ${ids[@]} ; do 
  for m in ${dmets[@]} ; do
    TVAdjustVoxelspace -in $scalar/${i}/${m}.nii -origin 0 0 0 -out $scalar/${i}/${m}_000.nii
  done
  for m in ${wmmets[@]} ; do
    TVAdjustVoxelspace -in $scalar/${i}/${m}.nii -origin 0 0 0 -out $scalar/${i}/${m}_000.nii
  done
done

#######################################################################################
# 4. Transform 000 metrics to population space
#######################################################################################
for i in ${ids[@]} ; do 
  for m in ${dmets[@]} ; do
    #gunzip $scalar/${i}/${m}_000.nii.gz
    deformationScalarVolume -in $scalar/${i}/${m}_000.nii -trans $tensors/${i}_combined.df.nii.gz -target $tensors/mean_initial.nii.gz -out $scalar/${i}/${m}_dtitk.nii.gz -vsize 1 1 1
  done
  for m in ${wmmets[@]} ; do
    #gunzip $scalar/${i}/${m}_000.nii.gz
    deformationScalarVolume -in $scalar/${i}/${m}_000.nii -trans $tensors/${i}_combined.df.nii.gz -target $tensors/mean_initial.nii.gz -out $scalar/${i}/${m}_dtitk.nii.gz -vsize 1 1 1
  done
done

#######################################################################################
# 5. TBSS 3 
#######################################################################################
mkdir $ana/03_TBSS
mkdir $ana/03_TBSS/WMM
mkdir $ana/03_TBSS/DKI
mkdir $ana/03_TBSS/stats

# File organization
for m in ${dmets[@]} ; do
  mkdir $ana/03_TBSS/DKI/${m}
  for i in $SUBJ_IDs ; do
    gunzip $scalar/${i}/${m}_dtitk.nii.gz
    cp $scalar/${i}/${m}_dtitk.nii $ana/03_TBSS/DKI/${m}/${i}_${m}.nii
  done
done

for m in ${wmmets[@]} ; do
  mkdir $ana/03_TBSS/WMM/${m}
  for i in ${ids[@]} ; do 
    gunzip $scalar/${i}/${m}_dtitk.nii.gz
    cp $scalar/${i}/${m}_dtitk.nii $ana/03_TBSS/WMM/${m}/${i}_${m}.nii
  done
done

fslmerge -t $ana/03_TBSS/stats/all_FA.nii $ana/03_TBSS/DKI/dti_fa/*dti_fa.nii 
fslmaths $ana/03_TBSS/stats/all_FA.nii -Tmean $ana/03_TBSS/stats/mean_FA.nii 
fslmaths $ana/03_TBSS/stats/mean_FA.nii -bin $ana/03_TBSS/stats/mean_FA_mask.nii
tbss_skeleton -i $ana/03_TBSS/stats/mean_FA.nii -o $ana/03_TBSS/stats/mean_FA_skeleton.nii

#######################################################################################
# 6. TBSS 4
#######################################################################################
cp -R $ana/03_TBSS/stats $ana/03_TBSS/WMM/stats

cd $ana/03_TBSS/WMM/stats
tbss_4_prestats 0.4

gunzip *nii.gz

cp -R $ana/03_TBSS/stats $ana/03_TBSS/DKI/stats

cd $ana/03_TBSS/DKI/stats
tbss_4_prestats 0.2

gunzip *nii.gz

#######################################################################################
# 7. TBSS non-fa
#######################################################################################
# Generate all_[metric]
for m in ${dmets[@]} ; do
  cd $ana/03_TBSS/DKI/${m}
  fslmerge -t all_${m} *${m}.nii
  cp all_${m}.nii.gz $ana/03_TBSS/DKI/stats/all_${m}.nii.gz
done

for m in ${wmmets[@]} ; do
  cd $ana/03_TBSS/WMM/${m}
  fslmerge -t all_${m} *${m}.nii
  cp all_${m}.nii.gz $ana/03_TBSS/WMM/stats/all_${m}.nii.gz
done

# Generate the white matter skeleton from the high-resolution FA map of the DTI template 
cd $ana/03_TBSS/DKI/stats
thresh=0.2
for m in ${dmets[@]} ; do
  tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${m}_skeletonised -a all_${m}
done

cd $ana/03_TBSS/WMM/stats
thresh=0.4
for m in ${wmmets[@]} ; do
  tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${m}_skeletonised -a all_${m}
done

mv $ana/03_TBSS/WMM/stats/all_wmti* $ana/03_TBSS/stats
mv $ana/03_TBSS/DKI/stats/all_d* $ana/03_TBSS/stats
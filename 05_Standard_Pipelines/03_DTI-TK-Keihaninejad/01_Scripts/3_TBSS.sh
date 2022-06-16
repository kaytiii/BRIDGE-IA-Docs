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
export wns=$ana/01_Tensor_Prep/Within-Subject

ids_all=("subj1" "subj2" "subj3" "subj1_FU" "subj2_FU" "subj3_FU")
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

####### Within Subj BL-FU
mkdir $scalar/Within-Subject

for i in $SUBJ_IDs ; do
  cp $wns/${i}/*_dti_dtitk.aff $scalar/Within-Subject
  cp $wns/${i}/*_dti_dtitk_aff_diffeo.df.nii.gz $scalar/Within-Subject
  cp $wns/${i}/mean_initial.nii.gz $scalar/Within-Subject/${i}_mean_initial.nii.gz
done

#######################################################################################
# 2. Combine transformations
#######################################################################################
for i in ${ids[@]} ; do
  dfRightComposeAffine -aff $scalar/Within-Subject/${i}_dti_dtitk.aff -df $scalar/Within-Subject/${i}_dti_dtitk_aff_diffeo.df.nii.gz -out $scalar/Within-Subject/${i}_combined.df.nii.gz
done

#######################################################################################
# 3. Set metric origin to 0 0 0
#######################################################################################
for i in ${ids[@]} ; do
  for m in ${dmets[@]} ; do
    TVAdjustVoxelspace -in $scalar/${i}/${m}.nii -origin 0 0 0 -out $scalar/${i}/${m}_000.nii
  done
done

for i in ${ids[@]} ; do
  for m in ${wmmets[@]} ; do
    TVAdjustVoxelspace -in $scalar/${i}/${m}.nii -origin 0 0 0 -out $scalar/${i}/${m}_000.nii
  done
done

for i in ${ids[@]} ; do
  cp $scalar/Within-Subject/${i}_mean_initial.nii.gz $scalar/Within-Subject/${i}_FU_mean_initial.nii.gz
done

#######################################################################################
# 4. Transform 000 metrics to population space
#######################################################################################
for i in ${ids[@]} ; do
  for m in ${dmets[@]} ; do
    deformationScalarVolume -in $scalar/${i}/${m}_000.nii -trans $scalar/Within-Subject/${i}_combined.df.nii.gz -target $scalar/Within-Subject/${i}_mean_initial.nii.gz -out $scalar/${i}/${m}_ws.nii.gz
  done
done

for i in ${ids[@]} ; do
  for m in ${wmmets[@]} ; do
    deformationScalarVolume -in $scalar/${i}/${m}_000.nii -trans $scalar/Within-Subject/${i}_combined.df.nii.gz -target $scalar/Within-Subject/${i}_mean_initial.nii.gz -out $scalar/${i}/${m}_ws.nii.gz
  done
done

####### Between Subject BL FU
for i in ${ids_all[@]} ; do
  dfRightComposeAffine -aff $dtitk_blfu/${i}_wi_subj.aff -df $dtitk_blfu/${i}_wi_subj_aff_diffeo.df.nii.gz -out $dtitk_blfu/${i}_combined.df.nii.gz
done

gunzip $scalar/*/*.nii.gz

for i in ${ids_all[@]} ; do
  for m in ${dmets[@]} ; do
    deformationScalarVolume -in $scalar/${i}/${m}_ws.nii -trans $dtitk_blfu/${i}_combined.df.nii.gz -target $dtitk_blfu/mean_initial.nii.gz -out $scalar/${i}/${m}_bs.nii.gz
  done
done

#######################################################################################
# 5. TBSS 3 
#######################################################################################
gunzip $scalar/*/*bs.nii.gz

mkdir $ana/03_TBSS
mkdir $ana/03_TBSS/DKI
mkdir $ana/03_TBSS/DKI/fa
mkdir $ana/03_TBSS/DKI/fa/stats

# make alls 
for i in ${ids[@]} ; do
  cp $scalar/${i}/fa_bs.nii $ana/03_TBSS/DKI/fa/stats/${i}_fa_bs.nii
done
fslmerge -t $ana/03_TBSS/DKI/fa/stats/all_FA.nii $ana/03_TBSS/DKI/fa/stats/*_fa_bs.nii
fslmaths $ana/03_TBSS/DKI/fa/stats/all_FA.nii -Tmean $ana/03_TBSS/DKI/fa/stats/mean_FA.nii
fslmaths $ana/03_TBSS/DKI/fa/stats/mean_FA.nii -bin $ana/03_TBSS/DKI/fa/stats/mean_FA_mask.nii 
tbss_skeleton -i $ana/03_TBSS/DKI/fa/stats/mean_FA -o $ana/03_TBSS/DKI/fa/stats/mean_FA_skeleton

for i in ${ids[@]} ; do
  rm $ana/03_TBSS/DKI/fa/stats/${i}_fa_bs.nii
done

# File organization
for m in ${dmets[@]} ; do
  mkdir $ana/03_TBSS/DKI/${metric_DKI}
done

mkdir $ana/03_TBSS/WMM/

for m in ${wmmets[@]} ; do
  mkdir $ana/03_TBSS/WMM/${metric_WMM}
done 

for i in ${ids[@]} ; do  
  for m in ${dmets[@]} ; do
    cp $scalar/${i}/${m}_bs.nii $ana/03_TBSS/DKI/${m}/${i}_${m}.nii
  done
done

for i in ${ids[@]} ; do  
  for m in ${wmmets[@]} ; do
    cp $scalar/${i}/${m}_bs.nii $ana/03_TBSS/WMM/${m}/${i}_${m}.nii
  done
done

mkdir $ana/03_TBSS/DKI/fa/orig 

#######################################################################################
# 6. TBSS 4
#######################################################################################

cp -R $input $output

cd $output
tbss_4_prestats 0.4

cd $output/stats
gunzip *nii.gz
mv $ana/03_TBSS/DKI/fa/*fa.nii $ana/03_TBSS/DKI/fa/orig 

cd $input
tbss_4_prestats 0.2

cd $input/stats
gunzip *nii.gz

#######################################################################################
# 7. TBSS non-fa
#######################################################################################

# Generate all_[metric]
for m in dax kax fa dmean kmean drad krad ; do
  cd $ph1/DKI/${m}
  fslmerge -t all_${m} *${m}.nii
  cp all_${m}.nii.gz $ph1/DKI/fa/stats/all_${m}.nii.gz
done

for m in wmm_de_rad wmm_awf ; do
  cd $ph1/WMM/${m}
  fslmerge -t all_${m} *${m}.nii
  cp all_${m}.nii.gz $ph1/WMM/fa/stats/all_${m}.nii.gz
done

# Generate the white matter skeleton from the high-resolution FA map of the DTI template 
cd $dkistats
thresh=0.2
for m in dax kax fa dmean kmean drad krad ; do
  tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${m}_skeletonised -a all_${m}
done

cd $wmmstats
thresh=0.4
for m in wmm_de_rad wmm_awf ; do
  tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${m}_skeletonised -a all_${m}
done

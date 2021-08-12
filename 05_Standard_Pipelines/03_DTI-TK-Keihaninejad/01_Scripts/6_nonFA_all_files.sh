##################################################
#
# Prep Processed Tensors for DTI-TK Registration
# Kayti Keith - 11/10/20
#
##################################################

# BL FU
export ph1=/Path/to/study/03_Analysis/03_TBSS/Phase1
export ana=/Path/to/study/03_Analysis
export dkistats=$ph1/DKI/fa/stats
export wmmstats=$ph1/WMM/fa/stats

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

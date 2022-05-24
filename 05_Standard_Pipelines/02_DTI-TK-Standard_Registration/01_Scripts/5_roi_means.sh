#############################################
#
#	Generate Stats w fslmeants - UPDATED METHOD 
#	Kayti Keith
#	4/30/20 - Updated 1/12/21
#      
#############################################

export base=/path/to/study
export roiwarps=$ana/04_ROI_Warps
export stats=$base/03_Analysis/03_TBSS/stats
export output=$base/03_Analysis/05_Means
export skelroipath=$base/03_Analysis/04_ROI_Warps/ROIs_skele
export roipath=$base/03_Analysis/04_ROI_Warps
export final=$base/03_Analysis/05_Means

dmets=("dti_ad" "dti_rd" "dti_md" "dti_fa" "dki_ak" "dki_rk" "dki_mk")
wmmets=("wmti_eas_rd" "wmti_awf")
rois=("Accumb" "Amyg" "Body_cc" "CST_Comb" "Cauda" "Cere_ped_Comb" "Cing_hippo" "Fornix_cres_Comb" "Genu_cc" "Hippo" "Pal" "Post_Limb_Int_Cap_Comb" "Put" "SLF_Comb" "Sag_Str_Comb" "Splen_cc" "Sup_Fr_Occ_F_Comb" "Thal" "Unc_Fas_Comb")

mkdir $skelroipath
mkdir $output
mkdir $output/Skele
mkdir $output/Non-Skele

#######################################################################################
# 1. Skeletonize ROIs
#######################################################################################
fslmaths $stats/all_dti_fa_skeletonised.nii.gz -Tmean -bin $stats/dki_skeleton_mask.nii
fslmaths $stats/all_wmti_awf_skeletonised.nii.gz -Tmean -bin $stats/wmm_skeleton_mask.nii
gunzip $stats/*

for r in ${rois[@]} ; do
  fslmaths $roipath/${r}.nii -mul $stats/dki_skeleton_mask.nii $skelroipath/${r}.nii 
  fslmaths $roipath/${r}.nii -mul $stats/wmm_skeleton_mask.nii $skelroipath/${r}_wm.nii
done

rm $stats/dki_skeleton_mask.nii
rm $stats/wmm_skeleton_mask.nii

gunzip $skelroipath/*

#######################################################################################
# 2. Calculate ROI means
#######################################################################################
### non-skele
for m in ${dmets[@]} ; do
  for r in ${rois[@]} ; do
    fslmeants -i $stats/all_${m}.nii.gz -o $output/Non-Skele/${m}_${r}.txt -m $roipath/${r}.nii
  done
done

for m in ${wmmets[@]} ; do
  for r in ${rois[@]} ; do
    fslmeants -i $stats/all_${m}.nii.gz -o $output/Non-Skele/${m}_${r}.txt -m $roipath/${r}.nii
  done
done

### skele - DKI
for m in ${dmets[@]} ; do
  for r in ${rois[@]} ; do
    fslmeants -i $stats/all_${m}_skeletonised.nii.gz -o $output/Skele/${m}_${r}_skele.txt -m $skelroipath/${r}.nii
  done
done


### skele - WMM
for m in ${wmmets[@]} ; do
  for r in ${rois[@]} ; do
    fslmeants -i $stats/all_${m}_skeletonised.nii.gz -o $output/Skele/${m}_${r}_skele.txt -m $skelroipath/${r}_wm.nii
  done
done

####### Combining
mkdir $final/Combined

# Comb - non-skele
export base=$final/Non-Skele

echo ${rois[@]} > $base/_ROI_Labels.txt

for m in ${mets[@]} ; do
  paste $base/${m}* > $base/All_${m}.txt
  cat $base/_ROI_Labels.txt $base/All_${m}.txt > $final/Combined/All_${m}.txt
done
    
# Comb - skele
export base=$final/Skele

echo ${rois[@]} > $base/_ROI_Labels.txt

for m in ${mets[@]} ; do
  paste $base/${m}* > $base/All_${m}.txt
  cat $base/_ROI_Labels.txt $base/All_${m}.txt > $final/Combined/All_${m}_skele.txt
done

# Comb - all
export base=$final/Combined

for m in ${mets[@]} ; do
  paste $base/All_${m}* > $base/${m}.txt
done

for m in ${mets[@]} ; do
  rm $base/All_${m}*
done

# Add ID labels
ls $base/03_Analysis/01_Scalar_Prep > $final/Combined/IDs.txt
xargs -n1 < $final/Combined/IDs.txt > $final/Combined/_IDs.txt

for m in ${mets[@]} ; do
  paste $final/Combined/_IDs.txt $final/Combined/${m}.txt > $final/Combined/All_${m}.txt
  rm $final/Combined/${m}.txt
done

rm $final/Combined/_IDs.txt
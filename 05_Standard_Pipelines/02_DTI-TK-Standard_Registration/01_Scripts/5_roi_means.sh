#############################################
#
#	Generate Stats w fslmeants - UPDATED METHOD 
#	Kayti Keith
#	4/30/20 - Updated 1/12/21
#      
#############################################

export a4ds=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis/03_TBSS/stats
export output=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis/05_Means
export input=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis
export skelroipath=$input/04_ROI_Warps/ROIs_skele
export roipath=$input/04_ROI_Warps

mkdir $skelroipath
mkdir $output
mkdir $output/Skele
mkdir $output/Non-Skele

######### ROI skele masking - for skeletonized means
fslmaths $a4ds/all_dti_fa_skeletonised.nii.gz -Tmean -bin $a4ds/dki_skeleton_mask.nii
fslmaths $a4ds/all_wmti_awf_skeletonised.nii.gz -Tmean -bin $a4ds/wmm_skeleton_mask.nii
gunzip $a4ds/*

for rois in Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb ; do
  fslmaths $roipath/${rois}.nii -mul $a4ds/dki_skeleton_mask.nii $skelroipath/${rois}.nii 
  fslmaths $roipath/${rois}.nii -mul $a4ds/wmm_skeleton_mask.nii $skelroipath/${rois}_wmm.nii
done

rm $a4ds/dki_skeleton_mask.nii
rm $a4ds/wmm_skeleton_mask.nii

gunzip $skelroipath/*


### non-skele
for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  for rois in Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb ; do
    fslmeants -i $a4ds/all_${metrics}.nii.gz -o $output/Non-Skele/${metrics}_${rois}.txt -m $roipath/${rois}.nii
  done
done


### skele - DKI
for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk ; do
  for rois in Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb ; do
    fslmeants -i $a4ds/all_${metrics}_skeletonised.nii.gz -o $output/Skele/${metrics}_${rois}_skele.txt -m $skelroipath/${rois}.nii
  done
done


### skele - WMM
for metrics in wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  for rois in Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb ; do
    fslmeants -i $a4ds/all_${metrics}_skeletonised.nii.gz -o $output/Skele/${metrics}_${rois}_skele.txt -m $skelroipath/${rois}_wmm.nii
  done
done


\


####### Combining
export final=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis/05_Means/
export ID_files=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/01_Protocols/IDs.txt

mkdir $final/Combined

# Comb - non-skele
export base=$final/Non-Skele

echo "Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb" > $base/_ROI_Labels.txt

for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  paste $base/${metrics}* > $base/All_${metrics}.txt
  cat $base/_ROI_Labels.txt $base/All_${metrics}.txt > $final/Combined/All_${metrics}.txt
done
    
# Comb - skele
export base=$final/Skele

echo "Accumb Amyg Body_cc CST_Comb Cauda Cere_ped_Comb Cing_hippo Fornix_cres_Comb Genu_cc Hippo Pal Post_Limb_Int_Cap_Comb Put SLF_Comb Sag_Str_Comb Splen_cc Sup_Fr_Occ_F_Comb Thal Unc_Fas_Comb" > $base/_ROI_Labels.txt

for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  paste $base/${metrics}* > $base/All_${metrics}.txt
  cat $base/_ROI_Labels.txt $base/All_${metrics}.txt > $final/Combined/All_${metrics}_skele.txt
done

# Comb - all
export base=$final/Combined

for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  paste $base/All_${metrics}* > $base/${metrics}.txt
done

for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  rm $base/All_${metrics}*
done

# Add ID labels
xargs -n1 < $ID_files > $final/Combined/_IDs.txt

for metrics in dti_ad dki_ak dti_fa dti_md dki_mk dti_rd dki_rk wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da ; do
  paste $final/Combined/_IDs.txt $final/Combined/${metrics}.txt > $final/Combined/All_${metrics}.txt
  rm $final/Combined/${metrics}.txt
done

rm $final/Combined/_IDs.txt
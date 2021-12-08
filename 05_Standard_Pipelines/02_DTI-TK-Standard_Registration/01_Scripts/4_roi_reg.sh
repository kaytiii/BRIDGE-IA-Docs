#############################################
#
#	Generate Stats w fslmeants 
#	Kayti Keith
#	4/30/20
#      
#############################################

export roisorig=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/01_Protocols/ROIs
export ana=/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis
export roiwarps=$ana/04_ROI_Warps

mkdir $roiwarps
cd $roiwarps 

cp $ana/03_TBSS/stats/mean_FA.nii mean_FA.nii
cp $roisorig/JHU-WhiteMatter-labels-1mm.nii JHU-WhiteMatter-labels-1mm.nii
cp $roisorig/JHU-ICBM-FA-1mm.nii JHU-ICBM-FA-1mm.nii
cp $roisorig/HarvardOxford-sub-maxprob-thr0-1mm.nii HarvardOxford-sub-maxprob-thr0-1mm.nii


flirt -ref mean_FA.nii -in JHU-ICBM-FA-1mm.nii -out FLIRT_MNI_to_mean_FA.nii -omat my_affine_guess.mat

fnirt --ref=mean_FA.nii --in=JHU-ICBM-FA-1mm.nii --aff=my_affine_guess.mat --cout=FNIRT_MNI_to_mean_FA.mat --iout=FNIRT_MNI_to_mean_FA.nii 

# JHU WM
applywarp --ref=mean_FA.nii --in=JHU-WhiteMatter-labels-1mm.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=FNIRT_ROIs_to_mean_FA.nii

gunzip FNIRT_ROIs_to_mean_FA.nii.gz

# HO sub
applywarp --ref=mean_FA.nii --in=HarvardOxford-sub-maxprob-thr0-1mm.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=FNIRT_ROIsub_to_mean_FA.nii

gunzip FNIRT_ROIsub_to_mean_FA.nii.gz
/

# Cortical WM ROI warps
export corwmorig=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/01_Protocols/Cortical_WM_ROIs

for r in anterior posterior mid ; do
  cp $corwmorig/CorWM_${r}_atlas_final.nii CorWM_${r}_final.nii
done

applywarp --ref=mean_FA.nii --in=CorWM_anterior_final.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=CorWM_anterior_to_mean_FA.nii
applywarp --ref=mean_FA.nii --in=CorWM_mid_final.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=CorWM_mid_to_mean_FA.nii
applywarp --ref=mean_FA.nii --in=CorWM_posterior_final.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=CorWM_posterior_to_mean_FA.nii

fslmaths CorWM_mid_to_mean_FA.nii.gz -thr 1 CorWM_mid_to_mean_FA.nii.gz
fslmaths CorWM_anterior_to_mean_FA.nii.gz -thr 1 CorWM_anterior_to_mean_FA.nii.gz
fslmaths CorWM_posterior_to_mean_FA.nii.gz -thr 1 CorWM_posterior_to_mean_FA.nii.gz

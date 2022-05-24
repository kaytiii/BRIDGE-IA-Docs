#############################################
#
#	Generate Stats w fslmeants 
#	Kayti Keith
#	4/30/20
#      
#############################################

export base=/path/to/study
export roisorig=$base/01_Protocols/ROIs
export ana=$base/03_Analysis
export roiwarps=$ana/04_ROI_Warps

mkdir $roiwarps
cd $roiwarps 

#######################################################################################
# 1. File Organization
#######################################################################################
cp $ana/03_TBSS/stats/mean_FA.nii mean_FA.nii
cp $roisorig/JHU-WhiteMatter-labels-1mm.nii JHU-WhiteMatter-labels-1mm.nii
cp $roisorig/JHU-ICBM-FA-1mm.nii JHU-ICBM-FA-1mm.nii
cp $roisorig/HarvardOxford-sub-maxprob-thr0-1mm.nii HarvardOxford-sub-maxprob-thr0-1mm.nii

#######################################################################################
# 2. Register mean FA to MNI space FA
#######################################################################################
flirt -ref mean_FA.nii -in JHU-ICBM-FA-1mm.nii -out FLIRT_MNI_to_mean_FA.nii -omat my_affine_guess.mat
fnirt --ref=mean_FA.nii --in=JHU-ICBM-FA-1mm.nii --aff=my_affine_guess.mat --cout=FNIRT_MNI_to_mean_FA.mat --iout=FNIRT_MNI_to_mean_FA.nii 

#######################################################################################
# 3. Apply warps to JHU and HO atlas
#######################################################################################
# JHU WM
applywarp --ref=mean_FA.nii --in=JHU-WhiteMatter-labels-1mm.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=FNIRT_ROIs_to_mean_FA.nii

gunzip FNIRT_ROIs_to_mean_FA.nii.gz

# HO sub
applywarp --ref=mean_FA.nii --in=HarvardOxford-sub-maxprob-thr0-1mm.nii --warp=FNIRT_MNI_to_mean_FA.mat.nii.gz --out=FNIRT_ROIsub_to_mean_FA.nii

gunzip FNIRT_ROIsub_to_mean_FA.nii.gz
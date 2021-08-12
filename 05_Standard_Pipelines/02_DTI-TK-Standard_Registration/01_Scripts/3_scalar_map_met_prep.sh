###################################
#    							  
#   Metric Prep for DTI_TK-TBSS   
#      Kayti Keith - 11/10/20	 	  
#    							  
###################################

export base=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/02_Data/01_DKE
export ana=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/03_Analysis
export stats=$ana
export scalar=$ana/01_Scalar_Prep
export dtitk_blfu=$ana/02_Tensors
export wns=$ana/01_Tensor_Prep/Within-Subject

export ID_file=/Users/kayti/Desktop/Projects/MIND/MIND_DTITK_allBL/01_Protocols/IDs.txt

SUBJ_IDs=$(cat $ID_file)

mkdir $scalar

# File org
for ID in $SUBJ_IDs ; do
  mkdir $scalar/${ID}
  for m in dax kax fa dmean kmean drad krad wmm_de_rad wmm_awf ; do
    cp $base/${ID}/${m}.nii $scalar/${ID}/${m}.nii
  done
done

####### Between Subject BL FU
for ID in $SUBJ_IDs ; do
  dfRightComposeAffine -aff $dtitk_blfu/${ID}_dti_dtitk.aff -df $dtitk_blfu/${ID}_dti_dtitk_aff_diffeo.df.nii.gz -out $dtitk_blfu/${ID}_combined.df.nii.gz
done

# Need to reset metric origin to 0 0 0 
for ID in $SUBJ_IDs ; do
  for m in dax kax fa dmean kmean drad krad wmm_de_rad wmm_awf ; do
    TVAdjustVoxelspace -in $scalar/${ID}/${m}.nii -origin 0 0 0 -out $scalar/${ID}/${m}_000.nii
  done
done

gunzip $scalar/*/*.nii.gz

for ID in $SUBJ_IDs ; do
  for m in dax kax fa dmean kmean drad krad wmm_de_rad wmm_awf ; do
    deformationScalarVolume -in $scalar/${ID}/${m}_000.nii -trans $dtitk_blfu/${ID}_combined.df.nii.gz -target $dtitk_blfu/mean_initial.nii.gz -out $scalar/${ID}/${m}_bs.nii.gz
  done
done

####### skeletonization no FU

mkdir $ana/03_TBSS
mkdir $ana/03_TBSS/Phase1
mkdir $ana/03_TBSS/Phase1/DKI
mkdir $ana/03_TBSS/Phase1/DKI/fa
mkdir $ana/03_TBSS/Phase1/DKI/fa/stats

gunzip $scalar/*/*.nii.gz

# make alls 
for ID in $SUBJ_IDs ; do
  cp $scalar/${ID}/fa_bs.nii $ana/03_TBSS/Phase1/DKI/fa/stats/${ID}_fa_bs.nii
done
fslmerge -t $ana/03_TBSS/Phase1/DKI/fa/stats/all_FA.nii $ana/03_TBSS/Phase1/DKI/fa/stats/*_fa_bs.nii
fslmaths $ana/03_TBSS/Phase1/DKI/fa/stats/all_FA.nii -Tmean $ana/03_TBSS/Phase1/DKI/fa/stats/mean_FA.nii
fslmaths $ana/03_TBSS/Phase1/DKI/fa/stats/mean_FA.nii -bin $ana/03_TBSS/Phase1/DKI/fa/stats/mean_FA_mask.nii 
tbss_skeleton -i $ana/03_TBSS/Phase1/DKI/fa/stats/mean_FA -o $ana/03_TBSS/Phase1/DKI/fa/stats/mean_FA_skeleton

for ID in $SUBJ_IDs ; do
  rm $ana/03_TBSS/Phase1/DKI/fa/stats/${ID}_fa_bs.nii
done

# File organization
for metric_DKI in dax kax fa dmean kmean drad krad ; do
  mkdir $ana/03_TBSS/Phase1/DKI/${metric_DKI}
done

mkdir $ana/03_TBSS/Phase1/WMM/

for metric_WMM in wmm_de_rad wmm_awf ; do
  mkdir $ana/03_TBSS/Phase1/WMM/${metric_WMM}
done 

for ID in $SUBJ_IDs ; do  
  for m in dax kax fa dmean kmean drad krad ; do
    cp $scalar/${ID}/${m}_bs.nii $ana/03_TBSS/Phase1/DKI/${m}/${ID}_${m}.nii
  done
done

for ID in $SUBJ_IDs ; do  
  for m in wmm_de_rad wmm_awf ; do
    cp $scalar/${ID}/${m}_bs.nii $ana/03_TBSS/Phase1/WMM/${m}/${ID}_${m}.nii
  done
done

mkdir $ana/03_TBSS/Phase1/DKI/fa/orig 
mv $ana/03_TBSS/Phase1/DKI/fa/*fa.nii $ana/03_TBSS/Phase1/DKI/fa/orig 


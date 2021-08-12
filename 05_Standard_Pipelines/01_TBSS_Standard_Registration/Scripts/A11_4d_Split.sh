#!/bin/bash

#############################################
#
#	Split 4d For Masking  
#	Created by Corinne McGill
#	Modified by Kayti Keith
#	11/16/20
#      
#############################################


#Pathways
export input=/Path/to/study/02_Cases/02_TBSS_Outputs/Phase1/DKI/stats
export input1=/Path/to/study/02_Cases/02_TBSS_Outputs/Phase1/WMM/stats
export output=/Path/to/study/03_Analysis/01_Skeletonized_Maps
export scripts=/Path/to/study/01_Protocols/Scripts
export ID_file=/Path/to/study/01_Protocols/Scripts/IDs.txt

mkdir $output

SUBJ_IDs=$(cat $ID_file)

#### Split DKI 4ds
for metrics in dmean dax drad kmean kax krad FA ; do
  mkdir $output/${metrics}/
  cp $input/all_${metrics}_skeletonised.nii.gz $output/${metrics}/all_${metrics}_skele.nii.gz
  gunzip $output/${metrics}/all_${metrics}_skele.nii.gz
  fslsplit $output/${metrics}/all_${metrics}_skele.nii $output/${metrics}/${metrics}_skele -t 
done

gunzip $output/*/*.nii.gz

#Rename Files
for metrics in dmean dax drad kmean kax krad FA ; do
    X=0
	for ID in $SUBJ_IDs ; do
	  mv $output/${metrics}/${metrics}_skele$(printf %04d%s ${X%.*}).nii "$output/${metrics}/${ID}_${metrics}.nii"
      let X="$X+1"
	done
done

#Sort skeletonized maps
for ID in $SUBJ_IDs ; do
for metrics in dmean dax drad kmean kax krad FA ; do
mkdir $output/${ID}
cp $output/${metrics}/${ID}_${metrics}.nii $output/${ID}/${ID}_${metrics}_skele.nii
cp $output/${ID}/${ID}_dmean.nii $output/${ID}/${ID}_skele.nii
fslmaths $output/${ID}/${ID}_skele.nii -uthr 2 -bin $output/${ID}/${ID}_skele_mask.nii
done
done

for ID in $SUBJ_IDs ; do
for metrics in dmean dax drad kmean kax krad FA ; do
mv $output/${ID}/${ID}_${metrics}.nii $output/${ID}/${ID}_${metrics}_skele.nii
done
done

##### Split WMM 4ds
for metrics in wmm_awf wmm_da wmm_de_ax wmm_de_rad wmm_tort ; do
  mkdir $output/${metrics}/
  cp $input1/all_${metrics}_skeletonised.nii.gz $output/${metrics}/all_${metrics}_skele.nii.gz
  gunzip $output/${metrics}/all_${metrics}_skele.nii.gz
  fslsplit $output/${metrics}/all_${metrics}_skele.nii $output/${metrics}/${metrics}_skele -t 
done

gunzip $output/*/*.nii.gz

#Rename Files
for metrics in wmm_awf wmm_da wmm_de_ax wmm_de_rad wmm_tort ; do
    X=0
	for ID in $SUBJ_IDs ; do
	  mv $output/${metrics}/${metrics}_skele$(printf %04d%s ${X%.*}).nii "$output/${metrics}/${ID}_${metrics}.nii"
      let X="$X+1"
	done
done

#Sort skeletonized maps
for ID in $SUBJ_IDs ; do
for metrics in wmm_awf wmm_da wmm_de_ax wmm_de_rad wmm_tort ; do
mkdir $output/${ID}
cp $output/${metrics}/${ID}_${metrics}.nii $output/${ID}/${ID}_${metrics}_skele.nii
cp $output/${ID}/${ID}_dmean.nii $output/${ID}/${ID}_skele.nii
fslmaths $output/${ID}/${ID}_skele.nii -uthr 2 -bin $output/${ID}/${ID}_skele_mask.nii
done
done

for ID in $SUBJ_IDs ; do
for metrics in wmm_awf wmm_da wmm_de_ax wmm_de_rad wmm_tort ; do
mv $output/${ID}/${ID}_${metrics}.nii $output/${ID}/${ID}_${metrics}_skele.nii
done
done

for ID in $SUBJ_IDs ; do
cp $scripts/JHU_Fornix_cres_Comb.nii $output/${ID}/${ID}_fornix.nii
done

gunzip $output/*/*.nii.gz
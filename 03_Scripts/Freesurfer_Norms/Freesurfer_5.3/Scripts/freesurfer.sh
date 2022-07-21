###########################
#
#  Freesurfer recon-all
#  Kayti Keith - 11/12/20
#
###########################

export base=/Path/to/T1s
for ID in ID1 ID2 ID3 ... IDn ; do
  recon-all -all -i $base/${ID}/T1.nii -sd $base/${ID} -subjid ${ID} 
done
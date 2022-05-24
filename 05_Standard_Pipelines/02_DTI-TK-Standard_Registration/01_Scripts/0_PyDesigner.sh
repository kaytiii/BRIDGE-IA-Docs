#############################################
#
#  IAM PyDesigner  
#  Kayti Keith - 11/23/20; updated: 1/13/21
#      
#############################################

export base=/path/to/study/02_Data

ids=("subj1" "subj2" "subj3")

for i in ${ids[@]} ; do 
  python pydesigner -o $base/${i} -s --rpe_pairs 1 --force $base/${i}/dwi_raw.nii 
done
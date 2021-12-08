#############################################
#
#  IAM PyDesigner  
#  Kayti Keith - 11/23/20; updated: 1/13/21
#      
#############################################

export base=/home/kak240/Desktop/IAM_PyDesigner/02_Data
export ID_file=/home/kak240/Desktop/IAM_PyDesigner/IDs.txt
export pydesigner=/home/kak240/PyDesigner/designer/pydesigner.py
SUBJ_IDs=$(cat $ID_file)

for i in $SUBJ_IDs ; do 
  time python $pydesigner -o $base/${i} -s --rpe_pairs 1 --force $base/${i}/dwi_raw.nii 
done

      

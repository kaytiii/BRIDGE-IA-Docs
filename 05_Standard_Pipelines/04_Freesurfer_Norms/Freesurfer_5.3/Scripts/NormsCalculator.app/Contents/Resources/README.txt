#################################################### INSTRUCTIONS #############################################################
@2017 MEDICS LABORATORY

The authors take no responsibility for the use of this script or its derivatives.
These normative data are not for diagnostic purposes.

These normative values are aimed to be used with FreeSurfer version 5.3 with default parameters.
All values were produced using the “recon-all -all” command without any flag option.
Normative values are Z scores with a mean of 0 and a standard deviation of 1.


>>> Mac users

 Double click on the app


>>> Linux users

 Install Tkinter: 
 apt-get install python-tk

 Run NormativeCalculator.py (in "CorticalNormesCalculator.app/Contents/Resources/"):
 python NormativeCalculator.py 


>>> In order to produce normative Z scores:

 Step 1 [Choose CSV]: provide a csv file containing subject id (as in FreeSurfer’s subject directory), sex (M/F), age,
    manufacturer (GE/Philips/Siemens), and magnetic field strength (1.5/3). For an example, see "Example/intrant_example.csv"

 Step 2 [Choose Directory]: indicate the path to FreeSurfer’s subject directory (location where all the subjects folders are). For an example, see "Example/FreeSurfer_dir/"

 Step 3 [Generate normative Z scores]


>>> Cortical atlases (DK, DKT, and Ex vivo)

 Each region Z score is identified with a suffix of two letters corresponding to Left (L) or Right (R) hemishphere followed by Surface (S),
 Thickness (T), or Volume (V). These regions correspond to SurfArea, ThickAvg, or GrayVol within the following FreeSurfer stats files:
 lh.aparc.DKTatlas40.stats
 lh.aparc.stats
 lh.BA.stats
 lh.entorhinal_exvivo.stats
 rh.aparc.DKTatlas40.stats
 rh.aparc.stats
 rh.BA.stats
 rh.entorhinal_exvivo.stats 

 Cortex surface = White Surface Total Area 
 Cortex thickness = Mean Thickness
 Cortex volume = Hemisphere cortical gray matter volume (from aseg.stats)


>>> Subcortical atlas (aseg.stats)

 Z score names are identical to those within the file except:
 CCsum = sum of the corpus callosum divisions
 ventricles = sum of all ventricles


>>> A complete example with a CSV file and FreeSurfer outputs is provided along with the calculator.


>>> Please cite and refer to the following publications for details:

 Potvin et al. (2016). Normative data for subcortical regional volumes over the lifetime of the adult human brain.
    NeuroImage, 137, 9-20. PMID: 27165761

 Potvin et al. (2017). Normative morphometric data for cerebral cortical areas over the lifetime of the adult human brain.
    NeuroImage (in press).

 Potvin et al. (2017). FreeSurfer cortical normative data for adults using Desikan-Killiany-Tourville and
    Ex vivo protocols. NeuroImage, 156, 43-64. PMID: 28479474

################################################################################################################################
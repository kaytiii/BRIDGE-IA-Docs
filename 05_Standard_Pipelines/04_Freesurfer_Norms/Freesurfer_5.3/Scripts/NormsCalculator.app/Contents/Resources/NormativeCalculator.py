#!/usr/bin/env python

import os
import sys
import re
from math import log #used in eval(string)
import csv
import time
import medics
from xml.dom import minidom
try:
    import Tkinter as tk
    import tkFileDialog as filedialog
    import ttk as ttk
    from tkMessageBox import showerror as showerror
except ImportError:
    import tkinter as tk
    import tkinter.filedialog as filedialog
    import tkinter.ttk as ttk
    from tkinter.messagebox import showerror as showerror

VolumeOnly = False
if len(sys.argv) > 1 and sys.argv[1].find("olume") >= 0:
    VolumeOnly = True

"""
 Using global variables for now
 because Widget command's Callbacks from Tkinter module
 only returning the integer Id of his self action.
"""
lefile = ""
lefolder = ""
"""
"""
# Tables to read
tables = [["lh.aparc.DKTatlas40.stats","lh.BA.stats","lh.entorhinal_exvivo.stats","rh.aparc.DKTatlas40.stats","rh.BA.stats","rh.entorhinal_exvivo.stats","aseg.stats"],
          ["lh.aparc.stats","lh.BA.stats","lh.entorhinal_exvivo.stats","rh.aparc.stats","rh.BA.stats","rh.entorhinal_exvivo.stats","aseg.stats"]]
#tables = [["lh.aparc.DKTatlas40.stats","rh.aparc.DKTatlas40.stats","aseg.stats"],
#          ["lh.aparc.stats","rh.aparc.stats","aseg.stats"]]
normes = [["DKT"],["DK"]]
##########################################################################################
##########################################################################################
def openFile():

    global lefile
    lesoptions = {}
    lesoptions['defaultextension'] = '.csv'
    lesoptions['filetypes'] = [("CSV Files", "*.csv"), ("Excel Files", "*.xls;*.xlsx;;*.xlsm"), ("All", "*")]
    lesoptions['title'] = 'Choose Subjects Informations CSV File.'
    lesoptions['parent'] = fenpri
    lefile = filedialog.askopenfilename(**lesoptions)
    entryfile.delete(0, "end")
    entryfile.insert(0, lefile)
    entryfile.focus()
    entryfile.xview_moveto(1)  # view the file name
    entryfile.config(fg='black')
    lefile = entryfile.get()

##########################################################################################
def openDirectory():
    global lefolder
    lesoptions = {}
    lesoptions['mustexist'] = True
    lesoptions['title'] = 'Choose A Folder Containing All Subjects.'
    lesoptions['parent'] = fenpri
    lefolder = filedialog.askdirectory(**lesoptions)
    entryfolder.delete(0, "end")
    entryfolder.insert(0, lefolder)
    entryfolder.focus()
    entryfolder.xview_moveto(1)  # view the file name
    entryfolder.config(fg='black')
    lefolder = entryfolder.get()

##########################################################################################
def file_save(ledata, csvpath):
    global lexml
    f = filedialog.asksaveasfilename(defaultextension=".csv", initialdir=os.path.dirname(csvpath), initialfile=os.path.basename(csvpath)
                                       , title=lexml.getElementsByTagName("saveas")[0].childNodes[0].nodeValue.strip())
    if f is None or len(str(f)) == 0: # asksaveasfile return `None` if dialog closed with "cancel".
        affiche_erreur(lexml.getElementsByTagName("noresult")[0].childNodes[0].nodeValue.strip())
        buttonexec['text'] = lexml.getElementsByTagName("execbutton")[0].childNodes[0].nodeValue.strip()
        return
    for i, val in enumerate(ledata):
        with open(f, 'a') as ff:
            w = csv.writer(ff, dialect='excel')
            w.writerow(val)
    buttonexec['text'] = lexml.getElementsByTagName("execbutton")[0].childNodes[0].nodeValue.strip()
    affiche_warning(lexml.getElementsByTagName("result")[0].childNodes[0].nodeValue.strip() + " " + f)

##########################################################################################
def Intercepte():
    print("Interception closing window")
    fenpri.destroy()
    exit()

##########################################################################################
def Intercepte2():
    global toplevel
    print("Interception closing readme window")
    toplevel.destroy()
    exit()

##########################################################################################
def on_entry_click(event):
    """function that gets called whenever entry is clicked"""
    if entryfile.get() == filetext:
        entryfile.delete(0, "end")  # delete all the text in the entry
        entryfile.insert(0, '')  # Insert blank for user input
        entryfile.config(fg='black')

##########################################################################################
def on_entry_click2(event):
    """function that gets called whenever entry is clicked"""
    if entryfolder.get() == foldertext:
        entryfolder.delete(0, "end")  # delete all the text in the entry
        entryfolder.insert(0, '')  # Insert blank for user input
        entryfolder.config(fg='black')

##########################################################################################
def on_focusout(event):
    if entryfile.get() == '':
        entryfile.insert(0, filetext)
        entryfile.config(fg='grey')

##########################################################################################
def on_focusout2(event):
    if entryfolder.get() == '':
        entryfolder.insert(0, foldertext)
        entryfolder.config(fg='grey')

##########################################################################################
def affiche_erreur(letext):
    progres.grid_remove()
    lemessage.grid()
    lemessage['fg'] = "red"
    lemessage['text'] = "ERREUR: " + letext

##########################################################################################
def affiche_warning(letext):
    progres.grid_remove()
    lemessage.grid()
    lemessage['fg'] = "#009900"
    lemessage['text'] = letext

##########################################################################################
def cleaner():
    global lexml
    progres.grid_remove()  # hide progressbar
    lemessage.grid_remove()  # hide message
    entryfile.delete(0, "end")
    entryfile.insert(0, filetext)
    entryfile.config(fg='grey')
    entryfolder.delete(0, "end")
    entryfolder.insert(0, foldertext)
    entryfolder.config(fg='grey')
    leradio.set(1)
    buttonexec['text'] = lexml.getElementsByTagName("execbutton")[0].childNodes[0].nodeValue.strip()
    labelgeneral.focus()
##########################################################################################
def parse_aparc(lefolder, patient_name, tableFile, ledata):
    global lexml

    filepath = os.path.join(lefolder, patient_name, "stats", tableFile)

    if os.path.isfile(filepath) is False:
        return ledata #print("file dont exist " + filepath)
    #else:
    #    print("file exist " + filepath)
    # find patient's line
    for p, val in enumerate(ledata):
        for q, lav in enumerate(val):
            if lav == patient_name:
                index_patient = p

    # add data from stats files
    datatemp = medics.createTuple(filepath)
    lesmesures = "SVT"
    for i, val in enumerate(datatemp):
        ### MEASURE LINES
        if val[0].find("Measure") >= 0 and tableFile.find("aparc") >= 0 and val[1] != "NumVert":
            #need to transform the names for uniformity
            if re.search(r'^(.*)(WhiteSurfArea)(.*)$', val[1]):
                datatemp[i][1] = "Cortex" + "_" + tableFile[:1].upper() + "S"
            if re.search(r'^(.*)(MeanThickness)(.*)$', val[1]):
                datatemp[i][1] = "Cortex" + "_" + tableFile[:1].upper() + "T"
            if datatemp[i][1] in ledata[0]:
                # verify if encounter same structure with different value
                for j, val1 in enumerate(ledata[0]):
                    if ledata[0][j] == datatemp[i][1]:
                        if ledata[index_patient][j] != datatemp[i][3] and ledata[index_patient][j] != '':
                            affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                        ledata[index_patient][j] = datatemp[i][3]
            else:
                # Adding column to array
                ledata = [x + [''] for x in ledata]
                ledata[0][len(ledata[0])-1] = datatemp[i][1] #+ "_" + tableFile[:1].upper() #tableFile[:1] + "_" + datatemp[i][1]
                ledata[index_patient][len(ledata[0])-1] = datatemp[i][3]
        ### STRUCTURES WITHOUT #
        if val[0][:1] != '#' and len(val[0]) > 4:
            if re.search(r'^(.*)(h.entorhinal_exvivo.label)(.*)$', val[0]):
                datatemp[i][0] = re.sub(r'^(.*)(entorhinal_exvivo)(.*)$', r'\2', val[0])
            for lesZ in lesmesures:
                if datatemp[i][0] + "_" + tableFile[:1].upper() + lesZ in ledata[0]:
                    # verify if encounter same structure with different value
                    for j, val1 in enumerate(ledata[0]):
                        if ledata[0][j] == datatemp[i][0] + "_" + tableFile[:1].upper() + lesZ:
                            if lesZ == 'S':
                                if ledata[index_patient][j] != datatemp[i][2] and ledata[index_patient][j] != '':
                                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                                ledata[index_patient][j] = datatemp[i][2]
                            if lesZ == 'V':
                                if ledata[index_patient][j] != datatemp[i][3] and ledata[index_patient][j] != '':
                                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                                ledata[index_patient][j] = datatemp[i][3]
                            if lesZ == 'T':
                                if ledata[index_patient][j] != datatemp[i][4] and ledata[index_patient][j] != '':
                                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                                ledata[index_patient][j] = datatemp[i][4]
                else:
                    #Adding column to array
                    ledata = [x + [''] for x in ledata]
                    ledata[0][len(ledata[0]) - 1] = datatemp[i][0] + "_" + tableFile[:1].upper() + lesZ #tableFile[:1] + "_" + lesZ + "_" + datatemp[i][0]
                    if lesZ == 'S':
                        ledata[index_patient][len(ledata[0])-1] = datatemp[i][2]
                    if lesZ == 'V':
                        ledata[index_patient][len(ledata[0])-1] = datatemp[i][3]
                    if lesZ == 'T':
                        ledata[index_patient][len(ledata[0])-1] = datatemp[i][4]

    return ledata
##########################################################################################
def parse_aseg(lefolder, patient_name, tableFile, ledata):
    global lexml

    filepath = os.path.join(lefolder, patient_name, "stats", tableFile)

    if os.path.isfile(filepath) is False:
        return ledata

    # find patient's line
    for p, val in enumerate(ledata):
        for q, lav in enumerate(val):
            if lav == patient_name:
                index_patient = p

    # add data from stats files
    ventricles_log = CCsum = 0
    datatemp = medics.createTuple(filepath)
    for i, val in enumerate(datatemp):
        ### MEASURE
        if val[0].find("Measure") >= 0:
            if (val[1] == "eTIV") or val[1].find("hCortexVol") >= 0 or val[1] == "SubCortGrayVol" or (VolumeOnly is True and val[1] == "BrainSegVolNotVent") or (VolumeOnly is True and val[1] == "TotalGrayVol"):
                #need to transform certain names for uniformity
                if re.search(r'^(.*)(hCortexVol)(.*)$', val[1]):
                    datatemp[i][1] = re.sub(r'^(.*)(Cortex)(.*)$', r'\2', val[1]) + "_" + re.sub(r'^([lr])(h)(Cortex)(.*)$', r'\1', val[1]).upper() + "V"
                if datatemp[i][1] in ledata[0]:
                    for j, val1 in enumerate(ledata[0]):
                        if ledata[0][j] == datatemp[i][1]:
                            if ledata[index_patient][j] != datatemp[i][3] and ledata[index_patient][j] != '':
                                affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                            ledata[index_patient][j] = datatemp[i][3]
                else:
                    ledata = [x + [''] for x in ledata]
                    ledata[0][len(ledata[0]) - 1] = datatemp[i][1]
                    #(" Adding \"" + str(datatemp[i][1]) + "\" column to array")
                    ledata[index_patient][len(ledata[0])-1] = datatemp[i][3]
        ### STRUCTURES
        if val[0][:1] != '#':
            #exceptions:
            if datatemp[i][4] != 'CSF' and datatemp[i][4].find("erebellum") == -1 and datatemp[i][4].find("vessel") == -1 and datatemp[i][4].find("choroid") == -1 and datatemp[i][4].find("WM-") == -1 and datatemp[i][4].find("Optic") == -1:
                #Sum section:
                if datatemp[i][4].find("Vent") >= 0 and datatemp[i][4].find("Ventral") == -1:
                    ventricles_log = ventricles_log + float(datatemp[i][3])
                if datatemp[i][4].find("CC_") >= 0:
                    CCsum = CCsum + float(datatemp[i][3])
                if datatemp[i][4].find("CC_") == -1 and datatemp[i][4].find("5th") == -1:
                    if datatemp[i][4] in ledata[0]:
                        for j, val1 in enumerate(ledata[0]):
                            if ledata[0][j] == datatemp[i][4]:
                                if ledata[index_patient][j] != datatemp[i][3] and ledata[index_patient][j] != '':
                                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                                ledata[index_patient][j] = datatemp[i][3]
                    else:
                        ledata = [x + [''] for x in ledata]
                        ledata[0][len(ledata[0]) - 1] = datatemp[i][4]
                        ledata[index_patient][len(ledata[0])-1] = datatemp[i][3]
    #add calculated columns
    if "ventricles_log" in ledata[0]:
        for j, val1 in enumerate(ledata[0]):
            if ledata[0][j] == "ventricles_log":
                if ledata[index_patient][j] != ventricles_log and ledata[index_patient][j] != '':
                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                ledata[index_patient][j] = ventricles_log
    else:
        ledata = [x + [''] for x in ledata]
        ledata[0][len(ledata[0]) - 1] = "ventricles_log"
        ledata[index_patient][len(ledata[0])-1] = ventricles_log
    if "CCsum" in ledata[0]:
        for j, val1 in enumerate(ledata[0]):
            if ledata[0][j] == "CCsum":
                if ledata[index_patient][j] != CCsum and ledata[index_patient][j] != '':
                    affiche_warning(lexml.getElementsByTagName("same")[0].childNodes[0].nodeValue.strip() + " (" + ledata[0][j] + ")")
                ledata[index_patient][j] = CCsum
    else:
        ledata = [x + [''] for x in ledata]
        ledata[0][len(ledata[0]) - 1] = "CCsum"
        ledata[index_patient][len(ledata[0])-1] = CCsum

    return ledata
##########################################################################################
def remove_column(ledata):
    if VolumeOnly is False:
        index = ledata[0].index('eTIV')
        for i, val in enumerate(ledata):
            del val[index]
        for j, val1 in enumerate(ledata[0]):
            if val1.find("_log") != -1:
                ledata[0][j] = val1.replace("_log", "")

##########################################################################################
def fourche(ledata=None, csvpath=None):
    global lefile
    global lefolder
    global lexml

    if buttonexec.cget('text') == lexml.getElementsByTagName("execbutton")[0].childNodes[0].nodeValue.strip():
        lefile = entryfile.get()
        lefolder = entryfolder.get()
        getScoreZ()
    elif buttonexec.cget('text') == lexml.getElementsByTagName("execbutton_fin")[0].childNodes[0].nodeValue.strip():
        remove_column(ledata)
        file_save(ledata, csvpath)
    else:
        affiche_erreur(lexml.getElementsByTagName("unknown")[0].childNodes[0].nodeValue.strip())

##########################################################################################
def getScoreZ():
    global lefile
    global lefolder
    global lexml

    lestables = tables[leradio.get()-1]
    lefilenorme = str(normes[leradio.get()-1][0]) + '.csv'

    if not lefile or not lefolder:
        affiche_erreur(lexml.getElementsByTagName("filefolder")[0].childNodes[0].nodeValue.strip())
        return
    else:
        lemessage.grid_remove()

    progres.grid()# progress bar
    progres["value"] = 0
    progres["maximum"] = 100

    ledata = medics.createTuple(lefile)###->READ CSV

    ###->READ STATS IN FOLDERS
    ACounter = 0
    index_patient = None
    ###search patient column from csv
    for i, val in enumerate(ledata[0]):
        if re.search(r'^(.*)(patient|subject)(.*)(id)(.*)$', ledata[0][i], re.IGNORECASE) or ledata[0][i].lower().strip() == 'id':
            index_patient = i
            ACounter += 1
    if index_patient is None:
        affiche_erreur(lexml.getElementsByTagName("id")[0].childNodes[0].nodeValue.strip())
        return
    if ACounter > 1:
        affiche_erreur(lexml.getElementsByTagName("ids")[0].childNodes[0].nodeValue.strip())
        return
    #start at second line not including matrix header (first line)
    found_one = False
    for i, val in list(enumerate(ledata))[1:]:
        patient_name = val[index_patient]
        # patient's folder is "rootdir/patient_id/stats/files.stats"
        d = os.path.join(lefolder, patient_name, 'stats')
        # if dir stats does not exist, continue
        if not os.path.isdir(d):
            continue #next subject if no stats folder
        else:
            found_one = True
        for i, latable in enumerate(lestables):
            if latable.find("aseg") == -1:
                try:
                    ledata = parse_aparc(lefolder, patient_name, latable, ledata)  # ledata pass byref
                except Exception as e:
                    affiche_erreur("%s on file %s for patient %s." % (e.__class__.__name__, latable, patient_name))
                    return
            else:
                try:
                    ledata = parse_aseg(lefolder, patient_name, latable, ledata)
                except Exception as e:
                    affiche_erreur("%s on file 2 %s for patient %s." % (e.__class__.__name__, latable, patient_name))
                    return

    if found_one == False:
        affiche_erreur(lexml.getElementsByTagName("nofolder")[0].childNodes[0].nodeValue.strip())
        return
    #load norme file
    lenorme = []
    with open(lefilenorme) as csvfile:
        reader = csv.reader(csvfile, dialect='excel')
        for x, y in enumerate(reader):
            lenorme.append(y)

    #get formula
    larowformule = [row for row in lenorme if 'NORME' in row[0]]
    laformule = larowformule[0][2]

    #loop volumes
    lesindex=[];lesindexDK=[];lesindexASEG=[]
    BCounter=0;lindexgenre=-1;lindexage=-1;lindexmanufac=-1;lindexmagnet=-1;lindexetiv=-1
    for i, val in enumerate(ledata[0]): # header
        ##look for particuliar values
         # gender
        lindexgenre = [k for k, x in enumerate(ledata[0]) if re.search(r'^(.*)(gen|sex)(.*)$', x, re.IGNORECASE) ]
        if len(lindexgenre) > 1:
            affiche_erreur(lexml.getElementsByTagName("many")[0].childNodes[0].nodeValue.strip() + "gender.")
            return
        elif len(lindexgenre) == 0:
            affiche_erreur(lexml.getElementsByTagName("none")[0].childNodes[0].nodeValue.strip() + "gender.")
            return
        else:
            lindexgenre = lindexgenre[0]
         # age
        lindexage = [k for k, x in enumerate(ledata[0]) if re.search(r'^(.*)(age)(.*)$', x, re.IGNORECASE) ]
        if len(lindexage) > 1:
            affiche_erreur(lexml.getElementsByTagName("many")[0].childNodes[0].nodeValue.strip() + "age.")
            return
        elif len(lindexage) == 0:
            affiche_erreur(lexml.getElementsByTagName("none")[0].childNodes[0].nodeValue.strip() + "age.")
            return
        else:
            lindexage = lindexage[0]
         # manufacturer
        lindexmanufac = [k for k, x in enumerate(ledata[0]) if re.search(r'^(.*)(manuf|mod)(.*)$', x, re.IGNORECASE) ]
        if len(lindexmanufac) > 1:
            affiche_erreur(lexml.getElementsByTagName("many")[0].childNodes[0].nodeValue.strip() + "manufacturer.")
            return
        elif len(lindexmanufac) == 0:
            affiche_erreur(lexml.getElementsByTagName("none")[0].childNodes[0].nodeValue.strip() + "manufacturer.")
            return
        else:
            lindexmanufac = lindexmanufac[0]
         # magnetic feild
        lindexmagnet = [k for k, x in enumerate(ledata[0]) if re.search(r'^(.*)(magn|fiel|champ|forc|streng)(.*)$', x, re.IGNORECASE) ]
        if len(lindexmagnet) > 1:
            affiche_erreur(lexml.getElementsByTagName("many")[0].childNodes[0].nodeValue.strip() + "magnetic field strength.")
            return
        elif len(lindexmagnet) == 0:
            affiche_erreur(lexml.getElementsByTagName("none")[0].childNodes[0].nodeValue.strip() + "magnetic field strength.")
            return
        else:
            lindexmagnet = lindexmagnet[0]
         # eTIV
        lindexetiv = [k for k, x in enumerate(ledata[0]) if re.search(r'^(.*)(eTIV)(.*)$', x, re.IGNORECASE) ] ## programmatically insert
        #if len(lindexetiv) > 1:
        #    affiche_erreur(lexml.getElementsByTagName("many")[0].childNodes[0].nodeValue.strip() + "gender.")
        #    return
        #elif len(lindexetiv) == 0:
        #    affiche_erreur(lexml.getElementsByTagName("none")[0].childNodes[0].nodeValue.strip() + "gender.")
        #    return
        #else:
        lindexetiv = lindexetiv[0]
        ##verify if all is there
        if lindexgenre==-1 or lindexage==-1 or lindexmanufac==-1 or lindexmagnet==-1 or lindexetiv==-1:
            affiche_erreur(lexml.getElementsByTagName("wrongCSV")[0].childNodes[0].nodeValue.strip())
            return
        else:
            lesindex = [index_patient, lindexgenre, lindexage, lindexmanufac, lindexmagnet, lindexetiv]
        ##formula transformation
        if i not in [index_patient, lindexgenre, lindexage, lindexmanufac, lindexmagnet, lindexetiv]:
            if re.search(r'^(.*)(\_[LR][SVT])$', val):
                lesindexDK.append(i)
            else:
                lesindexASEG.append(i)
            if VolumeOnly is False:
                BCounter = BCounter + 1
                for j in range(1, len(ledata) ):#check all value from a column, for each line
                    if j == 1:#get structure define constantes from norme, one time only
                        lastructure = [row for row in lenorme if re.sub(r'[^0-9a-zA-Z]+', '', val.lower()) in re.sub(r'[^0-9a-zA-Z]+', '', row[3].lower())]
                    if BCounter == 1 and j ==1:# build complete formula
                        lastructureDK = [row for row in lenorme if (row[0] == "eTIVc" or row[0] == "agec") and row[4].strip() != "SUBCOR"]
                        lastructureASEG = [row for row in lenorme if (row[0] == "eTIVc" or row[0] == "agec") and row[4].strip() == "SUBCOR"]
                        for k, v in enumerate(lastructure):
                            laformule = re.sub(r'\b' + v[0] + r'\b', v[2], laformule)
                    levolume = ledata[j][i]
                    if levolume is None or len(str(levolume)) == 0: #volume of structure missing because no stats file
                        levolume = 0
                    laformule_temp = laformule
                    if len(lastructure) > 0:
                        if re.search(r'^(.*)(_log)$', lastructure[0][3], re.IGNORECASE):
                            laformule_temp = laformule_temp.replace("[volume]", "log([volume], 10)")
                    laformule_temp = laformule_temp.replace("[volume]", str(levolume))
                    if ledata[j][lindexgenre] == 'M':
                        laformule_temp = laformule_temp.replace("[gender]", "1")
                    elif ledata[j][lindexgenre] == 'F':
                        laformule_temp = laformule_temp.replace("[gender]", "0")
                    if round(float(ledata[j][lindexmagnet]),1) == 1.5:
                        laformule_temp = laformule_temp.replace("[magnetic_field_strength]", "1")
                    elif round(int(ledata[j][lindexmagnet])) == 3:
                        laformule_temp = laformule_temp.replace("[magnetic_field_strength]", "0")
                    if re.search(r'^(.*)(GE)(.*)$', str(ledata[j][lindexmanufac])): #, re.IGNORECASE)
                        laformule_temp = laformule_temp.replace("G_[modality_manuf_id]", "1")
                    else:
                        laformule_temp = laformule_temp.replace("G_[modality_manuf_id]", "0")
                    if re.search(r'^(.*)(phil)(.*)$', str(ledata[j][lindexmanufac]), re.IGNORECASE):
                        laformule_temp = laformule_temp.replace("P_[modality_manuf_id]", "1")
                    else:
                        laformule_temp = laformule_temp.replace("P_[modality_manuf_id]", "0")
                    for m, n in enumerate(lastructure):
                        laformule_temp = re.sub(r'\b' + n[0] + r'\b', n[1], laformule_temp)
                    if re.search(r'^(.*)(_L|_R)([VTS])(.*)$', val):
                        for k, v in enumerate(lastructureDK):
                            laformule_temp = re.sub(r'\b' + v[0] + r'\b', v[2], laformule_temp)
                        for o, p in enumerate(lastructureDK):
                            laformule_temp = re.sub(r'\b' + p[0] + r'\b', p[1], laformule_temp)
                    else:
                        for k, v in enumerate(lastructureASEG):
                            laformule_temp = re.sub(r'\b' + v[0] + r'\b', v[2], laformule_temp)
                        for o, p in enumerate(lastructureASEG):
                            laformule_temp = re.sub(r'\b' + p[0] + r'\b', p[1], laformule_temp)
                    laformule_temp = laformule_temp.replace("[patient_age]", str(ledata[j][lindexage]))
                    laformule_temp = laformule_temp.replace("[eTIV]", str(ledata[j][lindexetiv]))

                    laformule_temp = laformule_temp.replace("Z=", "")

                    try:
                        if levolume != 0:
                            leZ = str(eval(laformule_temp))
                            ledata[j][i] = leZ
                        else:
                            ledata[j][i] = "-999"
                    except NameError:
                        ledata[j][i] = "-999"
        progres["value"] = int((float(i)/(len(ledata[0])-1))*100)
        progres.update()

    if progres["value"] == 100:
        buttonexec['text'] = lexml.getElementsByTagName("execbutton_fin")[0].childNodes[0].nodeValue.strip()
        buttonexec['fg'] = "#009900"
        buttonexec.update()
        lecsv = 'results_' + lefilenorme.replace(".csv", "_") + time.strftime("%Y%m%d-%H%M%S") + '.csv'
        csvpath = os.path.join(lefolder, lecsv)
        ledata = medics.sort_csv(ledata, lesindex, lesindexDK, lesindexASEG)
        fourche(ledata, csvpath)
    else:
        affiche_erreur(lexml.getElementsByTagName("notdone")[0].childNodes[0].nodeValue.strip())

##########################################################################################
def livedemo():

    toplevel = tk.Toplevel()

    toplevel.title(lexml.getElementsByTagName("titlereadme")[0].childNodes[0].nodeValue.strip())
    toplevel.config(background='white')
    #toplevel.resizable(height=False, width=False)

    lefilereadme = file("README.txt")
    lereadme = lefilereadme.read()
    lefilereadme.close()
    textreadme = tk.Text(toplevel, height=42, width=140, wrap='word', relief='ridge', borderwidth=1)
    textreadme.insert(0.0,lereadme)
    lescrollbar = tk.Scrollbar(toplevel, command=textreadme.yview, orient=tk.VERTICAL)
    #canvasblanc = tk.Canvas(toplevel, width=1, height=0, bg='grey') ## space between logos and entries on the right

    #canvasblanc.grid(       row=0, column=0)
    lescrollbar.grid(       row=10, column=1, columnspan=8, sticky='E' + 'N' + 'S', padx=(0,5))
    textreadme.grid(        row=10, column=1, columnspan=8, sticky='W' + 'E' + 'N' + 'S', padx=(5,5), pady=(5,5))
    textreadme.configure(yscrollcommand=lescrollbar.set)

##########################################################################################
#def main():
if __name__ == "__main__":

    lexml = minidom.parse('medics.xml') ##all the texts in that file

    if os.name == "nt":
        ## windows not support (as freesurfer is not)
        showerror(lexml.getElementsByTagName("title")[0].childNodes[0].nodeValue.strip(), lexml.getElementsByTagName("windows")[0].childNodes[0].nodeValue.strip())

    fenpri = tk.Tk()  ## Creation main window

    ## relative size of windows ##
    hauteur = 700 #fenpri.winfo_screenheight() / 2
    largeur = 1100 #fenpri.winfo_screenwidth() / 2
    fenpri.geometry('%dx%d+%d+%d' % (
        largeur,
        hauteur / 2,
        (largeur) - (largeur / 2) / 2,
        (hauteur / 2) #- (hauteur / 2)
    )
                    )
    fenpri.protocol("WM_DELETE_WINDOW", Intercepte)
    fenpri.title(lexml.getElementsByTagName("title")[0].childNodes[0].nodeValue.strip())
    fenpri.config(background='white')

    # creation widgets
    leradio = tk.IntVar()
    leradio.set(1) ##default selected
    filetext = lexml.getElementsByTagName("fileentry")[0].childNodes[0].nodeValue.strip()
    foldertext = lexml.getElementsByTagName("folderentry")[0].childNodes[0].nodeValue.strip()
    entryfile = tk.Entry(fenpri, text=filetext, textvariable=lefile, width=30)  ## file Entry
    entryfile.bind('<FocusIn>', on_entry_click)  ##grey default text behavior
    entryfile.bind('<FocusOut>', on_focusout)
    entryfile.insert(0, filetext)
    entryfile.config(fg='grey')
    labelfile = tk.Label(fenpri, text=lexml.getElementsByTagName("filelabel")[0].childNodes[0].nodeValue.strip())  ## file Label
    buttonfile = tk.Button(fenpri, text=lexml.getElementsByTagName("filebutton")[0].childNodes[0].nodeValue.strip(), command=openFile)  ## file Button
    entryfolder = tk.Entry(fenpri, text=foldertext, textvariable=lefolder)  ## folder Entry
    entryfolder.bind('<FocusIn>', on_entry_click2)  ##grey default text behavior
    entryfolder.bind('<FocusOut>', on_focusout2)
    entryfolder.insert(0, foldertext)
    entryfolder.config(fg='grey')
    labelfolder = tk.Label(fenpri, text=lexml.getElementsByTagName("folderlabel")[0].childNodes[0].nodeValue.strip())  ## folder Label
    buttonfolder = tk.Button(fenpri, text=lexml.getElementsByTagName("folderbutton")[0].childNodes[0].nodeValue.strip(), command=openDirectory)  ## folder Button
    labeltitle = tk.Label(fenpri, text=lexml.getElementsByTagName("description1")[0].childNodes[0].nodeValue.strip(),
                            font="Helvetica 19 bold", wraplength=1000, justify='left')  ## general explanation Label
    labelgeneral = tk.Label(fenpri, text=lexml.getElementsByTagName("description2")[0].childNodes[0].nodeValue.strip(),
                            font="Helvetica 15 bold", wraplength=1000, justify='left', fg="#660000")  ## general explanation Label
    labelauthors = tk.Label(fenpri, text=lexml.getElementsByTagName("authors")[0].childNodes[0].nodeValue.strip(),
                            font="Helvetica 13 italic", wraplength=1000, justify='left')  ## general explanation Label
    labeldisclaimer = tk.Label(fenpri, text=lexml.getElementsByTagName("disclaimer")[0].childNodes[0].nodeValue.strip(),
                            font="Helvetica 15 bold", wraplength=1000, justify='left', fg="#660000")  ## general explanation Label
    buttonexec = tk.Button(fenpri, text=lexml.getElementsByTagName("execbutton")[0].childNodes[0].nodeValue.strip(), command=fourche)#getScoreZ)
    progres = ttk.Progressbar(fenpri, orient='horizontal', length=200, mode='determinate')
    lemessage = tk.Message(fenpri, width=500, justify=tk.LEFT)#, textvariable=lemessagetext)
    lesboutons1 = tk.Radiobutton(fenpri, text=lexml.getElementsByTagName("radioDKT")[0].childNodes[0].nodeValue.strip(), variable=leradio, value=1, anchor='w', height=2, justify='left')
    lesboutons2 = tk.Radiobutton(fenpri, text=lexml.getElementsByTagName("radioDK")[0].childNodes[0].nodeValue.strip(), variable=leradio, value=2, anchor='w', height=2, justify='left')
    buttonreset = tk.Button(fenpri, text=lexml.getElementsByTagName("rebutton")[0].childNodes[0].nodeValue.strip(), command=cleaner)  ## file Button
    buttondemo = tk.Button(fenpri, text=lexml.getElementsByTagName("demo")[0].childNodes[0].nodeValue.strip(), command=livedemo)  ## file Button

    # Laboratory logo
    canvas = tk.Canvas(fenpri, width=155, height=85, bg = 'white')  ## Laboratory logo Canvas
    canvas2 = tk.Canvas(fenpri, width=120, height=54, bg = 'white')  ## Laboratory logo Canvas
    canvas3 = tk.Canvas(fenpri, width=110, height=57, bg = 'white')  ## Laboratory logo Canvas
    photo = tk.PhotoImage(file="Medics_Logo_135x65.pgm")
    photo2 = tk.PhotoImage(file="Cervo_Logo_100x34.pgm")
    photo3 = tk.PhotoImage(file="logo-universite-laval-90x37.pgm")
    canvas.create_image(50, 10, anchor='nw', image=photo)
    canvas2.create_image(10, 10, anchor='nw', image=photo2)
    canvas3.create_image(10, 10, anchor='nw', image=photo3)
    canvasblanc0 = tk.Canvas(fenpri, width=10, height=0, bg='grey') ## space between logos and entries on the right
    canvasblanc = tk.Canvas(fenpri, width=20, height=0, bg='grey') ## space between logos and entries on the right
    canvasblanc2 = tk.Canvas(fenpri, width=0, height=10, bg='grey') ## space between logos and reset button

    # place widgets
    canvasblanc0.grid(      row=0, column=0)
    labeltitle.grid(        row=0, column=1, columnspan=8, sticky='W')
    labelgeneral.grid(      row=1, column=1, columnspan=8, sticky='W')
    labelauthors.grid(      row=2, column=1, columnspan=8, sticky='W')
    labeldisclaimer.grid(   row=3, column=1, columnspan=8, sticky='W')
    canvas.grid(            row=5, column=1, columnspan=4, rowspan=3, sticky='E' + 'W')
    canvas2.grid(           row=8, column=1, columnspan=2, sticky='E')
    canvas3.grid(           row=8, column=3, columnspan=2, sticky='W')
    canvasblanc.grid(       row=5, column=5)
    canvasblanc2.grid(      row=4, column=1)
    labelfile.grid(         row=5, column=6, sticky='W')
    entryfile.grid(         row=5, column=7, sticky='E' + 'W')
    buttonfile.grid(        row=5, column=8, sticky='E' + 'W')
    labelfolder.grid(       row=6, column=6, sticky='W')
    entryfolder.grid(       row=6, column=7, sticky='E' + 'W')
    buttonfolder.grid(      row=6, column=8, sticky='E' + 'W')
    lesboutons1.grid(       row=7, column=6, sticky='W')
    lesboutons2.grid(       row=7, column=7, sticky='E')
    buttonexec.grid(        row=8, column=8, sticky='E')
    progres.grid(           row=8, column=6, columnspan=2, sticky='E' + 'W')
    lemessage.grid(         row=8, column=6, columnspan=2, sticky='W')
    buttonreset.grid(       row=9, column=6, sticky='W')
    buttondemo.grid(        row=9, column=1, columnspan=4, sticky='E' + 'W')

    progres.grid_remove()  # hide progressbar
    lemessage.grid_remove()  # hide message
    #textreadme.grid_remove()
    #lescrollbar.grid_remove()
    #textreadmestate = False

    # bring to front but not exclusive
    fenpri.lift()
    fenpri.attributes('-topmost', True)
    fenpri.after_idle(fenpri.attributes, '-topmost', False)
    fenpri.lift()

    fenpri.mainloop()

##########################################################################################

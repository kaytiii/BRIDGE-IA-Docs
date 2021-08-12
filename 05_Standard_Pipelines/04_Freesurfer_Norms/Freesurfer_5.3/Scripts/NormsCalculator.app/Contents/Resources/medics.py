#!/usr/bin/env python
import re

##########################################################################################
def sort_csv(ledata, lesindex, lesindexDK, lesindexASEG):

    ledata01=[];ledata02=[];ledata03=[]
    for i, ligne in enumerate(ledata):
        ledata01.append([])
        ledata02.append([])
        ledata03.append([])
        for j, colonne in enumerate(ligne):
            if j in lesindex:
                ledata01[i].append(colonne)
            elif j in lesindexDK:
                ledata02[i].append(colonne)
            elif j in lesindexASEG:
                ledata03[i].append(colonne)

    ledata02 = map(list, zip(*sorted(zip(*ledata02))))
    ledata03 = map(list, zip(*sorted(zip(*ledata03))))

    ledataNEW = []
    for k in range(0, len(ledata)):
        ledataNEW.append([])
        ledataNEW[k] = ledata01[k] + ledata02[k] + ledata03[k]

    return ledataNEW
##########################################################################################
def fixText(text, separator):
    row = []
    z = text.find(separator)
    if z == 0:
        row.append('')
    elif z == -1:
        row.append(text[:].strip())
    else:
        row.append(text[:z].strip())
    for x in range(len(text)):
        if text[x] != separator:
            pass
        else:
            if x == (len(text) - 1):
                row.append('')
            else:
                if separator in text[(x + 1):]:
                    y = text.find(separator, (x + 1))
                    c = text[(x + 1):y].strip()
                else:
                    c = text[(x + 1):].strip()
                row.append(c)
    return row
##########################################################################################
def createTuple(oldFile):
    f1 = open(oldFile, "r")
    tup = []
    while 1:
        text = f1.readline()
        if text == "":
            break
        else:
            pass
        text = re.sub(r"^(.*)(\s*)$", r"\1", text)
        #multi-spaces
        text = re.sub(' +', ' ', text)
        if text.find(",") >= 0:
            row = fixText(text.strip(), ',')
        else:# text[:1] != '#':
            row = fixText(text.strip(), ' ')
        tup.append(row)
    return tup
##########################################################################################

import os
import csv

print("input file path >> ")
boxdir = input()

print("output file path >>")
path = input()

outdirs = f"{path}/directories.csv"
outdirsep = f"{path}/directorysep.csv"
outfiles = f"{path}/files.csv" 
outfilesep = f"{path}/filesep.csv" 

with open(outfiles, mode='w', encoding='utf-16', newline="") as f:
    writer = csv.writer(f, dialect='excel-tab', quoting=csv.QUOTE_ALL)
    for root, dirs, files in os.walk(top=boxdir):
        for file in files:
            writer.writerow([root, file])
            print(f'{root},{file}\n')

print("================= START sep files ======================")
print("")
with open(outfilesep, mode='w', encoding='utf-16', newline="") as f:
    writer = csv.writer(f, dialect='excel-tab', quoting=csv.QUOTE_ALL)
    for root, dirs, files in os.walk(top=boxdir):
        for file in files:
            line = (os.path.join(root, file)).split("\\")
            writer.writerow(line)


print("================= START dirs ======================")
print("")
with open(outdirs, mode='w', encoding='utf-16', newline="") as f:
    writer = csv.writer(f, dialect='excel-tab', quoting=csv.QUOTE_ALL)
    for root, dirs, files in os.walk(top=boxdir):
        for dir in dirs:
            dirPath = os.path.join(root, dir)
            writer.writerow([dirPath])


print("================= START sepdirs ======================")
print("")
with open(outdirsep, mode='w', encoding='utf-16', newline="") as f:
    writer = csv.writer(f, dialect='excel-tab', quoting=csv.QUOTE_ALL)
    for root, dirs, files in os.walk(top=boxdir):
        for dir in dirs:
            line = (os.path.join(root, dir)).split("\\")
            writer.writerow(line)

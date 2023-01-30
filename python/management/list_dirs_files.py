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

with open(outfiles, mode='w', encoding='UTF-8') as f:
    for root, dirs, files in os.walk(top=boxdir):
        for file in files:
            f.write(f'{root},{file}\n')
            print(f'{root},{file}\n')

print("================= START sep files ======================")
print("")
with open(outfilesep, mode='w', encoding='UTF-8', newline="") as f:
    writer = csv.writer(f, delimiter=",")
    for root, dirs, files in os.walk(top=boxdir):
        for file in files:
            line = (os.path.join(root, file)).split("\\")
            writer.writerow(line)


print("================= START dirs ======================")
print("")
with open(outdirs, mode='w', encoding='UTF-8') as f:
    for root, dirs, files in os.walk(top=boxdir):
        for dir in dirs:
            dirPath = os.path.join(root, dir)
            f.write(f'{dirPath}\n')


print("================= START sepdirs ======================")
print("")
with open(outdirsep, mode='w', encoding='UTF-8', newline="") as f:
    writer = csv.writer(f, delimiter=",")
    for root, dirs, files in os.walk(top=boxdir):
        for dir in dirs:
            line = (os.path.join(root, dir)).split("\\")
            writer.writerow(line)

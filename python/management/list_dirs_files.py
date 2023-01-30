import os

print("input file path >> ")
boxdir = input()

print("output file path >>")
path = input()

outdirs = f"{path}/directories.csv"
outfiles = f"{path}/files.csv" 

with open(outfiles, mode='w') as f:
    for root, dirs, files in os.walk(top=boxdir):
        for file in files:
            filePath = os.path.join(root, file)
            f.write(f'{filePath}')

with open(outdirs, mode='w') as f:
    for root, dirs, files in os.walk(top=boxdir):
        for dir in dirs:
            dirPath = os.path.join(root, dir)
            f.write(f'{dirPath}')

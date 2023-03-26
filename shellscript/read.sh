#!/bin/bash

echo -e "input your name"
read name
echo "your name is " $name


echo -e "input file path"
read file_path

while read line
do
    echo $line
done < $file_path

#!/bin/bash

var1=1
var2=10

if [ $var1 -gt 1 -a $var2 -lt 10 ];
then
    echo "first statement"
elif [ $var1 -gt 1 -o $var2 -lt 10 ];
    echo "second statement"
else
    echo "else statement"
fi
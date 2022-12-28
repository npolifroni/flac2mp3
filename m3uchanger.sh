#!/bin/bash

sourcef=${1}
targetf=${2}
numparams=($#)

if [ $numparams -lt 2 ]; then
    echo "Missing parameter(s)";
    exit;
fi


while read line ; 
do 
    newval="${line%.*}.mp3"
    echo -e "${newval}" >> "${targetf}"
done < "${sourcef}"




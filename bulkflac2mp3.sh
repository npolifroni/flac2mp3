#!/bin/bash

bulkfile=${1}
numparams=($#)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while read line ; 
do 

    IFS=';' read -ra ADDR <<< "${line}"
    sourcef=${ADDR[0]}
    targetf=${ADDR[1]}
    echo from "${sourcef}" to "${targetf}"
    echo 
    echo
    "${SCRIPT_DIR}"/flac2mp3.sh -f -s "${ADDR[0]}/" -t "${ADDR[1]}/"
    echo 
    echo
    echo next

done < "${bulkfile}"
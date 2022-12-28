#!/bin/bash

#TODO
# make options instead of parameters
# ingest csv with source/target dirs
# check if target directory has files


type ffmpeg >/dev/null 2>&1 || { echo >&2 "This script requires ffmpeg. Aborting."; exit 1; }

sourcef=${1}
targetf=${2}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -d ${targetf} ]]
then
    echo "${targetf} exists on your filesystem."
else
    
    while true; do

        read -p "Directory ${targetf} does not exist, create is? (y/n) " yn

        case $yn in 
	        [yY] ) echo Creating directory...;
		        break;;
	        [nN] ) echo exiting...;
		        exit;;
	        * ) echo invalid response;;
        esac

    done
    
    mkdir "${targetf}"
fi

for f in "${sourcef}"*.flac;
    do 
    base_name=$(basename "${f}");
    ffmpeg -i "${f}" -codec:v copy -codec:a libmp3lame -q:a 2 "${targetf}"/"${base_name%.flac}.mp3";
done

for f in "${sourcef}"*;
    do 
    [[ $f == *.flac ]] && continue;
    if [[ $f == *.m3u ]]; then
        base_name=$(basename "${f}");
        echo "${targetf}${base_name}"
        "${SCRIPT_DIR}"/m3uchanger.sh "${f}" "${targetf}${base_name}"     
    else
        cp "${f}" "${targetf}"
    fi
done


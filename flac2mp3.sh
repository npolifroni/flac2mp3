#!/bin/bash

nlines=$(ls "${1}")


if [[ -d ${2} ]]
then
    echo "${2} exists on your filesystem."
else
    
    while true; do

    read -p "Directory ${2} does not exist, create is? (y/n) " yn

    case $yn in 
	    [yY] ) echo ok, we will proceed;
		    break;;
	    [nN] ) echo exiting...;
		    exit;;
	    * ) echo invalid response;;
    esac

    done
    
    mkdir "${2}"
fi

for f in "${1}"*.flac;
    do 
    base_name=$(basename "${f}");
    ffmpeg -i "${f}" -codec:v copy -codec:a libmp3lame -q:a 2 "${2}"/"${base_name%.flac}.mp3";
done

for f in "${1}"*;
    do 
    [[ $f == *.flac ]] && continue;
    cp "${f}" "${2}"
done


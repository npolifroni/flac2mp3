#!/bin/bash


type ffmpeg >/dev/null 2>&1 || { echo >&2 "This script requires ffmpeg. Aborting."; exit 1; }


promptdir=1

while getopts ":fs:t:" optname
    do
      case "$optname" in
        "f")
          promptdir=0
          echo "Option $optname has value $OPTARG"
          ;;
        "s")
          sourcef=$OPTARG
          echo "Option $optname has value $OPTARG"
          ;;
        "t")
          targetf=$OPTARG
          echo "Option $optname has value $OPTARG"
          ;;
        "?")
          echo "Unknown option $OPTARG"
          ;;
        ":")
          echo "No argument value for option $OPTARG"
          ;;
        *)
        # Should not occur
          echo "Unknown error while processing options"
          ;;
      esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift



#sourcef=${1}
#targetf=${2}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo Running flac2mp3 from ${sourcef} target to ${targetf}

if [[ -d ${targetf} ]]
then
    echo "${targetf} exists on your filesystem."
else
    
    while true && [ "$promptdir" -eq 1 ] ; do

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
    echo doing "${sourcef}${base_name}"
    < /dev/null ffmpeg -hide_banner -i "${f}" -n -codec:v copy -codec:a libmp3lame -q:a 2 "${targetf}"/"${base_name%.flac}.mp3";
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

#!/bin/bash
#Copyright (C) 2018 Hanyuan Liu (lhy2871@126.com)
set -u #use utf-8
LANG="" #use default language coding
if [ -f "$1" ];then
	clear
	echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo -e "@ Script written by Hanyuan  Sep.-20-2018 @"
	echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    ffmpeg -vn -i "$1" -acodec mp3 `dirname "$1"`"/"`basename "$1" ".wav"`".mp3" 2>> ${log}
    echo -e "\nNew file(s) saved at: \033[42;37;1m"$1"".mp3"\033[0m\n"
    exit
else
    if [ -d "$1" ];then
        mainfolder="${1##*/}" #get the latest file folder which contans the main files
    fi
fi
newfolder="mp3"

#GenereateLogName
cd "$1"
if [ "$1" = "/" ]
then
    #return ""
    log="/"${newfolder}"/"${newfolder}"_"$(date +%Y%b%d)""$(date +_%H%M%S)".log"
    realpath="/"
else
    #return $(pwd)
    log="$(pwd)""/""${newfolder}""/""${newfolder}"".log"
    realpath="$(pwd)"
fi
#cd ..
#/GenereateLogName

function encmp3 {
    newfileName="${realpath}""/${newfolder}/"`basename "$1" ".wav"`".mp3"
    #echo -e ${newfileName}
    #cd "$1"
    if [ -s "${newfileName}" ];then
        return 0;
    else
        #echo "debug"
        echo -ne "Transcoding2MP3: \033[43;37m`basename "$1"`\033[0m\r"
        ffmpeg -vn -i "$1" -acodec mp3 ${newfileName} 2>> ${log}
        echo -e "\n" >> ${log}
    fi
}

function show_error {
	echo -e "\033[41;37;5m\nSource folder is empty.\nEncode FAILED\n\033[0m"
}

function scandir {
	local cur_dir in_dir
    in_dir="$1"
    cd "${in_dir}"
    if [ "${in_dir}" = "/" ]
    then
        cur_dir=""
    else
        cur_dir="$(pwd)"
    fi

    for filelist in $(find . -type f ! -name "remux_*" ! -name ".*" ! -path "*/.*" -print)
    do
            encmp3 "${filelist}"
    done
}

clear
echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo -e "@ Script written by Hanyuan  Sep.-20-2018 @"
echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -e "Source folder is \033[42;37;1m"${mainfolder}"\033[0m"

#Main_body_EncodeMP3
if [ "`ls "$1"`" = "" ]; then # if the source foder is not empty
    show_error
	exit 0
else
    mkdir "$1""/""${newfolder}"
    echo -e "New file(s) saved at: \033[42;37;1m"$1""/""${newfolder}"\033[0m\n"
	scandir "$1"
    echo -e "\033[42;37;1mAll audio files has Encoded to MP3!\nHave a nice day!\033[0m\n"
    #find . -type d ! -name "remux_*" ! -name ".*" ! -path "*/.*" -print
fi
#!/usr/bin/env bash
#
# This script assumes a linux environment
#


DES=${1-/tmp}
DIR=${2-_locales}

hash jq 2>/dev/null || { echo; echo >&2 "Error: this script requires jq (https://stedolan.github.io/jq/), but it's not installed"; exit 1; }

printf "*** Generating locale files in $DES... "

LANGS=(en zh_TW zh_CN de fr ru it sk pt_PT pt_BR es)
FILES=src/_locales/**/adnauseam.json
reference=src/_locales/en/adnauseam.json
refLength=`jq '. | length' $reference`
refDes=`jq 'map(.description)' $reference`
report=0
# echo "Languages:" ${LANGS[*]}

for adnfile in $FILES
do
  messages="${adnfile/adnauseam/messages}"
  out="${messages/src/$DES}"
  outfile=`echo $out | sed "s/_locales/${DIR}/"`
  dir=`dirname $outfile`
  out="${out/\/messages.json/}"
  lang=`basename $out`
  length=`jq '. | length' $adnfile`
  curDes=`jq 'map(.description)' $adnfile`
  # continue ONLY IF $lang is in LANGS
  if [[ " ${LANGS[@]} " =~ " $lang " ]]
  then
    mkdir -p $dir && touch $outfile
    #echo Writing $outfile

    #Notification when English locale has changes
    if [[ "$length" -ne "$refLength" || "$refDes" != "$curDes" ]]
       then
          [ "$report" -eq "0" ] && echo -e "\nThere are new changes in the English locale file. Please update the locale folder"
          let "report++"
    fi

    jq -s '.[0] * .[1]' $messages $adnfile > $outfile
    sed -i -e "s/uBlock₀/AdNauseam/g" $outfile
    sed -i -e "s/uBlock Origin/AdNauseam/g" $outfile
    sed -i -e "s/ ＋ / \/ /g" $outfile
    sed -i -e "s/Ctrl+click/Alt+click/g" $outfile
  fi

done

#echo && ls -Rl $DES/*

echo "done."

#less /tmp/_locales/en/messages.json

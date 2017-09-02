#!/usr/bin/env bash
#
# This script assumes a linux/OSX environment

DES=$1/assets

if [ $# -eq 0 ]
  then
    echo "[FATAL] No destination supplied"
    exit
fi

printf "*** Packaging assets in $DES... "

if [ -n "${TRAVIS_TAG}" ]; then
  echo "it's me"
  pushd .. > /dev/null
  pwd
  git clone https://github.com/uBlockOrigin/uAssets.git
  ls -lia uAssets
  popd > /dev/null
fi

rm -rf $DES
mkdir $DES
cp    ./assets/assets.json                                       $DES/

mkdir $DES/thirdparties
echo ""
pwd
ls -lia ..
cp -R ../uAssets/thirdparties/easylist-downloads.adblockplus.org $DES/thirdparties/
cp -R ../../uAssets/thirdparties/mirror1.malwaredomains.com         $DES/thirdparties/
cp -R ../../uAssets/thirdparties/pgl.yoyo.org                       $DES/thirdparties/
cp -R ../../uAssets/thirdparties/publicsuffix.org                   $DES/thirdparties/
cp -R ../../uAssets/thirdparties/www.malwaredomainlist.com          $DES/thirdparties/
cp -R ../../uAssets/thirdparties/www.eff.org                        $DES/thirdparties/

mkdir $DES/ublock
cp -R ../uAssets/filters/*                                       $DES/ublock/
cp -R ./assets/ublock/filter-lists.json                          $DES/ublock/

# comment out when moved adnauseam.txt to uAssets
# cp assets/ublock/adnauseam.txt                                   $DES/ublock/   # adn

# cp ../uAssets/checksums/ublock0.txt                              $DES/checksums.txt

# append our checksum to the uBlock checksum list
# cat assets/checksum-adn.txt >> $DES/checksums.txt

#cp $DES/checksums.txt ./assets/checksums/ublock0.txt  # for checking in adn repo

echo "done."

#cat ./assets/checksums.txt

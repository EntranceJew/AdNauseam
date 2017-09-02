#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** AdNauseam::Firefox: Copying files"

DES=dist/build/adnauseam.firefox
rm -rf $DES
mkdir -p $DES

#VERSION=`jq .version manifest.json` # top-level adnauseam manifest
UBLOCK=`jq .version platform/chromium/manifest.json | tr -d '"'` # ublock-version no quotes

bash ./tools/make-assets.sh $DES
bash ./tools/make-locales.sh $DES  # locale

cp -R src/css                           $DES/
cp -R src/img                           $DES/
cp -R src/js                            $DES/
cp -R src/lib                           $DES/
#cp -R src/_locales                      $DES/
cp    src/*.html                        $DES/

sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/links.html

mv    $DES/img/icon_128.png             $DES/icon.png
cp    platform/firefox/css/*            $DES/css/
cp    platform/firefox/polyfill.js      $DES/js/
cp    platform/firefox/vapi-*.js        $DES/js/
cp    platform/firefox/bootstrap.js     $DES/
cp    platform/firefox/processScript.js $DES/
cp    platform/firefox/frame*.js        $DES/
cp -R platform/firefox/img              $DES/
cp    platform/firefox/chrome.manifest  $DES/
cp    platform/firefox/install.rdf      $DES/
cp    platform/firefox/*.xul            $DES/
cp    LICENSE.txt                       $DES/

echo "*** AdNauseam::Firefox: Generating meta..."
python tools/make-firefox-meta.py $DES/ "$2"


echo "*** AdNauseam::Firefox: Creating package..."
pwd
pushd $(dirname $DES/) > /dev/null
pwd
mkdir -p ../artifacts
if [ -n "${TRAVIS_TAG}" ]; then
  filename=adnauseam-${TRAVIS_TAG}.firefox
  altname=adnauseam-${TRAVIS_TAG}.webext
else
  filename=adnauseam.firefox
  altname=adnauseam.webext
fi
zip ../artifacts/${filename}.xpi -qr ./*
cp ../artifacts/${filename}.xpi ../artifacts/${altname}.zip
pwd
ls -lia .
ls -lia ../artifacts
popd > /dev/null

echo "*** AdNauseam::Firefox: Package done."
echo

#cat $DES/popup.html | less

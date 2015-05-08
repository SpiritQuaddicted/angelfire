#!/bin/bash
set -e
set -u

# FEED ME USERS LIKE THIS
# bash downloaduser.sh realm/name

workingdirectory=/tmp/
cd "${workingdirectory}"

date=$(date +%Y%m%d)

user=$1
prettyuser=$(echo "${user}" | sed 's#\/#_#g') # used for path of dl dir and filenames

echo "####################"
echo "user is: ${user}"
echo "prettified as: ${prettyuser}"
mkdir -p "${prettyuser}" && cd "${prettyuser}"

# get the user's sitemap
wget -nv -x --no-cookies --directory-prefix="${prettyuser}_${date}" http://www.angelfire.com/"${user}"/sitemap.xml

# extract all the urls from it
grep -Eo '<loc>.*</loc>' "${prettyuser}_${date}"/www.angelfire.com/"${user}"/sitemap.xml | sed 's#<loc>##' | sed 's#</loc>##' > "${prettyuser}_urls"
wc -l "${prettyuser}_urls"

# feed the urls to wget -m
# TODO are angelfire.com and lycos.com enough?
wget -m --no-parent --no-cookies -e robots=off --page-requisites \
--adjust-extension --convert-links \
--append-output="${prettyuser}_${date}.log" \
--directory-prefix="${prettyuser}_${date}" \
--warc-file="${prettyuser}_${date}" \
--domains=angelfire.com,lycos.com \
--reject-regex='(www.angelfire.com\/adm\/ad\/|www.angelfire.com\/doc\/images\/track\/ot_noscript\.gif)' \
-i "${prettyuser}_urls"

echo "${prettyuser} done"

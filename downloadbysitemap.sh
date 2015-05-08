#!/bin/bash
#set -e # will fail somehow
#set -u # will fail somehow
#set -o pipefail # will fail somehow

# bash downloadbysitemap.sh 00

workingdirectory=/tmp/angelfire/
cd "${workingdirectory}"

date=$(date +%Y%m%d)

sitemapID=$1 #00 .. ff

echo "Downloading sitemap ${sitemapID} and all its ~16000 users, hold tight..."

mkdir -p "sitemap-index-${sitemapID}" && cd "sitemap-index-${sitemapID}"

# get the sitemap
wget -nv -x --no-cookies http://www.angelfire.com/sitemap-index-"${sitemapID}".xml.gz

# extract all the urls from it
zgrep -Eo '<loc>.*</loc>' www.angelfire.com/sitemap-index-"${sitemapID}".xml.gz | \
sed 's#<loc>http://www.angelfire.com/##' | \
sed 's#/sitemap.xml</loc>##' > "sitemap-index-"${sitemapID}".users"

wc -l "sitemap-index-"${sitemapID}".users"

while read user
do
	bash ABSOLUTEPATHTO/downloaduser.sh "${user}" #TODO path of script...
done < "sitemap-index-"${sitemapID}".users"

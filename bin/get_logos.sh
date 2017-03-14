#!/bin/bash

abspath="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
bin_dir=`dirname $abspath`
root_dir=`dirname $bin_dir`
app_name=`basename $root_dir`

cat $root_dir/data/bracket.json | jq -r .games[].home.iconURL | grep "." | sed 's/^/i.turner.ncaa.com/' > icon_urls
cat $root_dir/data/bracket.json | jq -r .games[].away.iconURL | grep "." | sed 's/^/i.turner.ncaa.com/' >> icon_urls

while read url; do
  echo $url
  wget -P public/img/ $url
done < icon_urls


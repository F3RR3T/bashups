#! /usr/bin/bash
# Display a markdown file in a browser after converting it to HTML
# SJP 17 Feb 2021
#
# stolen from https://unix.stackexchange.com/questions/24931/how-to-make-firefox-read-stdin/24942
#
# 2021-05-13: update. Firefox no longer allows 'top level URLs' because security
# So I hacked this version from https://gist.github.com/defunkt/318247

# Check that we have a file to read
if [ $# -ne 1 ]; then
    echo "Requires the name of one markdown file"
    exit 1
fi

# check dependencies
if ! command -v marked &> /dev/null; then
    echo "Install 'marked' before running this script"
    exit 1
fi
if ! command -v firefox &> /dev/null; then
    echo "Install 'firefox' before running this script"
    exit 1
fi

mdFile=$1

if [ ${mdFile: -3} != ".md" ]; then
   echo "Works best with a markdown input file, but we'll try to parse it anyway"
fi

hypertext=`mktemp /tmp/mdXXXXXX.html` 

marked ${mdFile} > ${hypertext}
# This actually opens chromium on my system but that's ok
xdg-open ${hypertext}

#  defunct 2021-05-13
#  marked ${mdFile} | firefox "data:text/html;base64,$(base64 -w 0 <&0)"


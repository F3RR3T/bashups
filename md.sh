#! /usr/bin/bash
# Display a markdown file in a browser after converting it to HTML
# SJP 17 Feb 2021
#
# stolen from https://unix.stackexchange.com/questions/24931/how-to-make-firefox-read-stdin/24942

if [ $# -ne 1 ]; then
    echo "Requires the name of one markdown file"
    exit 1
fi

if ! command -v marked &> /dev/null; then
    echo "Install 'marked' before running this script"
    exit 1
fi
if ! command -v firefox &> /dev/null; then
    echo "Install 'firefox' before running this script"
    exit 1
fi


echo there were $# arguments
mdFile=$1
marked ${mdFile} | firefox "data:text/html;base64,$(base64 -w 0 <&0)"


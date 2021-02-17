#! /usr/bin/bash
# Display a markdown file in a browser after converting it to HTML
# SJP 17 Feb 2021
#
# stolen from https://unix.stackexchange.com/questions/24931/how-to-make-firefox-read-stdin/24942

source = $1

marked $source | firefox "data:text/html;base64,$(base64 -w 0 <&0)"


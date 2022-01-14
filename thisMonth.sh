#!/usr/bin/bash
#
# SJP 14 Jan 2022
#
# Once per month, update my 'nowX' softlinks.
#
# Background
# In my home directory, I have some lymlinks that point to my 'current' working directories.
# I have two main ones:
#   1) Year-delimited for most documents and projects
#       '.../dropbox/... .../life/YYYY/<files|directories>'
#
#   2) Month-delimited for images and soundfiles
#       '.../pix/YYYY/MM/<files|directories>'
#
# I would like to automate changes to the symlinks to relieve the
# 'burden' of changing them annually/monthly.
# At the moment I just point 'nowpix' to the current year and then navigate to the monthly directory.
#
# TODO: actual code, timer and service...

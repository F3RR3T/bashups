#!/bin/bash
# automate nightshot detection using 'mean' function in imagemagick
# SJP 6 Nov 2017



pix

mean=$(identify -format %[mean] ${picdate}.jpg | sed s/[.].*//)

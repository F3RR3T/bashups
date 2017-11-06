#!/bin/bash
# script to backup pix to walrus
# SJP 4 April 2017


# Move files from Stan
# https://logbuffer.wordpress.com/2011/03/24/linux-copy-only-certain-filetypes-with-rsync-from-foldertree/
src=st33v.ddns.net:/home/st33v/cams/
dst=~/pix/ixus/2017/camz
rsync -a --remove-source-files --include='*/' --include='*.jpg' --exclude='*' -e "ssh -p 51337" $src $dst

# Is walrus mounted already?
mountpoint -q /mnt/eye
if [ $? -eq 1 ]; then
	echo "Mounting walrus/pix to /mnt/eye."
	mount /mnt/eye
fi

if [ $? -ne 0 ]; then
	echo "Mounting walrus/pix failed - exiting"
	exit 1
fi

echo "Backing up pix to walrus."

begin=$(date +"%s")

rsync -a /mnt/dox/pix/* /mnt/eye
#rsync -avn /mnt/dox/pix/* /mnt/eye

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution."

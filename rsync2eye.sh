#!/bin/bash
# script to backup pix to walrus
# SJP 4 April 2017


# Move files from Stan
# https://logbuffer.wordpress.com/2011/03/24/linux-copy-only-certain-filetypes-with-rsync-from-foldertree/

thisyear=$(date +%Y)

src=st33v.ddns.net:/home/st33v/cams/
dst=~/pix/ixus/${thisyear}/camz
if [ ! -d ${dst} ]; then
	makedir -p ${dir}
fi
echo "$(date). Starting to move images from stan."
begin=$(date +"%s")
rsync -a --remove-source-files --include='*/' --include='*.jpg' --exclude='*' -e "ssh -p 51337" $src $dst

if [ $? -ne 0 ]; then
	echo "rsync from stan failed with exit code $? - exiting"
	exit 1
fi

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy from Stan."

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

echo "Starting at $(date). Backing up pix to walrus."


begin=$(date +"%s")
rsync -a /mnt/dox/pix/* /mnt/eye
#rsync -avn /mnt/dox/pix/* /mnt/eye

termin=$(date +"%s")
difftimelps=$(($termin-$begin))

echo "Finished at $(date)"
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy to Walrus."

#!/bin/bash
# script to backup pix to walrus
# SJP 4 April 2017


# Move files from Stan
# https://logbuffer.wordpress.com/2011/03/24/linux-copy-only-certain-filetypes-with-rsync-from-foldertree/

# read local config from file. The following lines define the variables and
# give examples for use. They will be overwritten by sourcing from local.config
src=remoteSystem:/path/to/photos
localpicdir=~/localpix
walrusmountpoint=/mnt/walrus/eye
# end of local.config vars

if [ -e local.config ]; then
    . local.config             # source directory name from local config file
else
    echo "local.config does not exist"; exit 1
fi
thisyear=$(date +%Y)
localpicdir=${localpicdir}/${thisyear}

if [ ! -d ${dst} ]; then
	makedir -p ${dir}
fi
echo "$(date). Starting to move images from stan."
begin=$(date +"%s")
rsync -a --remove-source-files --include='*/' --include='*.jpg' --exclude='*' -e "ssh -p 51337" $src ${localpicdir}/stansCams

if [ $? -ne 0 ]; then
	echo "rsync from stan failed with exit code $? - exiting"
	exit 1
fi

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy from Stan."

# Is walrus mounted already?
mountpoint -q ${walrusmountpoint}
if [ $? -eq 1 ]; then
	echo "Mounting walrus/pix to ${walrusmountpoint}."
	mount ${walrusmountpoint}
fi

if [ $? -ne 0 ]; then
	echo "Mounting walrus/pix failed - exiting"
	exit 1
fi

echo "Starting at $(date). Backing up pix to walrus."

begin=$(date +"%s")
rsync -a ${localpicdir}/* ${walrusmountpoint}

termin=$(date +"%s")
difftimelps=$(($termin-$begin))

echo "Finished at $(date)"
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy to Walrus."

#!/bin/bash
# script to backup pix drom stan to walrus
# SJP 4 April 2017
# Stan is the boss of all raspberry pis in my LAN. He is named after
# my imaginary STANdard poodle, who will also be a cattle dog. Thus Stan
# is in charge of all the other devices and keep strack of what they
# are doing.
#
# Walrus is a NAS (Network-Attached Storage). It is a Synology 2-disk model
# that looks a bit like a beached whale but its whiteness made me think
# of a walrus tusk. 
# I'm not always at stan's house, and walrus comes with me when I travel. So
# I have to include local config settings.

# Move files from Stan
# https://logbuffer.wordpress.com/2011/03/24/linux-copy-only-certain-filetypes-with-rsync-from-foldertree/

# read local config from file. The following lines define the variables and
# give examples for use. They will be overwritten by sourcing from local.config
src=remoteSystem:/path/to/photos
localpicdir=~/localpix
walrusmountpoint=/mnt/walrus/eye
sshport=22
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
rsyncstr="-a --remove-source-files --stats --include='*/' --include='*.jpg' --exclude='*'"
rsync ${rsyncstr} -e "ssh -p ${sshport} " $src ${localpicdir}/stansCams

if [ $? -ne 0 ]; then
	echo "rsync from stan failed with exit code $? - exiting"
	exit 1
fi

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy from Stan."

# Is walrus mounted already?
# This bit doesn't work too well. I need to mount as sudo.. hmmm
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
rsync -a --stats  ${localpicdir}/* ${walrusmountpoint}

termin=$(date +"%s")
difftimelps=$(($termin-$begin))

echo "Finished at $(date)"
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed to copy to Walrus."

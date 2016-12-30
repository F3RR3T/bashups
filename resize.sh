#! /bin/bash
# resize photos and put them in a subdirectory
# default is 25% but can add in  an arg later

# check for resize arg in command line
if [ -z $1 ] 
	then reduce=25
	else reduce=$1
fi

# Check for folder name in command line (no spaces of course!)
if [ -z $2 ]
	then smldir='sml'
	else smldir=$2
fi

if [ ! -d $smldir ]
    then mkdir $smldir
    else echo "Folder \"$smldir\" already exists. No files were altered."; exit 1
fi

# remove spaces from filenames
perl-rename -v 's/\s/_/g' *

# rename capital JPG to lower case jpg
if [ $(ls -l *.JPG 2> /dev/null | wc -l) -gt 0 ]
	then perl-rename -v 's/.JPG$/.jpg/' *.JPG
fi

numpix=$(ls -l *.jpg 2> /dev/null| wc -l)
if [ $numpix -eq 0 ] 
    then echo "No jpeg files in this folder"
    exit 1 
fi

for file in *.jpg
	do convert ${file} -resize ${reduce}% ${smldir}/sml-${file}
done

echo "${numpix} pictures were reduced to ${reduce}% and stored in ${smldir}."

exit 0

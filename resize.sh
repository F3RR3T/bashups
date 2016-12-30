#! /bin/bash
# resize photos and put them in a subdirectory
# default is 20% but can add in  an arg later


if [ -z $1 ] 
	then reduce=25
	else reduce=$1
fi

if [ -z $2 ]
	then smldir='sml'
	else smldir=$2
fi


mkdir $smldir
rename -v 's/\s/_/g' *
if [ $(ls -l *.JPG | wc -l) -gt 0 ]
	then rename -v 's/.JPG$/.jpg/' *.JPG
fi

numpix=$(ls -l *.jpg | wc -l)


for file in *.jpg
	do convert ${file} -resize ${reduce}% ${smldir}/sml-${file}
done

echo "${numpix} pictures were reduced to ${reduce}% and stored in ${smldir}."

exit 0

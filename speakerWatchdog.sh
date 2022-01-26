#! /bin/bash
# Workaround for stupid 'powersave' 'feature' of Creative Speakers
#
# SJP 11 Dec 2021
#
# Record a snippet of default stream:

# 0 rec -d  -n trim 0 .1 stat 

#    rec       sox in record mode
#    -d        default input
#    -n        direct output to /dev/null
#    trim 0 .1 duration 0.1 second
#    stat      write info about the audio stream
#    2>&1      redirect stderr to stdout 
#    |         pipe
#    grep      finds this line:    Minimum amplitude:     0.000000
#    |         pipe
#    awk       ruturns just the third word (the number)
#echo hello $USER | systemd-cat -t AlexySayle -p warning
maxAmp=$(rec -d -c1 -n trim 0 .1 stat 2>&1 | grep 'Maximum amplitude' | awk {'print $3'})
echo Max Amplitude = $maxAmp
if [ "$maxAmp" == "0.000000" ]; then
    # if Max amplitude = 0 then we have silence!
    if [ -f "/tmp/silencemarker" ] ; then
        # There was silence last time we checked, so play the tone
        echo Play the sound
        play -nq synth 1 sine 40 fade 0.2 0
        rm /tmp/silencemarker
    else
        touch /tmp/silencemarker
    fi
else 
    if [ -f "/tmp/silencemarker" ] ; then
        rm /tmp/silencemarker
    fi
fi

systemd-run --user --on-active=10m /usr/local/bin/speakerWatchdog.sh

#to generate a tone that is not audible:
#play -n  synth 1 sine  40 fade .2 0
#
#  play    sox alias
#  -n      dummy input file
#  synth   synthesise a sound
#  sine    sine wave [the default, so not strictly necessary]
#  40      Hz
#  fade    fade in from zero volume to max volume over 200 msec.
#          '0' says fade out at end over same period.

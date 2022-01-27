#! /bin/bash
# Workaround for stupid 'powersave' 'feature' of Creative Speakers
#
# SJP 11 Dec 2021
#
# Dependencies:     sox (required)
#                   xprintidle (not required)
#
# Record a snippet of default stream:
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

maxAmp=$(rec -d -c1 -n trim 0 .1 stat 2>&1 | grep 'Maximum amp' | awk {'print $3'})

# xprintidle is logfile eyecandy. Not necessary for the script to work
echo $(xprintidle)  Max Amplitude = "$maxAmp" | \
    systemd-cat -t "idle time (msec) & audio level " -p notice

if [ "$maxAmp" == "0.000000" ]; then
    # We have silence
    if [ -f "/tmp/silencemarker" ] ; then
        # There was silence last time we checked, so play the tone.
        # Even though there may have been some sounds played since the previous
        # observation, let's play it safe.
        echo 'Play inaudible tone (40 Hz for 1 sec)'
        play -nq synth 1 sine 40 fade 0.2 0
    else
        touch /tmp/silencemarker
    fi
else 
    # Sound was detected so remove the marker file if it is there
    if [ -f "/tmp/silencemarker" ] ; then
        rm /tmp/silencemarker
    fi
fi

# Set a 10 minute timer. Accuracy is 'per-minute' so the interval may be
# as long as 11 minutes. This is ok for Creative Gigaworks; they turn off after 11+mins.
systemd-run --user --on-active=10m /usr/local/bin/speakerSqueaker.sh

#TODO: possibly allow actual turn off if no sound has been heard for a 'long' time
#TODO: Measure actual power consumption to see how futile erp actually is
# http://eco3e.eu/regulations/erp-directive/


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

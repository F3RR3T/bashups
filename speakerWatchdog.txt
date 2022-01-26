#! /bin/bash
# Workaround for stupd 'powersave' 'feature' of Creative Speakers
#
# SJP 11 Dec 2021
#
#  This is just a stub for now

# Which device is the audio output going to?

# st33v@cr4y:~$ grep RUNNING /proc/asound/card*/pcm*/sub*/status
# /proc/asound/card2/pcm0p/sub0/status:state: RUNNING

# That is fine, but the status remains as 'RUNNING' even after the speakers have turned themselves off...
# So I'm going down the track of periodically sending a 'sound' to a loopback device
# sudo modprobe snd-aloop
# Now aply -l shows a new 'card' called Loopback.


record one second of default stream:

$ rec -d  -n trim 0 1 stat

    rec       sox in record mode
    -d        default input
    -n        direct output to /dev/null
    trim 0 1  duration 1 second
    stat

Output:

Input File     : 'default' (pulseaudio)
Channels       : 2
Sample Rate    : 48000
Precision      : 16-bit
Sample Encoding: 16-bit Signed Integer PCM

In:0.00% 00:00:01.02 [00:00:00.00] Out:48.0k [      |      ]        Clip:0    
Samples read:             96000
Length (seconds):      1.000000
Scaled by:         2147483647.0
Maximum amplitude:     0.000000
Minimum amplitude:     0.000000
Midline amplitude:     0.000000
Mean    norm:          0.000000
Mean    amplitude:     0.000000
RMS     amplitude:     0.000000
Maximum delta:         0.000000
Minimum delta:         0.000000
Mean    delta:         0.000000
RMS     delta:         0.000000
Rough   frequency:  -2147483648
Done.

So if Max amplitude = 0 then we have silence!

to generate a tone that is not audible:
play -n  synth 1 sine  40 fade .2 0

  play    sox alias
  -n      dummy input file
  synth   synthesise a sound
  sine    sine wave [the default, so not strictly necessary]
  40      Hz
  fade    fade in from zero volume to max volume over 200 msec.
          '0' says fade out at end over same period.

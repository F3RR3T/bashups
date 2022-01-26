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



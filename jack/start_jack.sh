#!/bin/bash
# This is a straight copy of the script at
# https://wiki.archlinux.org/title/JACK_Audio_Connection_Kit
# SJP 27 Oct 2021

jack_control start
jack_control ds alsa
# cat /proc/asound/cards
jack_control dps device hw:PCH  # I think should be the audio playback device
jack_control dps rate 48000
jack_control dps nperiods 2     # 3 for USB (mod from '2' default)
jack_control dps period 64
sleep 10
a2j_control --ehw               # export all available ALSA MIDI ports to JACK MIDI ports
a2j_control --start
sleep 10
qjackctl &

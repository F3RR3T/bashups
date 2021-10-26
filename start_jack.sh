#!/bin/bash
# This is a straight copy of the script at
# https://wiki.archlinux.org/title/JACK_Audio_Connection_Kit
# SJP 27 Oct 2021

jack_control start
jack_control ds alsa
jack_control dps device hw:HD2
jack_control dps rate 48000
jack_control dps nperiods 2
jack_control dps period 64
sleep 10
a2j_control --ehw
a2j_control --start
sleep 10
qjackctl &

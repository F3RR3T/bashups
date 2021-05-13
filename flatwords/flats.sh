# Make a list of 'flat' words.
# A flat word is comprised only of letters that do not have risers or descenders
#
#   SJP 1 Jan 2021

flats=aceimnorsuvwxz

grep -ix "[${flats}]*" < words | awk '{print tolower($0)}' | sed -rn '/^.{3,99}/p' > flatwords.txt

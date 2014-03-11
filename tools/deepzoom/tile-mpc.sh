#!/bin/bash

#usage:
#./tile-mpc.sh wall2-right_merged_55697px.mpc 55697 871

mpcin=$1
picsize=$2
tilesize=$3

tiledir=$4
if [ -z ${tiledir+x} ]; then tiledir="tiles/"; fi

x=0
y=0

while [ $y -lt $picsize ]
do
  ya=$[$y/871]
  yl=$[$picsize-$y]
  yl=$(($yl<871?$yl:871))

  while [ $x -lt $picsize ]
  do
    xa=$[$x/871]
    xl=$[$picsize-$x]
    xl=$(($xl<871?$xl:871))
   
    convert -limit memory 32 -limit map 32 $mpcin -crop $xl"x"$yl+$x+$y +repage $tiledir$xa"_"$ya.jpg
    x=$[$x+871]
  done

  x=0
  y=$[$y+871]
done

#!/bin/bash

input=$1
tilesize=$2
if [ -z $tilesize ]; then tilesize=512; fi
skipfirsttile=$3

#dim=$(mediainfo --Output="Image;%Height%" $input)
dim=$(identify -format "%w" $input)
type=$(identify -format "%m" $input)

if [ $type = "MPC" ]
then
  echo "good, input is already an MPC, we don't need to convert it"
  mpc=$input
else
  echo "will convert input image to MPC format before tiling"

  mpc="${input%.*}"".mpc"
  convert -verbose -monitor -limit memory 2G -limit map 4G $input $mpc
fi

lvl=$(./salado-level-calc.sh $dim)
if [ $skipfirsttile -eq 1 ]
then
  echo "skipfirsttile parameter set, will continue with first resize operation now"
else
  echo "tiling original image (lvl $lvl) now"
  mkdir $lvl
  ./tile-mpc.sh $mpc $dim $tilesize "$lvl/"
fi

lvl=$[$lvl-1]
scale=2
mpcpre=$mpc
mpcl="${input%.*}""_lvl$lvl.mpc"
diml=$[$dim/$scale]

while [ $diml -gt $tilesize ]
do
  echo "will resize for lvl $lvl with scale $scale -> edge length $diml into $mpcl now"

  #for best quality, use $mpc as source, for faster processing, use $mpcpre
  convert -verbose -monitor -limit memory 2G -limit map 4G "$mpcpre" -resize $diml"x"$diml "$mpcl"

  echo "finished resize for lvl $lvl - will start tiling it now"
  mkdir $lvl
  ./tile-mpc.sh $mpcl $diml $tilesize "$lvl/"

  lvl=$[$lvl-1]
  scale=$[$scale*2]
  mpcpre=$mpcl
  mpcl="${input%.*}""_lvl$lvl.mpc"
  diml=$[$dim/$scale]
done

mkdir $lvl
convert -verbose -monitor -limit memory 2G -limit map 4G "$mpcpre" -resize $diml"x"$diml "$lvl/0_0.jpg"

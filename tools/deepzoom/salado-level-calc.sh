#!/bin/bash

# Default scale used by float functions.
float_scale=2

#####################################################################
# Evaluate a floating point number expression.

function float_eval()
{
    local stat=0
    local result=0.0
    if [[ $# -gt 0 ]]; then
        result=$(echo "scale=$float_scale; $*" | bc -q 2>/dev/null)
        stat=$?
        if [[ $stat -eq 0  &&  -z "$result" ]]; then stat=1; fi
    fi
    echo $result
    return $stat
}

#####################################################################
# Evaluate a floating point number conditional expression.

function float_cond()
{
    local cond=0
    if [[ $# -gt 0 ]]; then
        cond=$(echo "$*" | bc -q 2>/dev/null)
        if [[ -z "$cond" ]]; then cond=0; fi
        if [[ "$cond" != 0  &&  "$cond" != 1 ]]; then cond=0; fi
    fi
    local stat=$((cond == 0))
    return $stat
}

#####################################################################
# main script

dim=$1
scale=1
lvl=0
diml=$dim

while float_cond "$diml > 1"
do
  #echo "$diml - $lvl"
  scale=$[$scale*2]
  diml=$(float_eval "$dim / $scale")
  lvl=$[$lvl+1]
done

echo $lvl

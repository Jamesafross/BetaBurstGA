#!/bin/bash
BASEDIR=$(pwd)
MPATH="$BASEDIR/HMM"

matlab -batch "run('$MPATH/Run')" > out.txt

#!/bin/bash
echo "time : $now"
BASEDIR=$(pwd)
JPATH="$BASEDIR/Julia_Code/scripts"
MPATH="$BASEDIR/HMM"
echo "using HMM"

((r = 1))
if (( $r == 1 ))
  then 
  JULIA=julia
  now=$(date +"%T")
  echo "time : $now"

  # Initial Population

  $JULIA --threads 6 $JPATH/makeInitialGeneration.jl
  $JULIA --threads 6 $JPATH/RunMassModel.jl
  matlab -batch "try;run('$MPATH/Run');catch;end;exit"
  echo "Generation 0" > datafiles/BestFitnessLog.txt
  j=0
  for i in {1..5}
  do
  now=$(date +"%T")
  echo "time : $now"
  echo Generation $i >> datafiles/BestFitnessLog.txt
  echo Running Generation: $i
  let j=$j+1
  $JULIA --threads 6 $JPATH/makeNextGeneration.jl
  $JULIA --threads 6 $JPATH/RunMassModel.jl
  matlab -batch "try;run('$MPATH/Run');catch;end;exit"
  done

  $JULIA --threads 6 $JPATH/GetFitnessLastGen.jl


  echo done.
else
 echo "choose a valid burst analysis method "
fi

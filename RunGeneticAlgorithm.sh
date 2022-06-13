#!/bin/bash
now=$(date +"%T")
echo "time : $now"
BASEDIR=$(pwd)
JPATH="$BASEDIR/Julia_Code/scripts"
#read -p "enter burst detection method (HMM/Threshold): " type
#echo "typeBurstAnalysis = \"$type\" " > $JPATH/burstDetectionMethod.jl

#if [ $type == Threshold ]
 # then
    MPATH="$BASEDIR/Threshold"
   # echo "using Threshold"
  #  (( r = 1 )) 
  #elif [ $type == HMM ]
  #then
   # MPATH="$BASEDIR/HMM"
   # echo "using HMM"
    #(( r = 1 ))
  #else
   # echo "invalid choice"
   # (( r = 0 ))
#fi

((r = 1))
if (( $r == 1 ))
  then 
  JULIA=julia
  now=$(date +"%T")
  echo "time : $now"

  # Initial Population

  $JULIA $JPATH/makeInitialGeneration.jl
  $JULIA $JPATH/RunMassModel.jl
  matlab -nodisplay -nojvm -nosplash -nodesktop -r "try;run('$MPATH/Run');catch;end;exit"
  echo "Generation 0" > datafiles/BestFitnessLog.txt
  j=0
  for i in {1..100}
  do
  now=$(date +"%T")
  echo "time : $now"
  echo Generation $i >> datafiles/BestFitnessLog.txt
  echo Running Generation: $i
  let j=$j+1
  $JULIA $JPATH/makeNextGeneration.jl
  $JULIA $JPATH/RunMassModel.jl
  matlab -nojvm -nodesktop -nodisplay  -r "try;run('$MPATH/Run');catch;end;exit"
  done


  echo done.
else
 echo "choose a valid burst analysis method "
fi

#!/bin/bash

OUTPUT=$1
INPUT=$2
LANGUAGES=${@:3}

echo Running examples in $LANGUAGES on input $INPUT

echo "Language,Command,Elapsed,System,User,CPU%,MaxRSS,AvgRSS,AvgData,AvgStack,AvgText,PageSize,Major,Minor,FileIn,FileOut,MsgRec,MsgSent,Signals,Swaps,CtxVol,CtxInvol,WaitSys,ExitStatus" > $OUTPUT

for d in $LANGUAGES
do
    pushd $d

    echo "===== Running benchmark in $d ====="
    echo -n "Starting at " ; date

    /usr/bin/time -f "$(basename $d),%C,%E,%S,%U,%P,%M,%t,%K,%D,%p,%X,%Z,%I,%O,%r,%s,%k,%W,%c,%w,%R,%x" ./run.sh < $INPUT 2> >(grep /run | tee -a ../$OUTPUT >&2)
    
    echo -n "Ending at " ; date
popd
done

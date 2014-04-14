#!/bin/bash
#    python ./pyMPTCP.py --bw 10 --mptcp -n 2 --sshd -O experiment -t 2 --tc --dump --bwm_ng

basal_bwidth="10"
subflow="2"
basal_delay="1ms"


enableMPTCP()
{
    sysctl net.mptcp.mptcp_path_manager=fullmesh
}

clean()
{
    echo "it kills all iperf, bwm-ng,tcpdump  procs"
    echo "*****************************************"
    sysctl net.mptcp.mptcp_path_manager=default
    pkill iperf
    pkill bwm-ng
    pkill tcpdump
    rm ./output/*
    mn -c

}

runMPTCP()
{
    #$1 -O experiment "experiment file"
    #$2 --bw  basal bandwidth for all links
    #$3 --delay basal delay time for all links (symetric)
    #$4 -n subflow (number of links)
    #$5 -t iperf duration
    #$6 --prepend prefix for output files
    #$7 options: --csv, --cli, --sshd, --pause,--dump, --file
    #$8 arg1
    #$9 arg2
    #$10 arg3
    #$11 arg4
    #$12 arg5

    enableMPTCP

    local NARGS=0
    NARGS=$(($#-7))
    
    local COUNT=0
    local optargs=""
    for i in `seq 1 $NARGS`
    do
	COUNT=$(($i+7))
	optargs="$optargs"\ "--arg""$i"\ "${@:(($COUNT)):1}"
	#echo "toto= "$optargs
    done

    echo python ./pyMPTCP.py -O $1 --bw $2 --delay $3 --mptcp -n $4 -t $5 --prepend $6 $7 $optargs

    
    python ./pyMPTCP.py -O $1 --bw $2 --delay $3 --mptcp -n $4 -t $5 --prepend $6 $7 $optargs
}


runTC()
{
   
    experiment="exp001_TC"
    iperf_time="4"
    subflow="2"
    test="runTC"
    options="--bwm_ng\ --tc\ --csv"
    arg1=0

    for arg1 in `seq 0 5`
    do
	prepend="$test""$arg1""$2"
	echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	
    done

}


runTest()
{
    experiment="experiment"
    iperf_time="4"
    subflow="2"
    prepend="runTest"
    arg1=0    
    options="--bwm_ng\ --cli"
    
    echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
    eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options

}


test()
{
    echo "$*"
    tata="titi"
    local tutu
    for i in `seq 2 10`
    do 
	tutu="$tata""$i"
	echo "$tutu" 
	
    done

}


if [ "$1" = "test" ];
then
    test "$2" #$2 trial nb
elif [ "$1" = "runTest" ];
then
    echo "runTest"
    runTest
elif [ "$1" = "runTC" ];
then
    echo "runTC"
    runTC "$2"
elif [ "$1" = "clean" ];
then
    echo "clean"
    clean
else
    echo "Incorrect args"
fi
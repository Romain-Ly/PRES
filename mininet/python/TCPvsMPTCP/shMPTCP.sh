#!/bin/bash
#    python ./pyMPTCP.py --bw 10 --mptcp -n 2 --sshd -O experiment -t 2 --tc --dump --bwm_ng




enableMPTCP()
{
    sysctl net.mptcp.mptcp_path_manager=fullmesh
}
disableMPTCP(){
    sysctl net.mptcp.mptcp_path_manager=default
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

    echo python ./pyMPTCP.py -O $1 --bw $2 --delay $3 -n $4 -t $5 --prepend $6 $7 $optargs

    
    python ./pyMPTCP.py -O $1 --bw $2 --delay $3 -n $4 -t $5 --prepend $6 $7 $optargs
}

#change bwidth for all links 
#add "\ --mptcp" in options to activate MPTCP
#change test for output files prefix
runbw()
{

    subflow="2"
    basal_delay="10ms"
    experiment="exp001_TC"
    iperf_time="60"
    test="runMPTCP-6-bw"
    options="--bwm_ng\ --csv\ --mptcp"
    arg1=0

    for basal_bwidth in `seq 1 2 100` `seq 100 10 400` `seq 500 100 1000`
    do
	prepend="$test""$basal_bwidth""$2"
	echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	
    done
}

runbwTC()
{

    subflow="2"
    basal_delay="10ms"
    basal_bwidth="500"
    experiment="exp001_TC"
    iperf_time="60"
    test="runeth1delay"

    for delay1 in `seq 0 5 200`
    do
	prepend="$test""$delay1""$2"
	#activation tc sur eth1
	options="--bwm_ng\ --csv\ --mptcp\ --tc\ --arg1\ $delay1""ms"
	echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	
    done
}



#change delay for all links 
#add "\ --mptcp" in options to activate MPTCP
#change test for output files prefix
runbasdelay()
{

    basal_delay="10ms"
    basal_bwidth="500"   
    experiment="exp001_TC"
    iperf_time="60"
    subflow="2"
    test="runbasdelay"
    options="--bwm_ng\ --csv\ --mptcp"
    arg1=0

    for basal_delay in `seq 60 5 100`
#`seq 1 30` `seq 32 2 48` `seq 50 5 100`
    do
	prepend="$test""$basal_delay""$2"
	delay="$basal_delay""ms"
	echo runMPTCP $experiment $basal_bwidth $delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $delay $subflow $iperf_time $prepend $options
	
    done

}

#change bwidth for all links 
#add "\ --mptcp" in options to activate MPTCP
#change test for output files prefix
runbwExp3()
{

    subflow="2"
    basal_bwidth="1000"   
    basal_delay="10ms"
    experiment="exp003_TCpingws"
    iperf_time="60"
    test="runMPTCP-3maxq-bw"
    options="--bwm_ng\ --csv\ --mptcp"
    maxq="10000000" 

    for window_size in `seq 1000 5000 100000` `seq 150000 50000 1000000` `seq 2000000 1000000 10000000`
    do
	prepend="$test""$window_size""$2"
	options="--bwm_ng\ --csv\ --mptcp\ --maxq\ $maxq\ --arg1\ $window_size"
	echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
	
    done
}


rundelay5subflow()
{

    basal_delay="5ms"
    basal_bwidth="500"   
    experiment="exp004_TCmultipleflow"
    iperf_time="60"
    subflow="5"
    test="run5sub-delay"
    options="--bwm_ng\ --csv\ --mptcp"

    slope=-1
    max1=10
    max2=20
    max3=100
    max4=470
    xhalf=5
    for i in `seq 1 0.1 10`
    do 

	delay1="1"
	delay2=$(echo "scale=2; $max1/(1+e(($i-$xhalf)/$slope));" | bc -l)
	delay3=$(echo "scale=2; $max2/(1+e(($i-$xhalf)/$slope));" | bc -l)
	delay4=$(echo "scale=2; $max3/(1+e(($i-$xhalf)/$slope));" | bc -l)
	delay5=$(echo "scale=2; 30+$max4/(1+e(($i-$xhalf)/$slope));" | bc -l)

	prepend="$test""$i""$2"
	delay="$basal_delay""ms"
	options="--bwm_ng\ --csv\ --mptcp\ --tc\ --arg1\ $delay1""ms""\ --arg2\ $delay2""ms""\ --arg3\ $delay3""ms""\ --arg4\ $delay4""ms""\ --arg5\ $delay5""ms"
	echo runMPTCP $experiment $basal_bwidth $delay $subflow $iperf_time $prepend $options
	eval runMPTCP $experiment $basal_bwidth $delay $subflow $iperf_time $prepend $options
	
    done

}


runTest()
{
    experiment="exp001_TC"
    iperf_time="4"
    subflow="2"
    prepend="runTest"
    arg1=0    
    options="--bwm_ng\ --csv"
    
    echo runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options
    eval runMPTCP $experiment $basal_bwidth $basal_delay $subflow $iperf_time $prepend $options

}


test()
{

    slope=-1
    max1=10
   # result1=  max1/(1+exp((a-5)/slope))
    max2=20
  #  result2= max2/(1+exp((a-5)/slope))
    max3=100
 #   result3= max3/(1+exp((a-5)/slope))
    max4=470
#    result4=30+max4/(1+exp((a-5)/slope))
    xhalf=5
    for i in `seq 1 0.1 10`
    do 

	result1=$(echo "scale=2; $max1/(1+e(($i-$xhalf)/$slope));" | bc -l)
	result2=$(echo "scale=2; $max2/(1+e(($i-$xhalf)/$slope));" | bc -l)
	result3=$(echo "scale=2; $max3/(1+e(($i-$xhalf)/$slope));" | bc -l)
	result4=$(echo "scale=2; 30+$max4/(1+e(($i-$xhalf)/$slope));" | bc -l)
	echo $result4

    done

}

if [ "$1" = "rundelay5subflow" ];
then
    rundelay5subflow
elif [ "$1" = "runbwTC" ];
then
    runbwTC "$2" #$2 trial nb
elif [ "$1" = "runbwExp3" ];
then
    runbwExp3 "$2" #$2 trial nb
elif [ "$1" = "runbasdelay" ];
then
    runbasdelay "$2" #$2 trial nb
elif [ "$1" = "runbw" ];
then
    runbw "$2" #$2 trial nb
elif [ "$1" = "test" ];
then
    test "$2" #$2 trial nb
elif [ "$1" = "runTest" ];
then
    echo "runTest"
    runTest "$2"
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
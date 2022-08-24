#!/bin/bash

modprobe moal mod_para=nxp/wifi_mod_para.conf
sleep 3

func2()
{
    ifconfig mlan0 down
    ifconfig wfd0 down
    ifconfig wlp1s0 down
    rmmod moal
    sleep 1
    
    modprobe moal mod_para=nxp/wifi_mod_para.conf
    sleep 3
    func1
}
   

func1() 
{
    add=$(ifconfig | grep Ethernet | awk {'print $1'})
    echo $add

    for item in $add
        do 
         if [ $item == "mlan0" ];then 
             func2
         elif [ $item == "uap0" ];then
             systemctl stop wpa_supplicant
         fi  
        done       
}

func1


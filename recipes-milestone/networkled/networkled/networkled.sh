#!/bin/sh

source /etc/entomologist/network_led.conf

#exporting gpio5 pin
echo 353 > /sys/class/gpio/export

#setting pin to output
echo "out" > /sys/class/gpio/gpio353/direction

#gpio pin low
echo 0 > /sys/class/gpio/gpio353/value
led_state=OFF

#initializing variables
internet_status_google=random_data
internet_status_aws=random_data

#reading serial ID
SerialID=$(cat /etc/entomologist/ento.conf | awk '/SERIAL_ID/ {print $2} ' | tr -d '",')

#aws url to ping request
address='https://ush9tkb8hj.execute-api.us-west-2.amazonaws.com/hbeat?deviceId='$SerialID


boot='https://ush9tkb8hj.execute-api.us-west-2.amazonaws.com/boot?deviceId='$SerialID

#curl -s --connect-timeout 5  $boot

net_status=not_connected
net_status=$(curl --connect-timeout 10 -sI http://www.google.com | awk '/200/ {print $2}')

while true
do
  if [ $net_status = "200" ]
  then
      break
  fi
  echo "No Internet" > /tmp/netstatus
  sleep 10
  net_status=$(curl --connect-timeout 10 -sI http://www.google.com | awk '/200/ {print $2}')
done

curl -s --connect-timeout 10  $boot

while true
do
     #checking network connectivity
     internet_status_google=$(curl --connect-timeout 10 -sI http://www.google.com | awk '/200/ {print $2}')
     internet_status_aws=$(curl -s --connect-timeout 10  $address | awk '/OK/ {print $1}'| tr -d '"')



   if [ $internet_status_google = "200" ] || [ $internet_status_aws = "OK" ]
   then
       if [ $led_state = OFF ]
       then
           led_state=ON
           echo 1 > /sys/class/gpio/gpio353/value
           echo "connected"
           echo "connected" > /tmp/netstatus
       fi
   else
       if [ $led_state = ON ]
       then
           led_state=OFF
           echo 0 > /sys/class/gpio/gpio353/value
           echo "disconnected"
           echo "disconnected" > /tmp/netstatus
       fi
   fi
sleep $ping_delay
done

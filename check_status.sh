#!/bin/bash


var1=$(docker exec -i nso1 ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data1=$(($var1))
Result=$(($Data1))

echo "NSO Status: "
echo -ne "NOT READY: NSO1 Status: $var1\033[0K\r"

while [ $Result -ne 0 ]
do
var1=$(docker exec -i nso1 ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data1=$(($var1))
Result=$(($Data1))

echo -ne "NOT READY: NSO1 Status: $var1\033[0K\r"
sleep 5
done

#sleep 2
echo -e "READY: NSO1\033[0K\r"

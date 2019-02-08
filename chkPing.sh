#!/bin/bash
IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
status=`ping -c 1 ${CMD[1]} | echo $?`

if [[ $status != 0 ]] ;then
     echo "3" > ${CMD[1]}/output/${CMD[3]}
     echo "Server" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "ERROR - ${CMD[1]} no response to ping" >> ${CMD[1]}/output/${CMD[3]}
     echo "Runway" >> ${CMD[1]}/output/${CMD[3]}
else
     echo "0" > ${CMD[1]}/output/${CMD[3]}
     echo "Server" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "${CMD[1]} is pingable." >> ${CMD[1]}/output/${CMD[3]}
     echo "Runway" >> ${CMD[1]}/output/${CMD[3]}
fi


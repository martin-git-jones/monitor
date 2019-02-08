#!/bin/bash
IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
HOST=${CMD[1]}
diskused=`ssh -o PasswordAuthentication=no -x -t -t -o StrictHostKeyChecking=no -i ec2-key  ec2-user@$HOST df --output=pcent | tail -n+2 | awk '{print 0+(substr($0, 1, length($0)-1))}' | sort -nr |head -1`
if [[ $diskused -eq '' ]] ; then
    diskused=UNKNOWN
fi
if [[ $diskused -gt 80 ]] || [[ $diskused == 'UNKNOWN' ]];then
     echo "3" > ${CMD[1]}/output/${CMD[3]}
     echo "Disk use" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "ERROR - Disk use is ${diskused} " >> ${CMD[1]}/output/${CMD[3]}
     echo "Training PC" >> ${CMD[1]}/output/${CMD[3]}
else
     echo "0" > ${CMD[1]}/output/${CMD[3]}
     echo "Disk use" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "Disk use is ${diskused}% " >> ${CMD[1]}/output/${CMD[3]}
     echo "Training PC" >> ${CMD[1]}/output/${CMD[3]}
fi


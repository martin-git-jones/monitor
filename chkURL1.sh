#!/bin/bash
IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
HOST="eng-trn-pc.avivaaws.com"
URL="http://eng-trn-pc.avivaaws.com:8080/pc/PolicyCenter.do"
status=`ssh -o PasswordAuthentication=no -x -t -t -o StrictHostKeyChecking=no -i ec2-key  ec2-user@$HOST curl -k -s -o /dev/null -w "%{http_code}"  $URL`;
if [[ $status != 200 ]] ;then
     echo "3" > ${CMD[1]}/output/${CMD[3]}
     echo "PolicyCenter" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "ERROR - $URL is unreachable" >> ${CMD[1]}/output/${CMD[3]}
     echo "Training" >> ${CMD[1]}/output/${CMD[3]}

else
     echo "0" > ${CMD[1]}/output/${CMD[3]}
     echo "PolicyCenter" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "OK - $URL is reachable." >> ${CMD[1]}/output/${CMD[3]}
     echo "Training" >> ${CMD[1]}/output/${CMD[3]}
fi


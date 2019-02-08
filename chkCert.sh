#!/bin/bash
IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
HOST=${CMD[1]}
URL="$HOST:8443"

if true | openssl s_client -connect $URL 2>/dev/null |   openssl x509 -noout -checkend 0; then  status=0; else   status=1; fi
if [[ status -eq 1 ]] ;then
     echo "3" > ${CMD[1]}/output/${CMD[3]}
     echo "Certificate" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "Certificate is invalid" >> ${CMD[1]}/output/${CMD[3]}
     echo "ExtDev" >> ${CMD[1]}/output/${CMD[3]}
else
     echo "0" > ${CMD[1]}/output/${CMD[3]}
     echo "Certificate" >> ${CMD[1]}/output/${CMD[3]}
     echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
     echo "Certificate is valid" >> ${CMD[1]}/output/${CMD[3]}
     echo "ExtDev" >> ${CMD[1]}/output/${CMD[3]}
fi



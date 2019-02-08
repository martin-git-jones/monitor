#!/bin/bash
IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
DB="euw1bcgwpcll003"
STATUS=`/usr/local/bin/aws rds describe-db-instances  --output text --db-instance-identifier $DB`
while read KEY VALUE
do 
if [[ $KEY == "DBINSTANCES" ]] ;then
       if [[ $VALUE =~ available ]] ;then
         echo "0" > ${CMD[1]}/output/${CMD[3]}
         echo "RDS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "RDS Status: $DB available" >> ${CMD[1]}/output/${CMD[3]}
         echo "Training" >> ${CMD[1]}/output/${CMD[3]}
       else
         echo "3" > ${CMD[1]}/output/${CMD[3]}
         echo "RDS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "ERROR $DB - $STATUS" >> ${CMD[1]}/output/${CMD[3]}
         echo "Training" >> ${CMD[1]}/output/${CMD[3]}
         inerror=1
       fi
fi
if [[ $inerror -eq 0 ]] ; then
 if [[ $KEY == "OPTIONGROUPMEMBERSHIPS" ]] ;then
       if ! [[ $VALUE =~ "in-sync" ]] ;then
         echo "3" > ${CMD[1]}/output/${CMD[3]}
         echo "RDS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "ERROR $DB - $STATUS" >> ${CMD[1]}/output/${CMD[3]}
         echo "Training" >> ${CMD[1]}/output/${CMD[3]}
       fi
 fi
fi
done <<< "$STATUS"
echo $STATUS

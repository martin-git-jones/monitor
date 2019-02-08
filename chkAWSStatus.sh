#!/bin/bash
Key=$(curl --silent http://169.254.169.254/latest/meta-data/iam/security-credentials/guidewire.utilities2 | grep 'AccessKeyId' | awk '{print $3}') && Key="${Key%\",}" && Key="${Key#\"}"
Secret=$(curl --silent http://169.254.169.254/latest/meta-data/iam/security-credentials/guidewire.utilities2 | grep 'SecretAccessKey' | awk '{print $3}') && Secret="${Secret%\",}" && Secret="${Secret#\"}"
Token_iam=$(curl --silent http://169.254.169.254/latest/meta-data/iam/security-credentials/guidewire.utilities2 | grep 'Token' | awk '{print $3}') && Token_iam="${Token_iam%\",}" && Token_iam="${Token_iam#\"}"

/usr/local/bin/aws configure set aws_access_key_id ${Key}
/usr/local/bin/aws configure set aws_secret_access_key ${Secret}
/usr/local/bin/aws configure set aws_session_token ${Token_iam}
/usr/local/bin/aws configure set default.region eu-west-1

IFS='/'; read -ra CMD <<< "${0}"; unset IFS
datestamp=`date '+%d-%m-%y %H:%M'`;
HOST=${CMD[1]}
#IP=`ping -c 1 $HOST | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
IP=`/bin/dig $HOST | grep -A 1 ANSWER |grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`;

ID=`/usr/local/bin/aws ec2 describe-instances --filter Name=private-ip-address,Values=$IP --query 'Reservations[].Instances[].[InstanceId]' --output text`
STATUS=`/usr/local/bin/aws ec2 describe-instance-status --instance-ids $ID --output text`
while read KEY VALUE
do 
if [[ $KEY == "INSTANCESTATE" ]] ;then
       if [[ $VALUE =~ running ]] ;then
         echo "0" > ${CMD[1]}/output/${CMD[3]}
         echo "AWS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "AWS Status: RUNNING." >> ${CMD[1]}/output/${CMD[3]}
	echo "Training" >> ${CMD[1]}/output/${CMD[3]}

       else
         echo "3" > ${CMD[1]}/output/${CMD[3]}
         echo "AWS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "ERROR - $STATUS" >> ${CMD[1]}/output/${CMD[3]}
	echo "Training" >> ${CMD[1]}/output/${CMD[3]}
       fi
fi

if [[ $KEY == "INSTANCESTATUS" ]] ;then
       if [[ $VALUE != "ok" ]] ;then
         echo "3" > ${CMD[1]}/output/${CMD[3]}
         echo "AWS Status" >> ${CMD[1]}/output/${CMD[3]}
         echo "$datestamp" >> ${CMD[1]}/output/${CMD[3]}
         echo "ERROR - $STATUS" >> ${CMD[1]}/output/${CMD[3]}
	echo "Training" >> ${CMD[1]}/output/${CMD[3]}
       fi
fi
done <<< "$STATUS"

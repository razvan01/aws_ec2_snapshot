#!/bin/bash

INSTANCE_ID=`aws ec2 describe-volumes --profile default | grep ATTACHMENTS | awk '{print $5}' | sort -u`
i=0;

#update your_owner_id variable with your id
OWNER_id=""

SNAPSHOT_NAME=`aws ec2 describe-snapshots --owner-ids $OWNER_id | awk '{print $6}'`;

#update this variable to keep snapshots more than 7 days
OLDER_THEN=$(date -d 'now - 7 days' +%Y%m%d);

#get instances name and instance volumes
function create_snap {
  for instance in $INSTANCE_ID; do
    INSTANCE_NAME=`aws ec2 describe-instances --instance-id $instance | grep Name | awk '{print $3$4}'`;
    INSTANCE_VOL=`aws ec2 describe-instances --instance-id $instance | grep vol | awk '{print $5}'`;
    DATE=$(date +%d%m%Y);

    if [ $(echo $INSTANCE_VOL | wc -w) -eq 1 ]; then
      aws ec2 create-snapshot --volume-id $INSTANCE_VOL --description "$INSTANCE_NAME-$DATE";
    else
      for volume in $INSTANCE_VOL; do
        i=$(($i + 1));
        aws ec2 create-snapshot --volume-id $volume --description "$INSTANCE_NAME-$i-$DATE";
      done;
    fi;
  done;
}

if [ $(echo $SNAPSHOT_NAME | wc -w) -ge 1 ]; then
  for snapshot in $SNAPSHOT_NAME; do
    SNAPSHOT_DATE=`aws ec2 describe-snapshots --owner-ids 299871785288 --snapshot-id $snapshot | awk '{print $7}' | cut -d T -f1 | sed 's/-//g'`;
    if [ "$SNAPSHOT_DATE" -le "$OLDER_THEN" ]; then
      aws ec2 delete-snapshot --snapshot-id $snapshot;
    fi;
  done;
  create_snap;
else
  create_snap;
fi;
# aws_ec2_snapshot
Create snapshots for AWS EC2 instances

Features:
- snapshoot all AWS EC2 instances
- create snapshot for moltiple drives attached to instance
- remove snapshots older then specific days

How to use it:
- Install python-pip
- Install awscli via pip
- configure awscli to use your aws account (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- clone repo
- add in crontab to following line: 
"59 23 * * *	root	/dowload_path/aws_ec2_snapshot/backup.sh"
- wait for it to create snapshots
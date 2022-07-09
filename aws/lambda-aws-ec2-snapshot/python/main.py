import boto3
import datetime
import os

today = datetime.date.today()
today_string = today.strftime('%Y%m%d')
now = datetime.datetime.now()
today_date = '{}-{}-{}-{}'.format(now.year, now.month, now.day, now.hour)
yesterday = today - datetime.timedelta(days=1)
delete_snashot = '{}-{}'.format(yesterday, now.hour)


region = os.environ['region']
tagname = os.environ['tagname']
tagvalue = os.environ['tagvalue']

def lambda_handler(event, context):
    ec2 = boto3.resource('ec2', region_name=region)
    instances = ec2.instances.filter(
        Filters=[
            {
                'Name': 'tag:'+tagname,
                'Values': [tagvalue]
            }
        ]
    )

    volume_ids = []

    for i in instances.all():
        for tag in i.tags:  # Get the name of the instance
            # print(tag)
            if tag['Key'] == 'Name':
                name = tag['Value']

        vols = i.volumes.all()  # Iterate through each instance's volumes

        for v in vols:
            # print(v)
            print(
                '{0} is attached to volume {1}, proceeding to snapshot'.format(name, v.id))
            volume_ids.extend(v.id)
            snapshot = v.create_snapshot(
                Description='AutoSnapshot of {0}, on volume {1} - Created {2}'.format(
                    name, v.id, today_string),
            )
            snapshot.create_tags(  # Add the following tags to the new snapshot
                Tags=[
                    {
                        'Key': 'lambda_snapshot',
                        'Value': 'true'
                    },
                    {
                        'Key': 'volume',
                        'Value': v.id
                    },
                    {
                        'Key': 'CreatedOn',
                        'Value': today_string
                    },
                    {
                        'Key': 'Name',
                        'Value': '{}-snapshot-{}'.format(name, today_date)
                    },
                    {
                        'Key': 'RotationIdentity',
                        'Value': '{}'.format(today_date)
                    }
                ]
            )
            print('Snapshot completed')

            snapshots = ec2.snapshots.filter(
                Filters=[
                    {'Name': 'tag:RotationIdentity', 'Values': [delete_snashot]
                     }
                ]
            )

            for snap in snapshots:
                # print(snap)
                for tag in snap.tags:
                    # print(tag)
                    if tag['Key'] == 'RotationIdentity':
                        # print(tag['Value'])
                        _snapid = snap.snapshot_id
                        print(snap.volume_id)
                        if v.id == snap.volume_id:
                            snap.delete()
                            print('Snapshot deleted :' + _snapid)
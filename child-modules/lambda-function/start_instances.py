import boto3

ec2_con_re = boto3.resource(service_name="ec2",region_name="us-east-1")
ec2_con_cli = boto3.client(service_name="ec2",region_name="us-east-1")

stopped_instance_ids = []
f1 = {"Name":"instance-state-name", "Values": ["stopped"]}
for each_instance in ec2_con_re.instances.filter(Filters=[f1]):
    stopped_instance_ids.append(each_instance.id)

print(stopped_instance_ids)
waiter=ec2_con_cli.get_waiter('instance_running')
print("starting the instances")
ec2_con_re.instances.filter(Filters=[f1]).start()
waiter.wait(InstanceIds=stopped_instance_ids)
print("instances are started")
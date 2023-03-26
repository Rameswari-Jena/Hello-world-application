import boto3

'''Define ec2 resource & client object to access EC2 using default session'''
ec2_con_re = boto3.resource(service_name="ec2",region_name="us-east-1")
ec2_con_cli = boto3.client(service_name="ec2",region_name="us-east-1")

'''create a blank list of running instance'''
running_instance_ids = []

'''create a filter to filter out only the running instances from all instances in us-east-1 region and append to the blank list'''
f1 = {"Name":"instance-state-name", "Values": ["running"]}
for each_instance in ec2_con_re.instances.filter(Filters=[f1]):
    running_instance_ids.append(each_instance.id)

print(running_instance_ids)

'''get waiter from client object to wait untill instance is stopped'''
waiter=ec2_con_cli.get_waiter('instance_stopped')
print("stopping the instances")
ec2_con_re.instances.filter(Filters=[f1]).stop()
waiter.wait(InstanceIds=running_instance_ids)
print("instances are stopped")
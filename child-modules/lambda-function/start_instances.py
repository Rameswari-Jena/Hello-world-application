import boto3

'''Define ec2 resource & client object to access EC2 using default session'''
ec2_con_re = boto3.resource(service_name="ec2",region_name="us-east-1")
ec2_con_cli = boto3.client(service_name="ec2",region_name="us-east-1")

'''create a blank list of stopped instance'''
stopped_instance_ids = []

'''create a filter to filter out only the stopped instances from all instances in us-east-1 region and append to the blank list'''
f1 = {"Name":"instance-state-name", "Values": ["stopped"]}
for each_instance in ec2_con_re.instances.filter(Filters=[f1]):
    stopped_instance_ids.append(each_instance.id)

print(stopped_instance_ids)

'''get waiter from client object to wait untill instance is running'''
waiter=ec2_con_cli.get_waiter('instance_running')
print("starting the instances")
ec2_con_re.instances.filter(Filters=[f1]).start()
waiter.wait(InstanceIds=stopped_instance_ids)
print("instances are started")
# Hello-world-application
Deploy hello world application on aws

Process Followed:
  1. Created child modules (resource config file-main.tf, vaiable.tf & output.tf files) of each components(vpc,subnets, ALB, Security groups/rules, Launch  Configuration, Autoscaling Group,IAM policies & Roles, Lambda-Functions, Event-bridge, S3 bucket etc) of required infrastructure.
  2. Created Parent modules for the same resources and provided path to the child modules as source. Along with that created backend configuration for keeping state file remotely, Declared the values of defined variables and configured provider block & version.
  3. Did Terraform init, Terraform fmt, terraform validate, terraform plan & terraform apply to deploy the resources

Steps to Create AWS Infrastructure:

VPC-subnets Module:
  1. create non-default vpc
  2. create non-default public subnets for web tier
  3. create non-default private subnets for app & database tier
  4. create internet gateway to attach with non-default vpc
  5. create route table 
  6. associate public subnets to the above created route table to pass traffic through igw to public subnets to connect to web server

Security-Group Module:
  1. Refer to the terraform state of vpc in data block, to use the output variable values vpc & subnets while creating the security group parameters
  2. Create Load balancer security group
  3. Create web server security group
  4. Create app server security group
  5. Create database server security group
  6. Create security group rules (ingress/egress rules) for all the security groups 

Load-Balancer Module:
  1. Define remote state of security groups, vpc & subnets in data blocks , so as to refer to its output in load balancer configurations
  2. create internal ALB in private subnets where application tier remains
  3. create app target group
  4. create a listener on port 80 with forward action

IAM(Role,policy & Instance Profile) Module (to allow SSM to manage EC2:
  1. create IAM role for EC2 to get managed by SSM
  2. Attach Amazon SSM managed Instance core policy to the created role
  3. create instance profile to attach to the launch configuration for creating autoscaling group

Auto-scaling Group Module:
  1. Define remote state of load-balancer, IAM, security groups, Amazon AMIs in data block , to use its output in launch-configuration & autoscaling configurations
  2. create launch configuration for web server and created shell script to install httpd in web server
  3. create launch configuration for app server and created shell script to install httpd and create Hello World Index.html file in app server
  4. Create web server ASG out of web server launch configuration
  5. Create app server ASG out of app server launch configuration
  6. Create an ALB app Target Group attachment with app ASG

IAM-for-lambda Module (to allow lambda to start & stop EC2):
  1. create IAM policy for lambda role, permitting operations on EC2 and cloudwatch
  2. create IAM role for lambda to access EC2 & cloud watch
  3. attach created lambda policy with lambda role
  4. attach EC2 read policy with lambda role to allow lambda to describe instance for carrying out starting & stopping Ec2 instance

Lambda-Function Module:
  1. Define remote state of iam-for-lambda role in data block , to use its output in lambda-function configuration
  2. Define location of python scripts in data block , to use it to create lambda-function
  3. create lambda function to stop EC2 instance at 7PM UTC, everyday (after office hour) and created python script to stop the running EC2 instances
  4. create lambda function to start EC2 instance at 7AM UTC from Monday-Friday (week days office hours) and created python script to start the stopped EC2 instances
        
Event-Bridge Module:
  1. Define remote state of lambda-function in data block , to use its output in event bridge configurations
  2. create event bridge rule to schedule cron for the cloud watch to trigger lambda function to stop the running EC2 instances
  3. create event bridge rule to schedule cron for the cloud watch to trigger lambda function to start the stopped EC2 instances
  4. create event bridge targets as lambda function (for stopping and starting the EC2 instances)
  5. create lambda permission to allow cloud watch event to invoke lambda functions at scheduled cron timings

Clouadwatch-Dashboard Module:
  1. create dashboard for app server autoscaling group for metrics CPUUtilization, NetworkIn, NetworkOut, StatusCheckFailed & StatusCheckFailed_Instance
  2. create dashboard for web server autoscaling group for metrics CPUUtilization, NetworkIn, NetworkOut, StatusCheckFailed & StatusCheckFailed_Instance

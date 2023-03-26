# Define variables required to set the crons for event bridge
variable "schedule_to_stop_ec2" {
  type        = string
  description = "cron schedule to stop ec2 instance"
}

variable "schedule_to_start_ec2" {
  type        = string
  description = "cron schedule to start ec2 instance"
}
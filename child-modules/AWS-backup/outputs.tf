# Define the variables of aws backup plan and vault which we want as outputs, to use it with other modules

output "aws_backup_vault-id" {
  value = aws_backup_vault.hello-world-vault.id
}

output "aws-backup-plan-id" {
  value = aws_backup_plan.hello-worl-infra-resource-backup-plan.id
}
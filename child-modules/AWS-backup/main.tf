#create a target vault to store aws backups
resource "aws_backup_vault" "hello-world-vault" {
  name = "${var.project-name}-vault"
}

#create a aws backup plan to backup all the resources created for hello world application
resource "aws_backup_plan" "hello-worl-infra-resource-backup-plan" {
  name = "${var.project-name}-infra-backup"

  rule {
    rule_name         = "${var.project-name}-infra-backup-rule"
    target_vault_name = aws_backup_vault.hello-world-vault.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}
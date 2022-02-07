resource "aws_efs_file_system" "magento-efs" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  tags = {
    Name = format("vf-%s-%s-mage-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_efs_mount_target" "magento-target-1" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  file_system_id = aws_efs_file_system.magento-efs.0.id
  subnet_id = var.network_config["private_subnets"][0]
  security_groups = [
    aws_security_group.magento-efs-server-sg.0.id
  ]

}

resource "aws_efs_mount_target" "magento-target-2" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  file_system_id = aws_efs_file_system.magento-efs.0.id
  subnet_id = var.network_config["private_subnets"][1]
  security_groups = [
    aws_security_group.magento-efs-server-sg.0.id
  ]

}

resource "aws_security_group" "magento-efs-server-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-server-efs", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("EFS server Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-server-efs", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group" "magento-efs-client-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-client-efs", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("EFS client Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-client-efs", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-efs-client" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  security_group_id = aws_security_group.magento-efs-server-sg.0.id
  source_security_group_id = aws_security_group.magento-efs-client-sg.0.id
  description = "Magento EFS client"
}

resource "aws_security_group_rule" "magento-efs-packer" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  security_group_id = aws_security_group.magento-efs-server-sg.0.id
  source_security_group_id = var.packer_sg
  description = "Magento packer"
}

// Alarms
resource "aws_cloudwatch_metric_alarm" "magento-efs-high-io-bytes-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-efs-high-IO-bytes", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s EFS: High IO Bytes", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/EFS"
  metric_name = "TotalIOBytes"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "500000000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    FileSystemId = aws_efs_file_system.magento-efs.0.id
  }
}


resource "aws_cloudwatch_metric_alarm" "magento-efs-low-throughput-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-efs-low-throughput", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s EFS: Low throughput", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/EFS"
  metric_name = "PermittedThroughput"
  statistic = "Average"
  comparison_operator = "LessThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "80000000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    FileSystemId = aws_efs_file_system.magento-efs.0.id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-efs-low-burst-credit-balance-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-efs-low-burst-credit-balance", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s EFS: Low burst credit balance", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/EFS"
  metric_name = "BurstCreditBalance"
  statistic = "Average"
  comparison_operator = "LessThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "400000000000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    FileSystemId = aws_efs_file_system.magento-efs.0.id
  }
}

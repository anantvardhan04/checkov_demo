resource "aws_db_subnet_group" "magento-rds-subnet-group" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  subnet_ids = var.network_config["private_subnets"]
  description = format("Magento Mysql Subnet group for %s", var.brand_config["brand_full_name"])
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

resource "aws_rds_cluster_parameter_group" "magento-rds-cluster-param" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s-cluster", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Magento Aurora DB %s for %s", var.account_environment, var.brand_config["brand_short_lc_name"])
  family = "aurora-mysql5.7"
  parameter {
    name = "log_bin_trust_function_creators"
    value = "1"
  }
  tags = {
    Name = format("vf-%s-%s-mage-%s-cluster", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_db_parameter_group" "magento-rds-cluster-instance-param" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s-cluster-instance", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Magento Aurora DB instance %s for %s", var.account_environment, var.brand_config["brand_short_lc_name"])
  family = "aurora-mysql5.7"
  parameter {
    name = "log_bin_trust_function_creators"
    value = "1"
  }
  tags = {
    Name = format("vf-%s-%s-mage-%s-cluster-instance", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_rds_cluster_instance" "magento-rds-cluster-instance" {
  count = var.brand_config["is_enabled"] ? var.brand_config["rds_cluster_instance_number"] : 0
  identifier = format("vf-%s-%s-mage-%s-cluster-db-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"], count.index + 1)
  cluster_identifier = aws_rds_cluster.magento-rds-cluster.0.id
  instance_class = var.brand_config["rds_cluster_instance_class"]
  apply_immediately = true
  db_parameter_group_name = aws_db_parameter_group.magento-rds-cluster-instance-param.0.id
  auto_minor_version_upgrade = true
  publicly_accessible = false
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.07.2"
  tags = {
    Name = format("vf-%s-%s-mage-%s-cluster-db", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_rds_cluster" "magento-rds-cluster" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  cluster_identifier = format("vf-%s-%s-mage-%s-cluster", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  database_name = format("magento_%s", var.brand_config["brand_full_name"])
  master_username = format("magento_%s", var.brand_config["brand_full_name"])
  master_password = random_password.rds_password.0.result
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.07.2"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.magento-rds-cluster-param.0.name
  preferred_maintenance_window = "Sun:02:00-Sun:04:00"
  preferred_backup_window = "00:00-02:00"
  backup_retention_period = 14
  storage_encrypted = var.brand_config["rds_storage_encrypted"]
  snapshot_identifier = var.brand_config["rds_cluster_instance_snapshot"]
  port = 3306
  db_subnet_group_name = aws_db_subnet_group.magento-rds-subnet-group.0.name
  deletion_protection = true
  skip_final_snapshot = true
  vpc_security_group_ids = [
    aws_security_group.magento-rds-server-sg.0.id
  ]
  tags = {
    Name = format("vf-%s-%s-mage-%s-cluster", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group" "magento-rds-client-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-client-db", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("RDS client Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-client-db", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-rds-client-egress" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-rds-client-sg.0.id
}

resource "aws_security_group" "magento-rds-server-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-server-db", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("RDS server Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-server-db", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-rds-server-clinet-in" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.magento-rds-server-sg.0.id
  source_security_group_id = aws_security_group.magento-rds-client-sg.0.id
  description = "Accept from client security group"
}

resource "aws_security_group_rule" "magento-rds-server-cd" {
  count = var.brand_config["is_enabled"] ? length(var.cd_sg) : 0
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.magento-rds-server-sg.0.id
  source_security_group_id = var.cd_sg[count.index]
  description = "Accept from CD security group"
}

resource "aws_security_group_rule" "magento-rds-server-egress" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-rds-server-sg.0.id
}

resource "random_password" "rds_password" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  length = 12
  special = true
  override_special = "!#()-[]<>\""
}

// Alarms
resource "aws_cloudwatch_metric_alarm" "magento-rds-high-cpu-alarm" {
  count = var.brand_config["is_enabled"] ? var.brand_config["rds_cluster_instance_number"] : 0
  alarm_name = format("%s-%s-%s-mage-rds-%s-high-cpu", var.brand_config["brand_full_name"], var.account_environment, var.vf_region, count.index + 1)
  alarm_description = format("Magento %s %s RDS %s: High CPU usage", var.brand_config["brand_full_name"], var.account_environment, count.index + 1)
  namespace = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "70"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.magento-rds-cluster-instance[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-rds-high-database-connections-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-rds-high-database-connections", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s RDS: High database connections", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/RDS"
  metric_name = "DatabaseConnections"
  statistic = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "3"
  threshold = "100"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.magento-rds-cluster[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-rds-high-database-queries-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-rds-high-database-queries", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s RDS: High database queries", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/RDS"
  metric_name = "Queries"
  statistic = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "15000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.magento-rds-cluster[count.index].id
  }
}

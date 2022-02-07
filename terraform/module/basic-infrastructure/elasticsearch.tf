resource "aws_security_group" "magento-es-client-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-client-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("ES Client Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-client-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-es-client-out" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-es-client-sg.0.id
}

resource "aws_security_group" "magento-es-server-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-server-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("ES Server Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-server-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-es-server-in-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.magento-es-server-sg.0.id
  source_security_group_id = aws_security_group.magento-es-client-sg.0.id
}

resource "aws_security_group_rule" "magento-es-server-in-80" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.magento-es-server-sg.0.id
  source_security_group_id = aws_security_group.magento-es-client-sg.0.id
}

resource "aws_security_group_rule" "magento-es-server-out" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-es-server-sg.0.id
}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "magento-elastic-domain" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_elastic_instances_created"] ? 1 : 0
  domain_name = format("vf-%s-%s-mage-%s-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  elasticsearch_version = var.magento_environment == "qa" || var.magento_environment == "uat" ? 7.9 : 6.8
  cluster_config {
    instance_count = var.brand_config["elastic_number_instances"]
    instance_type = var.brand_config["elastic_instance_type"]
    dedicated_master_enabled = false
    zone_awareness_enabled   = length(split(",",var.brand_config["elastic_subnet"])) == 1 ? false : true
    zone_awareness_config {
       availability_zone_count = 2
    }
  }
  vpc_options {
    subnet_ids = split(",",var.brand_config["elastic_subnet"])
    security_group_ids = [
      aws_security_group.magento-es-server-sg.0.id
    ]
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  encrypt_at_rest {
    enabled = false
  }
  node_to_node_encryption {
    enabled = false
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.brand_config["elastic_volume_size"]
  }
  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/*"
      }
  ]
}
CONFIG

  tags = {
    Name = format("vf-%s-%s-mage-%s-es", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }

}


// Alarms
resource "aws_cloudwatch_metric_alarm" "magento-elastic-domain-high-cpu-alarm" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_elastic_instances_created"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-elastic-domain-high-cpu", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s ElasticSearch: High CPU", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ES"
  metric_name = "CPUUtilization"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "70"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DomainName = aws_elasticsearch_domain.magento-elastic-domain.0.domain_name
    ClientId = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-elastic-domain-red-status-alarm" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_elastic_instances_created"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-elastic-domain-red-status", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s ElasticSearch: Red cluster status", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ES"
  metric_name = "ClusterStatus.red"
  statistic = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "3"
  threshold = "1"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DomainName = aws_elasticsearch_domain.magento-elastic-domain.0.domain_name
    ClientId = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-elastic-domain-yellow-status-alarm" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_elastic_instances_created"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-elastic-domain-yellow-status", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s ElasticSearch: Yellow cluster status", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ES"
  metric_name = "ClusterStatus.yellow"
  statistic = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "1"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DomainName = aws_elasticsearch_domain.magento-elastic-domain.0.domain_name
    ClientId = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-elastic-domain-free-storage-space-alarm" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_elastic_instances_created"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-elastic-domain-free-storage-space", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s ElasticSearch: Free storage space", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ES"
  metric_name = "FreeStorageSpace"
  statistic = "Average"
  comparison_operator = "LessThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "10000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    DomainName = aws_elasticsearch_domain.magento-elastic-domain.0.domain_name
    ClientId = data.aws_caller_identity.current.account_id
  }
}

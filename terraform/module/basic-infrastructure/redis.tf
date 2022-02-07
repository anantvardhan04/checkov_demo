resource "aws_security_group" "redis-client-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-client-redis", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Redis client Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-client-redis", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group" "redis-server-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-server-redis", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Redis server E-com for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-client-redis", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "redis-server-client" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = aws_security_group.redis-server-sg.0.id
  source_security_group_id = aws_security_group.magento-rds-client-sg.0.id
}

resource "aws_security_group_rule" "redis-server-cd" {
  count = var.brand_config["is_enabled"] ? length(var.cd_sg) : 0
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = aws_security_group.redis-server-sg.0.id
  source_security_group_id = var.cd_sg[count.index]
  description = "Accept from CD security group"
}


resource "aws_elasticache_subnet_group" "redis-subnetgroup" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  subnet_ids = var.network_config["private_subnets"]
}

resource "aws_elasticache_parameter_group" "redis5-allkeyslfu" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name   = format("redis5-allkeyslfu-%s-%s-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  family = "redis5.0"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lfu"
  }
}

resource "aws_elasticache_replication_group" "redis-replica-group" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  replication_group_id = format("vf-%s-%s-mage-%s", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  replication_group_description = format("Replication group for %s", var.brand_config["brand_full_name"])
  node_type = var.brand_config["cache_type"]
  multi_az_enabled = true
  number_cache_clusters = 2
  engine_version = "5.0.6"
  parameter_group_name = aws_elasticache_parameter_group.redis5-allkeyslfu.0.name
  port = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis-subnetgroup.0.name
  security_group_ids = [
    aws_security_group.redis-server-sg.0.id
  ]
  automatic_failover_enabled = true
  availability_zones = var.network_config["availability_zones"]
  snapshot_retention_limit = 5
  snapshot_window = "00:00-02:30"
  maintenance_window = "Sun:02:31-Sun:05:00"
  lifecycle {
    ignore_changes = [
      "number_cache_clusters"]
  }
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

// Alarms
resource "aws_cloudwatch_metric_alarm" "magento-redis-low-freeable-memory-alarm" {
  count = var.brand_config["is_enabled"] ? 2 : 0
  alarm_name = format("%s-%s-%s-mage-redis-low-freeable-memory-%s", var.brand_config["brand_full_name"], var.account_environment, var.vf_region, count.index + 1)
  alarm_description = format("Magento %s %s ElastiCache: Low freeable memory", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ElastiCache"
  metric_name = "FreeableMemory"
  statistic = "Average"
  comparison_operator = "LessThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "500000000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis-replica-group.0.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-redis-high-swap-usage-alarm" {
  count = var.brand_config["is_enabled"] ? 2 : 0
  alarm_name = format("%s-%s-%s-mage-redis-swap-memory-%s", var.brand_config["brand_full_name"], var.account_environment, var.vf_region, count.index + 1)
  alarm_description = format("Magento %s %s ElastiCache: High swap usage", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ElastiCache"
  metric_name = "SwapUsage"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "50000000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis-replica-group.0.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "magento-redis-high-cpu-alarm" {
  count = var.brand_config["is_enabled"] ? 2 : 0
  alarm_name = format("%s-%s-%s-mage-redis-high-cpu-%s", var.brand_config["brand_full_name"], var.account_environment, var.vf_region, count.index + 1)
  alarm_description = format("Magento %s %s ElastiCache: High CPU", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ElastiCache"
  metric_name = "CPUUtilization"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "70"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis-replica-group.0.id}-00${count.index + 1}"
  }
}

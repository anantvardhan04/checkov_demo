# Internal LB


resource "aws_alb_target_group" "magento-int-alb-tg-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s-i443", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  port = 80
  protocol = "HTTP"
  vpc_id = var.network_config["vpc_id"]
  health_check {
    interval = 60
    path = "/health_check.php"
    port = "80"
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 10
    protocol = "HTTP"
    matcher = "200"
  }
  tags = {
    Name = format("vf-%s-%s-mage-%s-int-443", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_alb_listener_rule" "int-alb-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  listener_arn = var.int_alb_listener_443_arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.magento-int-alb-tg-443.0.arn
  }
  condition {
    host_header {
      values = [
        var.brand_config["internal_load_balancer_domain"]
      ]
    }
  }
}

resource "aws_alb_listener_rule" "int-alb-80" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  listener_arn = var.int_alb_listener_80_arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.magento-int-alb-tg-443.0.arn
  }
  condition {
    host_header {
      values = [
        var.brand_config["internal_load_balancer_domain"]
      ]
    }
  }
}

resource "aws_route53_record" "magento-int-alb-dns-record" {
  count = var.network_config["is_internal_alb_registered_on_route53"] && var.brand_config["brand_short_lc_name"] != "" ? 1 : 0
  zone_id = var.network_config["internal_alb_public_hosted_zone"]
  name = var.brand_config["internal_load_balancer_domain"]
  type = "A"

  alias {
    name = var.int_alb_dns_name
    zone_id = var.int_alb_zone_id
    evaluate_target_health = false
  }
}

# Public facing LB

resource "aws_security_group" "magento-ext-alb-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-ext-lb", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Public facing LB Magento for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-ext-lb", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-sg-ext-in80-01" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "Allow all on port 80 (It is redirected to 443)"
}

resource "aws_security_group_rule" "magento-sg-ext-allow-internet" {
  count = var.brand_config["is_enabled"] && var.brand_config["is_opened_to_internet"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "Allow all on port 443 in production"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-01" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "10.6.0.0/16"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VFC US"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-02" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "172.22.0.0/16",
    # Private
    "212.203.75.2/32"
    # Public
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VFC EMEA"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-04" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "167.64.57.10/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VF VPN US"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-05" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "167.64.72.10/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VF VPN EMEA"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-06" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "10.1.214.155/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VF Federation"
}

resource "aws_security_group_rule" "magento-sg-ext-in443-07" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "84.198.196.182/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "VFC Antwerp"
}

resource "aws_security_group_rule" "magento-sg-ext-dickies-01" {
  count = var.brand_config["is_enabled"] && var.brand_config["brand_full_name"] == "dickies" ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "194.106.219.178/32",
    "82.43.223.163/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "Diligent Office"
}

resource "aws_security_group_rule" "magento-sg-ext-dickies-02" {
  count = var.brand_config["is_enabled"] && var.brand_config["brand_full_name"] == "dickies" ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "109.69.87.140/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "Dickies Office"
}

resource "aws_security_group_rule" "magento-sg-ext-dickies-03" {
  count = var.brand_config["is_enabled"] && var.brand_config["brand_full_name"] == "dickies" ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "80.169.116.242/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "Dickies SEO agency"
}

resource "aws_security_group_rule" "magento-sg-seo-agency" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "92.207.234.66/32",
    "37.157.33.58/32",
    "81.156.66.182/32",
    "81.109.249.90/32",
    "86.181.95.240/32"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "SEO agency Croud"
}

resource "aws_security_group_rule" "magento-sg-ext-eg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-ext-alb-sg.0.id
}

resource "aws_alb" "magento-ext-alb" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s-ext", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  internal = false
  load_balancer_type = "application"
  subnets = var.network_config["public_subnets"]
  security_groups = [
    aws_security_group.magento-ext-alb-sg.0.id,
    var.payment_sg,
    var.magento_team_sg_1,
    var.magento_team_sg_2,
    var.magento_team_sg_3
  ]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = true
  idle_timeout = var.magento_environment == "dev" ? 300 : 60 
  tags = {
    Name = format("vf-%s-%s-mage-%s-ext", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
  }
}

resource "aws_alb_listener" "magento-ext-alb-listener-80" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  load_balancer_arn = aws_alb.magento-ext-alb.0.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol = "HTTPS"
      port = "443"
    }
  }
}

resource "aws_alb_listener" "magento-ext-alb-listener-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  load_balancer_arn = aws_alb.magento-ext-alb.0.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.brand_config["external_SSL_certificate_arn"]
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><title>404 Not Found</title></head><body><center><h1>404 Not Found</h1></center><hr><center>nginx</center></body></html>"
      status_code = "404"
    }
  }
}

resource "aws_alb_target_group" "magento-ext-alb-tg-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  name = format("vf-%s-%s-mage-%s-e443", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  port = 80
  protocol = "HTTP"
  vpc_id = var.network_config["vpc_id"]
  health_check {
    interval = 60
    path = "/health_check.php"
    port = "80"
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 10
    protocol = "HTTP"
    matcher = "200"
  }
  tags = {
    Name = format("vf-%s-%s-mage-%s-ext-443", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_alb_listener_rule" "ext-alb-443" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  listener_arn = aws_alb_listener.magento-ext-alb-listener-443.0.arn
  priority = 10
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.magento-ext-alb-tg-443.0.arn
  }
  condition {
    host_header {
      values = [
        var.brand_config["external_load_balancer_domain"]
      ]
    }
  }
}

resource "aws_alb_listener_rule" "ext-alb-443-alternate-domains" {
  count = var.brand_config["is_enabled"] && length(var.brand_config["external_load_balancer_alt_domain"]) > 0 ? length(split(",", var.brand_config["external_load_balancer_alt_domain"])) : 0
  listener_arn = aws_alb_listener.magento-ext-alb-listener-443.0.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.magento-ext-alb-tg-443.0.arn
  }
  condition {
    host_header {
      values = [
        element(split(",", var.brand_config["external_load_balancer_alt_domain"]), count.index)
      ]
    }
  }
}

// Alarms
resource "aws_cloudwatch_metric_alarm" "magento-ext-alb-tg-443-high-requests-alarm" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  alarm_name = format("%s-%s-%s-mage-alb-high-requests", var.brand_config["brand_full_name"], var.account_environment, var.vf_region)
  alarm_description = format("Magento %s %s TG 443: High requests", var.brand_config["brand_full_name"], var.account_environment)
  namespace = "AWS/ApplicationELB"
  metric_name = "RequestCount"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period = "60"
  evaluation_periods = "5"
  threshold = "15000"
  alarm_actions = [
    var.sns_notifications_topic]
  dimensions = {
    LoadBalancer = aws_alb.magento-ext-alb.0.arn_suffix
    TargetGroup = aws_alb_target_group.magento-ext-alb-tg-443.0.arn_suffix
  }
}

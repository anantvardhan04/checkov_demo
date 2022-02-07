resource "aws_security_group" "magento-web-sg" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  vpc_id = var.network_config["vpc_id"]
  name = format("vf-%s-%s-mage-%s-web", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  description = format("Magento Web for %s", var.brand_config["brand_full_name"])
  tags = {
    Name = format("vf-%s-%s-mage-%s-web", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_security_group_rule" "magento-sg-internal-80" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = var.int_alb_sg
  description = "Internal 80"
}

resource "aws_security_group_rule" "magento-sg-from-group" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = aws_security_group.magento-web-sg.0.id
  description = "From group 80"
}

resource "aws_security_group_rule" "magento-sg-internal-8080" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = var.int_alb_sg
  description = "Internal 8080"
}

resource "aws_security_group_rule" "magento-sg-external-80" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "External 80"
}

resource "aws_security_group_rule" "magento-sg-external-8080" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = aws_security_group.magento-ext-alb-sg.0.id
  description = "External 8080"
}

resource "aws_security_group_rule" "magento-sg-ssh-bh" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = var.bastion_host_sg
  description = "Bastion Host SSH"
}

resource "aws_security_group_rule" "magento-sg-ssh-cd" {
  count = var.brand_config["is_enabled"] ? length(var.cd_sg) : 0
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.magento-web-sg.0.id
  source_security_group_id = var.cd_sg[count.index]
  description = "Continuous Delivery SSH"
}

resource "aws_security_group_rule" "magento-sg-egress" {
  count = var.brand_config["is_enabled"] ? 1 : 0
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.magento-web-sg.0.id
  description = "External 8080"
}
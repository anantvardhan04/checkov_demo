resource "aws_alb" "magento-int-alb" {
  name = format("vf-%s-%s-mage-int", var.account_environment, var.vf_region)
  internal = true
  load_balancer_type = "application"
  subnets = var.network_config["ec2_private_subnets"]
  security_groups = [
    aws_security_group.magento-int-alb-sg.id
  ]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = true
  tags = {
    Name = format("vf-%s-%s-mage-int", var.account_environment, var.vf_region)
    Application = var.tag_manager["Application"]
    Brand = "VF"
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = Development
  }
}

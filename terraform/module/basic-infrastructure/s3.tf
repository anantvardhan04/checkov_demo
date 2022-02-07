resource "aws_s3_bucket" "images" {
  count = var.brand_config["create_bucket_images"] ? 1 : 0
  bucket = format("vf-%s-%s-mage-%s-images", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  acl = "private"

  tags = {
    Name = format("vf-%s-%s-s3-%s-images", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_s3_bucket_public_access_block" "images-block" {
  count = var.brand_config["create_bucket_images"] ? 1 : 0
  bucket = aws_s3_bucket.images.0.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
}

resource "aws_s3_bucket" "stock" {
  count = var.brand_config["create_bucket_stock"] ? 1 : 0
  bucket = format("vf-%s-%s-mage-%s-stock", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  acl = "private"

  tags = {
    Name = format("vf-%s-%s-s3-%s-stock", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_s3_bucket_public_access_block" "stock-block" {
  count = var.brand_config["create_bucket_stock"] ? 1 : 0
  bucket = aws_s3_bucket.stock.0.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
}

resource "aws_s3_bucket" "prices" {
  count = var.brand_config["create_bucket_prices"] ? 1 : 0
  bucket = format("vf-%s-%s-mage-%s-prices", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
  acl = "private"
  tags = {
    Name = format("vf-%s-%s-%s-prices", var.account_environment, var.vf_region, var.brand_config["brand_short_lc_name"])
    Application = var.tag_manager["Application"]
    Brand = var.brand_config["brand_short_uc_name"]
    BusinessOwnerEmail = var.tag_manager["BusinessOwnerEmail"]
    CostCenter = var.tag_manager["CostCenter"]
    Environment = var.environment
    TechOwnerEmail = var.tag_manager["TechOwnerEmail"]
  }
}

resource "aws_s3_bucket_public_access_block" "prices-block" {
  count = var.brand_config["create_bucket_prices"] ? 1 : 0
  bucket = aws_s3_bucket.prices.0.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
}
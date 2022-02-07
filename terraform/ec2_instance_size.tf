data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
#checkov:skip=CUSTOM_AWS_2:this is required for a POC
  ami           = data.aws_ami.ubuntu.id
  instance_type = "r6.micro"

  tags = {
    Name = "HelloWorld"
  }
}
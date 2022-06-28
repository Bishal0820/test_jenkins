
locals {
  subnets = ["subnet-0bcab534fbed4010e", "subnet-005d0529f9c9452aa"]
}

data "template_file" "user-data" {
  template = file("./user_data.sh")
}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "web-sg"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "vpc-00b9b656e03095112"


  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/8"
  }]
  egress_rules = ["all-all"]
}

module "ec2-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "4.0.0"
  count                  = 2
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  key_name               = "test"
  monitoring             = true
  user_data              = data.template_file.user-data.rendered
  iam_instance_profile   = "iam-ssm-role"
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = local.subnets[count.index]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

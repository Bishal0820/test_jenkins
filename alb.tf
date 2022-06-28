module "alb_security_group" {
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
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = "vpc-00b9b656e03095112"
  subnets         = ["subnet-04864d6acb63e6cf9", "subnet-00859fc53edd2b85a"]
  security_groups = [module.alb_security_group.security_group_id]

  target_groups = [
    {
      name_prefix      = "prf-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.ec2-instance[0].id
          port      = 80
        },
        {
          target_id = module.ec2-instance[1].id
          port      = 80
        }
      ]
      }, {
      name_prefix      = "jenk-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      targets = [
        {
          target_id = module.ec2-instance[0].id
          port      = 8080
        },
        {
          target_id = module.ec2-instance[1].id
          port      = 8080
        }
      ]
    }
  ]

  #   https_listeners = [
  #     {
  #       port               = 443
  #       protocol           = "HTTPS"
  #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #       target_group_index = 0
  #     }
  #   ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]

  tags = {
    Environment = "Test"
  }
}

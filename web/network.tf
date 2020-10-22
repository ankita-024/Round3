#_______________________________ASG Names_____________________
asg_web_internal_name = "asg-web-dev"
asg_app_name = "asg-app-dev"  
#_____________________________Shared Configuration____________
terraform {
  backend "s3" {}
}
provider "aws" {
  region  = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account}:role"
  }
}
data "aws_vpc" "gi_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
  module "web_alb_sg" {
  source = "git::github_terraform_modules"
  name        = "${var.web_alb_sg_name}"
  description = "${var.web_alb_sg_description}"
  vpc_id      = "${data.aws_vpc.gi_vpc.id}"
  computed_ingress_with_cidr_blocks = [
    {
      from_port   = "${var.port_9999}"
      to_port     = "${var.port_9999}"
      protocol    = "tcp"
      description = " XXX Access"
      cidr_blocks = "${var.cidr_9999}"
    },
    ]
  number_of_computed_ingress_with_cidr_blocks = 1 
  tags {
    Name                   = "${var.web_alb_sg_name}"
  ....
      ....
  }
} 
#___________wEB Security Group
module "web_sg" {
  source = ""
  name        = "${var.web_sg_name}"
  description = "${var.web_sg_description}"
  vpc_id      = "${data.aws_vpc.gi_vpc.id}"
  computed_ingress_with_cidr_blocks = [
    {
      from_port   = "${var.port_3333}"
      to_port     = "${var.port_3333}"
      protocol    = "tcp"
      description = "SIP"
      cidr_blocks = "${var.cidr_ranges_all}"
    }, 
    ]
 number_of_computed_ingress_with_cidr_blocks = 1
  computed_egress_with_cidr_blocks = [
    {
      from_port   = "${var.port_1111}"
      to_port     = "${var.port_1111}"
      protocol    = "tcp"
      description = "SIP secured"
      cidr_blocks = "${var.cidr_dev}"
    }, 
    ]
    number_of_computed_egress_with_cidr_blocks = 1
    tags {
    Name                   = "${var.web_alb_sg_name}"
  ....
      ....
  }
} 

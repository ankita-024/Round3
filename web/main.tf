
#______________________________________AMI______________________________________

data "aws_ami" "web_ami" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["${var.app_ami_name}"]
  }
  filter {
    name   = "tag:Lifecycle"
    values = ["authorised"]
  }
} 
data "aws_ami" "web_ami_external" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["${var.app_ami_name}"]
  }
  filter {
    name   = "tag:Lifecycle"
    values = ["authorised"]
  }
} 
#____________________________Data Source For User Data__________________________

data "template" "userdata" {
  template = "${file("${var.userdatatype}")}"

  vars {
    vault_environment       = "${var.tag_environment}"
    tag_environment         = "${var.tag_environment}"
    vault_addr              = "${var.vault_addr}"
    vault_app_role          = "${var.vault_web_role}"
    domain_join_user        = "${var.domain_join_user}"
    domain_join_password    = "${var.domain_join_password}"
    ou_path                 = "${var.web_ou_path}"
    myappear_location       = "${var.myappzip_location}"
    asg_name                = "${var.asg_web_name}"
    logs_bucket_name        = "${var.logs_bucket_name}"
    no_proxy                = "${var.no_proxy}"
    admin_group      = "${var.admin_group}"
    developer_group  = "${var.developer_group}"
  }
}
#____________________________Data Source For SG__________________________
 
#____________________________Data Source For subnets_________________________

#____________________________Application load balancer internal_________________________

resource "aws_lb" "web_alb" {
  provider = "aws.client"
  security_groups            =  []
  ]
  subnets                    = ["${data.aws_subnet.*.id}"]
  load_balancer_type         = "application"
  internal                   =  true
  name                       = "${var.stack_name}-web-ALB-${var.tag_environment}"
  idle_timeout               = "${var.idle_timeout}" 
   tags {
   Name                       = "${var.stack_name}-web-ALB-${var.tag_environment}"
   tag_environment            = "${var.tag_environment}"
   team                       = "${var.tag_team}"
 }
} 

resource "aws_lb_target_group" "web_tg" {
  provider ="aws.client"
  vpc_id   = "${var.vpc_id}" 
  name                       = "${var.stack_name}-web-ALB-TG-${var.tag_environment}"
  port                       = "${var.port_7070}"                
  protocol                   = "${var.protocol_http}"
  deregistration_delay       = "${var.web_tg_deregistration_delay}"
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "${var.web_tg_cookie_duration}"
  }

  health_check {
    interval            = "${var.web_tg_check_interval}"
    path                = ""
    timeout             = ""
    healthy_threshold   = "${var.web_tg_healthy_threshold}"
    unhealthy_threshold = "${var.web_tg_unhealthy_threshold}"
    matcher             = ""
  }
  tags {
.....
  }
}  
 
resource "aws_lb_listener" "web_alb_listener" {
  provider = "aws.client"
  load_balancer_arn = "${aws_lb.web_alb.arn}"
  protocol          = "HTTPS"
  port            = "${var.port_cccc}"
  ssl_policy      = "${var.listener_ssl_policy}"
  certificate_arn = "${var.listener_certificate_arn}"
  default_action {
    target_group_arn = "${aws_lb_target_group.web_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "web_alb_listener_rule" {
  
  provider = "aws.client"

  listener_arn     = "${aws_lb_listener.web_alb_listener.arn}"
  priority         = "${var.web_priority_9999}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_tg.arn}"
  }
  condition {
    field  = "${var.web_listener_rule_field}"
    values = ["${var.web_listener_rule_values}"]
  }
} 
#____________________________Application load balancer external_________________________

resource "aws_lb" "web_alb_external" {
  provider = "aws.client"
  security_groups            =  []
  ]
  subnets                    = ["${data.aws_subnet.*.id}"]
  load_balancer_type         = "application"
  internal                   =  true
  name                       = "${var.stack_name}-web-ALB-ext-${var.tag_environment}"
  idle_timeout               = "${var.idle_timeout}" 
   tags {
   Name                       = "${var.stack_name}-web-ALB-ext-${var.tag_environment}"
   tag_environment            = "${var.tag_environment}"
   team                       = "${var.tag_team}"
 }
} 

resource "aws_lb_target_group" "web_tg_ext" {
  provider ="aws.client"
  vpc_id   = "${var.vpc_id}" 
  name                       = "${var.stack_name}-web-ALB-TG-ext-${var.tag_environment}"
  port                       = "${var.port_7070}"                
  protocol                   = "${var.protocol_http}"
  deregistration_delay       = "${var.web_tg_deregistration_delay}"
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "${var.web_tg_cookie_duration}"
  }

  health_check {
    interval            = "${var.web_tg_check_interval}"
    path                = ""
    timeout             = ""
    healthy_threshold   = "${var.web_tg_healthy_threshold}"
    unhealthy_threshold = "${var.web_tg_unhealthy_threshold}"
    matcher             = ""
  }
  tags {
.....
  }
}  
 
resource "aws_lb_listener" "web_alb_listener_ext" {
  provider = "aws.client"
  load_balancer_arn = "${aws_lb.web_alb.arn}"
  protocol          = "HTTPS"
  port            = "${var.port_cccc}"
  ssl_policy      = "${var.listener_ssl_policy}"
  certificate_arn = "${var.listener_certificate_arn}"
  default_action {
    target_group_arn = "${aws_lb_target_group.web_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "web_alb_listener_rule_ext" {
  
  provider = "aws.client"

  listener_arn     = "${aws_lb_listener.web_alb_listener.arn}"
  priority         = "${var.web_priority_9999}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_tg.arn}"
  }
  condition {
    field  = "${var.web_listener_rule_field}"
    values = ["${var.web_listener_rule_values}"]
  }
} 

#_________________________ASG_________________________________
resource "aws_autoscaling_group" "asg_external" {
  # ... other configuration ...

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_group" "asg_internal" {
  # ... other configuration ...

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_elb.test.id
}
 
resource "aws_autoscaling_schedule" "app_scheduler_up" {
  provider = "aws.client"
  scheduled_action_name  = "app_scheduler_up"
  min_size               = "${var.app_scheduler_up_min_size}"
  max_size               = "${var.app_scheduler_up_max_size}"
  desired_capacity       = "${var.app_scheduler_up_desired_capacity}"
  recurrence             = "${var.app_scheduler_up_recurrence}"
  autoscaling_group_name = "${data.terraform_remote_state.backend.asg_name}"
} 

resource "aws_autoscaling_schedule" "app_scheduler_down" {
  provider = "aws.client"
  scheduled_action_name  = "app_scheduler_down"
   min_size               = "${var.app_scheduler_down_min_size}"
  max_size               = "${var.app_scheduler_down_max_size}"
  desired_capacity       = "${var.app_scheduler_down_desired_capacity}"
  recurrence             = "${var.app_scheduler_down_recurrence}"
  autoscaling_group_name = "${data.terraform_remote_state.backend.asg_name}"
} 

 


 

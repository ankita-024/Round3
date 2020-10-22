module "db_eni"{
  

  subnet_id = "${data.aws_subnet.id}"

  security_group = []
  

  name                       = "${var.stack_name}-db-${var.tag_environment}"
  tag_team                   = "${var.tag_team}"
} 

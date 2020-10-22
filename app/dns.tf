#____________________dns______________________________
resource "aws_route53_record" "app_dns" {
  provider 			  = "aws.management"
  name                = "${var.service_record_name_app}.${var.hosted_zone}"
  zone_id             = "${var.hosted_zone_id}"
  type 				  = "A"
  alias {
    name                   = "${data.terraform_remote_state.backend.alb_dns_name}"
    zone_id                = "${data.terraform_remote_state.backend.alb_zone_id}"
    evaluate_target_health = true
  }
} 
 

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

# 1️⃣ Get hosted zone
data "aws_route53_zone" "main" {
  name = "djordje-test-app.click"
}

# 2️⃣ ALIAS record for Vault pointing to ALB
resource "aws_route53_record" "vault" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "vault.djordje-test-app.click"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

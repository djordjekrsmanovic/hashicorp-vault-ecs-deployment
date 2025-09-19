resource "aws_security_group" "this" {
  name   = "${var.environment_name}-${var.service_name}-task"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.from_port
    to_port     = var.to_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



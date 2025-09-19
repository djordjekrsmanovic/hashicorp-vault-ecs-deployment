variable "name" {
  description = "Prefix name for VPC and resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets with cidr and availability zone"
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

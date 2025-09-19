variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where to create the SG"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets where to create mount targets"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to EFS"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "root_directory" {
  description = "Root directory for the access point"
  type        = string
  default     = "/nginx"
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}

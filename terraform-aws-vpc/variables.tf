variable "aws_vpc_name" {
  description = "VPC name"
  default     = "DevOps-Demo"
  type        = string
}
variable "cidr_block" {
  default = "10.38.0.0/16"
  type    = string
}
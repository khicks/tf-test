variable "environment" {
  description = "The environment type being created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "num_azs" {
  description = "Number of Availability Zones in which to create subnets. Max is number of AZs in the Region."
  type        = number
  default     = 3
}

variable "subnet_new_bits" {
  description = "Number of new bits to add to the VPC CIDR mask to form the subnet masks. For example, a /16 VPC with /24 subnets would be 24 - 16 = 8."
  type        = number
  default     = 8
}

variable "enable_nat_gw" {
  description = "Create NAT Gateways in each private Subnet."
  type        = bool
  default     = true
}

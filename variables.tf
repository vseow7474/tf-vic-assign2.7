variable "name_prefix" {
  description = "Name prefix for table"
  type        = string
  default     = "victor"
}

variable "instance_type" {
  description = "Instance type of ec2"
  type        = string
  default     = "t2.micro"
}

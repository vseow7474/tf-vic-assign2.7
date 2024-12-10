output "public_subnet_id" {
  value = data.aws_subnets.public.ids
}
output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}
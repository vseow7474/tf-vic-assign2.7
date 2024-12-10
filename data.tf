data "aws_ami" "amazon2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
  owners = ["amazon"]
}

data "aws_vpc" "selected" {
  # default = true
  filter {
    name   = "tag:Name"
    values = ["*shared*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "first" {
  id = data.aws_subnets.public.ids[0]
}

data "aws_availability_zones" "available" {
  state = "available"
}

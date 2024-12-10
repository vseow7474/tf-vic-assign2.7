resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon2023.id # e.g. ami-04c913012f8977029
  instance_type               = var.instance_type          # "t2.micro"
  subnet_id                   = data.aws_subnet.first.id   #Public Subnet ID, e.g. subnet-xxxxxxxxxxx "subnet-0caaf48818e0596cc"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  availability_zone = data.aws_subnet.first.availability_zone

  tags = {
    Name = "${var.name_prefix}-ec2" # Prefix your own name, e.g. jazeel-ec2
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.name_prefix}-ebs-sg" #Security group name, e.g. jazeel-terraform-security-group
  description = "Allow SSH inbound"
  vpc_id      = data.aws_vpc.selected.id #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_ebs_volume" "vic_ebs" {
  availability_zone = aws_instance.public.availability_zone # Match the AZ of the instance
  size              = 1                                     # Volume size in GiB
  type              = "gp3"

  tags = {
    Name = "${var.name_prefix}-ebs-volume"
  }
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.vic_ebs.id
  instance_id = aws_instance.public.id
}
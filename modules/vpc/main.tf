### Network

# Internet VPC
resource "aws_vpc" "application_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}_application_vpc"
  }
}

# Subnets
resource "aws_subnet" "public_subnets" {
  count = var.num_azs

  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.application_vpc.cidr_block, var.subnet_new_bits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_public_subnet_${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.num_azs

  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.application_vpc.cidr_block, var.subnet_new_bits, (length(data.aws_availability_zones.available.names) * 1) + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_public_subnet_${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "${var.environment}_internet_gw"
  }
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "${var.environment}_public_rt"
  }
}

resource "aws_route" "public_rt_igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gw.id
}

# NAT EIPs
resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gw ? var.num_azs : 0

  tags = {
    Name = "${var.environment}_nat_eip_${data.aws_availability_zones.available.names[count.index]}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_nat_gw ? var.num_azs : 0

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.environment}_nat_gw_${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "lambda_function_rt" {
  count = var.enable_nat_gw ? var.num_azs : 1

  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "${var.environment}_lambda_function_rt${var.enable_nat_gw ? "_${data.aws_availability_zones.available.names[count.index]}" : ""}"
  }
}

resource "aws_route" "lambda_function_rt_ngw" {
  count = var.enable_nat_gw ? var.num_azs : 0

  route_table_id         = aws_route_table.lambda_function_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
}

# private subnet route table associations
resource "aws_route_table_association" "private_rta" {
  count = var.num_azs

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.lambda_function_rt[var.enable_nat_gw ? count.index : 0].id
}

# public subnet route table associations
resource "aws_route_table_association" "public_rta" {
  count = var.num_azs

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

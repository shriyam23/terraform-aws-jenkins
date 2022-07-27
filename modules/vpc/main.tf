variable "vpc_cidr_block" {
	description = "VPC CIDR Block"
}

variable "public_subnet_cidr_block" {
	description = "Public Subnet CIDR Block"
}

data "aws_availability_zones" "available" {
	state = "available"
}

resource "aws_vpc" "my_vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		Name = "Devops_A1"
	}
}

resource "aws_internet_gateway" "my_igw" {
	vpc_id = aws_vpc.my_vpc.id

	tags = {
		Name = "Devops_A1"
	}
}

resource "aws_subnet" "my_public_subnet" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = var.public_subnet_cidr_block
	availability_zone = data.aws_availability_zones.available.names[0]

	tags = {
		Name = "Devops_A1"
	}
}

resource "aws_route_table" "my_public_rt" {
	vpc_id = aws_vpc.my_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.my_igw.id
	}
}

resource "aws_route_table_association" "public" {
	route_table_id = aws_route_table.my_public_rt.id
	subnet_id = aws_subnet.my_public_subnet.id
}

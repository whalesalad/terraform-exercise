resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.owner}-vpc"
    Owner = "${var.owner}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "main" {
  cidr_block = "10.0.0.0/26"
  availability_zone = "${var.az}"
  vpc_id = "${aws_vpc.main.id}"

  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.main"]

  tags {
    Name = "${var.owner}-subnet"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

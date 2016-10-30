variable "az" {
  default = "ap-northeast-1c"
}

variable "owner" {
  default = "mwhalen"
}

variable "coreos_ami" {
  default = "ami-a38026c2"
}

variable "ssh_key_name" {
  default = "mwhalen"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.owner}-vpc"
    Owner = "${var.owner}"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
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

resource "aws_security_group" "main" {
  name = "Internal"
  description = "Internal"

  vpc_id = "${aws_vpc.main.id}"

  tags {
    Owner = "${var.owner}"
  }

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "backend" {
  ami = "${var.coreos_ami}"

  instance_type = "t2.small"
  source_dest_check = false

  security_groups = ["${aws_security_group.main.id}"]

  key_name = "${var.ssh_key_name}"

  subnet_id = "${aws_subnet.main.id}"

  associate_public_ip_address = true

  # Strange syntax.
  user_data = "${file("templates/instance_user_data.yml")}"

  tags {
    Name = "${var.owner}-backend"
    Owner = "${var.owner}"
  }
}

# Finally, print out the ELB dns name
output "elb_dns_name" {
  value = "${aws_instance.backend.public_ip}"
}

# Create an EC2 instance to run the web application
resource "aws_instance" "backend" {
  ami = "${var.coreos_ami}"
  instance_type = "t2.small"
  key_name = "${var.ssh_key_name}"
  source_dest_check = false
  subnet_id = "${aws_subnet.main.id}"
  user_data = "${file("templates/instance_user_data.yml")}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]

  tags {
    Name = "${var.owner}-backend"
    Owner = "${var.owner}"
  }
}

# Finally, print out the ELB dns name
output "elb_dns_name" {
  value = "${aws_instance.backend.public_ip}"
}

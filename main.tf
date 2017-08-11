provider "aws" {
  region = "${var.aws_region}"
}

# Create VPC

resource "aws_vpc" "auar_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
  Name      = "automate-up-and-running-training-vpc"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "auar_internet_gateway" {
  vpc_id = "${aws_vpc.auar_vpc.id}"

  tags {
  Name      = "automate-up-and-running-training-gateway"
  }
}

# Create Route to the Internet

resource "aws_route" "auar_internet_access" {
  route_table_id         = "${aws_vpc.auar_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.auar_internet_gateway.id}"
}

# Create VPC Subnet

resource "aws_subnet" "auar_public_subnet" {
  vpc_id                  = "${aws_vpc.auar_vpc.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
  Name      = "automate-up-and-running-training-subnet"
  }
}

# Create All-Open Security Group

resource "aws_security_group" "auar_allow_all" {
  name        = "auar_allow_all"
  description = "Chef Automate Up and Running Security Group - Insecure"
  vpc_id      = "${aws_vpc.auar_vpc.id}"

  tags {
  Name      = "automate-up-and-running-training-security-group"
  }
}

resource "aws_security_group_rule" "ingress_allow_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.auar_allow_all.id}"
}

resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.auar_allow_all.id}"
}

# Create Student Chef Servers

resource "aws_instance" "student_chef_server" {
  connection {
    type        = "ssh"
    user        = "${var.aws_ami_user}"
    private_key = "${file("${var.aws_key_path}")}"
  }

  ami                         = "${var.aws_ami}"
  count                       = "${var.student_count}"
  instance_type               = "${var.student_chef_server_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.auar_public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.auar_allow_all.id}"]

  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }

  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.card_table, count.index)}.chefserver.success.co",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::student_chef_server]"
    ]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  tags {
  Name      = "automate-up-and-running-training-${element(var.card_table, count.index)}-chef-server"
  }
}

# Create Student Automate Servers

resource "aws_instance" "student_automate_server" {
  connection {
    type        = "ssh"
    user        = "${var.aws_ami_user}"
    private_key = "${file("${var.aws_key_path}")}"
  }

  ami                         = "${var.aws_ami}"
  count                       = "${var.student_count}"
  instance_type               = "${var.student_automate_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.auar_public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.auar_allow_all.id}"]

  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }

  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.card_table, count.index)}.automate.success.co",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::student_automate]"
    ]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  tags {
  Name      = "automate-up-and-running-training-${element(var.card_table, count.index)}-automate-server"
  }
}

# Create Student Chef Runners

resource "aws_instance" "student_runner" {
  connection {
    type        = "ssh"
    user        = "${var.aws_ami_user}"
    private_key = "${file("${var.aws_key_path}")}"
  }

  ami                         = "${var.aws_ami}"
  count                       = "${var.student_count}"
  instance_type               = "${var.student_runner_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.auar_public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.auar_allow_all.id}"]

  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }

  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.card_table, count.index)}.runner.success.co",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab]"
    ]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  tags {
  Name      = "automate-up-and-running-training-${element(var.card_table, count.index)}-runner"
  }
}

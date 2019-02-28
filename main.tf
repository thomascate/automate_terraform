provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
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

  provisioner "local-exec" {
    command = "./update_dns.rb create \"${element(var.card_table, count.index)}.automate\" \"${self.public_ip}\""
  }

  provisioner "local-exec" {
    command = "./update_dns.rb delete \"${element(var.card_table, count.index)}.automate\""
    when = "destroy"
  }

  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.card_table, count.index)}.automate.e9.io",
      "sudo /bin/rpm -Uv ${var.chefdk_url}",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::student_automate]"
    ]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  tags {
    Name = "automate-up-and-running-training-${element(var.card_table, count.index)}-automate-server",
    X-Contact = "tcate@chef.io",
    X-Dept = "Training"
  }
}

# Create Student Workstations

resource "aws_instance" "student_workstation" {
  connection {
    type        = "ssh"
    user        = "${var.aws_ami_user}"
    private_key = "${file("${var.aws_key_path}")}"
  }

  ami                         = "${var.aws_ami}"
  count                       = "${var.student_count}"
  instance_type               = "${var.student_workstation_instance_type}"
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${aws_subnet.auar_public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.auar_allow_all.id}"]

  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }

  provisioner "local-exec" {
    command = "./update_dns.rb create \"${element(var.card_table, count.index)}.workstation\" \"${self.public_ip}\""
  }

  provisioner "local-exec" {
    command = "./update_dns.rb delete \"${element(var.card_table, count.index)}.workstation\""
    when = "destroy"
  }

  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.card_table, count.index)}.workstation.e9.io",
      "sudo /bin/rpm -Uv ${var.chefdk_url}",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::student_workstation]"
    ]
  }

  provisioner "file" {
    destination = "/tmp/config.rb"

    content = <<EOL
node_name "${element(var.card_table, count.index)}.workstation.e9.io"
data_collector.server_url "https://${element(var.card_table, count.index)}.automate.e9.io/data-collector/v0/"
data_collector.token "93a49a4f2482c64126f7b6015e6b0f30284287ee4054ff8807fb63d9cbd1c506"
ssl_verify_mode :verify_none
verify_api_cert false
EOL
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  tags {
    Name      = "automate-up-and-running-training-${element(var.card_table, count.index)}-workstation"
    X-Contact = "tcate@chef.io",
    X-Dept    = "Training"
  }
}

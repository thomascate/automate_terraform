provider "aws" {
  shared_credentials_file = ".aws_creds"
  region     = "us-west-2"
}


#create the Chef Servers
resource "aws_instance" "chefserver" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.chefServerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.chefserver\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.chefserver.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::chef_server]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  tags {
    Name = "${element(var.cardTable, count.index)}.chefserver.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success",
    deletable = "very yes"
  }
}

#resource "aws_eip" "chefserverip" {
#  count = "${var.studentCount}"
#  instance = "${element(aws_instance.chefserver.*.id, count.index)}"
#  provisioner "local-exec" {
#    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.chefserver\" \"${aws_eip.chefserverip.public_ip}\""
#  }
#  provisioner "file" {
#    source      = "./cookbooks"
#    destination = "/tmp/cookbooks"
#  }
#  provisioner "remote-exec" {
#    inline    = [
#      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.chefserver.e9.io",
#      "sudo /usr/bin/yum -y install wget",
#      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
#      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
#      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab]"
#    ]
#  }
#  connection {
#    type     = "ssh"
#    user     = "centos"
#    private_key = "${file("~/.ssh/id_rsa")}"
#  }
#}

##create Automate Servers
#resource "aws_instance" "automate" {
#  count = "${var.studentCount}"
#  ami           = "${var.ami}"
#  instance_type = "${var.automateInstanceType}"
#  tags {
#    Name = "${element(var.cardTable, count.index)}.automate.e9.io",
#    X-Contact = "tcate@chef.io",
#    X-Dept = "Customer Success",
#    deletable = "very yes"
#  }
#}#

#resource "aws_eip" "automateip" {
#  count = "${var.studentCount}"
#  instance = "${element(aws_instance.automate.*.id, count.index)}"
#}#

##create Runner Servers
#resource "aws_instance" "runner" {
#  count = "${var.studentCount}"
#  ami           = "${var.ami}"
#  instance_type = "${var.runnerInstanceType}"
#  tags {
#    Name = "${element(var.cardTable, count.index)}.runner.e9.io",
#    X-Contact = "tcate@chef.io",
#    X-Dept = "Customer Success",
#    deletable = "very yes"
#  }
#}#

#resource "aws_eip" "runnerip" {
#  count = "${var.studentCount}"
#  instance = "${element(aws_instance.runner.*.id, count.index)}"
#}#

##create Infrastructure Servers
#resource "aws_instance" "prod" {
#  count = "${var.studentCount}"
#  ami           = "${var.ami}"
#  instance_type = "${var.prodInstanceType}"
#  tags {
#    Name = "${element(var.cardTable, count.index)}.prod.e9.io",
#    X-Contact = "tcate@chef.io",
#    X-Dept = "Customer Success",
#    deletable = "very yes"
#  }
#}#

#resource "aws_eip" "prodip" {
#  count = "${var.studentCount}"
#  instance = "${element(aws_instance.prod.*.id, count.index)}"
#}

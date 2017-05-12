provider "aws" {
  shared_credentials_file = ".aws_creds"
  region     = "us-west-2"
}


#create the Chef Servers
resource "aws_instance" "chefserver" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.chefServerInstanceType}"
  tags {
    Name = "${element(var.cardTable, count.index)}.chefserver.e9.io",
    X-Contact = "tcate@chef.io",
    deletable = "very yes"
  }
}

resource "aws_eip" "chefserverip" {
  count = "${var.studentCount}"
  instance = "${element(aws_instance.chefserver.*.id, count.index)}"
}

#create Automate Servers
resource "aws_instance" "automate" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.automateInstanceType}"
  tags {
    Name = "${element(var.cardTable, count.index)}.automate.e9.io",
    X-Contact = "tcate@chef.io",
    deletable = "very yes"
  }
}

resource "aws_eip" "automateip" {
  count = "${var.studentCount}"
  instance = "${element(aws_instance.automate.*.id, count.index)}"
}

#create Runner Servers
resource "aws_instance" "runner" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.runnerInstanceType}"
  tags {
    Name = "${element(var.cardTable, count.index)}.runner.e9.io",
    X-Contact = "tcate@chef.io",
    deletable = "very yes"
  }
}

resource "aws_eip" "runnerip" {
  count = "${var.studentCount}"
  instance = "${element(aws_instance.runner.*.id, count.index)}"
}

#create Infrastructure Servers
resource "aws_instance" "prod" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.prodInstanceType}"
  tags {
    Name = "${element(var.cardTable, count.index)}.prod.e9.io",
    X-Contact = "tcate@chef.io",
    deletable = "very yes"
  }
}

resource "aws_eip" "prodip" {
  count = "${var.studentCount}"
  instance = "${element(aws_instance.prod.*.id, count.index)}"
}

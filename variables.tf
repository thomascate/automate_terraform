# A lookup table made the most sense to do this in a terraform plan

variable "card_table" {
  description = "List of card names for instances"
  type = "list"
  default = ["2ofhearts", "3ofhearts", "4ofhearts", "5ofhearts", "6ofhearts", "7ofhearts", "8ofhearts", "9ofhearts", "aceofhearts", "jackofhearts", "queenofhearts", "kingofhearts", "2ofdiamonds", "3ofdiamonds", "4ofdiamonds", "5ofdiamonds", "6ofdiamonds", "7ofdiamonds", "8ofdiamonds", "9ofdiamonds", "aceofdiamonds", "jackofdiamonds", "queenofdiamonds", "kingofdiamonds", "2ofclubs", "3ofclubs", "4ofclubs", "5ofclubs", "6ofclubs", "7ofclubs", "8ofclubs", "9ofclubs", "aceofclubs", "jackofclubs", "queenofclubs", "kingofclubs", "2ofspades", "3ofspades", "4ofspades", "5ofspades", "6ofspades", "7ofspades", "8ofspades", "9ofspades", "aceofspades", "jackofspades", "queenofspades", "kingofspades"]
}

# Set this to how many students we're making instances for

variable "student_count" {
  description = "How many students we need to make nodes for"
}

variable "aws_ami" {
  description = "which ami to use for this environment"
  default = "ami-6bb7310b"
}

variable "aws_ami_user" {
  description = "Username for SSH to Training AMI"
  default = "centos"
}

variable "aws_region" {
  description = "The AWS Region in which to deploy instances"
}

variable "student_chef_server_instance_type" {
  description = "Chef server ec2 instance type"
  default = "t2.medium"
}

variable "student_automate_instance_type" {
  description = "Automate server ec2 instance type"
  default = "t2.xlarge"
}

variable "student_runner_instance_type" {
  description = "Runner server ec2 instance type"
  default = "t2.micro"
}

variable "aws_key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_key_path" {
  description = "Path to the SSH key to auth to AWS"
  default = "~/.ssh/id_rsa"
}

variable "instructor_chef_server_instance_type" {
  description = "EC2 instance type for instructor Chef Server"
  default = "t2.medium"
}

variable "instructor_automate_instance_type" {
  description = "EC2 instance type for instructor Chef Server"
  default = "t2.xlarge"
}

variable "instructor_runner_instance_type" {
  description = "EC2 instance type for instructor Chef Server"
  default = "t2.micro"
}

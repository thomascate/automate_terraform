# Description

Terraform plan for building out the training environment for Chef Automate: Up and Running. This is for trainers and should not be supplied to trainees.

# Disclaimers

This environment is entirely insecure. It is to be used only for the purposes of creating short-lived training environments for Chef Automate: Up and Running training courses.

The instances used in this training module do not fall into the free tier category in AWS. The authors will not be held responsible for any costs incurred by the user.

# Getting Started

If you have not already done so, you will need to:

1. Download and familiarize yourself with the basics of [Terraform](https://www.terraform.io/)
1. Create and configure an [AWS Keypair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
1. Attain a Chef Automate license from [Chef Software, Inc.](https://downloads.chef.io/automate) by downloading Chef Automate. If you have already received a trial license in the past, you will need to use a variation of your email. We suggest using a plus address. e.g., If your email is human@example.com, you may use human+automatelicense1@example.com.

Now that you have what you need in place:

1. `git clone` this repo.
1. Copy your `automate.license` to `./cookbooks/automate_lab/files/default/automate.license`
1. Copy your ssh key to  `./cookbooks/automate_lab/files/default/instructor.pub`
1. Remove *.tfvars and *.tfstate from your .gitignore.
1. Create a terraform.tfvars and include your variables there. See the included example.tfvars.
1. Run `terraform plan`.
1. Run `terraform apply`.

# Variables in terraform.tfvars

- student_count - The number of students for whom to deploy infastructure. It is generally advised to over-provision by a few clusters in case problems with instances arise. e.g., If you have 15 students, set `student_count` to `18`.

- aws_ami - The EC2 AMI to use for your instances. Presently, this course is only tested with Irving Popovetsky's 2017/02/16 release of his [High Performance CentOS 7 AMI](https://github.com/irvingpop/packer-chef-highperf-centos7-ami). The following are matching AMI/Region pairs suggested for use in this training:

| Region    |     AMI      |
|-----------|--------------|
| us-east-1 | ami-a88c47be |
| us-west-1 | ami-f0481790 |
| us-west-2 | ami-6bb7310b |

- aws_ami_user - The user for authentication into the EC2  AMI you have selected. This defaults to "centos" and assumes you are using one of the above AMIs.

- aws_key_name - The name of your AWS keyfile.

- aws_key_path - The path to your AWS keyfile.

- aws_instance_type - The size and type of machines you will spin up for all Chef Automate instances. Examples in `example.tfvars` should be used in most cases.

- aws_region - The region name where your aws instances will live. Presently, only the following regions are explicitly supported. Choose from one of the following:

  us-east-1
  
  us-west-1
  
  us-west-2

- instructor_automate_instance_type - The instance type for the instructor's Chef Automate instance. Defaults to `"t2.xlarge"`.

- instructor_chef_server_instance_type - The instance type for the instructor's Chef Automate instance. Defaults to `"t2.medium"`.

- instructor_runner_instance_type - The instance type for the instructor's Chef Automate instance. Defaults to `"t2.micro"`.

- student_automate_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.xlarge"`.

- student_chef_server_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.medium"`.

- student_runner_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.micro"`.

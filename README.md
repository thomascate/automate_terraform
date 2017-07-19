# Description

Terraform plan for building out the training environment for Chef Automate: Up and Running. This is for trainers and should not be supplied to trainees.

# Disclaimers

This environment is entirely insecure. It is to be used only for the purposes of creating short-lived training environments for Chef Automate: Up and Running training courses.

The instances used in this training module do not fall into the free tier category in AWS. The authors will not be held responsible for any costs incurred by the user.

# Getting Started

If you have not already done so, you will need to:

1. Download and familiarize yourself with the basics of [Terraform](https://www.terraform.io/)
1. Create and configure an [AWS Keypair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
1. Create and configure an [AWS IAM User](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) and get your **access key ID and secret access key**
1. Attain a Chef Automate license from [Chef Software, Inc.](https://downloads.chef.io/automate) by downloading Chef Automate. If you have already received a trial license in the past, you will need to use a variation of your email. We suggest using a plus address. e.g., If your email is human@example.com, you may use human+automatelicense1@example.com.

Now that you have what you need in place:

1. `git clone` this repo.
1. Copy your `automate.license` to `./cookbooks/automate_lab/files/default/automate.license`
1. Copy your ssh public key to  `./cookbooks/automate_lab/files/default/instructor.pub`
1. Remove *.tfvars and *.tfstate from your .gitignore.
1. Create a terraform.tfvars and include your variables there. See the included example.tfvars. See also next section for more details regarding the `terraform.tfvars` file.
1. Run `terraform plan`.
1. Run `terraform apply`.

Final preparation for training:

1. Create a table mapping IP addresses to cardnames. Each card should have an Automate Server, a Chef Server, and a Runner assigned by each machine's respective IP.
1. Pass out cards during training to students to assign machines.

# Variables in terraform.tfvars

- student_count - The number of students for whom to deploy infastructure. It is generally advised to over-provision by a few clusters in case problems with instances arise. e.g., If you have 15 students, set `student_count` to `18`. Be sure also to include the instructor in the count.

- aws_ami - The EC2 AMI to use for your instances. Presently, this course is only tested with Irving Popovetsky's 2017/02/16 release of his [High Performance CentOS 7 AMI](https://github.com/irvingpop/packer-chef-highperf-centos7-ami). The following are matching AMI/Region pairs suggested for use in this training:

| Region    |     AMI      |
|-----------|--------------|
| us-east-1 | ami-a88c47be |
| us-west-1 | ami-f0481790 |
| us-west-2 | ami-6bb7310b |

- aws_ami_user - The user for authentication into the EC2  AMI you have selected. This defaults to "centos" and assumes you are using one of the above AMIs.

- aws_key_name - The name of your AWS keyfile in AWS.

- aws_key_path - The path to your AWS keyfile, including the filename, on your workstation.

- aws_instance_type - The size and type of machines you will spin up for all Chef Automate instances. Examples in `example.tfvars` should be used in most cases.

- aws_region - The region name where your aws instances will live. Presently, only the following regions are explicitly supported. Choose from one of the following:

  us-east-1
  
  us-west-1
  
  us-west-2

- student_automate_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.xlarge"`.

- student_chef_server_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.medium"`.

- student_runner_instance_type - The instance type for the student's Chef Automate instance. Defaults to `"t2.micro"`.

# Administering the Training

You will need to record the IP Addresses associated with each of the student machines in a table that correlates to the card to which they are assigned. Example:

| Card        | Automate Server IP | Chef Server IP |   Runner IP  |
|-------------|--------------------|----------------|--------------|
| 2 of Hearts |    52.87.215.142   | 54.236.12.94   | 34.203.29.59 |
| 3 of Hearts |    52.637.15.97    | 54.77.325.153  | 52.817.25.14 |

Each student, as well as the instructor, will be assigned a card from a standard 52 card deck. That card assignment will determine which machines are theirs for the duration of the training. When the training begins, students should be given their card assignment and asked to ssh to the machines using the user and password supplied in the training materials.

# Using EC2 Instance to Launch Terraform

In the event that an instructor has difficulty getting Terraform provisioning working from her/his workstation, an AWS EC2 instance may be used to launch the training environment. This assumes that you have locally handled the above instructions and keys, etc. are now in the correct location within this repo.

1. Create a t2.micro instance using the Ubuntu Server 16.04 LTS ami (ami-d15a75c7 if in US East 1). To reduce friction, it may be beneficial to ensure that the instance has an open security group. Be sure to tag the instance to prevent its deletion. This last point is **very** important, as you will need to destroy the training environment from this machine when the training concludes.
1. ssh to the newly created launch server instance and su to root
1. Install unzip `apt-get install unzip`
1. Download the 64-bit Linux Terraform package from the [downloads page](https://www.terraform.io/downloads.html) using something like `wget`.
1. Unzip the Terraform download and ensure that the resulting binary is available on the PATH.
1. On your local workstation, create a directory called `launch_server` and copy the following files into it:
  - Your aws credentials file for your IAM user (generally located at `~/.aws/credentials`)
  - Your private key from your aws ec2 key pair (example `~/.ssh/id_rsa` or `~/.ssh/user.pem` etc.)
  - Your local copy of this repository.
1. Compress/zip up that `launch_server` directory, and transfer the resulting file to the Ubuntu image using something like `scp` (example: `$ scp launch_server.zip ubuntu@IP_ADDR:/tmp/`)
1. Once you have copied the necessary files and directories to your launch machine, move them to sane locations such as:
  * `~/.aws/credentials`
  * `~/.ssh/$PRIVATE_KEY`
  * Wherever you'd like to keep the `automate_terraform` repo should be fine.
1. From within the `automate_terraform` directory, run `terraform plan` followed by `terraform apply` and your environment should be all set.

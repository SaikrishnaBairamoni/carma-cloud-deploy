# use ubuntu 20 AMI for EC2 instance
data "aws_ami" "ubuntu" {
    most_recent = true
filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
    }
filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
owners = ["099720109477"] # Canonical
}
# provision to us-east-2 region
provider "aws" {
  region  = "us-east-2"
}
resource "aws_instance" "carmacloud-test" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "myJune222Key"
  user_data = <<-EOL
  #!/bin/bash -xe
  echo hello
  lsb_release -a
  sudo apt update
  sudo mkdir tmp && cd tmp
  wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz
  tar -xzf apache-tomcat-9.0.34.tar.gz
  mv apache-tomcat-9.0.34 tomcat
  EOL
tags = {
    Name = var.ec2_name
  }
}

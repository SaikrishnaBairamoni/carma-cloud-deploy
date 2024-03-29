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
  availability_zone = "us-east-2a"
  key_name      = "myJune222Key"  
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("./myJune222Key.pem")}"
    host     = self.public_ip
  } 
   provisioner "file" {
    source      = "cc.sh"
    destination = "/home/ubuntu/cc.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/cc.sh",
      "sudo /home/ubuntu/cc.sh args",
      "ls -la",
      "./cc.sh",
      "sudo apt install python3-pip -y",
      "mkdir carmacloud-logs && cd carmacloud-logs",
      "sudo mkdir tmp && cd tmp",
      "wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz",
      "tar -xzf apache-tomcat-9.0.34.tar.gz",
      "mv apache-tomcat-9.0.34 tomcat",
      "mv tomcat /home/ubuntu/carmacloud-logs",
      "fdisk -l",
      "df -h",
      "mount /dev/xvdh1 /home/ubuntu/carmacloud-logs",
      "mv /home/ubuntu/tmp/tomcat /home/ubuntu/carmacloud-logs",
      "df -h",
    ]
  }
}  


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
      "sudo apt-get install s3cmd -y",
      "pip3 install awscli --ignore-installed six",
      "aws s3 cp /home/ubuntu/tomcat s3://s3-carma-cloud-dev/ --recursive",
      # "aws s3 cp /home/ubuntu/cc.sh ${aws_s3_bucket.carma.id}",
    ]
  }
}  
resource "aws_s3_bucket" "carma" {
 bucket = "s3-carma-cloud-dev"
 acl    = "private"   # or can be "public-read"
  tags = {
    Name        = "ccdata"
    Environment = "Dev"
  }    

}



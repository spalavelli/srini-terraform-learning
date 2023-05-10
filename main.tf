# install jenkins and maven
provider "aws" {
	region = "ap-south-1"
	profile = "default"
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "default VPC"
  }
}

# to list all availabulity zones
data "aws_availability_zones" "available" {}

# we need subnet_id before launch instance

resource "aws_default_subnet" "default_az" {
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    name = "default subnet"
  }
}

# We need a vpc security group to control traffic

resource "aws_security_group" "web_sg" {
    name = "web_security_group"
    description = "Allow 80,8080 & 22 inbound traffic"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    description = "http proxy access" 
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "ssh access"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "http access" 
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web_instance" {

    ami  = "ami-02eb7a4783e7e9317"
    instance_type = "t2.micro"
    subnet_id = aws_default_subnet.default_az.id
    vpc_security_group_ids = [ aws_security_group.web_sg.id  ]
    key_name = "Ex_jen_ngx"

    tags = {
        name = "jenkins_server"
    }
}

resource "null_resource" "name" {


# ssh connection into Ec2 instance
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./Ex_jen_ngx.pem")
    host        = aws_instance.web_instance.public_ip
  }

# copy the install_jenkins.sh file from local to instance

  provisioner "file" {
    source       = "./install_jenkins.sh"
    destination  = "/tmp/install_jenkins.sh"
  }

# set permission and execute the install_jenkins.sh file

  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_jenkins.sh",
        "sh /tmp/install_jenkins.sh",
	  ]
  }

 depends_on = [aws_instance.web_instance]
	
}

# To see the jenkins_web_server_url
output "jenkins_url" {
    value = join ("",[ "http://", aws_instance.web_instance.public_dns, ":","8080"])
}


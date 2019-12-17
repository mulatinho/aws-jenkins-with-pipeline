provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "jenkins-ci-keypair" {
    key_name   = "jenkins-ci-keypair"
    public_key = file("~/.ssh/ec2_keyfile.pub")
}

resource "aws_vpc" "jenkins-ci-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        name = "jenkins-ci-vpc"
    }
}

resource "aws_internet_gateway" "jenkins-ci-igw" {
    vpc_id = aws_vpc.jenkins-ci-vpc.id
}

resource "aws_subnet" "us-east-1a-public" {
    vpc_id = aws_vpc.jenkins-ci-vpc.id

    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        name = "jenkins-ci-subnet"
    }
}

resource "aws_route_table" "us-east-1a-public" {
    vpc_id = aws_vpc.jenkins-ci-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins-ci-igw.id
    }

    tags = {
        name = "jenkins-ci-rt"
    }
}

resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = aws_subnet.us-east-1a-public.id
    route_table_id = aws_route_table.us-east-1a-public.id
}

resource "aws_security_group" "jenkins-ci-sg" {
  name = "jenkins-ci-sg"
  description = "security group rules for SSH and Jenkins port 8080"
  vpc_id = aws_vpc.jenkins-ci-vpc.id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 443 
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins-ci" {
    ami           = "ami-00068cd7555f543d5"
    instance_type = "t2.micro"
    key_name      = "jenkins-ci-keypair"
    subnet_id     = aws_subnet.us-east-1a-public.id

    associate_public_ip_address = true

    vpc_security_group_ids = [ aws_security_group.jenkins-ci-sg.id ]
    
    ebs_block_device {
        device_name           = "/dev/xvda"
        volume_size           = 8
        volume_type           = "gp2"
        delete_on_termination = true
    }

    connection {
        type        = "ssh" 
        private_key = file("~/.ssh/ec2_keyfile.pem")
        user        = "ec2-user"
        host        = aws_instance.jenkins-ci.public_ip
    }

    provisioner "remote-exec" {
        inline = ["sudo yum update -y && sudo yum install python -y && sudo amazon-linux-extras install ansible2 -y"]
    }

    provisioner "local-exec" {
        command = <<END
	sleep 10;
	echo "[jenkins-ci]" > hosts;
	echo "${aws_instance.jenkins-ci.public_ip} ansible_ssh_private_key_file=~/.ssh/ec2_keyfile.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" >> hosts;
	ansible-playbook -i ./hosts ./ec2-provision.yaml
	END
    }

    tags = {
	Name = "jenkins-ci-instance-01"
    }
}

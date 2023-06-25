terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
}


# Create a VPC
resource "aws_vpc" "proj-vpc" {
  cidr_block = "10.0.0.0/16"
}

#Create a Gateway
resource "aws_internet_gateway" "proj-ig" {
  vpc_id = vpc-062700ea1eb221c9c

  tags = {
    Name = "gateway1"
  }
}

# Setting up the routing table
resource "aws_route_table" "proj-rt" {
  vpc_id = vpc-062700ea1eb221c9c

  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proj-ig.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.proj-ig.id
  }

  tags = {
    Name = "rt1"
  }
}


#Create Subnet
resource "aws_subnet" "proj-subnet" {
  vpc_id     = vpc-062700ea1eb221c9c
  cidr_block = "10.0.1.0/24"
  availability_zone= "us-east-1a"
  tags = {
    Name = "subnet1"
  }
}

#associate the subnet with the route table
resource "aws_route_table_association" "proj-rt-sub-assoc" {
        subnet_id = subnet-0ca43b70c6615274a
        route_table_id = aws_route_table.proj-rt.id
}


# Create Scurity Groups
resource "aws_security_group" "proj-sg" {
  name        = "proj-sg"
  description = "enable traffic on port 22,80 and 443"
  vpc_id      = aws_vpc.proj-vpc.id

  ingress {
    description      = "HTTPS Traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "proj-sg1"
  }
}




#Create Network interfaces
resource "aws_network_interface" "proj-ni" {
  subnet_id       = subnet-0ca43b70c6615274a
  private_ips     = ["10.0.1.10"]
  security_groups = [sg-059e816842c060dc4]
}

#Creating Elastic IP
resource "aws_eip" "proj-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.proj-ni.id
  associate_with_private_ip = "10.0.1.10"
}


#Creating Ec2 instance
resource "aws_instance" "proj-instance" {
  ami           = "ami-0261755bbcb8c4a84" # us-east-1a
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "devops"

  network_interface {
    network_interface_id = aws_network_interface.proj-ni.id
    device_index         = 0
  }
  

  user_data = <<EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
                EOF

  tags = {
      Name = "project-instance"
  }
}


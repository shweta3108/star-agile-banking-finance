
resource "aws_instance" "Prod-Server" {
 ami = "ami-0261755bbcb8c4a84"
 instance_type = "t2.micro"
 availability_zone = "us-east-1a"
 key_name = "devops"
 vpc_security_group_ids = "sg-059e816842c060dc4"
tags ={
name=" Terraform prod"
}

user data = <<-EOF
#!/bin/bash
  apt-get update -y
  apt install docker.io -y
  systemctl enable docker
  docker run -itd -p 8087:8081 shwetas27/finance-me:1.0
  docker start $(docker ps -aq)
EOF
}

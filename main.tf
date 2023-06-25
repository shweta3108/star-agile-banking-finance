
resource "aws_instance" "Prod-Server" {
 ami = "ami-0261755bbcb8c4a84"
 instance_type = "t2.micro"
 availability_zone = "us-east-1a"
 key_name = "devops"

tags ={
name=" Terraform prod"
}
user_data = <<-EOF
 #!/bin/bash
 sudo apt-get update -y
 sudo apt install docker.io -y
 sudo systemctl enable docker
 sudo docker run -itd -p 8085:8081 shwetas27/finance-me:1.0
 sudo docker start $(docker ps -aq)
EOF
}
 

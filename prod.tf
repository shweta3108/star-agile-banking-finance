resource "aws_instance" "Prod-Server" {
 ami = "ami-0261755bbcb8c4a84"
 instance_type = "t2.micro"
 availability_zone = "us-east-1"
 key_name = "devops"
 network_interface {
 device_index = 0
 network_interface_id = aws_network_interface.proj-ni.id
 }
 user_data  = <<-EOF
 #!/bin/bash
     sudo apt-get update -y
     sudo apt install docker.io -y
     sudo systemctl enable docker
     sudo docker run -itd -p 8085:8081 shwetas27/financeme:1.0
     sudo docker start $(docker ps -aq)
 EOF
 tags = {
 Name = "Prod-Server"
 }

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test_server" {
  ami           = "ami-03a933af70fa97ad2"
  instance_type = "t2.micro"
  key_name      = "devopslab"
  vpc_security_group_ids = ["sg-0a10474335ac41ac2"]

  tags = {
    Name = "test-server"
  }
}

resource "aws_instance" "production_server" {
  ami           = "ami-03a933af70fa97ad2"  
  instance_type = "t2.micro"               
  key_name      = "devopslab"          
  vpc_security_group_ids = ["sg-0a10474335ac41ac2"]  

  tags = {
    Name = "production-server"
  }
}

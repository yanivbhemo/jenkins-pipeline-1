provider "aws" {
	profile    = "default"
	region     = "eu-west-1"
}

resource "aws_lightsail_key_pair" "general_key" {
  name   = "general_key"
  public_key = file("id_rsa.pub")
}

resource "aws_lightsail_instance" "dell-devops-lab01" {
  key_pair_name    	= aws_lightsail_key_pair.general_key.name
  name              = "dell-devops-lab01"
  availability_zone = "eu-west-1a"
  blueprint_id      = "amazon_linux_2018_03_0_2"
  bundle_id         = "nano_2_0"
  connection {
		type	=	"ssh"
		user	=	"ec2-user"
		private_key	=	file("id_rsa")
		host        = self.public_ip_address
	}
  
  provisioner "remote-exec" {
    inline = [
	  "sudo yum -y update",
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo service nginx start"
    ]
  }
}
provider "aws" {
    region = "<add your region>" # The region should be same as S3 bucket region
}

# It will fech the AMI-ID of AWS-AMI2

data "aws_ami" "fetch_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Creating the Ansible Remote machine #

resource "aws_instance" "remote" {
  ami = data.aws_ami.fetch_ami.id
  instance_type = local.insta
  count = 2
  key_name = "<Key-pair name>"
  tags = {
    name = "Ansible_Remote_Node.${count.index}"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("./<Key-pair name>.pem")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    on_failure = "continue"
    inline = [ 
      "sudo install -y python"
     ]
  }
}


# Creating the Ansible Control machine #

resource "aws_instance" "control" {
  ami = data.aws_ami.fetch_ami.id
  instance_type = local.insta
  key_name = "<Key-pair name>"
  tags = {
    name = "Ansible_Control_Node"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("./<keypair-name>.pem")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    on_failure = "continue"
    inline = [ 
      "sudo amazon-linux-extras install -y ansible2"
     ]
  }
}

locals {
  insta = "t2.micro"
}

# Output value will display the IP address of remote nodes.
output "ip_of_remote_node" {
  value = aws_instance.remote[*].public_ip
}

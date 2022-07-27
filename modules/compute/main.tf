variable "security_group" {
   description = "The security groups my aws instance"
}

variable "public_subnet" {
   description = "The public subnet IDs assigned to my aws instance"
}

data "aws_ami" "ubuntu" {
   most_recent = "true"

   filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
   }

   filter {
      name = "virtualization-type"
      values = ["hvm"]
   }

   owners = ["099720109477"]
}

resource "aws_instance" "my_vm" {
   ami = data.aws_ami.ubuntu.id
   subnet_id = var.public_subnet
   instance_type = "t2.large"
   vpc_security_group_ids = [var.security_group]
   key_name = aws_key_pair.my_kp.key_name
   user_data = "${file("${path.module}/install_jenkins.sh")}"

   tags = {
      Name = "Devops_A1"
   }
}

resource "aws_key_pair" "my_kp" {
   key_name = "my_kp"
   public_key = file("${path.module}/my_key.pub")
}

resource "aws_eip" "server_eip" {
   instance = aws_instance.my_vm.id
   vpc      = true

   tags = {
      Name = "Devops_A1"
   }
}
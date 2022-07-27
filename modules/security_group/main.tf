variable "vpc_id" {
   description = "VPC ID"
   type        = string
}

variable "my_ip" {
   description = "My IP address"
   type = string
}

resource "aws_security_group" "my_sg" {
   name = "my_sg"
   description = "Security group for the instance"
   vpc_id = var.vpc_id

   ingress {
      description = "Allow all traffic through port 8080-will be used for jenkins"
      from_port = "8080"
      to_port = "8080"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      description = "Allow all traffic through port 8888-will be used for petclinic"
      from_port = "8888"
      to_port = "8888"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      description = "Allow all traffic through port 9000-will be used for SonarQube"
      from_port = "9000"
      to_port = "9000"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      description = "Allow SSH from my computer"
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
      description = "Allow all outbound traffic"
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "Devops_A1"
   }
}
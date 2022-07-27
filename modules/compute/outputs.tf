output "public_ip" {
   description = "The public IP address of the Jenkins server"
   value = aws_eip.server_eip.public_ip
}
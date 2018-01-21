provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "default"{
    name="Default SG"
    description="default VPC security group"

    ingress{
        from_port = 22
        to_port = 22
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "vpc-XXXXXX0"

}

data "template_file" "user_data" {
  template = "${file("app_install.tpl")}"
  vars {
    region = "${var.region}"
  }
}

 resource "aws_instance" "web1" {

        connection={
        user="ubuntu"
        private_key="${file(var.private_key_path)}"
    }
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  count=2
  key_name = "${var.key_name}"
  security_groups= ["${aws_security_group.default.name}"]
  user_data = "${data.template_file.user_data.rendered}"
   tags{
        Name="Terraform-go"
    }
    provisioner "remote-exec"{

        inline=[
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "sudo apt-get -y install golang-go"
            ]
            }
    provisioner "file" {
         source  = "/Users/ragul.n/Documents/test-go.go"
         destination = "/tmp/"

         connection {
            type = "ssh"
            user = "ubuntu"
            private_key = "${file(var.private_key_path)}"
        }
    }
    provisioner "remote-exec" {
        inline=[
           "sudo mv /tmp/tmp /usr/local/go/src/test-go/test-go.go",
           "sudo go build /usr/local/go/src/test-go/test-go.go",
           "./test-go &"
           ]
    }
} 



 resource "aws_instance" "web2" {
        connection={
        user="ubuntu"
        private_key="${file(var.private_key_path)}"
    }
  ami   = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups= ["${aws_security_group.default.name}"]
  tags{
        Name="Terraform-nginx"
    }
    provisioner "remote-exec"{

        inline=[
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "sudo apt-get -y install nginx git",
            "sudo service nginx restart"
            ]
            }

  
} 

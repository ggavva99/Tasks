packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "ami_prefix" {
  type    = string
  default = "learn-packer-linux-aws-redis"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "source_ami" {
  type    = string
  default = "ami-0c7217cdde317cfec"
}
source "amazon-ebs" "ubuntu" {
  ami_name      = var.ami_prefix
  instance_type = var.instance_type
  region        = var.region
  source_ami    = var.source_ami
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
"echo '> Cleaning apt-get ...'",
"sudo apt-get clean",
"# Cleans the machine-id.",
"echo '> Cleaning the machine-id ...'",
"sudo rm /etc/machine-id",
"sudo touch /etc/machine-id",
"# Start iscsi and ntp",
"echo '> Start iscsi and ntp ...'",
"# Disable Cloud Init",
"sudo touch /etc/cloud/cloud-init.disabled",
"# Install docker",
"sudo apt update -y",
"sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
"sudo yes '' | sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
"sudo apt update -y",
"sudo apt-cache policy docker-ce",
"sudo apt install docker-ce -y",
"sudo usermod -aG docker ubuntu"
    ]
  }

} 

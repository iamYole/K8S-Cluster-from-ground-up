packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
} 

locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  }

 source "amazon-ebs" "Kubernetes-AMI" {
    ami_name      = "Kubernetes-AMI-${local.timestamp}"
    instance_type = "t2.micro"
    region        = "us-east-2" //var.region

    source_ami_filter {
      filters = {
        name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240411"
        root-device-type    = "ebs"
        virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["099720109477"]
    }
    ssh_username = "ubuntu"
    tag {
      key   = "Name"
      value = "Kubernetes-AMI"
    }
 }

 build {
  sources = ["source.amazon-ebs.Kubernetes-AMI"]

  provisioner "shell" {
    script = "userdata.sh"
  }
}
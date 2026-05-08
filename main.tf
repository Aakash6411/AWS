terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }
}

provider "aws" {
    region = local.region
}

resource "aws_instance" "Test" {
  ami           = "ami-21f78e11"
  instance_type = "t2.micro"
  availability_zone = local.region

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-comprehensive-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Recommendation: Limit to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "app_storage" {
  bucket = "test_bucket"

  tags = {
    Environment = "Dev"
  }
}

resource "aws_ebs_volume" "ebs1" {
  availability_zone = local.region
  size              = 10

  tags = {
    Name = "test_ebs1"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs1.id
  instance_id = aws_instance.Test.id
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "datos" {
  bucket = var.bucket_name

  tags = {
    Name    = "practica5-terraform"
    Project = "Ejercicio-5-IaC"
  }
}

resource "aws_s3_bucket_public_access_block" "datos" {
  bucket = aws_s3_bucket.datos.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_instance" "servidor" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false

  tags = {
    Name    = "practica5-miguel-terraform"
    Project = "Ejercicio-5-IaC"
  }
}

output "bucket" {
  description = "Nombre del bucket S3 creado"
  value       = aws_s3_bucket.datos.bucket
}

output "instancia" {
  description = "Identificador de la instancia EC2"
  value       = aws_instance.servidor.id
}
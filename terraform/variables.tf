variable "aws_region" {
  description = "Region de AWS donde desplegar los recursos"
  type        = string
  default     = "eu-south-2"
}

variable "ami_id" {
  description = "AMI de Amazon Linux 2023"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Identificador de la subred"
  type        = string
}

variable "security_group_id" {
  description = "Identificador del grupo de seguridad"
  type        = string
}

variable "bucket_name" {
  description = "Nombre unico del bucket S3"
  type        = string
}
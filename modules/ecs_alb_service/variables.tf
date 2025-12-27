variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecr_image" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "container_name" {
  type    = string
  default = "api"
}

variable "container_port" {
  type    = number
  default = 8000
}

variable "healthcheck_path" {
  type    = string
  default = "/"
}

variable "cpu" {
  type    = string
  default = "256"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "environment" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

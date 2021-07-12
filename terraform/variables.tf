variable "project" {
    type = string
    description = "Project name"
}

variable "location" {
    type = string
    description = "Azure region to deploy module to"
}

variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
}

variable "docker_image" {
  description = "Docker image name"
}
 
variable "docker_image_tag" {
  description = "Docker image tag"
}

variable "docker_hub_username" {
  description = "Docker hub username"
}
variable "docker_hub_password" {
  description = "Docker hub password"
}
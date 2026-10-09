variable "ssh_user" {
  type        = string
  description = "User for ssh connection"
  default = "ksf"
}

variable "remote_ip" {
  type        = string
  description = "IP address of the remote server for SSH connection"
  default = "IP remote server"
}

variable "remote_port" {
  type        = string
  description = "Port of the remote server for SSH connection"
  default = "22"
}

variable "db_image" {
  type        = string
  description = "Name of docker image"
  default = "mysql:8"
}
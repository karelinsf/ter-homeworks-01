terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
  required_version = ">1.12.0" 
}
provider "docker" {
  host     = "ssh://${var.ssh_user}@${var.remote_ip}:${var.remote_port}"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "random_password" "mysql_root_pqssword" {
  length      = 20
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "db_password" {
  length      = 20
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql"{
  name         = var.db_image
  keep_locally = true
}

resource "docker_container" "mysql" {
  name  = "mysql_server"
  image = docker_image.mysql.image_id

  # Передача ENV-переменных для инициализации базы данных
  env = [
      "MYSQL_ROOT_PASSWORD=root_pess_${random_password.mysql_root_pqssword.result}",
      "MYSQL_DATABASE=wordpress",
      "MYSQL_USER=wordpress",
      "MYSQL_PASSWORD=db_pass_${random_password.db_password.result}",
      "MYSQL_ROOT_HOST=\"%\""
  ]

  # Проброс портов: контейнер будет доступен только локально на ВМ через 127.0.0.1:3306
  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  # Обеспечиваем перезапуск контейнера при сбоях
  restart = "always"
}
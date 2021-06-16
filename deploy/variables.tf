variable "docker_image" {
  description = "The Flask App docker image."
  default     = "gcr.io/model-hexagon-316719/flask-todos"
}

variable "db_password" {
  description = "PostgreSQL superuser password"
}

variable "db_application_password" {
  description = "PostgreSQL Flask application password"
}

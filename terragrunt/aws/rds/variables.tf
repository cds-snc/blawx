variable "database_instances_count" {
  description = "The number of db instances to create"
  type        = number
  default     = 1
}

variable "database_name" {
  description = "The database name of the postgresql database"
  type        = string
  sensitive   = true
}

variable "database_username" {
  description = "The username of the postgresql database"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "The password for the postgresql database"
  type        = string
  sensitive   = true
}

variable "vpc_private_subnet_ids" {
  description = "The private subnet ids of the VPC"
  type        = list(any)
}

variable "vpc_id" {
  description = "The VPC id of the url shortener"
  type        = string
}

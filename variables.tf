variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-central2"
}

variable "zone" {
  type    = string
  default = "europe-central2-a"
}

variable "name" {
  type    = string
  default = "eve-ng"
}

variable "machine_type" {
  type    = string
  default = "n2-standard-2"
}

variable "disk_size" {
  type    = number
  default = 20
}
variable "region" {
  default = "us-east1"
}

variable "count" {}
variable "name_prefix" {}
variable "machine_type" {}
variable "user_data" {
  default = ""
}

variable "disk_type" {
  default = "pd-ssd"
}

variable "disk_size" {}
variable "disk_image" {}

variable "subnetwork" {}

variable "startup_script" {
  default = <<EOF
#! /bin/bash
apt-get update
apt-get install -y apache2
cat <<EOF > /var/www/html/index.html
<html><body><h1>Hello World</h1>
<p>This page was created from a simple startup script!</p>
</body></html>
EOF
}

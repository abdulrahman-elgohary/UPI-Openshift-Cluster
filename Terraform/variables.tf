variable "vpc_cidr" {
    type = string 
}
variable "public_subnet_cidr" {
    type = string 
}
variable "private_subnet_cidr" {
    type = string 
}
variable "esky_availability_zone" {
    type = string
}

variable "static_private_nic_ip" {
    type = string
}

########################################################################
# Computing Variables
variable "instance_type" {
    type = string
}

variable "instance_key" {
    type = string
}


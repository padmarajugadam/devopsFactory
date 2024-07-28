variable "key_name" {
  type = string
  default     = "test"

}
variable "region" {

  default = "us-west-2"

}

variable "ins_type" {

   default = "t2.large"

}

variable "cpu_core" {

  default = 2 

}



variable "public_snets" {

type = string
default = "0.0.0.0/0"

}
variable "public_subnets" {

type = string

default = "172.1.0.0/16"

}

variable "vol_size" {

  default = 10 

}

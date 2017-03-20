//-------------------------------------------------------------------
// SO settings
//-------------------------------------------------------------------

variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "user" {
  default = "ubuntu"
  description = "The default user for the platform"
}

variable "service_conf" {
  default = "debian_upstart.conf"
}

variable "service_conf_dest" {
  default = "upstart.conf"
}

//-------------------------------------------------------------------
// AWS settings
//-------------------------------------------------------------------

variable "region" {
  default     = "us-west-2"
  description = "The region of AWS, for AMI lookups."    
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types."
  default = "ami-9abea4fb"
}

variable "instance_type" {                                                                                                default     = "t2.micro"                                                                                                description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types."
}  

variable "servers" {                                                                                                      default     = "3"                                                                                                       description = "The number of Consul servers to launch."                                                               
}  

variable "subnet" {
  default     = ""
  description = "The current subnet"
}

variable "vpc" {
  default     = ""
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "tagName" {
  default     = "consul"
  description = "Name tag for the servers"
}

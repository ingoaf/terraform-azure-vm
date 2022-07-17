variable "my_ip_address" {
  type = string
  description = "Set to your ip address to allow access from your machine to the network in which the virtual machine resides. Put /32 at the end to preserve cidr block notation."
}

variable "path_to_private_key" {
  type = string
  description = "Local path to a private key which will be used for SSH connection to the Azure VM."
}

variable "path_to_public_key" {
  type = string
  description = "Local path to a public key which will be used for SSH connection to for SSH connection to the Azure VM."
}
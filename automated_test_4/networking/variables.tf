variable "rg_name" {
  type        = string
  description = "Resource group name"
  default     = "dev-rg"
}

variable "location" {
  type        = string
  description = "Azure deployment location"
  default     = "australiaeast"
}

variable "vnet_cidr" {
  type        = list(string)
  description = "The CIDR for the VNet"
  default     = ["10.0.0.0/16"]
}

variable "zones" {
  type        = list(string)
  description = "Name of subnet zones"
}

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

variable "bastion_subnet_id" {
  type        = string
  description = "The Bastion subnet id"
}
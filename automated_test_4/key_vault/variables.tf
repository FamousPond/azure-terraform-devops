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

variable "vnet_id" {
  type        = string
  description = "The VNet id"
}

variable "kv_subnet_id" {
  type        = string
  description = "The key vault subnet id"
}
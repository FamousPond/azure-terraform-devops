variable "location" {
  type        = string
  description = "Azure deployment location"
  default     = "australiaeast"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
  default     = "dev-rg"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for accessing the virtual machines"
}


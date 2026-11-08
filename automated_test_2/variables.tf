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

variable "public_ip" {
  type        = string
  description = "Public IP of the deployed system."

  validation {
    condition     = can(cidrnetmask("${var.public_ip}/32"))
    error_message = "Public IP privided is invalid."
  }
}

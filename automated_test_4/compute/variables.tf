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

variable "subnets" {
  type        = map(string)
  description = "Maps the name of a subnet to it's id"
}

variable "machines" {
  type        = map(number)
  description = "Map of the number of machines in each subnet zone"

  validation {
    condition     = alltrue([for zone in var.machines : contains([for subnet in var.subnets : subnet], zone)])
    error_message = "Every zone in 'machines' has to have a corresponding zone in 'subnets'"
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH key to use on the machines"
}
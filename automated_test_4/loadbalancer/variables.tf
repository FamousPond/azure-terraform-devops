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

variable "lb_zone" {
  type        = string
  description = "The subnet zone to deploy the load balancer to"
  default     = "web"
}

variable "vms" {
  type = map(object({
    subnet = string
    nic_id = string
  }))
  description = "Map of the vms and their associated nic and what subnet zone that is in"
}
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

variable "vms" {
  type = map(object({
    subnet          = string
    nic_id          = string
    vm_principal_id = string
  }))
  description = "Map of the vms and their associated nic, principal id and what subnet zone that is in"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT Gateway id"
}

variable "bastion_subnet" {
  type = object({
    id               = string
    address_prefixes = list(string)
  })
  description = "The Bastion subnet"
}

variable "kv_id" {
  type        = string
  description = "Key vault id"
}

variable "zone_to_access_kv" {
  type        = string
  description = "Zone that can access the key vault"
}
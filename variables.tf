variable "env" {
  default = "dev"
}

variable "project" {
  default = "batcave"
}

variable "transport_subnets_exist" {
  description = "Transport subnets are used to house the NLB in situations where a service is required to be exposed to VDI users"
  default     = false
  type        = bool
}

variable "shared_subnets_exist" {
  description = "Shared subnets are used to house resources intended to be shared across ALL CMS Cloud systems via the transit gateway"
  default     = false
  type        = bool
}

variable "shared_subnets_additional_tgw_routes" {
  description = "These CIDR blocks will be added to the shared subnet route tables and routed to the transit gateway"
  default     = []
  type        = list(any)
}

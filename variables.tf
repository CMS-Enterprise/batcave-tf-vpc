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
  default = false
  type    = bool
}

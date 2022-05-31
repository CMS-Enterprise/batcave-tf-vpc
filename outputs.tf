## VPC Data
output "vpc" {
  value = data.aws_vpc.batcave_vpc.cidr_block_associations.*.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = data.aws_vpc.batcave_vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = data.aws_vpc.batcave_vpc.arn
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = data.aws_subnets.private.ids
}

output "private_subnets_by_zone" {
  description = "map of AZs to private subnet ids"
  value       = { for subnet in data.aws_subnet.private : subnet.availability_zone => subnet.id }
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = toset(data.aws_subnets.public.ids)
}

output "container_subnets" {
  description = "List of IDs of container subnets"
  value       = toset(data.aws_subnets.container.ids)
}

output "transport_subnets" {
  description = "List of IDs of transport subnets"
  value       = var.transport_subnets_exist ? toset(data.aws_subnets.transport[0].ids) : toset([])
}

output "transport_subnet_cidr_blocks" {
  description = "map of IDs to transport subnet cidrs"
  value       = var.transport_subnets_exist ? { for subnet in data.aws_subnet.transport : subnet.id => subnet.cidr_block } : {}
}

output "transport_subnets_by_zone" {
  description = "map of AZs to transport subnet ids"
  value       = var.transport_subnets_exist ? { for subnet in data.aws_subnet.transport : subnet.availability_zone => subnet.id } : {}
}

output "container_subnets_by_zone" {
  description = "map of AZs to container subnet ids"
  value       = { for container in data.aws_subnet.container : container.availability_zone => container.id }
}

output "cmscloud_vpn_pl" {
  description = "Prefix list of cmscloud vpn"
  value       = data.aws_ec2_managed_prefix_list.vpn_prefix_list.id
}

output "cmscloud_shared_services_pl" {
  value = data.aws_ec2_managed_prefix_list.cmscloud_shared_services_pl.id
}

output "cmscloud_security_tools_pl" {
  value = data.aws_ec2_managed_prefix_list.cmscloud_security_tools.id
}

output "cmscloud_public_pl" {
  description = "Prefix list of cmscloud public"
  value       = var.public_pl_exists ? data.aws_ec2_managed_prefix_list.cmscloud_public_pl[0].id : ""
}

output "subnets" {
  value = { for subnet_name, subnet_values in local.all_subnets : subnet_name => {
    ids         = toset(keys(subnet_values))
    azs_to_id   = { for subnet_id, subnet_value in subnet_values : subnet_value.availability_zone => subnet_id }
    ids_to_cidr = { for subnet_id, subnet_value in subnet_values : subnet_id => subnet_value.cidr_block }
    }
  }
}

output "cms_public_ip_cidrs" {
  value = [
    "198.179.3.171/27",
    "198.179.4.128/28",
    "52.5.212.71/32",
    "35.160.156.109/32",
    "52.34.232.30/32",
    "52.20.26.200/32",
  ]
}

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

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = data.aws_subnets.public.ids
}

output "container_subnets" {
  description = "List of IDs of container subnets"
  value       = data.aws_subnets.container.ids
}

output "transport_subnets" {
  description = "List of IDs of transport subnets"
  value       = data.aws_subnets.transport.ids
}

output "transport_subnet_cidr_blocks" {
  description = "map of IDs to transport subnet cidrs"
  value       = { for subnet in data.aws_subnet.transport : subnet.id => subnet.cidr_block }
}

output "transport_subnets_by_zone" {
  description = "map of AZs to transport subnet ids"
  value       = { for subnet in data.aws_subnet.transport : subnet.availability_zone => subnet.id }
}

output "cmscloud_vpn_pl" {
  description = "Prefix list of cmscloud vpn"
  value       = data.aws_ec2_managed_prefix_list.vpn_prefix_list.id
}

output "cmscloud_shared_services_pl" {
  value = data.aws_ec2_managed_prefix_list.cmscloud_shared_services_pl.id
}

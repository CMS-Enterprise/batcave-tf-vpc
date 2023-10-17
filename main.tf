# vpc id
data "aws_vpc" "batcave_vpc" {
  tags = {
    Name = coalesce(var.vpc_lookup_override, "${var.project}-*-${var.env}")
  }
}

# private subnets
data "aws_subnets" "private" {
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.private, "${var.project}-*-${var.env}-private-*")
    ]
  }
}

# public subnets
data "aws_subnets" "public" {
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.public, "${var.project}-*-${var.env}-public-*")
    ]
  }
}

# container subnets
data "aws_subnets" "container" {
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.container, "${var.project}-*-${var.env}-unroutable-*")
    ]
  }
}

# transport subnets
data "aws_subnets" "transport" {
  count = var.transport_subnets_exist ? 1 : 0
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.transport, "${var.project}-*-${var.env}-transport-*")
    ]
  }
}

# shared subnets
data "aws_subnets" "shared" {
  count = var.shared_subnets_exist ? 1 : 0
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.shared, "${var.project}-*-${var.env}-shared-*")
    ]
  }
}

# data subnets
data "aws_subnets" "data" {
  count = var.data_subnets_exist ? 1 : 0
  filter {
    name = "tag:Name"
    values = [
      try(var.subnet_lookup_overrides.data, "${var.project}-*-${var.env}-data-*")
    ]
  }
}

## subnet resources
data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnet" "container" {
  for_each = toset(data.aws_subnets.container.ids)
  id       = each.value
}

data "aws_subnet" "transport" {
  for_each = var.transport_subnets_exist ? toset(data.aws_subnets.transport[0].ids) : toset([])
  id       = each.value
}

data "aws_subnet" "shared" {
  for_each = var.shared_subnets_exist ? toset(data.aws_subnets.shared[0].ids) : toset([])
  id       = each.value
}

data "aws_subnet" "data" {
  for_each = var.data_subnets_exist ? toset(data.aws_subnets.data[0].ids) : toset([])
  id       = each.value
}

data "aws_ec2_managed_prefix_list" "vpn_prefix_list" {
  name = "cmscloud-vpn"
}

data "aws_ec2_managed_prefix_list" "cmscloud_shared_services_pl" {
  name = "cmscloud-shared-services"
}

data "aws_ec2_managed_prefix_list" "cmscloud_security_tools" {
  name = "cmscloud-security-tools"
}

data "aws_ec2_managed_prefix_list" "cmscloud_public_pl" {
  count = var.public_pl_exists ? 1 : 0
  name  = "cmscloud-public"
}

data "aws_ec2_managed_prefix_list" "zscaler_pl" {
  count = var.zscaler_pl_exists ? 1 : 0
  name  = "zscaler"

}

data "aws_route_table" "shared" {
  for_each  = toset(try(data.aws_subnets.shared[0].ids, []))
  subnet_id = each.key
}

data "aws_route_table" "all_non_public_route_tables" {
  for_each  = toset(local.all_non_public_subnet_ids)
  subnet_id = each.key
}


locals {
  # shared subnet route table ids
  shared_subnet_route_tables = [for rt in data.aws_route_table.shared : rt.route_table_id]
  # Map of routes and CIDRs
  shared_subnet_additional_routes = { for each in setproduct(local.shared_subnet_route_tables, var.shared_subnets_additional_tgw_routes)
    : "${each[0]}_${each[1]}" =>
    { route_table_id = each[0], cidr = each[1] }
  }
}

## Commenting out while we determine if these routes are necessary at all.  2023-01-26
#data "aws_ec2_transit_gateway" "shared_services" {
#  count = var.shared_subnets_exist && length(keys(local.shared_subnet_additional_routes)) > 0 ? 1 : 0
#  filter {
#    name   = "owner-id"
#    values = ["921617238787"]
#  }
#}
#resource "aws_route" "shared_subnet_additional_routes_to_tgw" {
#  for_each = local.shared_subnet_additional_routes
#
#  route_table_id         = each.value.route_table_id
#  destination_cidr_block = each.value.cidr
#  transit_gateway_id     = try(data.aws_ec2_transit_gateway.shared_services[0].id, null)
#}

locals {
  all_subnets = merge({
    "public"    = data.aws_subnet.public
    "private"   = data.aws_subnet.private
    "container" = data.aws_subnet.container
    },
    var.shared_subnets_exist ? { "shared" = data.aws_subnet.shared } : {},
    var.data_subnets_exist ? { "data" = data.aws_subnet.data } : {},
    var.transport_subnets_exist ? { "transport" = data.aws_subnet.transport } : {},
  )

  all_non_public_subnets = merge({
    "private"   = data.aws_subnet.private
    "container" = data.aws_subnet.container
    },
    var.shared_subnets_exist ? { "shared" = data.aws_subnet.shared } : {},
    var.data_subnets_exist ? { "data" = data.aws_subnet.data } : {},
    var.transport_subnets_exist ? { "transport" = data.aws_subnet.transport } : {},
  )

  all_non_public_subnet_ids = flatten([for subnet_group in local.all_non_public_subnets : [for subnet in subnet_group : subnet.id]])
}

resource "aws_vpc_endpoint" "s3" {
  count = var.create_s3_vpc_endpoint ? 1 : 0

  vpc_id          = data.aws_vpc.batcave_vpc.id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [for route_table in data.aws_route_table.all_non_public_route_tables : route_table.id]

  tags = {
    Name = coalesce(var.vpc_endpoint_lookup_overrides, "${var.project}-${var.env}-s3-endpoint")
  }
}

data "aws_eips" "nat_gateways" {
  tags = {
    Name = coalesce(var.nat_gateways_lookup_overrides, "${var.project}-*-${var.env}-nat-gateway-*")
  }
}

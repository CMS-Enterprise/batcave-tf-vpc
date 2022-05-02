# vpc id
data "aws_vpc" "batcave_vpc" {
  tags = {
    Name = "${var.project}-*-${var.env}"
  }
}

# private subnets
data "aws_subnets" "private" {
  filter {
    name = "tag:Name"
    values = [
      "${var.project}-*-${var.env}-private-*"
    ]
  }
}

# public subnets
data "aws_subnets" "public" {
  filter {
    name = "tag:Name"
    values = [
      "${var.project}-*-${var.env}-public-*"
    ]
  }
}

# container subnets
data "aws_subnets" "container" {
  filter {
    name = "tag:Name"
    values = [
      "${var.project}-*-${var.env}-unroutable-*"
    ]
  }
}

# transport subnets
data "aws_subnets" "transport" {
  count = var.transport_subnets_exist ? 1 : 0
  filter {
    name = "tag:Name"
    values = [
      "${var.project}-*-${var.env}-transport-*"
    ]
  }
}

# shared subnets
data "aws_subnets" "shared" {
  count = var.shared_subnets_exist ? 1 : 0
  filter {
    name = "tag:Name"
    values = [
      "${var.project}-*-${var.env}-shared-*"
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

data "aws_ec2_managed_prefix_list" "vpn_prefix_list" {
  name = "cmscloud-vpn"
}

data "aws_ec2_managed_prefix_list" "cmscloud_shared_services_pl" {
  name = "cmscloud-shared-services"
}

data "aws_ec2_managed_prefix_list" "cmscloud_security_tools" {
  name = "cmscloud-security-tools"
}

locals {
  all_subnets = merge({
    "public"    = data.aws_subnet.public
    "private"   = data.aws_subnet.private
    "container" = data.aws_subnet.container
    },
    var.shared_subnets_exist ? { "shared" = data.aws_subnet.shared } : {},
    var.transport_subnets_exist ? { "transport" = data.aws_subnet.transport } : {},
  )
}

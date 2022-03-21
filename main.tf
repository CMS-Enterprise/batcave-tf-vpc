# vpc id
data "aws_vpc" "batcave_vpc" {
  tags = {
    Name = "batcave-*-${var.env}"
  }
}

# private subnets
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = [
      "batcave-*-${var.env}-private-*"
    ]
  }
}

# public subnets
data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = [
      "batcave-*-${var.env}-public-*"
    ]
  }
}

# container subnets
data "aws_subnets" "container" {
  filter {
    name   = "tag:Name"
    values = [
      "batcave-*-${var.env}-unroutable-*"
    ]
  }
}

# transport subnets
data "aws_subnets" "transport" {
  filter {
    name   = "tag:Name"
    values = [
      "batcave-*-${var.env}-transport-*"
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
  for_each = toset(data.aws_subnets.transport.ids)
  id       = each.value
}

data "aws_ec2_managed_prefix_list" "vpn_prefix_list" {
  name = "cmscloud-vpn"
}

data "aws_ec2_managed_prefix_list" "cmscloud_shared_services_pl"{
  name = "cmscloud-shared-services"
}
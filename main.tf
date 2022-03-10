# vpc id
data "aws_vpc" "batcave_vpc" {
  tags = {
    Name = "batcave-*-${var.env}"
  }
}

# private subnets
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "batcave-*-${var.env}-private-*"
    ]
  }
}

# public subnets
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "batcave-*-${var.env}-public-*"
    ]
  }
}

# container subnets
data "aws_subnet_ids" "container" {
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "batcave-*-${var.env}-unroutable-*"
    ]
  }
}

# transport subnets
data "aws_subnet_ids" "transport" {
  count  = var.transport_subnets_exist ? 1 : 0
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "batcave-*-${var.env}-transport-*"
    ]
  }
}

## subnet resources
data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}

data "aws_subnet" "container" {
  for_each = data.aws_subnet_ids.container.ids
  id       = each.value
}

data "aws_subnet" "transport" {
  for_each = try(data.aws_subnet_ids.transport[0].ids, toset([]))
  id       = each.value
}

data "aws_security_group" "shared_services_sg" {
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "cmscloud-shared-services"
    ]
  }
}

data "aws_security_group" "cmscloud_vpn" {
  vpc_id = data.aws_vpc.batcave_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "cmscloud-vpn"
    ]
  }
}

data "aws_ec2_managed_prefix_list" "vpn_prefix_list" {
  name = "cmscloud-vpn"
}

data "aws_ec2_managed_prefix_list" "cmscloud_shared_services_pl"{
  name = "cmscloud-shared-services"
}


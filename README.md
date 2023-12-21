# batcave-tf-vpc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_ec2_managed_prefix_list.cmscloud_public_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.cmscloud_security_tools](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.cmscloud_shared_services_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.vpn_prefix_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.zscaler_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_eips.nat_gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eips) | data source |
| [aws_route_table.all_non_public_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet.container](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.container](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.batcave_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_create_s3_vpc_endpoint"></a> [create\_s3\_vpc\_endpoint](#input\_create\_s3\_vpc\_endpoint) | toggle on/off the creation of s3 vpc endpoint | `bool` | `true` | no |
| <a name="input_data_subnets_exist"></a> [data\_subnets\_exist](#input\_data\_subnets\_exist) | Data subnets are used to house resources intended to access services inside CMS's data plane | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"dev"` | no |
| <a name="input_nat_gateways_lookup_overrides"></a> [nat\_gateways\_lookup\_overrides](#input\_nat\_gateways\_lookup\_overrides) | Some nat gateways don't follow standard naming conventions.  Use this map to override the query used for looking up Subnets.  Ex: { private = "foo-west-nonpublic-*" } | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"batcave"` | no |
| <a name="input_public_pl_exists"></a> [public\_pl\_exists](#input\_public\_pl\_exists) | The public PL is a work in progress (as of 2022-05-27) by the network team.  It will eventually be rolled out everywhere, but is not yet.  For now, it defaults to false, but can eventually be removed when every ADO VPC has it | `bool` | `false` | no |
| <a name="input_shared_subnets_exist"></a> [shared\_subnets\_exist](#input\_shared\_subnets\_exist) | Shared subnets are used to house resources intended to be shared across ALL CMS Cloud systems via the transit gateway | `bool` | `false` | no |
| <a name="input_subnet_lookup_overrides"></a> [subnet\_lookup\_overrides](#input\_subnet\_lookup\_overrides) | Some Subnets don't follow standard naming conventions.  Use this map to override the query used for looking up Subnets.  Ex: { private = "foo-west-nonpublic-*" } | `map(string)` | `{}` | no |
| <a name="input_transport_subnets_exist"></a> [transport\_subnets\_exist](#input\_transport\_subnets\_exist) | Transport subnets are used to house the NLB in situations where a service is required to be exposed to VDI users | `bool` | `false` | no |
| <a name="input_vpc_endpoint_lookup_overrides"></a> [vpc\_endpoint\_lookup\_overrides](#input\_vpc\_endpoint\_lookup\_overrides) | Some vpc endpoints don't follow standard naming conventions.  Use this map to override the query used for looking up Subnets.  Ex: { private = "foo-west-nonpublic-*" } | `string` | `""` | no |
| <a name="input_vpc_lookup_override"></a> [vpc\_lookup\_override](#input\_vpc\_lookup\_override) | Some VPCs don't follow standard naming conventions.  Use this to override the query used to lookup VPC names.  Accepts wildcard in form of '*' | `string` | `""` | no |
| <a name="input_zscaler_pl_exists"></a> [zscaler\_pl\_exists](#input\_zscaler\_pl\_exists) | The zscaler PL is a work in progress (as of 2022-07-08) by the network team.  It will eventually be rolled out everywhere, but is not yet.  For now, it defaults to false, but can eventually be removed when every ADO VPC has it | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cms_public_ip_cidrs"></a> [cms\_public\_ip\_cidrs](#output\_cms\_public\_ip\_cidrs) | n/a |
| <a name="output_cmscloud_public_pl"></a> [cmscloud\_public\_pl](#output\_cmscloud\_public\_pl) | Prefix list of cmscloud public |
| <a name="output_cmscloud_security_tools_pl"></a> [cmscloud\_security\_tools\_pl](#output\_cmscloud\_security\_tools\_pl) | n/a |
| <a name="output_cmscloud_shared_services_pl"></a> [cmscloud\_shared\_services\_pl](#output\_cmscloud\_shared\_services\_pl) | n/a |
| <a name="output_cmscloud_vpn_pl"></a> [cmscloud\_vpn\_pl](#output\_cmscloud\_vpn\_pl) | Prefix list of cmscloud vpn |
| <a name="output_container_subnets"></a> [container\_subnets](#output\_container\_subnets) | List of IDs of container subnets |
| <a name="output_container_subnets_by_zone"></a> [container\_subnets\_by\_zone](#output\_container\_subnets\_by\_zone) | map of AZs to container subnet ids |
| <a name="output_nat_gateway_public_ip_cidrs"></a> [nat\_gateway\_public\_ip\_cidrs](#output\_nat\_gateway\_public\_ip\_cidrs) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_by_zone"></a> [private\_subnets\_by\_zone](#output\_private\_subnets\_by\_zone) | map of AZs to private subnet ids |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | n/a |
| <a name="output_transport_subnet_cidr_blocks"></a> [transport\_subnet\_cidr\_blocks](#output\_transport\_subnet\_cidr\_blocks) | map of IDs to transport subnet cidrs |
| <a name="output_transport_subnets"></a> [transport\_subnets](#output\_transport\_subnets) | List of IDs of transport subnets |
| <a name="output_transport_subnets_by_zone"></a> [transport\_subnets\_by\_zone](#output\_transport\_subnets\_by\_zone) | map of AZs to transport subnet ids |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_blocks"></a> [vpc\_cidr\_blocks](#output\_vpc\_cidr\_blocks) | # VPC Data |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_zscaler_pl"></a> [zscaler\_pl](#output\_zscaler\_pl) | Prefix list of zscaler |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

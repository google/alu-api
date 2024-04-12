## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.4.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apigee-x-bridge-mig"></a> [apigee-x-bridge-mig](#module\_apigee-x-bridge-mig) | github.com/apigee/terraform-modules//modules/apigee-x-bridge-mig | v0.21.0 |
| <a name="module_apigee-x-core"></a> [apigee-x-core](#module\_apigee-x-core) | github.com/apigee/terraform-modules//modules/apigee-x-core | v0.21.0 |
| <a name="module_mig-l7xlb"></a> [mig-l7xlb](#module\_mig-l7xlb) | github.com/apigee/terraform-modules//modules/mig-l7xlb | v0.21.0 |
| <a name="module_nip-development-hostname"></a> [nip-development-hostname](#module\_nip-development-hostname) | github.com/apigee/terraform-modules//modules/nip-development-hostname | v0.21.0 |
| <a name="module_project"></a> [project](#module\_project) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/project | v28.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc | v28.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_member) | resource |
| [google_project_service.cloud_spanner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.api_runner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.apigee_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigee_billing_type"></a> [apigee\_billing\_type](#input\_apigee\_billing\_type) | Billing type of the Apigee organization (Valid values are EVALUATION, PAYG, and SUBSCRIPTION) | `string` | `"PAYG"` | no |
| <a name="input_apigee_environments"></a> [apigee\_environments](#input\_apigee\_environments) | Apigee Environments. | <pre>map(object({<br>    display_name = optional(string)<br>    description  = optional(string)<br>    node_config = optional(object({<br>      min_node_count = optional(number)<br>      max_node_count = optional(number)<br>    }))<br>    iam       = optional(map(list(string)))<br>    envgroups = list(string)<br>    type      = optional(string)<br>  }))</pre> | <pre>{<br>  "prod": {<br>    "description": "Environment created by apigee/terraform-modules",<br>    "display_name": "prod",<br>    "envgroups": [<br>      "prod"<br>    ],<br>    "iam": null,<br>    "node_config": null,<br>    "type": "INTERMEDIATE"<br>  }<br>}</pre> | no |
| <a name="input_apigee_instances"></a> [apigee\_instances](#input\_apigee\_instances) | Apigee Instances (only one instance for EVAL orgs). | <pre>map(object({<br>    region       = string<br>    ip_range     = string<br>    environments = list(string)<br>  }))</pre> | <pre>{<br>  "as1-instance-dev": {<br>    "environments": [<br>      "prod"<br>    ],<br>    "ip_range": "10.0.0.0/22",<br>    "region": "asia-south1"<br>  }<br>}</pre> | no |
| <a name="input_ax_region"></a> [ax\_region](#input\_ax\_region) | GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli). | `string` | `"asia-south1"` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account id. | `string` | `null` | no |
| <a name="input_cloud_run_location"></a> [cloud\_run\_location](#input\_cloud\_run\_location) | Location of Cloud Run for alu-api service | `string` | `"asia-south1"` | no |
| <a name="input_cloud_run_max_instance_count"></a> [cloud\_run\_max\_instance\_count](#input\_cloud\_run\_max\_instance\_count) | Maximum number of instance of alu-api service | `number` | `20` | no |
| <a name="input_cloud_run_min_instance_count"></a> [cloud\_run\_min\_instance\_count](#input\_cloud\_run\_min\_instance\_count) | Minimum number of instance of alu-api service | `number` | `1` | no |
| <a name="input_cloud_run_service_name"></a> [cloud\_run\_service\_name](#input\_cloud\_run\_service\_name) | Name of the Cloud Run service for alu-api | `string` | `"alu-api"` | no |
| <a name="input_exposure_subnets"></a> [exposure\_subnets](#input\_exposure\_subnets) | Subnets for exposing Apigee services | <pre>list(object({<br>    name               = string<br>    ip_cidr_range      = string<br>    region             = string<br>    secondary_ip_range = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "ip_cidr_range": "10.100.0.0/24",<br>    "name": "apigee-exposure",<br>    "region": "asia-south1",<br>    "secondary_ip_range": null<br>  }<br>]</pre> | no |
| <a name="input_network"></a> [network](#input\_network) | VPC name | `string` | `"apigee-network"` | no |
| <a name="input_peering_range"></a> [peering\_range](#input\_peering\_range) | Peering CIDR range | `string` | `"10.0.0.0/22"` | no |
| <a name="input_project_create"></a> [project\_create](#input\_project\_create) | Create project. When set to false, uses a data source to reference existing project. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID (also used for the Apigee Organization) | `string` | n/a | yes |
| <a name="input_project_parent"></a> [project\_parent](#input\_project\_parent) | Parent folder or organization in 'folders/folder\_id' or 'organizations/org\_id' format. | `string` | `null` | no |
| <a name="input_support_range"></a> [support\_range](#input\_support\_range) | Support CIDR range of length /28 (required by Apigee for troubleshooting purposes). | `string` | `"10.1.0.0/28"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigee_hostname"></a> [apigee\_hostname](#output\_apigee\_hostname) | n/a |
| <a name="output_apigee_proxy_service_account_email"></a> [apigee\_proxy\_service\_account\_email](#output\_apigee\_proxy\_service\_account\_email) | n/a |
| <a name="output_cloud_run_url"></a> [cloud\_run\_url](#output\_cloud\_run\_url) | n/a |

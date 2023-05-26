# networking module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | Google cloud region where the resource will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| netowrk\_self\_link | Network self link |
| subnet\_netowrk\_self\_link | Subnet netowrk self link |
| vpc\_access\_connector\_id | VPC access connector id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

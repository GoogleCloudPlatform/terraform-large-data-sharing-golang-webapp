# Simple Example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| init | Initialize resource or not | `bool` | `true` | no |
| project\_id | GCP project for provisioning cloud resources. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backend\_bucket\_name | The name of the backend bucket used for Cloud CDN |
| cdn\_bucket\_name | The bucket name for cdn |
| lb\_global\_ip | Frontend IP address of the load balancer |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

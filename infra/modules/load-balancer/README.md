# load-balancer module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Bucket name | `string` | n/a | yes |
| client\_service\_name | Frontend service name | `string` | n/a | yes |
| labels | A map of key/value label pairs to assign to the bucket. | `map(string)` | n/a | yes |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | Google cloud region where the resource will be created. | `string` | n/a | yes |
| resource\_path | Resource folder path | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backend\_bucket\_name | The name of the backend bucket used for Cloud CDN |
| lb\_external\_ip | Frontend IP address of the load balancer |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

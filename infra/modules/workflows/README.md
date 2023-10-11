# workflows module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| job\_migrate\_data\_name | CloudRun job name to migrate data | `string` | n/a | yes |
| job\_reset\_data\_name | CloudRun job name to reset data | `string` | n/a | yes |
| labels | A map of key/value label pairs to assign to the bucket. | `map(string)` | `{}` | no |
| name | Workflow name | `string` | n/a | yes |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | Workflow region | `string` | n/a | yes |
| service\_account\_email | Workflow service account email | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | Workflow name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

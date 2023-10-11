# workflows module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| job_migrate_data_name | CloudRun job name to migrate data | `string` | `{}` | no |
| job_reset_data_name | CloudRun job name to reset data | `string` | `{}` | no |
| labels | A map of key/value label pairs to assign to the bucket. | `map(string)` | `{}` | no |
| region | Workflow region | `string` | n/a | yes |
| name | Workflow name | `string` | n/a | yes |
| project\_id | GCP project ID. | `string` | n/a | yes |
| service\_account\_email | Workflow service account email | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| workflow\_name | Workflow name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# cloudrun module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud\_run\_image | Docker image for Cloud Run | `string` | n/a | yes |
| cloud\_run\_name | Name of Cloud Run | `string` | n/a | yes |
| container\_port | Container port | `string` | n/a | yes |
| env\_vars | Environment variables | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| ingress | Ingress of Cloud Run | `string` | n/a | yes |
| labels | A map of key/value label pairs to assign to the bucket | `map(string)` | n/a | yes |
| limits | Resource limits to the container | `map(string)` | n/a | yes |
| liveness\_probe | helth check | <pre>object(<br>    {<br>      initial_delay_seconds = number,<br>      timeout_seconds       = number,<br>      period_seconds        = number,<br>      failure_threshold     = number,<br>      http_get = object(<br>        {<br>          path = string<br>        }<br>      )<br>    }<br>  )</pre> | <pre>{<br>  "failure_threshold": 3,<br>  "http_get": {<br>    "path": "/"<br>  },<br>  "initial_delay_seconds": 600,<br>  "period_seconds": 300,<br>  "timeout_seconds": 60<br>}</pre> | no |
| location | Google cloud location where the resource will be created | `string` | n/a | yes |
| project\_id | GCP project ID | `string` | n/a | yes |
| service\_account\_email | cloud run service account email | `string` | n/a | yes |
| vpc\_access\_connector\_id | VPC access connector id | `string` | n/a | yes |
| vpc\_egress | VPC access egress | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_run | Cloud Run service |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

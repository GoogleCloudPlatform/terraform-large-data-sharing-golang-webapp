# Large Data Sharing Golang Web App

## Description

### Tagline

Create a web app to share large quantities of files to users across the globe

### Detailed

This solution provides an end-to-end demonstration on how a developer would architect an application that can handle large quantities of files operations on GCP. The goal of this solution is to utilize Google Cloud CDN to serve large quantities of files.

The resources/services/activations/deletions that this module will create/trigger are:

- Cloud Load Balancing
- Cloud Storage
- Cloud CDN
- Cloud Run
- Firestore

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_location | Bucket location. https://cloud.google.com/storage/docs/locations | `string` | `"US"` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed. | `bool` | `false` | no |
| init | Initialize resource or not | `bool` | `true` | no |
| labels | A map of key/value label pairs to assign to the resources. | `map(string)` | <pre>{<br>  "app": "large-data-sharing-golang"<br>}</pre> | no |
| lds\_client\_image | Docker image for frontend | `string` | `"gcr.io/hsa-resources-public/hsa-lds-golang-frontend:latest"` | no |
| lds\_firestore | Firestore collection id | `string` | `"fileMetadata-cdn"` | no |
| lds\_firestore\_field\_name | Firestore field: name | `string` | `"name"` | no |
| lds\_firestore\_field\_orderNo | Firestore field: orderNo | `string` | `"orderNo"` | no |
| lds\_firestore\_field\_path | Firestore field: path | `string` | `"path"` | no |
| lds\_firestore\_field\_size | Firestore field: size | `string` | `"size"` | no |
| lds\_firestore\_field\_tags | Firestore field: tags | `string` | `"tags"` | no |
| lds\_initialization\_archive\_file\_name | Archive file's name in lds-initialization bucket | `string` | `"initialization.tar.gz"` | no |
| lds\_initialization\_bucket\_name | Bucket for cloud run job | `string` | `"jss-resources"` | no |
| lds\_server\_image | Docker image for backend | `string` | `"gcr.io/hsa-public/hsa-lds-golang-backend:firestore-db"` | no |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | Google cloud region where the resource will be created. | `string` | `"us-west1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_bucket\_name | The name of the backend bucket used for Cloud CDN |
| bucket\_name | Bucket name |
| lb\_external\_ip | Frontend IP address of the load balancer |
| neos\_walkthrough\_url | Neos Tutorial URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v0.13
- [Terraform Provider for GCP](https://registry.terraform.io/providers/hashicorp/google/latest/docs) plugin v4.57

### Service Account

- roles/storage.objectAdmin
- roles/datastore.user
- roles/compute.networkUser

A service account with the following roles must be used to provision
the resources of this module:

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- compute.googleapis.com
- run.googleapis.com
- iam.googleapis.com
- firestore.googleapis.com
- vpcaccess.googleapis.com
- monitoring.googleapis.com

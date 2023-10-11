/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "GCP project ID."
  type        = string
  validation {
    condition     = var.project_id != ""
    error_message = "Error: project_id is required"
  }
}

variable "region" {
  description = "Google cloud region where the resource will be created."
  type        = string
  default     = "us-west1"
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed."
  type        = bool
  default     = false
}

variable "bucket_location" {
  description = "Bucket location. https://cloud.google.com/storage/docs/locations"
  type        = string
  default     = "US"

  validation {
    condition     = contains(["ASIA", "EU", "US"], var.bucket_location)
    error_message = "Allowed values for type are \"ASIA\", \"EU\", \"US\"."
  }
}

variable "lds_server_image" {
  description = "Docker image for backend"
  type        = string
  default     = "gcr.io/hsa-public/hsa-lds-golang-backend:firestore-db"
}

variable "lds_client_image" {
  description = "Docker image for frontend"
  type        = string
  default     = "gcr.io/hsa-resources-public/hsa-lds-golang-frontend:latest"
}

variable "lds_initialization_bucket_name" {
  description = "Bucket for cloud run job"
  type        = string
  default     = "hsa-public-bucket"
}

variable "lds_initialization_archive_file_name" {
  description = "Archive file's name in lds-initialization bucket"
  type        = string
  default     = "initialization.tar.gz"
}

variable "labels" {
  type        = map(string)
  description = "A map of key/value label pairs to assign to the resources."
  default = {
    app = "large-data-sharing-golang"
  }
}

variable "lds_firestore" {
  description = "Firestore collection id"
  type        = string
  default     = "fileMetadata-cdn"
}

variable "lds_firestore_field_path" {
  description = "Firestore field: path"
  type        = string
  default     = "path"
}

variable "lds_firestore_field_name" {
  description = "Firestore field: name"
  type        = string
  default     = "name"
}

variable "lds_firestore_field_size" {
  description = "Firestore field: size"
  type        = string
  default     = "size"
}

variable "lds_firestore_field_tags" {
  description = "Firestore field: tags"
  type        = string
  default     = "tags"
}

variable "lds_firestore_field_orderNo" {
  description = "Firestore field: orderNo"
  type        = string
  default     = "orderNo"
}

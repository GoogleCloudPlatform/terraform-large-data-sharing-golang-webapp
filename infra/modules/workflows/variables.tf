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
}

variable "region" {
  description = "Workflow region"
  type        = string
}

variable "name" {
  description = "Workflow name"
  type        = string
}

variable "service_account_email" {
  description = "Workflow service account email"
  type        = string
}

variable "job_migrate_data_name" {
  description = "CloudRun job name to migrate data"
  type        = string
}

variable "job_reset_data_name" {
  description = "CloudRun job name to reset data"
  type        = string
}

variable "labels" {
  type        = map(string)
  description = "A map of key/value label pairs to assign to the bucket."
  default     = {}
}

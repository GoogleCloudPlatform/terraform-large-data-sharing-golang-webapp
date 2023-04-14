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
  description = "GCP project ID"
  type        = string
}

variable "location" {
  description = "Google cloud location where the resource will be created"
  type        = string
}

variable "cloud_run_name" {
  description = "Name of Cloud Run"
  type        = string
}

variable "cloud_run_image" {
  description = "Docker image for Cloud Run"
  type        = string
}

# cpu = (core count * 1000)m
# memory = (size) Mi/Gi
variable "limits" {
  type        = map(string)
  description = "Resource limits to the container"
}

variable "container_port" {
  description = "Container port"
  type        = string
}

variable "env_vars" {
  description = "Environment variables"
  type = list(object({
    value = string
    name  = string
  }))
  default = []
}

variable "ingress" {
  description = "Ingress of Cloud Run"
  type        = string
}

variable "vpc_access_connector_id" {
  description = "VPC access connector id"
  type        = string
}

variable "vpc_egress" {
  description = "VPC access egress"
  type        = string
}

variable "service_account_email" {
  description = "cloud run service account email"
  type        = string
}

variable "liveness_probe" {
  description = "helth check"
  type = object(
    {
      initial_delay_seconds = number,
      timeout_seconds       = number,
      period_seconds        = number,
      failure_threshold     = number,
      http_get = object(
        {
          path = string
        }
      )
    }
  )
  default = {
    initial_delay_seconds = 600,
    timeout_seconds       = 60,
    period_seconds        = 300,
    failure_threshold     = 3,
    http_get = {
      path = "/"
    }
  }
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the bucket"
  type        = map(string)
}

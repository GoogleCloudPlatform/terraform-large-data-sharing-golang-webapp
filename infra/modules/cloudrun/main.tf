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

resource "google_cloud_run_v2_service" "main" {
  name     = var.cloud_run_name
  location = var.location
  ingress  = var.ingress
  template {
    service_account = var.service_account_email
    scaling {
      max_instance_count = 4
    }
    containers {
      image = var.cloud_run_image
      liveness_probe {
        initial_delay_seconds = lookup(var.liveness_probe, "initial_delay_seconds", null)
        timeout_seconds       = lookup(var.liveness_probe, "timeout_seconds", null)
        period_seconds        = lookup(var.liveness_probe, "period_seconds", null)
        failure_threshold     = lookup(var.liveness_probe, "failure_threshold", null)
        http_get {
          path = lookup(var.liveness_probe.http_get, "path", null)
        }
      }
      resources {
        limits   = var.limits
        cpu_idle = true
      }
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.value["name"]
          value = env.value["value"]
        }
      }
      ports {
        container_port = var.container_port
      }
    }
    vpc_access {
      connector = var.vpc_access_connector_id
      egress    = var.vpc_egress
    }
  }
  labels = var.labels
}

resource "google_cloud_run_service_iam_policy" "policy" {
  project     = var.project_id
  location    = var.location
  service     = google_cloud_run_v2_service.main.name
  policy_data = data.google_iam_policy.cloud_run.policy_data
}

data "google_iam_policy" "cloud_run" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

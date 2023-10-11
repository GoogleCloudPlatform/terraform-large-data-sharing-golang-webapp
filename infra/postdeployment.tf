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

locals {
  migrate_data_commands = [
    "gsutil cp gs://${var.lds_initialization_bucket_name}/large-data-sharing/execution.sh .",
    "gsutil cp gs://${var.lds_initialization_bucket_name}/large-data-sharing/upload.sh .",
    "bash execution.sh ${var.lds_initialization_bucket_name}/large-data-sharing ${var.lds_initialization_archive_file_name} ${module.cloud_run_client.cloud_run.uri}",
  ]
}

resource "google_cloud_run_v2_job" "migrate_data" {
  depends_on = [
    module.project_services,
  ]
  name         = "migration-data-job-golang"
  location     = var.region
  launch_stage = "BETA"
  template {
    template {
      service_account = google_service_account.cloudrun.email
      containers {
        image   = "gcr.io/google.com/cloudsdktool/cloud-sdk"
        command = ["/bin/bash"]
        args = [
          "-c",
          join(" && ", local.migrate_data_commands)
        ]
      }
      vpc_access {
        connector = module.networking.vpc_access_connector_id
        egress    = "ALL_TRAFFIC"
      }
    }
  }
  labels = var.labels
}

resource "google_cloud_run_v2_job" "reset_data" {
  depends_on = [
    module.project_services,
  ]
  name         = "reset-data-job-golang"
  location     = var.region
  launch_stage = "BETA"
  template {
    template {
      service_account = google_service_account.cloudrun.email
      containers {
        image   = "curlimages/curl"
        command = ["/bin/sh"]
        args = [
          "-c",
          "curl -X DELETE ${module.cloud_run_server.cloud_run.uri}/api/reset"
        ]
      }
      vpc_access {
        connector = module.networking.vpc_access_connector_id
        egress    = "ALL_TRAFFIC"
      }
    }
  }
  labels = var.labels
}

# execute workflows after all resources are created
# # get a token to execute the workflows
data "google_client_config" "current" {
}

# # execute the post init workflow
data "http" "call_workflows_post_init" {
  url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project_services.project_id}/locations/${var.region}/workflows/${module.workflows.name}/executions"
  method = "POST"
  request_headers = {
    Accept = "application/json"
  Authorization = "Bearer ${data.google_client_config.current.access_token}" }
}

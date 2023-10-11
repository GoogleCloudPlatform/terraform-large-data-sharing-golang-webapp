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

resource "google_workflows_workflow" "main" {
  project         = var.project_id
  name            = var.name
  region          = var.region
  service_account = var.service_account_email
  description     = "Runs post Terraform setup steps for Solution in Console"

  labels = var.labels

  source_contents = templatefile("../../templates/workflow.tftpl", {
    project_id        = var.project_id,
    reset_data_name   = var.job_reset_data_name,
    migrate_data_name = var.job_migrate_data_name,
    region            = var.region,
  })
}

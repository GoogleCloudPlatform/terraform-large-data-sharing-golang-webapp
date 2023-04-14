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
    "gsutil cp gs://${var.lds_initialization_bucket_name}/execution.sh .",
    "gsutil cp gs://${var.lds_initialization_bucket_name}/upload.sh .",
    "bash execution.sh ${var.lds_initialization_bucket_name} ${var.lds_initialization_archive_file_name} ${module.cloud_run_client.cloud_run.uri}",
  ]
}

resource "google_cloud_run_v2_job" "migrate_data" {
  depends_on = [
    module.project_services,
  ]
  name         = "migration-data-job"
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
          "${join(" && ", local.migrate_data_commands)}"
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
  name         = "reset-data-job"
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

data "google_compute_zones" "available" {
  depends_on = [
    module.project_services,
  ]
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "initialization" {
  depends_on = [
    module.project_services,
    module.cloud_run_server,
    module.cloud_run_client,
  ]

  name         = "lds-initialization"
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = module.networking.netowrk_self_link
    subnetwork = module.networking.subnet_netowrk_self_link
  }

  service_account {
    email = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    scopes = [
      "cloud-platform"
    ]
  }

  metadata_startup_script = <<EOT
    #!/bin/bash
    gcloud beta run jobs execute ${google_cloud_run_v2_job.reset_data.name} --wait --project ${var.project_id} --region ${var.region}
    gcloud beta run jobs execute ${google_cloud_run_v2_job.migrate_data.name} --wait --project ${var.project_id} --region ${var.region}
    shutdown -h now
  EOT
  labels                  = var.labels
}

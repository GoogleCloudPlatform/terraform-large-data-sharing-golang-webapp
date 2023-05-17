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

module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 14.0"
  disable_services_on_destroy = var.disable_services_on_destroy
  project_id                  = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "run.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firestore.googleapis.com",
    "vpcaccess.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

data "google_project" "project" {
  depends_on = [
    module.project_services,
  ]
}

locals {
  resource_path = "resource"
}

module "storage" {
  depends_on = [
    module.project_services,
  ]
  source = "./modules/storage"

  project_id = var.project_id
  location   = var.bucket_location
  labels     = var.labels
  name       = "lds-resource-${data.google_project.project.number}"
}

module "networking" {
  depends_on = [
    module.project_services,
  ]
  source = "./modules/networking"

  project_id = var.project_id
  region     = var.region
}

module "firestore" {
  depends_on = [
    module.project_services
  ]
  source = "./modules/firestore"

  project_id = var.project_id
  init       = var.init
}

resource "random_id" "random_code" {
  byte_length = 4
}

resource "google_service_account" "cloudrun" {
  depends_on = [
    module.project_services,
  ]

  account_id = "cloudrun-${random_id.random_code.hex}"
}

resource "google_project_iam_member" "cloudrun" {
  for_each = toset([
    "roles/storage.objectAdmin",
    "roles/datastore.user",
    "roles/compute.networkUser",
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

module "cloud_run_server" {
  depends_on = [
    module.project_services,
  ]
  source = "./modules/cloudrun"

  project_id      = var.project_id
  location        = var.region
  cloud_run_name  = "lds-server"
  cloud_run_image = var.lds_server_image
  limits = {
    cpu    = "2000m"
    memory = "2Gi"
  }
  container_port = "8000"
  liveness_probe = {
    initial_delay_seconds = 300
    timeout_seconds       = 10
    period_seconds        = 60
    failure_threshold     = 1
    http_get = {
      path = "/api/healthchecker"
    }
  }
  env_vars = [
    {
      name  = "LDS_REST_PORT"
      value = "8000"
    },
    {
      name  = "LDS_PROJECT"
      value = var.project_id
    },
    {
      name  = "LDS_BUCKET"
      value = module.storage.bucket_name
    },
    {
      name  = "LDS_RESOURCE_PATH"
      value = "/${local.resource_path}"
    },
  ]
  ingress                 = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  vpc_access_connector_id = module.networking.vpc_access_connector_id
  vpc_egress              = "PRIVATE_RANGES_ONLY"
  service_account_email   = google_service_account.cloudrun.email
  labels                  = var.labels
}

module "cloud_run_client" {
  depends_on = [
    module.project_services,
  ]
  source = "./modules/cloudrun"

  project_id      = var.project_id
  location        = var.region
  cloud_run_name  = "lds-client"
  cloud_run_image = var.lds_client_image
  limits = {
    cpu    = "1000m"
    memory = "512Mi"
  }
  container_port = "80"
  liveness_probe = {
    initial_delay_seconds = 30
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 1
    http_get = {
      path = "/"
    }
  }
  env_vars = [
    {
      name  = "LDS_REST_URL"
      value = module.cloud_run_server.cloud_run.uri
    },
  ]
  ingress                 = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  vpc_access_connector_id = module.networking.vpc_access_connector_id
  vpc_egress              = "ALL_TRAFFIC"
  service_account_email   = google_service_account.cloudrun.email
  labels                  = var.labels
}

module "load_balancer" {
  depends_on = [
    module.project_services,
  ]
  source = "./modules/load-balancer"

  project_id          = var.project_id
  region              = var.region
  bucket_name         = module.storage.bucket_name
  client_service_name = module.cloud_run_client.cloud_run.name
  resource_path       = local.resource_path
  labels              = var.labels
}

resource "google_monitoring_dashboard" "lds" {
  depends_on = [
    module.project_services,
  ]

  for_each = {
    "lds_cloudrun_dashboard.tftpl" = {
      PROJECT_ID = var.project_id,
    }
    "lds_cdn_dashboard.tftpl" = {

    }
  }

  dashboard_json = templatefile("${path.module}/files/${each.key}", each.value)
}

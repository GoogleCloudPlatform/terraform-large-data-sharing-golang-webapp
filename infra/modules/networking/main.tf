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

resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = "lds-network"
  auto_create_subnetworks = true
}

resource "google_compute_subnetwork" "main" {
  region                   = var.region
  network                  = google_compute_network.main.id
  name                     = "lds-vpc-connector-subnetwork"
  private_ip_google_access = true

  # Subnets used for VPC connectors must have a netmask of 28.
  ip_cidr_range = "10.2.0.0/28"
}

resource "google_vpc_access_connector" "main" {
  project = var.project_id
  region  = var.region
  name    = "lds-vpc-connector"
  subnet {
    name = google_compute_subnetwork.main.name
  }
}

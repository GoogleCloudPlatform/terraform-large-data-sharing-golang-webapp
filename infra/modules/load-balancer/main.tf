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

resource "google_compute_backend_bucket" "cdn" {
  project     = var.project_id
  name        = "lds-cdn"
  bucket_name = var.bucket_name
  enable_cdn  = true
  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
  custom_response_headers = [
    "X-Cache-ID: {cdn_cache_id}",
    "X-Cache-Hit: {cdn_cache_status}",
    "X-Client-Location: {client_region_subdivision}, {client_city}",
    "X-Client-IP-Address: {client_ip_address}"
  ]
}

resource "google_compute_region_network_endpoint_group" "client" {
  name                  = "lds-client"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.client_service_name
  }
}

resource "google_compute_backend_service" "lds" {
  name                  = "lds"
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_network_endpoint_group.client.id
  }
}

resource "google_compute_url_map" "lds" {
  project         = var.project_id
  name            = "lds-lb"
  default_service = google_compute_backend_bucket.cdn.id
  host_rule {
    path_matcher = "client"
    hosts = [
      "*",
    ]
  }
  path_matcher {
    name            = "client"
    default_service = google_compute_backend_service.lds.id
    path_rule {
      paths = [
        "/${var.resource_path}/*",
      ]
      service = google_compute_backend_bucket.cdn.id
    }
  }
}

resource "google_compute_target_http_proxy" "lds" {
  project = var.project_id
  name    = "lds-proxy"
  url_map = google_compute_url_map.lds.self_link
}

resource "google_compute_global_forwarding_rule" "lds" {
  project    = var.project_id
  labels     = var.labels
  name       = "lds-frontend"
  target     = google_compute_target_http_proxy.lds.self_link
  ip_address = google_compute_global_address.lds.address
  port_range = "80"
}

resource "google_compute_global_address" "lds" {
  project      = var.project_id
  name         = "lds-external-ip"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

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

output "lb_external_ip" {
  description = "Frontend IP address of the load balancer"
  value       = module.load_balancer.lb_external_ip
}

output "bucket_name" {
  description = "Bucket name"
  value       = module.storage.bucket_name
}
  
output "neos_walkthrough_url" {
  description = "Neos Tutorial URL"
  value       = "https://console.cloud.google.com/products/solutions/deployments?walkthrough_id=solutions-in-console--large-data-sharing--large-data-sharing-golang_tour"
}

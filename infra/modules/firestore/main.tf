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

resource "google_firestore_database" "default" {
  count       = var.init ? 1 : 0
  project     = var.project_id
  name        = var.firestore_db_name
  location_id = "nam5" //US
  type        = "FIRESTORE_NATIVE"
}

resource "google_firestore_index" "meta" {

  for_each   = var.collection_fields
  collection = each.key
  dynamic "fields" {
    for_each = each.value
    iterator = field
    content {
      field_path   = lookup(field.value, "field_path", null)
      order        = lookup(field.value, "order", null)
      array_config = lookup(field.value, "array_config", null)
    }
    database     = google_firestore_database.default.name
  }
}

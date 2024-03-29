/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

provider "google" {
  project     = var.project_id
  region      = "europe-west4"
  zone        = "europe-west4-a"
}

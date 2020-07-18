resource "google_container_cluster" "primary" {
  name     = var.CLUSTER_NAME
  location = var.REGION
  min_master_version = var.MIN_MASTER_VERSION
 
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }


  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.NODE_POOL_NAME
  location   = var.REGION
  cluster    = google_container_cluster.primary.name
  node_count = var.NODE_COUNT

  autoscaling {
    min_node_count = var.MIN_NODE_COUNT
    max_node_count = var.MAX_NODE_COUNT
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    preemptible  = true
    machine_type = var.MACHINE_TYPE

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

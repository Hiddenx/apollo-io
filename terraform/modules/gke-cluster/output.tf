output "gke_cluster" {
  value = google_container_cluster.primary.name
}

output "gke_nodepool_name" {
  value = google_container_node_pool.primary_preemptible_nodes.name
}


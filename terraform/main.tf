module "my-cluster" {
  source              = "./modules/gke-cluster"
  REGION              = "us-east1-b"
  CLUSTER_NAME        = "dev-gke2"
  NODE_POOL_NAME      = "nodepool2"
  NODE_COUNT          = "1"
  MACHINE_TYPE        = "n1-standard-1"
  MIN_NODE_COUNT      = "1"
  MAX_NODE_COUNT      = "3"
  MIN_MASTER_VERSION  = "1.16"
}

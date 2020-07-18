terraform {
  backend "gcs" {
    credentials = "credentials.json" 
    bucket      = "apollo-io-tf-remote-state"
    prefix      = "terraform/state"
  }
}

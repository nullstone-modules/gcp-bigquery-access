// Optional connection to a BigQuery dataset. When connected, IAM grants are scoped to
// just this dataset instead of being granted across the entire project.
data "ns_connection" "dataset" {
  name     = "dataset"
  contract = "datastore/gcp/bigquery"
  optional = true
}

locals {
  dataset_id      = try(data.ns_connection.dataset.outputs.dataset_id, "")
  dataset_project = try(data.ns_connection.dataset.outputs.project_id, local.project_id)
  has_dataset     = local.dataset_id != ""
}

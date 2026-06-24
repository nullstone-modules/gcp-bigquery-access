output "env" {
  value = [
    {
      name  = "BIGQUERY_DATASET"
      value = local.has_dataset ? local.dataset_id : ""
    }
  ]
}

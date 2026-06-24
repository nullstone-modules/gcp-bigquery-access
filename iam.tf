// When no dataset is connected, grant each role across the entire project.
resource "google_project_iam_member" "access" {
  for_each = local.has_dataset ? toset([]) : toset(var.access)

  project = local.project_id
  role    = "roles/bigquery.${each.value}"
  member  = "serviceAccount:${local.service_account_email}"
}

// When a dataset is connected, scope each grant to just that dataset.
resource "google_bigquery_dataset_iam_member" "access" {
  for_each = local.has_dataset ? toset(var.access) : toset([])

  project    = local.dataset_project
  dataset_id = local.dataset_id
  role       = "roles/bigquery.${each.value}"
  member     = "serviceAccount:${local.service_account_email}"
}

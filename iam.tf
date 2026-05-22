resource "google_project_iam_member" "access" {
  for_each = toset(var.access)

  project = local.project_id
  role    = "roles/bigquery.${each.value}"
  member  = "serviceAccount:${local.service_account_email}"
}

locals {
  access = toset(var.access)

  // BigQuery roles whose purpose is data access. These are the only predefined
  // roles that BigQuery supports on a dataset resource, so they are the only
  // ones eligible to be scoped to a connected dataset.
  dataset_scoped_roles = toset([
    "dataOwner",
    "dataEditor",
    "dataViewer",
    "metadataViewer",
    "filteredDataViewer",
  ])

  // When a dataset is connected, scope the data-access roles to just that dataset.
  dataset_roles = local.has_dataset ? setintersection(local.access, local.dataset_scoped_roles) : toset([])

  // Everything else is a project-level capability (e.g. jobUser, user) that
  // BigQuery does not support on a dataset resource, so it is always granted at
  // the project level. When no dataset is connected, this is the full access list.
  project_roles = setsubtract(local.access, local.dataset_roles)
}

// Project-level grants: project-only roles always, plus all roles when no dataset is connected.
resource "google_project_iam_member" "access" {
  for_each = local.project_roles

  project = local.project_id
  role    = "roles/bigquery.${each.value}"
  member  = "serviceAccount:${local.service_account_email}"
}

// Dataset-scoped grants: data-access roles narrowed to the connected dataset.
resource "google_bigquery_dataset_iam_member" "access" {
  for_each = local.dataset_roles

  project    = local.dataset_project
  dataset_id = local.dataset_id
  role       = "roles/bigquery.${each.value}"
  member     = "serviceAccount:${local.service_account_email}"
}

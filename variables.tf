variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  service_account_email = var.app_metadata["service_account_email"]
}

variable "access" {
  description = <<EOF
A list of BigQuery roles to grant to the app's service account.
Each item is interpolated as `roles/bigquery.<item>`, so provide only the suffix of the
predefined role (e.g. `dataViewer`, `jobUser`).

By default, every role is granted at the project level. When a `dataset` connection is
present, data-access roles (dataOwner, dataEditor, dataViewer, metadataViewer,
filteredDataViewer) are instead scoped to just that dataset. Project-level capabilities
that BigQuery does not support on a dataset resource (e.g. jobUser, user) remain granted
at the project level so that connecting a dataset never breaks them.

Valid values:
  - admin
  - connectionAdmin
  - connectionUser
  - dataEditor
  - dataOwner
  - dataViewer
  - filteredDataViewer
  - jobUser
  - metadataViewer
  - readSessionUser
  - resourceAdmin
  - resourceEditor
  - resourceViewer
  - studioAdmin
  - studioUser
  - user
EOF

  type = list(string)

  validation {
    condition = alltrue([
      for item in var.access : contains([
        "admin",
        "connectionAdmin",
        "connectionUser",
        "dataEditor",
        "dataOwner",
        "dataViewer",
        "filteredDataViewer",
        "jobUser",
        "metadataViewer",
        "readSessionUser",
        "resourceAdmin",
        "resourceEditor",
        "resourceViewer",
        "studioAdmin",
        "studioUser",
        "user",
      ], item)
    ])
    error_message = "Each item in access must be a valid BigQuery role suffix (interpolated as roles/bigquery.<item>). Valid values: admin, connectionAdmin, connectionUser, dataEditor, dataOwner, dataViewer, filteredDataViewer, jobUser, metadataViewer, readSessionUser, resourceAdmin, resourceEditor, resourceViewer, studioAdmin, studioUser, user."
  }
}

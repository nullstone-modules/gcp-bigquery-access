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
A list of BigQuery roles to grant to the app's service account at the project level.
Each item is interpolated as `roles/bigquery.<item>`, so provide only the suffix of the
predefined role (e.g. `dataViewer`, `jobUser`).

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

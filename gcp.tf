data "google_project" "this" {}

locals {
  project_id = data.google_project.this.project_id
}

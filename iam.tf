locals {
  members = [
    "serviceAccount:test1-account-id@<project-id>.iam.gserviceaccount.com",
    "serviceAccount:test3-account-id@<project-id>.iam.gserviceaccount.com",
  ]
  roles = [
    "roles/viewer",
    "roles/editor",
  ]

  # Nested loop over both lists, and flatten the result.
  members_roles = distinct(flatten([
    for member in local.members : [
      for role in local.roles : {
        role   = role
        member = member
      }
    ]
  ]))
}

resource "google_project_iam_member" "add_permissions" {
  for_each = { for entry in local.members_roles : "${entry.member}.${entry.role}" => entry }
  project  = <project-id>

  member = each.value.member
  role   = each.value.role
}

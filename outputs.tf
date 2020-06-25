output "repository_name" {
  description = "Name of the repository."
  value       = module.cicd_bootstrap.repository_name
}

output "repository_fullname" {
  description = "A string of the form 'orgname/reponame'."
  value       = module.cicd_bootstrap.repository_fullname
}

output "repository_http_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
  value       = module.cicd_bootstrap.repository_http_clone_url
}

output "repository_ssh_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via SSH."
  value       = module.cicd_bootstrap.repository_ssh_clone_url
}

output "tf_organization" {
  description = "Terraform organization"
  value       = var.tf_organization
}

output "tf_workspace" {
  description = "Terraform workspace"
  value       = var.tf_workspace
}

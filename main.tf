module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = var.github_token
  github_organization = var.github_organization

  repository_name = var.repository_name

  tf_organization = var.tf_organization
  tf_token        = var.tf_token
  tf_workspace    = var.tf_workspace
}

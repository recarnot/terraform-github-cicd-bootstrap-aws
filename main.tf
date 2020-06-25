module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  auto_deploy_workflow = false

  github_token        = var.github_token
  github_organization = var.github_organization

  repository_name          = var.repository_name
  repository_description   = var.repository_description
  repository_has_downloads = var.repository_has_downloads
  repository_has_issues    = var.repository_has_issues
  repository_has_projects  = var.repository_has_projects
  repository_has_wiki      = var.repository_has_wiki
  repository_homepage_url  = var.repository_homepage_url
  repository_private       = var.repository_private

  tf_hostname     = var.tf_hostname
  tf_organization = var.tf_organization
  tf_token        = var.tf_token
  tf_workspace    = var.tf_workspace

  security_check            = var.security_check
  security_bridgecrew_token = var.security_bridgecrew_token
}

#Creates GitHub secret to store AWS Access Key ID
resource "github_actions_secret" "access_key" {
  repository      = module.cicd_bootstrap.repository_name
  secret_name     = "AWS_ACCESS_KEY"
  plaintext_value = var.aws_access_key
}

#Creates GitHub secret to store AWS Secret Key
resource "github_actions_secret" "secret_key" {
  repository      = module.cicd_bootstrap.repository_name
  secret_name     = "AWS_SECRET_KEY"
  plaintext_value = var.aws_secret_key
}

#Creates GitHub secret to store AWS Access token
resource "github_actions_secret" "access_token" {
  repository      = module.cicd_bootstrap.repository_name
  secret_name     = "AWS_ACCESS_TOKEN"
  plaintext_value = var.aws_token
}

#Push provider file
resource "github_repository_file" "provider" {
  repository = module.cicd_bootstrap.repository_name
  file       = "provider.tf"
  content    = templatefile("${path.module}/template/provider.tpl", {})

  depends_on = [module.cicd_bootstrap]
}

locals {
  checkov_step    = file("${path.module}/template/checkov.tpl")
  bridgecrew_step = file("${path.module}/template/bridgecrew.tpl")
  security_step   = var.security_check ? length(var.security_bridgecrew_token) > 0 ? local.bridgecrew_step : local.checkov_step : ""
  vars            = templatefile("${path.module}/template/vars.tpl", { AWS_REGION : var.aws_region })
}

#And then update/push the GitHub workflow file
resource "github_repository_file" "workflow" {
  repository = module.cicd_bootstrap.repository_name
  file       = ".github/workflows/terraform_deploy.yml"

  content = templatefile("${path.module}/template/terraform_deploy.yml",
    {
      SECURITY_CHECK_STEP : local.security_step,
      TF_ORGANIZATION : var.tf_organization,
      TF_WORKSPACE : var.tf_workspace
      TF_VARS : local.vars
    }
  )

  depends_on = [github_repository_file.provider]
}



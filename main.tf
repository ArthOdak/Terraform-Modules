provider "github" {
}
module "git" {
  source = "git::https://github.com/ArthOdak/Terraform-Modules.git"
}

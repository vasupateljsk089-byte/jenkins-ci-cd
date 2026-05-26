terraform {
  backend "s3" {
    bucket         = "3tier-jenkins-tf-state-bucket"  
    key            = "devsecops/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
  }
}

# S3 Remote Backend Configuration
#
# Initial setup instructions:
# 1. First run: `terraform init` (without backend configured)
# 2. Apply the configuration: `terraform apply`
# 3. Create an S3 bucket for Terraform state manually or via a separate Terraform run
# 4. Uncomment the backend block below
# 5. Run: `terraform init -migrate-state` to migrate local state to S3
#
# This approach ensures you have the state bucket created before attempting
# to use it as a backend.

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-name"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

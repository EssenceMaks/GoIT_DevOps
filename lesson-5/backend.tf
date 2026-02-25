# Uncomment this block AFTER creating the bucket using `terraform apply -target=module.s3_backend`
# Then run `terraform init -migrate-state`

 # terraform {
#    backend "s3" {
#      bucket         = "lesson-7-tf-state-eu-central-1" # Must match module.s3_backend.bucket_name
#      key            = "lesson-7/terraform.tfstate"
#      region         = "eu-central-1"
#      dynamodb_table = "lesson-7-tf-locks"       # Must match module.s3_backend.dynamodb_table_name
#      encrypt        = true
#    }
# }

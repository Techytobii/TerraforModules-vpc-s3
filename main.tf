module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}
module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-tf-project-bucket"
}

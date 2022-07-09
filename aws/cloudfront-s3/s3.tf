module "s3_cloudfront" {
  source               = "./main-module"
  bucket_name          = "dodonots"
  tags                 = {
    environment= "development"
    provision= "terraform"
  }
}

#----
#CODEBUILD
#----

resource "aws_s3_bucket" "codebuild" {
  bucket        = "${module.this.id}-codebuild"
  force_destroy = var.cicd_log_bucket_force_destroy

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-codebuild"
    }
  )
}

resource "aws_s3_bucket_acl" "codebuild" {
  bucket = aws_s3_bucket.codebuild.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "codebuild" {
  bucket = aws_s3_bucket.codebuild.id
  versioning_configuration {
    status = "Enabled"
  }
}

#----
#CODEPIPELINE
#----

resource "aws_s3_bucket" "codepipeline" {
  bucket        = "${module.this.id}-artifacts"
  force_destroy = var.cicd_log_bucket_force_destroy

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-artifacts"
    }
  )
}

resource "aws_s3_bucket_acl" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.codepipeline.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_lifecycle_configuration" "cicd" {

#   rule {
#     id     = "build-log"
#     status = "Enabled"

#     filter {
#       prefix = "build-log/"
#     }

#     noncurrent_version_expiration {
#       noncurrent_days           = 30
#       newer_noncurrent_versions = 1
#     }

#     noncurrent_version_transition {
#       noncurrent_days           = 30
#       newer_noncurrent_versions = 1
#       storage_class             = "STANDARD_IA"
#     }
#   }
# }

resource "aws_codebuild_project" "default" {
  name         = module.this.id
  description  = "${module.this.id}-project"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${var.buildspec_path}")
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "environment"
      value = module.this.environment
    }

    environment_variable {
      name  = "namespace"
      value = module.this.namespace
    }

  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  logs_config {

    dynamic "cloudwatch_logs" {
      for_each = var.codebuild_cloudwatch_logs == "true" ? [var.codebuild_cloudwatch_logs] : []

      content {
        group_name  = module.this.id
        stream_name = "logstream"
      }
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild.id}/build-log"
    }
  }

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}"
    }
  )
}










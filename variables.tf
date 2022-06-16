
variable "cicd_log_bucket_force_destroy" {
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)"
  type        = bool
  default     = false
}

#-----
#CODEBUILD
#-----

variable "buildspec_path" {
  description = "Buildspect file path. It can either be a path to a local file path leveraging the file() built-in."
  type        = string
  default     = null
}

variable "codebuild_cloudwatch_logs" {
  description = "Enable CloudWathach log for CodeBuild. Defaul = false"
  default     = false
}

variable "additional_codebuild_iam_permisssions" {
  description = "Additional permissions to attach to CodeBuild IAM policy. Ex: [\"ecs:*\", \"cloudwatch:*\"] "
  type        = list(any)
  default     = []
}


#-----
#CODEPIPELINE
#-----

variable "additional_codepipeline_iam_permisssions" {
  description = "Additional permissions to attach to CodePipeline IAM policy. Ex: [\"ecs:*\", \"cloudwatch:*\"] "
  type        = list(any)
  default     = []
}

# variable "codestar_connection_arn" {
#   description = "CodeStar connection ARN for CodePipeline."
#   type        = string
# }

variable "deploy_provider" {
  description = "CodePipeline Deployment provider. Ex: ECS, S3,.."
  type        = string
}

variable "deploy_config" {
  description = <<EOF
  "CodePipeline Deployment configuration"
   ex (ECS):
  {
    ClusterName = test_cluster
    ServiceName = test_service
  }
  ex (S3):
  {
   BucketName = "test_bucket"
   Extract = "true"
   ObjectKey = "project1"
 }
  EOF
  type        = map(any)

}
#---
#Deploy to ECS
#---

variable "github_repository" {
  description = "GitHub repository name. Ex: studiographen/tf-module"
  type        = string
}

variable "github_branch" {
  description = "GitHub repository branch to use as source"
  type        = string
}

# Purpose:
To setup CodeBuild, CodePipeline CICD.
                                                 

## Variable Inputs:

REQUIRED:

- namespace                  (ex: project name)
- environment                (ex: dev/prod)
- buildspec_path             Buildspec.yml location in your local machine.
- github_repository          GitHub repository name (ex: studiographen/tf-module).
- github_branch              (ex: main)
- deploy_provider            (ex: ECS, S3)

deploy_config exapmple for deploy proiver (ECS)
- deploy_config = {
    ClusterName = "sg-dev"
    ServiceName = module.ecs-td-service.ecs_serivce_name
  }

deploy_config example for deploy proiver (S3)
- deploy_config = {
    BucketName = module.cdn_cloudfront_s3.s3_bucket
    Extract    = "true"
  }

OPTIONAL:

- codebuild_cloudwatch_logs:        (ex: true). Default = false.

- cb_log_bucket_force_destroy:      Delete all objects from CodeBuild log bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)". Default = false.

- cp_artifact_bucket_force_destroy: Delete all objects from CodePipeline Artifact bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)". Default = false.

- codebuild_cloudwatch_logs:                Enable CloudWathach log for CodeBuild. Defaul = false.
                                            Default     = false.

- additional_codebuild_iam_permisssions:    Additional permissions to attach to CodeBuild IAM policy.
                                            ex: ["ecs:*", "cloudwatch:*"]

- additional_codepipeline_iam_permisssions: Additional permissions to attach to CodePipeline IAM policy.                                     ex: ["ecs:*", "cloudwatch:*"]

## Resources created:

- CodeBuild Project
- CodePipeline
- S3 bucket    [2]                    
- IAM policy CodeBuild role
- IAM policy CodePipeline role                                  

## Resources naming convention:

- CodeBuild Project & CodePipeline: namespace-stage
    ex: sg-dev
- CodeStar Connection: namespace-environment-github
    ex: sg-dev-github
- IAM Role: CodeBuild & Codepipeline: "namepsace-environment-codebuild-role", "namespace-environment-codepipeline-role" 
    ex: sg-dev-codebuild-role, sg-dev-codepipeline-role
- IAM Policy: CodeBuild & Codepipeline: "namepsace-environment-codebuild-policy","namespace-environment-codepipeline-policy"
    ex: sg-dev-codebuild-policy, sg-dev-codepipeline-policy.
- S3 bucket:
  CodeBuild log bucket: namespace-environment-cb-log
    ex: sg-dev-cb-log
  CodePipeline Artifact bucket: namespace-environment-cp-artifact"
    ex: sg-dev-cp-artifact

# Steps to create the resources

1. Call the "cicd" module from your tf code.
3. Specifying Variable Inputs along the module call.
4. Apply.

Example:

```
provider "aws" {
  region = "us-east-1"

}

module "cicd-backend" {
  source      = "git@github.com:studiographene/tf-modules.git//cicd"
  namespace   = "sg"
  environment = "dev"

  #---
  #CODEBUILD
  #---
  codebuild_cloudwatch_logs = true
  buildspec_path            = file("./buildspec.yml")

  #---
  #CODEPIPELINE
  #---

  github_repository = "studiographene/sample-backend"
  github_branch     = "main"
  deploy_provider   = "ECS"

  deploy_config = {
    ClusterName = "sg-dev"
    ServiceName = module.ecs-td-service.ecs_serivce_name
  }
}

```

3. From terminal: 

```
terraform init
```
```
terraform plan
```
```
terraform apply
```

4. Activate CodeStar connection:
    GitHub connection is created by Terraform in pending stage.
    Goto https://us-east-1.console.aws.amazon.com/codesuite/settings/connections and click on "Update connection" to complete the connection
    by logging into GitHub account.

!! You have successfully setup CICD components as per your specification !!

---


##OUTPUTS

```
```

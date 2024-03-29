# AWS Lambda 

Simplifies the deployment of an AWS Lambda function by pre-configurating 
basic IAM roles, enabling X-Ray for monitoring, and setting up log groups. 
It also provides flexibility for most common configuration requirements.

## Usage

```hcl
module "aws-lambda" {
  source            = "glenngillen/lambda/aws"
  version           = "1.0.11"
  name              = "my_function"
  filename          = "path/to/my/lambda.zip"
  handler           = "ruby2.7"
  runtime           = "index.handler"
  source_code_hash  = "hash-to-track-if-function-should-be-updated"
}
```

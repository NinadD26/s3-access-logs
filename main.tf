# Provider configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# Specify the existing S3 bucket name

# Configure server-side encryption for the existing bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "existing_bucket_encryption" {
  bucket = var.existing_bucket_name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "arn:aws:kms:us-east-1:381492211326:alias/s3-bucket-key" # Replace with your existing KMS key ARN
    }
  }
}

# Enable versioning for the existing bucket
resource "aws_s3_bucket_versioning" "existing_bucket_versioning" {
  bucket = var.existing_bucket_name
  versioning_configuration {
    status = "Enabled"
  }

}

# Configure S3 bucket logging for the existing bucket
resource "aws_s3_bucket_logging" "existing_bucket_logging" {
  bucket        = var.existing_bucket_name
  target_bucket = "comon-access-log-bucket" # Bucket for storing access logs
  target_prefix = "logs/"
}

# Configure secure transport policy for the existing bucket
resource "aws_s3_bucket_policy" "existing_bucket_policy" {
  bucket = var.existing_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = "arn:aws:s3:::${var.existing_bucket_name}/*" # Use bucket name for policy
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}




# provider "aws" {
#   region = "us-east-1"
# }
# resource "aws_s3_bucket" "bucket1" {
#   bucket = "flowlog-bckt"
# #   acl    = "private"
#   # Enable KMS encryption
# #   server_side_encryption_configuration {
# #     rule {
# #       apply_server_side_encryption_by_default {
# #         sse_algorithm     = "aws:kms"
# #         kms_master_key_id = "arn:aws:kms:us-east-1:381492211326:alias/s3-bucket-key" # Replace with your existing KMS key ARN
# #       }
# #     }
# #   }

#   # Enable bucket versioning
# #   versioning {
# #     enabled = true
# #   }

# }

# resource "aws_s3_bucket_acl" "bucket1_acl" {
#   bucket = aws_s3_bucket.bucket1.id
#   acl    = "private"  # Set the desired ACL (private, public-read, etc.)
# }


# resource "aws_s3_bucket_versioning" "bucket1_versioning" {
#   bucket = aws_s3_bucket.bucket1.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "bucket1_encryption" {
#   bucket = aws_s3_bucket.bucket1.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "aws:kms"
#       kms_master_key_id      = "arn:aws:kms:us-east-1:381492211326:alias/s3-bucket-key"  
#     }
#   }
# }

# resource "aws_s3_bucket_logging" "bucket1_logging" {

#   bucket = aws_s3_bucket.bucket1.id

#   target_bucket = "comon-access-log-bucket" # Bucket for storing access logs

#   target_prefix = "logs/"

# }



# resource "aws_s3_bucket_policy" "bucket1_policy" {

#   bucket = aws_s3_bucket.bucket1.id



#   policy = jsonencode({

#     Version = "2012-10-17"

#     Statement = [

#       {

#         Effect = "Deny"

#         Principal = "*"

#         Action = "s3:*"

#         Resource = "arn:aws:s3:::${aws_s3_bucket.bucket1.bucket}/*" # Use bucket name for policy

#         Condition = {

#           Bool = {

#             "aws:SecureTransport" = "false"

#           }

#         }

#       }

#     ]

#   })

# }


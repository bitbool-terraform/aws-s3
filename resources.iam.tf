resource "aws_iam_policy" "write" {

  name   = format("s3-%s-write",var.bucket_name)
  path   = "/"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [         
        {
          "Sid": "S3FullAccess",
          "Action": [
            "s3:Get*",
            "s3:List*",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject"
          ],
          "Effect": "Allow",
          "Resource": ["${module.s3_bucket.s3_bucket_arn}","${module.s3_bucket.s3_bucket_arn}/*"]
        }
      ]
    })
}

resource "aws_iam_policy" "read" {

  name   = format("s3-%s-read",var.bucket_name)
  path   = "/"
  policy = jsonencode({         
      "Version": "2012-10-17",
      "Statement": [  
        {
          "Sid": "S3ReadOnlyAccess",
          "Action": [
            "s3:Get*",
            "s3:List*"
          ],
          "Effect": "Allow",
          "Resource": ["${module.s3_bucket.s3_bucket_arn}","${module.s3_bucket.s3_bucket_arn}/*"]
        }                       
      ]
    })

}
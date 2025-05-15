output "bucket" {
  value = module.s3_bucket
}


output "policy_write" {
  value = aws_iam_policy.write.arn
}

output "policy_read" {
  value = aws_iam_policy.read.arn
}
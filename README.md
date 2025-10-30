# Terraform – AWS S3 Static Website Hosting

## Project Overview
This Terraform project creates a **static website hosted on Amazon S3**.

It provisions:
- An S3 bucket with **Static Website Hosting** enabled  
- A public access policy for `s3:GetObject`  
- Automatic upload of all files from the local `site/` directory  

After deployment, the website is available via a public HTTP endpoint such as:

```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```

---

## Requirements
- Terraform v1.6 or newer  
- AWS account with permissions to create S3 resources  
- Configured AWS credentials (`aws configure`)

---

## Terraform Resources
| Resource | Description |
|-----------|-------------|
| `aws_s3_bucket` | Creates the S3 bucket |
| `aws_s3_bucket_ownership_controls` | Enforces object ownership by the bucket owner |
| `aws_s3_bucket_public_access_block` | Allows public bucket policy |
| `aws_s3_bucket_website_configuration` | Enables static website hosting |
| `aws_s3_bucket_policy` | Grants public read access (`s3:GetObject`) |
| `aws_s3_object` | Uploads all files from the local `site/` directory |
| `data.aws_iam_policy_document` | Generates the JSON for the public access policy |

---

## Notes
- The S3 website endpoint uses **HTTP** only.  
- Each uploaded file receives an automatically detected `Content-Type` (HTML, CSS, JS, PNG, etc.).  
- The project is intended as a base for simple static site hosting and Terraform IaC demonstrations.

---

## Cleanup
To remove all created AWS resources:
```bash
terraform destroy
```

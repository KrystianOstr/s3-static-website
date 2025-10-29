locals {
  tags = {
    version = "1.0"
    project = "s3-static-website"
  }

  site_path = "${path.module}/site"
  files     = fileset(local.site_path, "**")
}
locals {
  s3_origin_id = "cloudfrontS3Origin"
}

resource "aws_cloudfront_origin_access_identity" "multi_poster_website_origin_access_identity" {
  comment = "Multi Poster website OAI"
}

resource "aws_cloudfront_distribution" "multi_poster_website_distribution" {
  origin {
    domain_name = aws_s3_bucket.multi_poster_website_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.multi_poster_website_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CloudFront distribution"
  default_root_object = "index.html"

  aliases = ["mmp.velizarkacharov.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:937808942071:certificate/537c9eb7-6390-4866-85bb-136cacda2351"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  lifecycle {
   prevent_destroy = true
  }
}
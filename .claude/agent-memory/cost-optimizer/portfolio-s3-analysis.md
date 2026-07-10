---
name: portfolio-s3-analysis
description: S3 bucket cost optimization for portfolio site static content
metadata:
  type: project
---

## Portfolio Site S3 Configuration

**Current Setup**: STANDARD storage class, no versioning, no lifecycle policies, CloudFront OAC access only

### Storage Class Analysis

**Current**: S3 STANDARD
- Cost: ~$0.023 per GB/month (US regions, higher in ap-south-1)
- Appropriate for: Frequently accessed content

**Assessment**: STANDARD is correct for active portfolio site content served via CloudFront. No change needed.

**Why NOT Intelligent-Tiering**: 
- Intelligent-Tiering adds minimum $0.0025/GB overhead
- For a portfolio site (typically <100 MB), overhead ($0.25/month) exceeds any benefit
- Only cost-effective if bucket grows to multi-GB and access becomes infrequent

### Lifecycle Policy Opportunities

**Current**: None configured

**Recommended Addition** (if versioning is enabled):
```hcl
resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
```

**Impact**: Minimal for portfolio site (typically small files), but required if versioning is enabled
- Prevents unbounded storage costs from version accumulation
- Estimated savings: $1-5/month IF versioning is enabled and many versions accumulate

### Good Decisions Already Made

- No MFA Delete configured (unnecessary cost complexity for portfolio)
- No access logging enabled (avoids extra S3 API calls and storage)
- CloudFront as only access method (prevents direct S3 costs)
- Public access blocked (security + prevents unexpected charges)

### Data Transfer Costs

All user traffic flows through CloudFront, not S3:
- CloudFront → Origin (S3) transfer: $0.020/GB (mostly free tier-adjacent traffic)
- User → CloudFront: Included in CloudFront pricing (PriceClass dependent)

**Why this is good**: S3 data transfer costs are minimal because content is cached at CloudFront edge locations.


---
name: recurring-tf-findings
description: Baseline gaps repeatedly found in this repo's terraform/ S3+CloudFront stack, to check whether they've been fixed in later audits
metadata:
  type: project
---

First full audit on 2026-07-10 of `terraform/main.tf` (S3 + CloudFront + OAC static
site) found the bucket/policy/OAC wiring itself was done correctly (public access
block on, OAC — not legacy OAI, bucket policy scoped to a specific distribution ARN
via `AWS:SourceArn`, no hardcoded account IDs/ARNs — account ID pulled from
`data.aws_caller_identity.current`). Gaps found, to re-check in future audits before
re-reporting:

- No `aws_s3_bucket_server_side_encryption_configuration` — encryption at rest missing.
- No `aws_cloudfront_response_headers_policy` attached to the default cache
  behavior — no CSP/X-Frame-Options/HSTS security headers.
- No `aws_s3_bucket_logging` and no CloudFront `logging_config` block — no access
  logs for either the bucket or the distribution.
- No `aws_s3_bucket_versioning` on the website bucket.
- No `aws:SecureTransport=false` explicit Deny statement in the bucket policy
  (defense-in-depth; not exploitable today since only the CloudFront service
  principal is allowed, but recommended by AWS Security Hub / CIS benchmarks).
- No `aws_s3_bucket_ownership_controls` (`BucketOwnerEnforced`) to fully disable ACLs.
- No WAFv2 web ACL associated with the CloudFront distribution (lower priority for a
  static portfolio site — cost/complexity tradeoff, flagged as LOW/optional).
- Terraform state backend still commented out (see [[project_portfolio_infra_scope]]).

**Why:** these are the kind of findings that repeat verbatim across audits if the user
hasn't gotten to remediation yet — track here so future reviews can quickly diff
"still open" vs "fixed" instead of re-discovering from scratch.

**How to apply:** In future audits, check each item above against current
`terraform/main.tf` before including it in the report. Drop items that are fixed;
keep items still open. Add newly discovered gap patterns here as they show up.

---
name: project-portfolio-infra-scope
description: Current scope/shape of terraform/ for this portfolio site repo — no IAM/OIDC resources exist yet, backend is intentionally commented out pending bootstrap
metadata:
  type: project
---

As of 2026-07-10, `terraform/` contains only 5 `.tf` files: `main.tf`, `variables.tf`,
`outputs.tf`, `providers.tf`, `backend.tf`. The stack is a static HTML/CSS portfolio
site (no JS, no build step — see root CLAUDE.md) served via S3 (private, OAC-fronted)
+ CloudFront. There are no `.github/workflows` and no IAM/OIDC resources anywhere in
the repo yet.

**Why this matters:** The security checklist includes IAM least-privilege, wildcard
actions/resources, and OIDC trust-policy scoping — none of these are currently
applicable because no IAM resources exist in `terraform/`. Don't report "missing IAM
review" as a finding; instead note it as informational/out-of-scope until CI/CD IAM
roles are actually added.

**How to apply:** Before flagging IAM/OIDC issues in future audits, re-grep for
`iam|oidc|role|policy` across `terraform/` and `.github/` — if resources have since
been added there, the checklist items become active and should be fully enforced
(no wildcards, repo/branch-scoped OIDC trust conditions, least privilege).

Also: `terraform/backend.tf` has an S3 remote backend block fully written but
commented out, with instructions to bootstrap the state bucket manually first, then
uncomment and run `terraform init -migrate-state`. This is intentional bootstrapping,
not an oversight — but state is currently local, unencrypted, and unlocked, which is
still worth flagging as MEDIUM until migrated. Check whether it's been uncommented in
future reviews before repeating this finding. See [[recurring_tf_findings]].

---
name: portfolio-cloudfront-analysis
description: CloudFront distribution cost optimization opportunities for portfolio site
metadata:
  type: project
---

## Portfolio Site CloudFront Configuration

**Current Setup**: PriceClass_200, Managed-CachingOptimized policy, CloudFront default certificate

### High-Priority Optimization

**PriceClass Downgrade (PriceClass_200 → PriceClass_100)**
- Current: PriceClass_200 (includes 200+ edge locations across US, Europe, Asia, Middle East, Africa)
- Recommended: PriceClass_100 (US, Canada, Europe only)
- Reasoning: Portfolio site is static content with no indication of global audience. PriceClass_100 serves 90% of internet users at 30-50% lower cost
- Estimated Impact: If current data transfer is $100/month, saves $30-50/month ($360-600/year)

### Caching Configuration

Currently uses AWS-managed "Caching Optimized" policy with 300-second TTL for 404 errors. This is appropriate for static HTML/CSS.

**Why current setup is good:**
- Managed policy ensures best practices
- Error caching is set to 5 minutes (prevents cache storms)
- GET/HEAD methods cached appropriately
- No query string complexity

No TTL optimization needed — defaults are solid for portfolio sites.


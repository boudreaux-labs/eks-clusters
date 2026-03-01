# EKS Clusters — Terraform

## Module Versions (pin these)
- `terraform-aws-modules/eks/aws` → `21.15.1`
- `terraform-aws-modules/vpc/aws` → `6.0`

## Key Variables
- `region` = `us-east-1`
- `cluster_name` = `eks-dev`
- `vpc_cidr` = `10.0.0.0/16`
- `kubernetes_version` = `1.31`

## File Layout
| File | Purpose |
|------|---------|
| `versions.tf` | Provider versions, Terraform backend (GitLab HTTP) |
| `providers.tf` | AWS, Kubernetes, Helm providers |
| `variables.tf` | Input variable declarations |
| `data.tf` | Data sources (AZs, etc.) |
| `networking.tf` | VPC — 3 private + 3 public subnets, single NAT |
| `eks.tf` | EKS cluster + managed node group (SPOT) |
| `irsa.tf` | IRSA roles for VPC CNI, EBS CSI, LBC, External DNS |
| `eks_addons.tf` | Helm releases: AWS LBC, External DNS |
| `argo.tf` | ArgoCD Helm release + Ingress |

## Conventions
- Every new AWS service account gets an IRSA role — never use node IAM role for app permissions
- Subnet tags required for K8s discovery: `kubernetes.io/role/internal-elb` and `kubernetes.io/role/elb`
- SPOT instances only in dev; use ON_DEMAND for any production-like env
- Single NAT gateway in dev (cost); multi-NAT for prod
- New environments follow the `eks-clusters/<env>/` pattern

## Terraform Workflow
```bash
# Validate
terraform init && terraform validate

# Plan (CI does this automatically on MR)
terraform plan -var-file=<env>.tfvars

# Apply — manual gate in GitLab CI only
# Do not apply locally unless explicitly debugging
```

## State Backend
GitLab HTTP backend — do not reconfigure without updating `.gitlab-ci.yml` to match.

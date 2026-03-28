# eks-clusters

Terraform for the Boudreaux Labs EKS platform. Deploys a cost-optimized dev cluster on AWS with full GitOps delivery via ArgoCD.

## What this provisions

| Component | Details |
|---|---|
| EKS cluster | v1.31, SPOT t3.large/t3a.large, 1–2 nodes |
| VPC | 3 AZs, single NAT gateway (cost-optimized) |
| IAM / IRSA | OIDC-backed service account roles for each addon |
| AWS Load Balancer Controller | Provisions ALBs from Ingress resources |
| External DNS | Writes Route53 records for annotated services |
| EBS CSI Driver | Persistent volume support |
| ArgoCD | v7.7.3, accessible at `argocd-dev.boudreauxlabs.com` |

## Pipeline

GitHub Actions — no manual `terraform` commands after initial state setup.

| Job | Trigger | Gate |
|---|---|---|
| `plan` | Push to `main` | Auto |
| `apply` | After plan | Manual (`dev` environment) |
| `destroy` | `workflow_dispatch` | Manual (`dev` environment) |

Auth: GitHub Actions OIDC → `sts:AssumeRoleWithWebIdentity` → `boudreaux-admin` role. No static credentials anywhere.

Terraform state: `s3://boudreaux-labs-terraform-state` / key `eks-clusters/dev/terraform.tfstate`, DynamoDB locking.

## Repository variables required

Set these in GitHub → Settings → Secrets and variables → Actions:

| Variable | Value |
|---|---|
| `ROLE_ARN` | ARN of the `boudreaux-admin` IAM role |
| `TF_VAR_acm_certificate_arn` | ARN of the ACM cert for `*.boudreauxlabs.com` |

## Operating model

- **Ephemeral** — cluster is destroyed at end of each working session; apply/destroy are cheap one-click operations
- **Zero manual steps** — no `kubectl` or console changes after apply; everything declarative
- **GitOps delivery** — ArgoCD pulls app state from the [gitops](https://github.com/boudreaux-labs/gitops) repo; pipelines never push to the cluster

## Claude Code

This repo is developed with Claude Code. A security auditor sub-agent (`.claude/agents/security-auditor.md`) runs automatically on every file change via a PostToolUse hook, triaging IAM, Terraform, k8s manifests, and pipeline configs.

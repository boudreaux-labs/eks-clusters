FROM hashicorp/terraform:1.10
RUN apk add --no-cache aws-cli jq

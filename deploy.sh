#!/bin/bash
# Deploy xSyna Central to Cloudflare Workers
# Usage: ./deploy.sh <CLOUDFLARE_API_TOKEN> <CLOUDFLARE_ACCOUNT_ID>

set -e

TOKEN=$1
ACCOUNT_ID=$2

if [ -z "$TOKEN" ] || [ -z "$ACCOUNT_ID" ]; then
  echo "Usage: ./deploy.sh <CLOUDFLARE_API_TOKEN> <CLOUDFLARE_ACCOUNT_ID>"
  echo ""
  echo "Get your API token from: https://dash.cloudflare.com/profile/api-tokens"
  echo "Get your Account ID from: https://dash.cloudflare.com (right sidebar)"
  exit 1
fi

echo "Installing dependencies..."
npm ci

echo "Building..."
NITRO_PRESET=cloudflare-module npm run build

echo "Deploying to Cloudflare..."
npx wrangler deploy dist/server/index.mjs \
  --name synapse-collective-hub \
  --compatibility-date 2025-01-01 \
  --compatibility-flags nodejs_compat \
  --routes '{"pattern":"central.xsyna.de","custom_domain":true}' \
  --config dist/server/wrangler.json

echo "Deployed!"

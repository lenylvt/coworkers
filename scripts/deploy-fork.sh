#!/bin/sh
# Deploy command for the Cloudflare git build of this fork. cloudflare.config.ts
# stays identical to upstream; the custom domain (not supported by the deploy
# file) is added to the build's working copy only, so `cf deploy` sees no drift.
set -e
node -e '
const fs = require("fs")
const { domain } = JSON.parse(fs.readFileSync("coworkers.deploy.json", "utf8"))
if (!domain) process.exit(0)
const s = fs.readFileSync("cloudflare.config.ts", "utf8")
const t = s.replace("previewUrls: false,", `previewUrls: false,\n    domains: [${JSON.stringify(domain)}],`)
if (t === s) throw new Error("previewUrls anchor not found in cloudflare.config.ts")
fs.writeFileSync("cloudflare.config.ts", t)
'
pnpm run deploy

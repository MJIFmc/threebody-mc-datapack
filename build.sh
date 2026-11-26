#!/usr/bin/env bash
# 构建数据包 zip： dist/threebody.zip
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p dist
rm -f dist/threebody.zip
if command -v zip >/dev/null 2>&1; then
  zip -qr dist/threebody.zip pack.mcmeta data
else
  python3 - <<'PY'
import zipfile, os
with zipfile.ZipFile("dist/threebody.zip", "w", zipfile.ZIP_DEFLATED) as z:
    for root, dirs, files in os.walk("data"):
        for f in files:
            p = os.path.join(root, f)
            z.write(p, os.path.relpath(p, "."))
    z.write("pack.mcmeta", "pack.mcmeta")
PY
fi
echo "built dist/threebody.zip"

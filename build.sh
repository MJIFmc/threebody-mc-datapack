#!/usr/bin/env bash
# 多版本构建：python3 build.py [--only 1.21.3 ...]
set -euo pipefail
cd "$(dirname "$0")"
if command -v python3 >/dev/null 2>&1; then
  exec python3 build.py "$@"
elif command -v python >/dev/null 2>&1; then
  exec python build.py "$@"
else
  echo "需要 Python 3 来构建多版本 zip；也可直接使用仓库 dist/ 下的现成 zip。" >&2
  exit 1
fi

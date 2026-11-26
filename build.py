#!/usr/bin/env python3
"""构建多版本数据包 zip -> dist/.

用法:
    python3 build.py                 # 构建 versions.json 里全部版本
    python3 build.py --only 1.21.3   # 只构建指定版本
    python3 build.py --list          # 列出目标
"""
import argparse
import hashlib
import json
import os
import shutil
import sys
import zipfile

ROOT = os.path.dirname(os.path.abspath(__file__))
BUILD = os.path.join(ROOT, ".build")
DIST = os.path.join(ROOT, "dist")
PACK = "threebody"
FIXED_DATE = (2026, 1, 1, 0, 0, 0)


def load_versions():
    with open(os.path.join(ROOT, "versions.json"), encoding="utf-8") as f:
        return json.load(f)


def copy_merge(src, dst):
    """把 src 目录内容合并进 dst（dst 已有文件保留，src 同名文件覆盖）。"""
    if not os.path.isdir(src):
        raise SystemExit("缺少目录: " + src)
    for name in os.listdir(src):
        s = os.path.join(src, name)
        d = os.path.join(dst, name)
        if os.path.isdir(s):
            os.makedirs(d, exist_ok=True)
            copy_merge(s, d)
        else:
            os.makedirs(os.path.dirname(d), exist_ok=True)
            shutil.copy2(s, d)


def merge_overrides(version, staging):
    ov = os.path.join(ROOT, "overrides", version)
    if os.path.isdir(ov):
        copy_merge(ov, staging)


def legacy_layout(staging):
    """1.20.1 及更老的数据包目录: function -> functions, tags/function -> tags/functions"""
    data = os.path.join(staging, "data")
    if not os.path.isdir(data):
        return
    for ns in os.listdir(data):
        nsp = os.path.join(data, ns)
        if not os.path.isdir(nsp):
            continue
        f = os.path.join(nsp, "function")
        if os.path.isdir(f):
            os.rename(f, os.path.join(nsp, "functions"))
        tf = os.path.join(nsp, "tags", "function")
        if os.path.isdir(tf):
            os.rename(tf, os.path.join(nsp, "tags", "functions"))


def zip_dir(src_dir, out_path):
    """确定性 zip（固定时间戳），根目录为 pack.mcmeta + data/。"""
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    if os.path.exists(out_path):
        os.remove(out_path)
    entries = []
    for root, dirs, files in os.walk(src_dir):
        dirs.sort()
        for f in sorted(files):
            p = os.path.join(root, f)
            arc = os.path.relpath(p, src_dir).replace(os.sep, "/")
            entries.append((arc, p))
    with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED) as z:
        for arc, p in entries:
            zi = zipfile.ZipInfo(arc, date_time=FIXED_DATE)
            zi.external_attr = 0o644 << 16
            zi.compress_type = zipfile.ZIP_DEFLATED
            with open(p, "rb") as fh:
                z.writestr(zi, fh.read())
    return out_path


def build_target(name, cfg, meta, out_name):
    staging = os.path.join(BUILD, name)
    shutil.rmtree(staging, ignore_errors=True)
    os.makedirs(staging)
    source = cfg.get("source")
    if source:
        copy_merge(os.path.join(ROOT, source), staging)
    else:
        copy_merge(os.path.join(ROOT, "data"), os.path.join(staging, "data"))
        merge_overrides(name, staging)
    if cfg.get("layout") == "plural":
        legacy_layout(staging)
    pack = dict(cfg.get("pack", {}))
    pack["description"] = cfg.get("description", meta.get("description", PACK) + " · MC " + name)
    mcmeta = {"pack": pack}
    with open(os.path.join(staging, "pack.mcmeta"), "w", encoding="utf-8") as f:
        json.dump(mcmeta, f, indent=2, ensure_ascii=False)
        f.write("\n")
    out = os.path.join(DIST, out_name.replace("{version}", name))
    zip_dir(staging, out)
    h = hashlib.sha256(open(out, "rb").read()).hexdigest()
    print("  %-14s -> dist/%-32s %8d B  sha256=%s" % (name, os.path.basename(out), os.path.getsize(out), h[:16]))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", default=None, help="只构建这些版本")
    ap.add_argument("--list", action="store_true")
    args = ap.parse_args()
    versions = load_versions()
    targets = versions["targets"]
    if args.list:
        for name in targets:
            print(name)
        return
    names = args.only or list(targets)
    os.makedirs(DIST, exist_ok=True)
    print("构建 %s（%d 个版本）" % (PACK, len(names)))
    built = []
    for name in names:
        if name not in targets:
            raise SystemExit("未知版本: " + name)
        cfg = targets[name]
        built.append(build_target(name, cfg, versions, "threebody-{version}.zip"))
    # 汇总校验和
    sums = os.path.join(DIST, "SHA256SUMS.txt")
    lines = []
    for p in sorted(built):
        lines.append(hashlib.sha256(open(p, "rb").read()).hexdigest() + "  " + os.path.basename(p))
    with open(sums, "w") as f:
        f.write("\n".join(lines) + "\n")
    print("完成: %d 个 zip + dist/SHA256SUMS.txt" % len(built))


if __name__ == "__main__":
    main()

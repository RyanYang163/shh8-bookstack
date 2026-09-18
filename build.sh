#!/bin/bash
# ============================================================
# Docker 应用打包 —— TOS 7
# 产物：<appid>.tar.gz，根层恰好 4 个文件
# ============================================================
set -e
APPID="$(python3 -c "import json;print(json.load(open('config.ini'))['id'])")"
VERSION="$(python3 -c "import json;print(json.load(open('config.ini'))['version'])")"
OUT="build/output"

echo "=== Building ${APPID} v${VERSION} (docker) ==="

# ---- 前置校验 ----
python3 - <<'PY'
import json, sys, re
c = json.load(open('config.ini'))
errs = []
if 'type' in c and 'open_path' in c:
    errs.append("type 与 open_path 互斥，不能同时出现")
if c.get('application_type') != 'docker':
    errs.append("application_type 必须为 docker")
if 'DockerEngine' not in c.get('depend', []):
    errs.append("Docker 应用 depend 必须包含 DockerEngine")
if errs:
    print("ERROR: " + "; ".join(errs)); sys.exit(1)
PY

if grep -q "TAG-VERIFY" docker-compose.yml; then
    echo "ERROR: docker-compose.yml 中仍有 TAG-VERIFY 占位符，请先填入经验证的镜像版本号。"
    echo "       本机无法访问 Docker Hub，TAG 必须由开发者核实后填写。"
    exit 1
fi

if grep -qE "image:.*:latest" docker-compose.yml; then
    echo "ERROR: 禁止使用 :latest 标签，必须锁定具体版本。"
    exit 1
fi

# 指引 6.3：container_name 必须与应用 id 一致
if ! grep -q "container_name: ${APPID}" docker-compose.yml; then
    echo "ERROR: container_name 必须与应用 id (${APPID}) 一致。"
    exit 1
fi

for f in config.ini "${APPID}.lang" "${APPID}.svg" docker-compose.yml; do
    [ -f "$f" ] || { echo "ERROR: 缺少必需文件 $f"; exit 1; }
done

rm -rf "$OUT"; mkdir -p "$OUT"
# 指引 6.2：归档根层恰好 4 个文件，README 等一律不得进入
tar -czf "${OUT}/${APPID}.tar.gz" config.ini "${APPID}.lang" "${APPID}.svg" docker-compose.yml
( cd "$OUT" && sha256sum "${APPID}.tar.gz" > "${APPID}.tar.gz.sha256" )

echo ""
echo "=== 完成 ==="
# 核对根层文件数必须为 4
N=$(tar -tzf "${OUT}/${APPID}.tar.gz" | grep -c '[^/]$')
echo "  归档根层文件数：${N}（必须为 4）"
[ "$N" -eq 4 ] || { echo "ERROR: 归档根层文件数不为 4，将被驳回"; exit 1; }
ls -lh "$OUT"

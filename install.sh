#!/usr/bin/env bash
# Sublink v2.1 Fixed - 安全安装脚本（仅适用于全新 Linux 服务器）
# 来源：https://github.com/avici9877/sublink-v2.1-fixed
set -Eeuo pipefail

REPO="avici9877/sublink-v2.1-fixed"
INSTALL_DIR="/usr/local/bin/sublink"
SERVICE_FILE="/etc/systemd/system/sublink.service"

if [ "$(id -u)" -ne 0 ]; then
  echo "错误：请使用 root 或 sudo 执行。" >&2
  exit 1
fi

for cmd in curl sed od tr systemctl sha256sum mktemp install; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "错误：缺少命令 $cmd，请先安装。" >&2
    exit 1
  fi
done

case "$(uname -m)" in
  x86_64) ASSET="sublink-linux-amd64" ;;
  *) echo "不支持的架构：$(uname -m)" >&2; exit 1 ;;
esac

# 绝不直接覆盖现有数据库/安装；升级需单独备份与验证。
if [ -e "$INSTALL_DIR/sublink" ] || [ -e "$SERVICE_FILE" ]; then
  echo "检测到 Sublink 已安装。为保护数据库及配置，本脚本只用于全新安装，已安全退出。" >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

TAG="$(printenv SUBLINK_VERSION 2>/dev/null || true)"
if [ -z "$TAG" ]; then
  if ! curl -fsSL --retry 3 --connect-timeout 15 \
      "https://api.github.com/repos/$REPO/releases/latest" \
      -o "$TMP/release.json"; then
    echo "无法获取本仓库最新 Release。请先在 GitHub 发布包含可执行文件的 Release。" >&2
    exit 1
  fi
  TAG="$(sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' "$TMP/release.json" | head -n 1)"
fi
if [ -z "$TAG" ]; then
  echo "本仓库尚未发布正式 Release。没有执行任何安装操作。" >&2
  exit 1
fi

URL="https://github.com/$REPO/releases/download/$TAG/$ASSET"
echo "下载本仓库版本：$TAG / $ASSET"
if ! curl -fL --retry 3 --connect-timeout 15 -o "$TMP/sublink" "$URL"; then
  echo "下载失败：$URL" >&2
  echo "请检查 Release 是否包含名为 $ASSET 的附件。" >&2
  exit 1
fi

# 校验下载文件与同一 Release 中的 SHA256 是否一致。
if ! curl -fL --retry 3 --connect-timeout 15   -o "$TMP/sublink-linux-amd64.sha256"   "https://github.com/$REPO/releases/download/$TAG/sublink-linux-amd64.sha256"; then
  echo "缺少 SHA256 校验文件。为安全起见，拒绝安装。" >&2
  exit 1
fi
(
  cd "$TMP"
  cp sublink sublink-linux-amd64
  sha256sum -c sublink-linux-amd64.sha256
) || { echo "程序校验失败，已终止安装。" >&2; exit 1; }

# 防止把错误页面当成二进制文件执行。
MAGIC="$(od -An -tx1 -N4 "$TMP/sublink" | tr -d ' \n')"
if [ "$MAGIC" != "7f454c46" ]; then
  echo "下载的文件不是 Linux ELF 可执行文件，安装已终止。" >&2
  exit 1
fi

umask 077
mkdir -p "$INSTALL_DIR/db" "$INSTALL_DIR/template" "$INSTALL_DIR/logs"
install -m 755 "$TMP/sublink" "$INSTALL_DIR/sublink"

cat > "$SERVICE_FILE" <<'UNIT'
[Unit]
Description=Sublink v2.1 Fixed
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/usr/local/bin/sublink
ExecStart=/usr/local/bin/sublink/sublink run --port 8000
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now sublink
sleep 2
if ! systemctl is-active --quiet sublink; then
  systemctl status sublink --no-pager -l || true
  echo "服务启动失败，请检查日志：journalctl -u sublink -n 80 --no-pager" >&2
  exit 1
fi

echo "安装完成：Sublink $TAG"
echo "服务状态：systemctl status sublink"
echo "本程序只监听 127.0.0.1:8000。若需公网订阅，请自行配置 Nginx HTTPS 反向代理。"
echo "首次使用请及时修改默认管理员凭据。"

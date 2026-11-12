#!/usr/bin/env bash
# Sublink v2.1 Fixed 本地服务菜单：不执行不受控的自动升级
set -u

SERVICE="sublink"
INSTALL_DIR="/usr/local/bin/sublink"
REPO="https://github.com/avici9877/sublink-v2.1-fixed"

if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 sudo sublink 或 root 用户运行"
  exit 1
fi

while true; do
  echo
  echo "========== Sublink v2.1 Fixed =========="
  echo "1. 启动服务"
  echo "2. 停止服务"
  echo "3. 重启服务"
  echo "4. 查看服务状态"
  echo "5. 查看最新日志"
  echo "6. 查看监听地址"
  echo "7. 查看程序目录"
  echo "8. 查看修复版发布页面"
  echo "0. 退出"
  read -r -p "请选择 [0-8]：" choice
  case "$choice" in
    1) systemctl start "$SERVICE" ;;
    2) systemctl stop "$SERVICE" ;;
    3) systemctl restart "$SERVICE" ;;
    4) systemctl status "$SERVICE" --no-pager -l || true ;;
    5) journalctl -u "$SERVICE" -n 60 --no-pager || true ;;
    6) ss -lntp | grep ':8000' || echo "未发现 TCP 8000 监听，请检查服务与端口配置" ;;
    7) echo "$INSTALL_DIR" ;;
    8) echo "$REPO/releases" ;;
    0) exit 0 ;;
    *) echo "输入无效，请重试。" ;;
  esac
done

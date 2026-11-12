# Sublink v2.1 Fixed｜首个修复版本

本项目是基于 [xeefei/sublink](https://github.com/xeefei/sublink) v2.1 的社区维护修复版，并非原作者的官方更新。

## 修复内容

- **订阅请求不再等待第三方接口**：IP 归属地查询调整为后台异步执行。
- **2 秒超时保护**：当外部 IP 查询服务不可达、响应缓慢或发生协议错误时，查询自动结束。
- **监听范围收紧**：默认仅监听 `127.0.0.1`，建议通过 Nginx HTTPS 反向代理对外提供服务。
- **保留原有订阅逻辑**：已在 Ubuntu 22.04 AMD64 环境比对新旧订阅输出一致。

## 发布附件

- `sublink-linux-amd64`：Linux x86_64 可执行程序。
- `sublink-linux-amd64.sha256`：对应的 SHA256 校验文件。

## 安装

适用于全新安装的 Linux AMD64 系统：

```bash
curl -fsSL https://raw.githubusercontent.com/avici9877/sublink-v2.1-fixed/main/install.sh | sudo bash
```

注意：安装程序仅用于**全新服务器**。如果已有 Sublink，需要先完整备份程序、数据库和模板，再按文档进行手工升级。安装后的服务仅监听 `127.0.0.1:8000`，公网访问需要另行配置 Nginx 等反向代理。

完整说明见 [FIX_NOTES.md](https://github.com/avici9877/sublink-v2.1-fixed/blob/main/FIX_NOTES.md)。

> 目前已验证的香港生产程序是独立构建的 Linux AMD64 二进制文件。GitHub Actions 重新编译产生的 SHA256 可能不同，需要单独测试后再用于生产替换。
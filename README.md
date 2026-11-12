# Sublink v2.1 Fixed（修复维护版）

> 基于原项目 Sublink v2.1 维护。此分支已经修复第三方 IP 归属地接口异常导致订阅获取卡住的问题，并默认仅监听本机。
>
> **中文更新说明与服务器部署注意事项：** [查看 FIX_NOTES.md](FIX_NOTES.md)
>
> **本次修改：** IP 归属地查询异步执行；单次查询超时 2 秒；订阅接口不再等待查询结束；默认监听地址由 `0.0.0.0` 改为 `127.0.0.1`。
>
> **重要：** 当前修复主要面向 Linux AMD64 + Nginx 反代部署；不要直接使用原项目安装脚本覆盖本修复版。部署前先备份 `db/` 和 `template/`，不要将数据库或订阅 Token 上传公开仓库。Release 安装包是否已发布，请以 [Releases](https://github.com/avici9877/sublink-v2.1-fixed/releases) 页面为准。

---

<div align="center">
<img src="webs/src/assets/logo.png" width="150px" height="150px" />
</div>

<div align="center">
    <img src="https://img.shields.io/badge/Vue-5.0.8-brightgreen.svg"/>
    <img src="https://img.shields.io/badge/Go-1.22.0-green.svg"/>
    <img src="https://img.shields.io/badge/Element Plus-2.6.1-blue.svg"/>
    <img src="https://img.shields.io/badge/license-MIT-green.svg"/>
    <a href="https://t.me/XUI_CN" target="_blank">
        <img src="https://img.shields.io/badge/TG-交流群-orange.svg"/>
    </a>
    <div align="center"> 中文 | <a href="README.en-US.md">English</div>
</div>

## [项目简介]

1、项目基于sublink项目二次开发：https://github.com/gooaclok819/sublinkX

2、前端基于：https://github.com/youlaitech/vue3-element-admin

3、后端采用go+gin+gorm，默认账号admin 密码123456，请进入后台自行修改

4、因为重写目前还有很多布局结构以及功能稍少，也需要额外花费不少时间。

## [项目特色]

1、自由度和安全性较高，能够记录访问订阅，配置轻松，

2、二进制编译直接脚本进行安装，无需Docker容器，

3、目前仅支持客户端：v2ray clash surge，

4、对于 v2rayN/v2rayNG 则为base64通用格式，

5、clash支持协议:ss ssr trojan vmess vless hy hy2 tuic，

6、surge支持协议:ss trojan vmess hy2 tuic。

## [项目预览]

![1712594176714](webs/src/assets/1.png)
![1712594176714](webs/src/assets/2.png)

## [2.1更新说明]

#### 后端更新

1. 修复底层代码
2. 修复各种奇葩bug
3. 建议卸载数据库(记得备份数据) 新数据库结构有些不一样可能会导致一些bug

#### 前端更新

1. 完善node页面




## [安装说明]
### linux方式：
```
curl -s -H "Cache-Control: no-cache" -H "Pragma: no-cache" https://raw.githubusercontent.com/xeefei/sublink/main/install.sh | sudo bash
```

```sublink``` 呼出菜单

然后输入安装脚本即可

### docker方式：

在自己需要的位置创建一个目录比如mkdir sublinkx

然后cd进入这个目录，输入下面指令之后数据就挂载过来

需要备份的就是db和template
```
docker run --name sublinkx -p 8000:8000 \
-v $PWD/db:/app/db \
-v $PWD/template:/app/template \
-v $PWD/logs:/app/logs \
-d jaaksi/sublinkx
```


## Stargazers over time
[![Stargazers over time](https://starchart.cc/xeefei/sublink.svg?variant=adaptive)](https://starchart.cc/xeefei/sublink)


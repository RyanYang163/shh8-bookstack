# BookStack

| 项 | 值 |
|---|---|
| 应用 ID | `shh8-bookstack` |
| 形态 | Docker 应用（Compose） · WebUI 外开（浏览器新标签） |
| 版本 | 1.0.007 |
| 上游项目 | https://github.com/BookStackApp/BookStack |
| 上游许可证 | MIT |
| 宿主端口 | 18808 |

## 简介

所见即所得的知识库 / 维基：书籍-章节-页面三层结构，适合记录服务配置与运维文档。

## 打包

```bash
./build.sh                # 默认 x86_64
./build.sh aarch64        # ARM（Deb 应用）
```

产物在 `build/output/`，同级生成 `<包名>.sha256`。

## 提交前必办事项

- ⚠️ 必须锁定 ≥26.05.4：CVE-2026-84695（26.05.4 之前存在 Stored XSS，2026-09-02 才公开）与 CVE-2026-5484（26.03.1 修复）。
- ⚠️ **不要用 iframe 内嵌**：第三方 OAuth 登录页（如 Google）自带 X-Frame-Options: deny，在 iframe 中无法完成登录，因此本应用采用浏览器外开形态。
- 使用 LinuxServer 社区镜像；上游仓库自带的 compose 是开发环境配置，不可直接用于生产。
- [ ] 真机安装、启动、停止、卸载残留四项实测
- [ ] 首屏加载 ≤ 5 秒（指引 H10）
- [ ] x86_64 与 aarch64 分别构建并测试（指引 H7）
- [ ] 提交前跑一遍指引 13.9 上架前自查清单

## 隐私政策（审核项 C3 / C4 / C5）

**公网地址（可直接访问）**：<https://github.com/RyanYang163/shh8-bookstack/blob/main/PRIVACY.md>

- `config.ini` 的 `help` 字段就指向该地址 —— 平台应用详情页的「帮助」即可直达，因此**包内可查**。
- 仓库内全文：[`PRIVACY.md`](./PRIVACY.md)。
- 已覆盖 C4 要求的全部要素：数据收集范围、**保存期限**、第三方共享与**数据存放地域**、
  安全措施、**用户权利**、**删除途径**、联系方式。

## 运行时写入路径清单（指引 12.9.6）

| 路径 | 由谁创建 | 内容 | 保留策略 |
|---|---|---|---|
| `/Volume*/DockerAppData/shh8-bookstack/data` | 应用（挂 `/config`） | `.env`、日志、备份、**首次启动生成的 `app_key`** | 随数据保留，不自动过期 |
| `/Volume*/DockerAppData/shh8-bookstack/www` | 应用（挂 `/config/www`） | 上传的附件与图片、缓存 | 同上 |
| `/Volume*/DockerAppData/shh8-bookstack/db` | MariaDB（挂 `/config`） | 知识库数据库 | 同上 |
| `/Volume*/DockerAppData/shh8-bookstack/secret` | 首次启动的 entrypoint 包装 | 自动生成的数据库密码（`600`） | 同上 |
| 容器内 `/var/log`、`/run` | 镜像自带 nginx / php-fpm | 运行期日志与 pid | 随容器生命周期 |

应用**不写入本清单以外的路径**。

## 权限与最小化（对应 V1 豁免申请）

本应用**不写 `user:` 字段**：`linuxserver/bookstack` 基于 s6-overlay，init 需要 root 完成
`chown` / 降权（LinuxServer.io 官方明确不支持 `user:`），强行指定会让容器起不来。等价的最小权限措施：

- `PUID=1000` / `PGID=1000` —— **nginx 与 php-fpm 的 worker 进程实际以 uid 1000 运行**；
  数据库容器同理，MariaDB 进程以 uid 1000 运行；root 只用于容器初始化与绑定 80 端口；
- `security_opt: no-new-privileges:true`；
- `cap_drop: [ALL]` + `cap_add` 白名单（**不授予** `NET_RAW` / `SETPCAP` / `SETFCAP`）；
- 无 `privileged`、无 `network_mode: host`；**数据库不发布任何端口**，只在 compose 内网可达；
- **包内无任何凭据**：数据库密码与应用 `APP_KEY` 都在首次启动时随机生成并落盘复用
  （见 `docker-compose.yml` 的 `entrypoint`）。

豁免申请材料见 `../../../开发应用计划/TOS社区应用V1豁免申请邮件-shh8-bookstack.md`。

## 已知限制（运维须知）

- **`db/` 与 `secret/` 必须同生共死**：数据库密码存在 `secret/db_password`，
  而 MariaDB 首次初始化时把用户口令写进了 `db/`。只删 `secret/` 而保留 `db/`，
  新生成的口令与库里的旧口令不匹配 → 永久认证失败。备份 / 还原 / 删除请两者一起。
- **删除 `data/` 会作废会话与加密设置**：`/config/app_key` 是 Laravel 的加密密钥，
  删掉后重新生成，既有的会话与已加密的设置将无法解密（页面内容本身不受影响）。
- **`APP_URL` 无法在打包期设定**：平台不会把 NAS 的 IP 注入 compose，而包内只允许 4 个文件，
  无法随包下发 `.env`。直接访问 Web UI 不受影响（Laravel 按请求 Host 生成链接）；
  但若启用**邮件通知 / Webhook**，队列任务在 CLI 上下文会用到 `.env` 里的默认域名，
  需要管理员手动把 `/Volume*/DockerAppData/shh8-bookstack/www/.env` 的 `APP_URL`
  改成实际访问地址。此条为**待实机验证项**。
- 数据库容器**不发布任何宿主端口**，只在 compose 内网可达；这是刻意的。

## 许可证与出处

本仓库**仅包含 TOS 平台集成所需的配置文件与打包脚本**，应用本体的源码与二进制来自上游项目：https://github.com/BookStackApp/BookStack

上游许可证：**MIT**。本封装保留上游许可证声明，未修改上游代码（Deb 形态下按上游许可证要求随包提供 LICENSE）。

应用名称与图标为上游项目的标识；本仓库图标为自行绘制的简易图形，不含上游商标元素（对应审核项 H19）。

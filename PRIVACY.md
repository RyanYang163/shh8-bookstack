# Privacy Policy — BookStack

> Review items covered / 适用审核项：C3 (policy provided) · C4 (completeness) · C5 (accessibility) ·
> C6 (data collection consistency) · C7 (user rights) · C8 (third-party disclosure)
>
> Public URL / 公网地址：<https://github.com/RyanYang163/shh8-bookstack/blob/main/PRIVACY.md>

**Effective date / 生效日期**：2026-09-22
**Applies to / 适用版本**：1.0.007
**Publisher / 开发者**：shh
**Package / 包名**：`shh8-bookstack` (Docker)

---

## 1. Data Collected / 收集哪些数据

BookStack is a self-hosted wiki. All content is created by the users of the device and stays on
the device.

本应用是自托管知识库，所有内容由本机用户自己创建，不离开设备。

- Wiki content: books, chapters, pages, page revisions and their edit history
  知识库内容：书籍、章节、页面及其历史版本
- Uploaded files and images attached to pages
  页面上传的附件与图片
- User accounts created by the administrator: display name, e-mail address and a hashed password
  管理员创建的账号：显示名、邮箱、密码哈希
- Application settings and per-role permissions
  应用设置与角色权限

Stored in a **MariaDB database and a configuration directory that are both local to the device**,
under `/Volume*/DockerAppData/shh8-bookstack/`.

**The developer collects nothing.** No analytics, no telemetry, no crash reporting, no account
with the developer is required or possible.
**开发者不收集任何数据**：无埋点、无遥测、无崩溃上报。

## 2. Retention Period / 数据保存期限

- Content and accounts are retained on the device **for as long as the user keeps them**. There is
  **no automatic expiry and no server-side retention window**, because the developer operates no
  server.
  内容与账号由用户自行保管，**不设自动过期**，也没有任何「服务端保留期」——开发者没有服务端。
- Page revisions are kept by the application until the user deletes the page or the revision.
  页面历史版本由应用保留，直到用户删除该页面或版本。
- Container and database logs are rotated by the container runtime (Docker `json-file` driver) and
  are removed together with the application data.
  容器与数据库日志由 Docker 自身的日志轮转管理，随应用数据一并清除。

## 3. Third-Party Sharing and Data Location / 第三方共享与数据存放地域

- **Default: no third party is involved and no data leaves the device.**
  **默认不涉及任何第三方，数据不出设备。**
- The bundled **database is not published to the LAN at all** — no host port is mapped for it. It
  is reachable only by the application container over the private compose network.
  随附的**数据库不对局域网发布任何端口**，只有应用容器能通过 compose 内部网络访问它。
- Optional integrations are **off by default** and only run if the administrator configures them;
  in those cases the request goes from the device **directly to the provider the administrator
  chose**, under that provider's own terms. No copy passes through the developer.
  可选集成**默认关闭**，只有管理员自行配置后才生效；此时请求由设备**直连管理员选定的服务商**，
  遵循对方条款，**不经过开发者**：

  | Integration / 集成 | Destination / 去处 | Default / 默认 |
  |---|---|---|
  | E-mail notifications / 邮件通知 | the SMTP server the administrator configures | **disabled / 关闭** |
  | OIDC / SAML / LDAP single sign-on | the identity provider the administrator configures | **disabled / 关闭** |
  | Outbound HTTP for embedded images | the URL the page author typed | only when a page uses one |

- **Data location / 数据存放地域**：the device the user installed the app on. The developer
  stores no copy anywhere, in any region.

## 4. Security Measures / 数据安全措施

This is a Docker application; the statements below describe what is actually configured in
`docker-compose.yml` and are verifiable there.

- Web server and PHP processes run as a **non-root UID (`PUID=1000` / `PGID=1000`)**; the
  container's init only drops privileges to that UID. The database container works the same way:
  its init drops privileges to uid 1000 and the MariaDB server process runs as that unprivileged
  uid, never as root.
- `security_opt: no-new-privileges:true` — no process can gain privileges at runtime.
- **Capability allow-list**: `cap_drop: [ALL]` followed by an explicit `cap_add` list, instead of
  Docker's unrestricted default set. `NET_RAW`, `SETPCAP` and `SETFCAP` are **not** granted.
- **No hard-coded credentials.** The database password and the application encryption key are
  **generated randomly on first start** and stored only in the local data directory
  (`/Volume*/DockerAppData/shh8-bookstack/`). They are never shipped in the package and are never
  shared between installations.
- No `privileged` mode and no `network_mode: host`; only the single Web UI port (`18808`) is
  published. The database has no published port.
- Data is confined to the declared volumes under `/Volume*/DockerAppData/shh8-bookstack/` and is
  never relayed through a developer-operated server.

## 5. User Rights / 用户权利

The administrator and each user can, at any time and without contacting the developer:

- **Access / 查阅**：browse and search all content in the Web UI, and read the user list under
  *Settings → Users*.
- **Correct / 更正**：edit any page or profile in the Web UI.
- **Export / 导出**：export books and chapters as HTML, Markdown or PDF from the Web UI, or take a
  full backup of the data directory.
- **Delete / 删除**：delete pages, users and their content in the Web UI — see section 6.

## 6. Deletion Channel / 数据删除途径

1. **In the app / 应用内**：delete pages, books, uploaded files and user accounts from the Web UI;
   deleting a user removes their profile, and page history can be pruned per page.
2. **Uninstall with data / 卸载时删除**：uninstall from the TOS App Center and select
   "delete data" — this removes `/Volume*/DockerAppData/shh8-bookstack/` entirely, including the
   database and the generated keys.
3. **Manual / 手动**：delete the `/Volume*/DockerAppData/shh8-bookstack/` directory on the device.

Uninstalling **without** selecting "delete data" keeps the directory, so the user can reinstall
and continue with their content intact. There is no developer-side copy to delete.

## 7. Contact / 联系方式

- Packaging repository / 本封装仓库：<https://github.com/RyanYang163/shh8-bookstack/issues>
- Upstream project / 上游项目：<https://github.com/BookStackApp/BookStack/issues>

Questions about this policy can be raised in either tracker.

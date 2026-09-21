# BookStack

| 项 | 值 |
|---|---|
| 应用 ID | `shh8-bookstack` |
| 形态 | Docker 应用（Compose） · WebUI 外开（浏览器新标签） |
| 版本 | 1.0.006 |
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

## 隐私政策

见 [PRIVACY.md](./PRIVACY.md)（对应审核项 C3–C8）。

## 许可证与出处

本仓库**仅包含 TOS 平台集成所需的配置文件与打包脚本**，应用本体的源码与二进制来自上游项目：https://github.com/BookStackApp/BookStack

上游许可证：**MIT**。本封装保留上游许可证声明，未修改上游代码（Deb 形态下按上游许可证要求随包提供 LICENSE）。

应用名称与图标为上游项目的标识；本仓库图标为自行绘制的简易图形，不含上游商标元素（对应审核项 H19）。

# BookStack

> TOS 7 application package for **BookStack** — platform integration only.
> The application itself is provided by the upstream project, unmodified.

## Overview

A simple, self-hosted wiki and documentation platform organised into books, chapters and pages.

上游项目 / Upstream: <https://github.com/BookStackApp/BookStack>
上游许可证 / License: **MIT**

## Features

- WYSIWYG editor with Markdown support
- Books / chapters / pages hierarchy
- Full-text search across all content
- Role-based permissions and multi-language UI

## Installation

1. Requirements: TOS 7.0+ and Docker Engine (install from the TOS App Center)
2. Install from the TOS App Center
3. Open the app and complete initial configuration

## Usage

1. Access URL: `http://${ip}:18808`
2. Default credentials: see upstream documentation
3. Key settings: see upstream documentation

## Permissions

| Permission | Rationale |
|---|---|
| Network: port 18808 | Web UI access |
| File system: `/Volume*/DockerAppData/shh8-bookstack/` | Application data persistence |
| User: shh8bookstack | Isolated non-root service execution |

## Configuration

See `config.ini` for platform metadata; see `docker-compose.yml` for runtime configuration.

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 18808 | TCP | Web UI (BookStack) |

## Support

- Documentation: https://github.com/BookStackApp/BookStack
- Issue tracker: https://github.com/BookStackApp/BookStack/issues
- Community: https://github.com/BookStackApp/BookStack

## Security & Compliance

- **License**: MIT — full text in [`LICENSE`](./LICENSE)
- **Attribution**: see [`NOTICE`](./NOTICE)
- **Privacy Policy**: see [`PRIVACY.md`](./PRIVACY.md)
- **Vulnerability scan**: `trivy-report.txt` attached to each Release (HIGH/CRITICAL must be 0)
- Runs as a non-root dedicated user; no privileged mode, no host network

## Changelog

### v1.0.3 (2026-09-20)
- Compliance update: added LICENSE / NOTICE / PRIVACY materials,
  declared upstream license inside the package, added container healthcheck

### v1.0.0
- Initial release

## License

**MIT** — this packaging repository is distributed under the same license as the
upstream project. Full text: [`LICENSE`](./LICENSE).

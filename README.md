# mst CLI downloads

`mst` is the command line client for [mstep](https://mstep.moltavista.com). It signs you in, connects Claude Code and Codex to your workspace, and runs the local MCP bridge.

Install the current macOS or Linux build with the [mstep installer](https://mstep.moltavista.com/install.sh):

```sh
curl -fsSL https://mstep.moltavista.com/install.sh | sh
mst login
```

You can also use the [GitHub installer in this repository](install.sh):

```sh
curl -fsSL https://raw.githubusercontent.com/moltavista/mst/main/install.sh | sh
mst login
```

The [latest release](https://github.com/moltavista/mst/releases/latest) has `mst-darwin-amd64`, `mst-darwin-arm64`, `mst-linux-amd64`, `mst-linux-arm64`, `SHA256SUMS` and `VERSION`. Both installers verify the selected binary against the published SHA-256 checksum before installing it into `~/.local/bin` (or `MST_INSTALL_DIR`). If you download a binary yourself, check its hash against `SHA256SUMS` before running it.

This repository distributes binaries and install instructions. The mstep server builds the binaries and publishes them at [`/download/mst/`](https://mstep.moltavista.com/download/mst/VERSION); the workflow here copies a checked build into the rolling GitHub release. The release's `Build:` line matches that server version. [Setup instructions](https://mstep.moltavista.com/docs/quick-start) cover the first login and client plugins.

# fluxvale homebrew tap

Homebrew distribution for [DashFloat](https://github.com/fluxvale/dashfloat) —
a command-line AI coding harness with a terminal UI, shipped as
self-contained `mix release` builds (bundled ERTS, no runtime dependencies).

## Install

    brew tap fluxvale/dashfloat https://github.com/fluxvale/homebrew-tap
    brew install fluxvale/dashfloat/dashfloat

One-command equivalent (Homebrew finds `github.com/fluxvale/homebrew-tap`
for you):

    brew install fluxvale/tap/dashfloat

Then:

    dashfloat --version

## Platforms

- macOS, Apple silicon and Intel (unsigned builds — see below)
- Linux x86_64, glibc 2.34+ (Debian 12+, Ubuntu 22.04+, current Fedora/RHEL)
- Not packaged: Linux arm64, Alpine/musl, Windows

Linux builds link the system `libtinfo.so.6`, `libstdc++.so.6`, and
`libcrypto.so.3` (OpenSSL 3); those are standard on the distributions above.

## macOS: first launch of an unsigned build

The macOS binaries are not notarized. A copy downloaded **with a browser**
carries the quarantine flag, and macOS refuses it with "unidentified
developer". Clear it once, either way:

- Finder: right-click (or Control-click) `dashfloat`, choose **Open**, then
  **Open** again in the dialog.
- Terminal: `xattr -d com.apple.quarantine "$(command -v dashfloat)"`

Installing with Homebrew or `curl` sets no quarantine flag, so there is
nothing to clear.

## No Homebrew? The curl installer

The same builds install with a curl|sh script — installs under
`~/.local/share/dashfloat`, shims into `~/.local/bin`, verifies sha256s
before extracting:

    curl -fsSL https://github.com/fluxvale/dashfloat/releases/latest/download/install.sh | sh

## CI

`.github/workflows/test-formula.yml` installs this tap on both macOS runner
families (arm64 and Intel) and asserts the installed version — currently
`dashfloat 0.1.0`, matching the formula.

class Dashfloat < Formula
  desc "Command-line AI coding harness with a terminal UI"
  homepage "https://dashfloat.com"
  version "0.5.0"
  license "MIT"

  # Self-contained mix-release tarballs: the BEAM release plus its bundled
  # ERTS, so the formula carries no runtime dependencies. One tarball per
  # platform, published on the v0.5.0 GitHub release; every sha256 below was
  # cross-checked against that release's dashfloat-0.5.0-sha256sums.txt.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.5.0/dashfloat-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "6a7dfa74d1561c932edf8f296da5f2d0090aeb5b64b320b5d2f2b24aa82d40c5"
    else
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.5.0/dashfloat-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "84b5fab585efa480cd2354b859998f36412e91ef6316f519ec244643264a7a4a"
    end
  end

  on_linux do
    unless Hardware::CPU.intel?
      raise "dashfloat ships x86_64 Linux only; Linux arm64 and musl are not packaged."
    end
    url "https://github.com/fluxvale/dashfloat/releases/download/v0.5.0/dashfloat-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0a53f6f27cd32f1e501526507fdefedc849595f6722121cc064b72de861ce461"
  end

  def install
    # The tarball IS the release tree: bin/dashfloat (the launcher),
    # erts-*/, lib/, releases/. Install the tree whole and link just the
    # launcher onto PATH.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin"/"dashfloat"
  end

  def caveats
    <<~EOS
      The macOS builds are unsigned (not notarized). A copy downloaded with a
      browser carries the quarantine flag; clear it once with either
        xattr -d com.apple.quarantine #{bin/"dashfloat"}
      or Finder: right-click the binary, choose Open, then Open again.
      Installs through Homebrew or curl set no quarantine flag.
    EOS
  end

  test do
    assert_match(/^dashfloat 0\.1\.1$/, shell_output("#{bin/"dashfloat"} --version"))
  end
end

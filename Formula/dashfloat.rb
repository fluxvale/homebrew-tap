class Dashfloat < Formula
  desc "Command-line AI coding harness with a terminal UI"
  homepage "https://dashfloat.com"
  version "0.3.0"
  license "MIT"

  # Self-contained mix-release tarballs: the BEAM release plus its bundled
  # ERTS, so the formula carries no runtime dependencies. One tarball per
  # platform, published on the v0.3.0 GitHub release; every sha256 below was
  # cross-checked against that release's dashfloat-0.3.0-sha256sums.txt.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.3.0/dashfloat-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "a84d362000bc1c66801e9336e69135a2f610dbefab0b479526a3de4b5420d7d4"
    else
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.3.0/dashfloat-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "f71f2863324660655cb1611beba01dc2eb39e3c3ed0cda1df4c5f9d8f22fb305"
    end
  end

  on_linux do
    unless Hardware::CPU.intel?
      raise "dashfloat ships x86_64 Linux only; Linux arm64 and musl are not packaged."
    end
    url "https://github.com/fluxvale/dashfloat/releases/download/v0.3.0/dashfloat-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d1270604547ee9717e9928f052ffe5fad8cc93b61291ccf857e3da4ab289ba40"
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

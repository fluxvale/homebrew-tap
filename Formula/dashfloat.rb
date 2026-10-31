class Dashfloat < Formula
  desc "Command-line AI coding harness with a terminal UI"
  homepage "https://dashfloat.com"
  version "0.4.0"
  license "MIT"

  # Self-contained mix-release tarballs: the BEAM release plus its bundled
  # ERTS, so the formula carries no runtime dependencies. One tarball per
  # platform, published on the v0.4.0 GitHub release; every sha256 below was
  # cross-checked against that release's dashfloat-0.4.0-sha256sums.txt.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.4.0/dashfloat-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "c70f6386be40e3eb33ed8e1007c826098956554a1cca7ab9581497dcd2880065"
    else
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.4.0/dashfloat-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "4f176b016c9cd9519b7fbb3d878c697f2b695d727869e2fac11d9185214c6915"
    end
  end

  on_linux do
    unless Hardware::CPU.intel?
      raise "dashfloat ships x86_64 Linux only; Linux arm64 and musl are not packaged."
    end
    url "https://github.com/fluxvale/dashfloat/releases/download/v0.4.0/dashfloat-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "8b44dd87c6b728bce4827d6a47009b81a9767141de4ea1ad025ebea45ebcd066"
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

class Dashfloat < Formula
  desc "Command-line AI coding harness with a terminal UI"
  homepage "https://dashfloat.com"
  version "0.2.0"
  license "MIT"

  # Self-contained mix-release tarballs: the BEAM release plus its bundled
  # ERTS, so the formula carries no runtime dependencies. One tarball per
  # platform, published on the v0.2.0 GitHub release; every sha256 below was
  # cross-checked against that release's dashfloat-0.2.0-sha256sums.txt.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.2.0/dashfloat-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "20be5819472c328021d2d18141df50a20f5d8626c69911d26330aef9669d2745"
    else
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.2.0/dashfloat-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "b46f54c985ad9d03208c8232e31e2e478b6a2e82d9d90dae9502906d538b1357"
    end
  end

  on_linux do
    unless Hardware::CPU.intel?
      raise "dashfloat ships x86_64 Linux only; Linux arm64 and musl are not packaged."
    end
    url "https://github.com/fluxvale/dashfloat/releases/download/v0.2.0/dashfloat-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "256bd558ad5e1c7b1ff4d010718dc83468591a1a61b9e297099df3e9148f26bd"
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

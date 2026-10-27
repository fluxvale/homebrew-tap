class Dashfloat < Formula
  desc "Command-line AI coding harness with a terminal UI"
  homepage "https://dashfloat.com"
  version "0.1.0"
  license "MIT"

  # Self-contained mix-release tarballs: the BEAM release plus its bundled
  # ERTS, so the formula carries no runtime dependencies. One tarball per
  # platform, published on the v0.1.0 GitHub release; every sha256 below was
  # cross-checked against that release's dashfloat-0.1.0-sha256sums.txt.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.1.0/dashfloat-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "d8ae228848510193b92f1685f486e085b748a3e32c9d28d6418eb156c9a243c5"
    else
      url "https://github.com/fluxvale/dashfloat/releases/download/v0.1.0/dashfloat-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "ba69bd7eb69ca1e9f65042ec1cf3d8925cc9a4615575396fb709bb088f290c49"
    end
  end

  on_linux do
    unless Hardware::CPU.intel?
      raise "dashfloat ships x86_64 Linux only; Linux arm64 and musl are not packaged."
    end
    url "https://github.com/fluxvale/dashfloat/releases/download/v0.1.0/dashfloat-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "53af9a380db6c3c4718f95e7d2a2e1c042381005c272782883406c4cc7d72128"
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
    assert_match(/^dashfloat 0\.1\.0$/, shell_output("#{bin/"dashfloat"} --version"))
  end
end

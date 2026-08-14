class Glasspad < Formula
  desc "AI-friendly HTML/Markdown-artifact publisher: hand it markdown, get a URL — config-driven loopback or hosted, each page in a null-origin sandboxed iframe for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.11.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.11.0/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "7f1d1681431d8e5f9e69e2ba29751b1d1ed188a8e8bfa7de1b8dfae9e5169d68"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.11.0/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a88b4ff942531bd61da4a5fdd45b4884a52aa27fa80cf8ff1632b1b274b05ad1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.11.0/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6389638d7dbad3ea5456455d178dd7d5a4b0a1e84abaf860b7f2631723d616e5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "glasspad"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "glasspad"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "glasspad"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

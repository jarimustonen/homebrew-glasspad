class Glasspad < Formula
  desc "AI-friendly HTML/Markdown-artifact publisher: hand it markdown, get a URL — config-driven loopback or hosted, each page in a null-origin sandboxed iframe for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.9.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.9.0/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "b5fbfa1e844c15cea26449b4b3e97c097981b3e5d38ee3eae8be11e8b52528b8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.9.0/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a737d9e19e34117b4da18f4d73f2537cf276a7dc0204e0393f09f1a670033c82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.9.0/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d4d3807c59fa93860b3fbe768a84b49ab4b89b3abadac9e553e7c7a220abd51"
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

class Glasspad < Formula
  desc "AI-friendly, loopback-only HTML-artifact host: serves agent-authored HTML in null-origin sandboxed iframes for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.0/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "3c764d39b47b4e021f94f05a5b8ea792689f9a37189dd5a5b8b2253883469d2d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.0/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5b0b2c92fa668eb5358442295d1781b742e2497dc5faa3ee5d4292ef91f1877"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.0/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb6178a66dd5d41a50937122f61a4f5761f90778db5d2c80009dc57ce2694bb2"
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
    bin.install "glasspad" if OS.mac? && Hardware::CPU.arm?
    bin.install "glasspad" if OS.linux? && Hardware::CPU.arm?
    bin.install "glasspad" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

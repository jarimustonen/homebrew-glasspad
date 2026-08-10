class Glasspad < Formula
  desc "AI-friendly, loopback-only HTML-artifact host: serves agent-authored HTML in null-origin sandboxed iframes for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.1/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "7d8a68f104c71397581f8a17fdaf521d8560370377de8eb88e4cc71e485f451a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.1/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e09b119068d80dddfe2c5cb5cc4f13ad8a6a974ad2b52357d57196b7819cf6a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.3.1/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "65318de53a765dfe116e4d4ae4f6d0e535bb150af543618e57349c0060b08030"
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

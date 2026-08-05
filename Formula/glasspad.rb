class Glasspad < Formula
  desc "AI-friendly, loopback-only HTML-artifact host: serves agent-authored HTML in null-origin sandboxed iframes for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.2.1/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "f47deb2df137e5c9bd48735803de163724177429acbe3c08a2ae9a703fd4caf1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.2.1/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8f96b7a905961d055b0be7eea64320b5f65acd385d46ac92ce4732754306622"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.2.1/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fced86d05958f2c9c1ada1f9c0569fa15b1b931e64fb26c8fc50fb64223b0362"
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

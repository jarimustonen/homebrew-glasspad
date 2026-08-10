class Glasspad < Formula
  desc "AI-friendly, loopback-only HTML-artifact host: serves agent-authored HTML in null-origin sandboxed iframes for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.4.0/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "5ce742aed1b138ff0d87f5e25c93acc0a0b50c2b3919dd5934a9ab21924113e0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.4.0/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20d4ec1c37e88c3d55bd4eb4dc210c25e235a12c93daf31070878939b17ceb58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.4.0/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46b99d2a0d73554bb51e0a4b3afa8e74e96fbbd41e50d432fcaa7ef0a2988324"
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

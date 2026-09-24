class Glasspad < Formula
  desc "AI-friendly HTML/Markdown-artifact publisher: hand it markdown, get a URL — config-driven loopback or hosted, each page in a null-origin sandboxed iframe for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.18.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.18.3/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "b329297cfb07b411e677031c4bc2d2d00bf5f7dda303966476260b0c6a44b0d3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.18.3/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5cd6334306a2700190397bc650d3d2783f5f5a9e01904a9140ceb6902c1cc420"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.18.3/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f440b79443b0e2c7980e59bddac992a7aa18bfbe0e90eeb3582861999577da4b"
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

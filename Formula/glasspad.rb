class Glasspad < Formula
  desc "AI-friendly HTML/Markdown-artifact publisher: hand it markdown, get a URL — config-driven loopback or hosted, each page in a null-origin sandboxed iframe for dashboards, charts, and interactive UIs."
  homepage "https://github.com/jarimustonen/glasspad"
  version "0.17.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/glasspad/releases/download/v0.17.0/glasspad-aarch64-apple-darwin.tar.xz"
    sha256 "f8878cfdd49ff0a665f2b49bfbe323d28bc87c6cd912fd3eb630ed891a51d831"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.17.0/glasspad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "71cad3981a833aeb3dc61ad5b53a6b55c73bb39fadf3cf7694d140e7233fccbe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/glasspad/releases/download/v0.17.0/glasspad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14df833064c15ef8a9781d7570f181c90599b922daac0e10956706d80febe35e"
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

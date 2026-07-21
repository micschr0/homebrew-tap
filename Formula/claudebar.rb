class Claudebar < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.7.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "970753f0c718b818bb6f15df3d635160858ba506233ce9377a5600af2909945d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "d1492d698bb6a8180de47ba3fa23c0d0e4c39a0bce43fbd92cb2f1bf5ee9cde2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3fa7e03a631de713c66086cda65fc86e693253fd96576d4a51f8caf9402d6436"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7c57068140c3c00818bcece6545896e5177c1a6ff90cbe1fc36e91e8a844584a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "claudebar" if OS.mac? && Hardware::CPU.arm?
    bin.install "claudebar" if OS.mac? && Hardware::CPU.intel?
    bin.install "claudebar" if OS.linux? && Hardware::CPU.arm?
    bin.install "claudebar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

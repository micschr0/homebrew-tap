class ClaudebarBeta < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.8.26-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.26-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "fcb14f6fab5b40fd2c5ef87fddf1376c1d916ec3f963380fd0a1a30642d4f91b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.26-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "9a5451c691d6ba2f9382cac4043ddbb5ba1872b42f212289c93054dcf8784cbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.26-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9f5f223ae5c9d310b9657662387c95360cd12f05a146aa2326157fa1f5a92d37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.26-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "984cff88b2b2c6f74c1a4e4f77691efc9fa1ff5b1e4ef761f838e59580a0908a"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "claudebar"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "claudebar"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "claudebar"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "claudebar"
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

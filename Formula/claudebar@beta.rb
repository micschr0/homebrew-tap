class ClaudebarATBeta < Formula
  desc "Powerline-style statusline for Claude Code, with a TUI configurator, themes and styles"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.7.21-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "4a32094458ccfaf130ebb2f95640d248ef206c0c8e8219e7768abc065daa5ea8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "8cdcb92eb84e85f3eb1ac356a6a03699a8a499ad7fcafa954eb41399287e4e0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1b731419d5a1ebaab2d68979c275a38a21bb7fdfe3eb21676b09c9d903136461"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "09a4792bb7fac4ed7a9377c7e09f85d628b179a022453923efa96308c0b1959f"
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

class ClaudebarBeta < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.8.15-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.15-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "899a854391b422bb6074592997aaa77959d0e071b7ca1c701dd84cfc41291176"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.15-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "c02d6559a14a4b6a1730c9d8db2523e750e33d6f14967e39bab6df86b98c214a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.15-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e0efe38373d8929a158faa71e52db2486d658c815c85e910fbbd76a5d9c09e34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.15-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cda5585a37169a9f5e418c71ea7b34c73be40a8ce0a09374957b10b58cf08f55"
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

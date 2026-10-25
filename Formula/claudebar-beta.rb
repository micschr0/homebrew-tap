class ClaudebarBeta < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.10.25-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.25-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "cdbf61698e5e8647d7736a696f2efb319391cab73e297b07a2342b8cfb6941ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.25-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "460181ef44e9d54d3632e31715b026d721b979d1eec2213316e9b97be95dd1fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.25-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8e9a6e0e91d8c03621e2a4551cbbce24dd3c05e0246f174a371cfaf05bfe9975"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.25-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "93293864b8f433c21cc265fccceab4d8b828bf59e670029bf6de49b6c687c574"
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

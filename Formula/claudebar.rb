class Claudebar < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.8.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.27/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "cda21dc6a48019533893b54fe4e0b8e2217e12041ad3a981ba44901478fcf567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.27/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "6b11924f26a89e7ea4513108241105155eaf8fd586a99c737a07e0a7f63eca47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.27/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6743f2feaf605726236ce92507cc21c502d0c1fa26ee6d53e3f727624a7b5b70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.8.27/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b71858d4ea935b36000ce272f11281197a53ba5df368e7f263df38942b85d6f7"
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

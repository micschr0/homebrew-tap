class ClaudebarBeta < Formula
  desc "Powerline-style statusline for Claude Code, with TUI configurator and themes"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.10.24-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.24-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "d62c77df61c38917bae8bbb10718500c886009721ed6a79b8a6964623e02b675"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.24-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "0829d7b298cec8a4a06bfefc7668ec54eca4812a4aa41bba928867e9a9f42e06"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.24-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "24ddde3daf532b169516fab2ef69a9d81fbdea63e3cbfcf972c3a975d83f1bc2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.10.24-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bd01e07fce2f21afcbdacb9fc528f2575631272a6179d8993358b895a9fe3a35"
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

class ClaudebarBeta < Formula
  desc "Powerline-style statusline for Claude Code, with a TUI configurator, themes and styles"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.7.21-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "3b62e5a5ca72db300ffee4b3cf9095272a4db946fe78ea4ae6518ec7cb9650a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "dbca468873f94391445dadda11383916302cda34daa38abd0c728895683dd15c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4c2be3e3a427b6230552def6d5d76bda44499ef98b6925ceb56d5e600d4fcf1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.21-beta.1/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e5e35f530a6c05ff28c5099bb67ca2ca755bf728a33b1b6f1a0796e4214308e5"
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

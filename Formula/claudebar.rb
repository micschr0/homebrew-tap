class Claudebar < Formula
  desc "Powerline-style statusline for Claude Code, with a TUI configurator, themes and styles"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.7/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "41193d8459aeac95fdbf67c9e669a5f67bd32f2ab664928a3cb269c700a375b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.7/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "668295179f7cbee5a985e1c8709f35c1aebf8434bc30da6e108c0516800a42c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.7/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "41971ef53ec96bb2b9b34c1fcc9ce6409a54bb98c1ac5e36c815a0c152c93047"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.7/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bde2c2f4a0a0ba557fc81476f3267dd02131916b2f6c4d97dbddc5394ee9bcf9"
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

class Claudebar < Formula
  desc "Powerline-style statusline for Claude Code, with a TUI configurator, themes and styles"
  homepage "https://micschr0.github.io/claudebar"
  version "2026.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.3/claudebar-aarch64-apple-darwin.tar.gz"
      sha256 "8158a8c6229bb522b1636f033e124138d48bb257c8c45ec7938c7c0c93d0882c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.3/claudebar-x86_64-apple-darwin.tar.gz"
      sha256 "8b7754e01d8ad28b3923ef5da00752e2ca2e500582cd36d7fe5490f19f3ecfd1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.3/claudebar-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5bfe6207702e165424825e30aba38f3bf950d3351f8d80e93d52cad79cfa956a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/micschr0/claudebar/releases/download/2026.7.3/claudebar-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fdeecf727359540836a8b06ec0c3cd76efd8eb1cdcdbcdbb37d46442a7a27c77"
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

  def caveats
    <<~EOS
      To wire claudebar into Claude Code's statusline, run:
        claudebar setup
    EOS
  end
end

class PactRubyStandalone1612 < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Travelling Ruby"
  homepage "https://github.com/pact-foundation/pact-ruby-standalone"
  version "1.61.2"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.61.2/pact-1.61.2-osx.tar.gz"
      sha256 "d9dc1279585dc6163b20927ae03f91c204f0225a312f15465b3a40fda641e78b"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.61.2/pact-1.61.2-osx.tar.gz"
      sha256 "d9dc1279585dc6163b20927ae03f91c204f0225a312f15465b3a40fda641e78b"
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      on_intel && Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.61.2/pact-1.61.2-linux-x86_64.tar.gz"
        sha256 "1a1855ccc14ff5c4b459185f29696d30131b7c621b0e2336165a6500fa1fd4df"
      end
    end
   if Hardware::CPU.is_32_bit?
      on_intel && !Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.61.2/pact-1.61.2-linux-x86.tar.gz"
        sha256 "f8d5da9020b91ecf0130486c5ccbe60eef7d03c3a325ca6a84dd49bd2b751db1"
      end
    end
  end

  def install
    # pact-ruby-standalone
    bin.install Dir["bin/*"]
    lib.install Dir["lib/*"]
    puts "# (see https://github.com/pact-foundation/pact-ruby-standalone/releases/)'"
    puts "# Run 'pact --help'"
    puts "# Run 'pact-broker --help'"
    puts "# Run 'pact-message --help'"
    puts "# Run 'pact-mock-service --help'"
    puts "# Run 'plugin-cli --help'"
    puts "# Run 'pact-provider-verifier --help'"
    puts "# Run 'pact-stub-service --help'"
    puts "# Run 'pactflow --help'"
  end

  test do
    system "#{bin}/pact", "help"
    system "#{bin}/pact-broker", "help"
    system "#{bin}/pact-message", "help"
    system "#{bin}/pact-mock-service", "help"
    system "#{bin}/pact-plugin-cli", "help"
    system "#{bin}/pact-provider-verifier", "help"
    system "#{bin}/pact-stub-service", "help"
    system "#{bin}/pactflow", "help"

  end
end

class PactRubyStandalone1750 < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Travelling Ruby"
  homepage "https://github.com/pact-foundation/pact-ruby-standalone"
  version "1.75.0"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.75.0/pact-1.75.0-osx.tar.gz"
      sha256 "140e24b7a53b8dc305f5c704a03701f1670394a99484a83001560c73b134f6d7"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.75.0/pact-1.75.0-osx.tar.gz"
      sha256 "140e24b7a53b8dc305f5c704a03701f1670394a99484a83001560c73b134f6d7"
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      on_intel && Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.75.0/pact-1.75.0-linux-x86_64.tar.gz"
        sha256 "f9f03871fda31bddca2bf1cbfdc73563817e82cf60021d7f98bdc9e6defb2e03"
      end
    end
   if Hardware::CPU.is_32_bit?
      on_intel && !Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.75.0/pact-1.75.0-linux-x86.tar.gz"
        sha256 "0549be6738099b07b5e27b6c42542bd4ab7204e31a6215f78f525c1626045718"
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

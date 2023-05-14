class PactRubyStandalone1810 < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Travelling Ruby"
  homepage "https://github.com/pact-foundation/pact-ruby-standalone"
  version "1.81.0"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.81.0/pact-1.81.0-osx.tar.gz"
      sha256 "e72be2e5e7372d075e032e39f55100ebeb88c8c64c92b039bdb1473c12693036"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.81.0/pact-1.81.0-osx.tar.gz"
      sha256 "e72be2e5e7372d075e032e39f55100ebeb88c8c64c92b039bdb1473c12693036"
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      on_intel && Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.81.0/pact-1.81.0-linux-x86_64.tar.gz"
        sha256 "c3d4731d60807f9a7043ec6149d0f9af007cf68e4e07203b5ffeaaeb989b940f"
      end
    end
   if Hardware::CPU.is_32_bit?
      on_intel && !Hardware::CPU.is_64_bit? do
        url "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.81.0/pact-1.81.0-linux-x86.tar.gz"
        sha256 "ed309307e4b42613301fbf3819568f24abd1a95fadb499bbedf0ae655619a189"
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

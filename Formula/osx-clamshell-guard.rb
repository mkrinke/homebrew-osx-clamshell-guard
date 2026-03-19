class OsxClamshellGuard < Formula
  desc "Prevents macOS clamshell sleep during USB-C dock power delivery renegotiation"
  homepage "https://github.com/mkrinke/osx-clamshell-guard"
  url "https://github.com/mkrinke/osx-clamshell-guard/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "27545f50ba35fa5998f80eef950cd98dbfd16a1bcce2adaf0745fbe17974936a"
  license "MIT"
  head "https://github.com/mkrinke/osx-clamshell-guard.git", branch: "main"

  depends_on :macos
  depends_on :xcode => ["14.0", :build]

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "osx-clamshell-guard"
  end

  service do
    run [opt_bin/"osx-clamshell-guard", "-t", "30"]
    keep_alive true
    require_root true
    log_path var/"log/osx-clamshell-guard/osx-clamshell-guard.log"
    error_log_path var/"log/osx-clamshell-guard/osx-clamshell-guard.log"
  end

  def post_install
    (var/"log/osx-clamshell-guard").mkpath
  end

  def caveats
    <<~EOS
      osx-clamshell-guard requires root privileges to create PreventSystemSleep
      assertions and deny sleep requests. Start it as a system service:

        sudo brew services start osx-clamshell-guard

      Logs: #{var}/log/osx-clamshell-guard/osx-clamshell-guard.log
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/osx-clamshell-guard --version")
  end
end

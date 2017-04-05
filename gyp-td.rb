class GypTd < Formula
  url "https://chromium.googlesource.com/external/gyp", 
    :using => :git 
  version "1"
  
  keg_only "Only TDestkop needs this"

  depends_on :python

  patch do
    url "https://raw.githubusercontent.com/telegramdesktop/tdesktop/dev/Telegram/Patches/gyp.diff"
    sha256 "46a39cf34eddca001ef43a4a16ca628de05568074ed6d2c641711b1f508d3604"
  end

  def install
    system "python", "./setup.py", "build"
    system "python", *Language::Python.setup_install_args(prefix)

    bin.install "gyp"
    bin.install "gyp_main.py"
  end
end

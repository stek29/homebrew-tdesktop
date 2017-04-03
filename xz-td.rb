# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class XzTd < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"
  url "http://tukaani.org/xz/xz-5.0.5.tar.gz"
  sha256 "5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a"

  keg_only "Because only tdesktop needs this"
  
  def install
    # Causes 'error: C compiler cannot create executables' 
    # ENV.append "MACOSX_DEPLOYMENT_TARGET", "10.8"
    system "./configure", 
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end

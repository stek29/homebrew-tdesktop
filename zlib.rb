class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "http://www.zlib.net/"
  url "http://zlib.net/zlib-1.2.8.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.8/zlib-1.2.8.tar.gz"
  sha256 "36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d"

  bottle do
    cellar :any
    revision 1
    sha256 "9ec582bc10aeb72e417a2c5bdb6f2db6541d3cc8b23c31e51e351c4ad924aaa7" => :sierra
    sha256 "502f66f8a3df28cd47568967250c534d19ad6c1439c23b235abcc74144e8dd4c" => :el_capitan
    sha256 "2971abbd45572722af5043a74ecf8a5bfd06adc9834ec90e4126a34c6ce982a1" => :yosemite
    sha256 "adc394a9e296003bc2bc88451c649aec019496cb6ed3d6673005fcd818ae44a5" => :mavericks
    sha256 "6ece1cb4b656f0f7ef1feab95ef6eb183e2f9ee2448c1e034de1a97d7f9da249" => :mountain_lion
  end

  keg_only :provided_by_osx

  option :universal

  # configure script fails to detect the right compiler when "cc" is
  # clang, not gcc. zlib mantainers have been notified of the issue.
  # See: https://github.com/Homebrew/homebrew-dupes/pull/228
  patch :DATA

  # http://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "http://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert File.exist?("foo.txt.z")
  end
end

__END__
diff --git a/configure b/configure
index b77a8a8..54f33f7 100755
--- a/configure
+++ b/configure
@@ -159,6 +159,7 @@ case "$cc" in
 esac
 case `$cc -v 2>&1` in
   *gcc*) gcc=1 ;;
+  *clang*) gcc=1 ;;
 esac
 
 show $cc -c $test.c

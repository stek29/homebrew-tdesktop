class OpusTd < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.1.tar.gz"
  sha256 "b9727015a58affcf3db527322bf8c4d2fcf39f5f6b8f15dbceca20206cbe1d95"

  keg_only "Only TDestkop needs this"

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]

    system "./configure", *args
    system "make", "install"
  end
end

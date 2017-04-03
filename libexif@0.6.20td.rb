class LibexifAT0620td < Formula
  desc "EXIF parsing library"
  homepage "https://libexif.sourceforge.io/"
  url "https://github.com/telegramdesktop/libexif-0.6.20.git",
    :revision => "5d4453c1f0a7a0c76336f16b6c6eef3f83c54058"

  keg_only "Because only tdesktop needs this"

  def install
    # This breaks everything :(
    # ENV.append "MACOSX_DEPLOYMENT_TARGET", "10.8"
    system "./configure", 
      "--prefix=#{prefix}", 
      "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <libexif/exif-loader.h>

      int main(int argc, char **argv) {
        ExifLoader *loader = exif_loader_new();
        ExifData *data;
        if (loader) {
          exif_loader_write_file(loader, argv[1]);
          data = exif_loader_get_data(loader);
          printf(data ? "Exif data loaded" : "No Exif data");
        }
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lexif
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    test_image = test_fixtures("test.jpg")
    assert_equal "No Exif data", shell_output("./test #{test_image}")
  end
end

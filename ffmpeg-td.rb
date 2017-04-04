class FfmpegTd < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-3.2.tar.bz2"
  sha256 "76d6cd9f5e64463a5b9940736da8a515c990bcbbe506a722e2040916cb366d74"

  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "lame"
  depends_on "x264"
  depends_on "xvid"
  depends_on "fdk-aac"
  depends_on "libass"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "theora"
  depends_on "sdl"

  keg_only "Only TDesktop needs this"
  
  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace %w[libavdevice/v4l2.c libavutil/time.c], "HAVE_CLOCK_GETTIME",
                                                         "UNDEFINED_GIBBERISH"
    end

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}

      --disable-doc
      --disable-programs
      --disable-everything
      --enable-protocol=file
      --enable-libopus
      --enable-decoder=aac
      --enable-decoder=aac_latm
      --enable-decoder=aasc
      --enable-decoder=flac
      --enable-decoder=gif
      --enable-decoder=h264
      --enable-decoder=h264_vda
      --enable-decoder=mp1
      --enable-decoder=mp1float
      --enable-decoder=mp2
      --enable-decoder=mp2float
      --enable-decoder=mp3
      --enable-decoder=mp3adu
      --enable-decoder=mp3adufloat
      --enable-decoder=mp3float
      --enable-decoder=mp3on4
      --enable-decoder=mp3on4float
      --enable-decoder=mpeg4
      --enable-decoder=msmpeg4v2
      --enable-decoder=msmpeg4v3
      --enable-decoder=opus
      --enable-decoder=vorbis
      --enable-decoder=wavpack
      --enable-decoder=wmalossless
      --enable-decoder=wmapro
      --enable-decoder=wmav1
      --enable-decoder=wmav2
      --enable-decoder=wmavoice
      --enable-encoder=libopus
      --enable-hwaccel=mpeg4_videotoolbox
      --enable-hwaccel=h264_vda
      --enable-hwaccel=h264_videotoolbox
      --enable-parser=aac
      --enable-parser=aac_latm
      --enable-parser=flac
      --enable-parser=h264
      --enable-parser=mpeg4video
      --enable-parser=mpegaudio
      --enable-parser=opus
      --enable-parser=vorbis
      --enable-demuxer=aac
      --enable-demuxer=flac
      --enable-demuxer=gif
      --enable-demuxer=h264
      --enable-demuxer=mov
      --enable-demuxer=mp3
      --enable-demuxer=ogg
      --enable-demuxer=wav
      --enable-muxer=ogg
      --enable-muxer=opus
    ]

    # # These librares are GPL-incompatible, and require ffmpeg be built with
    # # the "--enable-nonfree" flag, which produces unredistributable libraries
    # if %w[fdk-aac openssl].any? { |f| build.with? f }
      # args << "--enable-nonfree"
    # end

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    if MacOS.version < :yosemite || ENV.compiler == :clang
      args << "--enable-vda"
    else
      args << "--disable-vda"
    end

    # For 32-bit compilation under gcc 4.2, see:
    # https://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware::CPU.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace "config.mak" do |s|
        shflags = s.get_make_var "SHFLAGS"
        if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
          s.change_make_var! "SHFLAGS", shflags
        end
      end
    end

    system "make", "install"
  end
end

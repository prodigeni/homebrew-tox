require 'formula'

class Toxic < Formula
  head "git://github.com/Tox/toxic", :using => :git
  homepage "https://tox.im"

  depends_on "libtoxcore"
  depends_on "homebrew/dupes/ncurses"
  depends_on "freealut"
  depends_on "libconfig"

  option "without-audio", "Build toxic without audio call support"

  def install
    Dir.chdir("build")
    cflags = ["-DPACKAGE_DATADIR=\\\"/usr/local/Cellar/toxic/HEAD/share/toxic/\\\"", "-I/usr/local/opt/ncurses/include", "-I/usr/local/include"]
    ldflags = ["-L/usr/local/lib", "-L/usr/local/opt/ncurses/lib", "-lncursesw", "-ltoxcore", "-ltoxdns", "-lresolv", "-lalut", "-lconfig"]

    unless build.without? "audio"
      cflags.push "-framework OpenAL"
      ldflags.push "-ltoxav"
    end

    ENV["USER_CFLAGS"] = cflags.join " "
    ENV["USER_LDFLAGS"] = ldflags.join " "

    system "make", "PREFIX='#{prefix}'", "DISABLE_DESKTOP_NOTIFY=YES"
    system "make", "install", "PREFIX='#{prefix}'", "DISABLE_DESKTOP_NOTIFY=YES"
  end

  patch :DATA
end

__END__
diff --git a/cfg/check_features.mk b/cfg/check_features.mk
index 56d2210..a6b357d 100644
--- a/cfg/check_features.mk
+++ b/cfg/check_features.mk
@@ -1,10 +1,3 @@
-# Check if we can use X11
-CHECK_X11_LIBS = $(shell pkg-config x11 || echo -n "error")
-ifneq ($(CHECK_X11_LIBS), error)
-	LIBS += x11
-	CFLAGS += -D_X11
-endif
-
 # Check if we want build audio support
 AUDIO = $(shell if [ -z "$(DISABLE_AV)" ] || [ "$(DISABLE_AV)" = "0" ] ; then echo enabled ; else echo disabled ; fi)
 ifneq ($(AUDIO), disabled)


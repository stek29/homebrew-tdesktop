### 10.8 + Only! Tested on 10.12

# Contains:
 - [x] zlib 1.2.*11*: homebrew/core
 - [x] OpenSSL 1.0.*2*: homebrew/core 
 - [x] xz-5.*2.3*: homebrew/core
 - [x] libexif 0.6.2*1*: homebrew/core
 - [x] OpenAL Soft
 - [x] opus-1.1*.4*: homebrew/core
 - [x] pkg-config: homebrew/core 
 - [x] ffmpeg-3.2
 - [x] libiconv-1.1*5*: homebrew/core
 - [x] _Qt 5.6.2 patched_: I'm 100% sure I'm doing it wrong, but it works
 - [x] _gyp_: Needs `echo /usr/local/opt/gyp-td/lib/python2.7/site-packages >> /usr/local/lib/python2.7/site-packages/gyp-td.pth`
 - [ ] Google Crashpad: build it on your own following official instructions (except gyp PATH, take it from gyp-td installation)

# Installation:
 - Install [homebrew](https://brew.sh)
 - Tap this repo ( `brew tap stek29/tdesktop` ). Btw, after that repo would be cloned to `$(brew --repo stek29/tdesktop)`, and you could take patches and other stuff from there.
 - Install all the formulas, following order in official instructions:
   zlib, openssl, libexif, openal-soft*-td*, opus, ffmpeg-td, libiconv, qt5*-td* (this one would be really sloooooow), gyp*-td* (don't forget to add it to site-packages)
 - Apply gyp.diff patch to tdesktop
 - If you really want to get crashpad, clone depot\_tools to Libraries, and then follow official instructions starting at 'Build crashpad', but instead of `/Users/user/TBuild/Libraries/gyp` add `/usr/local/opt/gyp-td/bin` to PATH. Or you could try not to use crashpad.
 - If you don't want to, apply no\_crashpad.diff
 - I also highly recommend you to disable autoupdate by adding `TDESKTOP_DISABLE_AUTOUPDATE` in Telegram.gyp's defines

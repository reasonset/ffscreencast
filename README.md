# ffscreencast

Shorthand Zsh script that screen casting with ffmpeg for Linux/X11.

# Dependency

* Zsh
* FFmpeg
* xwininfo
* X Server
* ALSA (for audio recording)
* PulseAudio (for audio recording)
* Nvidia video card (for `nv*` options.)
* VA-API support (for `va*` options.)

# Usage

```
ffscreencast.zsh <format> [-w] [-m]
```

format is codec you want to use.
Avilable options are `x264`, `x264good`, `x265`, `vp8`, `vp9`, `nv264`, `nv265`, `va264`, `va265`.

`-w` option records only an window.
`-m` option records audio.

`x264`, `x265` options set paramater for as fast as possibile.
VP8, VP9 and other hardware accelarated options are for balanced (re-encoding needless) recording.

# Advance

If you want change paramater, change audio codec, and more,
you edit the script.

# Hint

`x264` or `x265` option makes huge videofile.
Screen recorded video is highly likely that it able to compress very.
You should re-encoding ourput video because it may be compressed 1/10 more.

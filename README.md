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
Avilable options are `x264`, `x265`, `vp8`, `vp9`, `nvfast`, `nv264`, `nv265`, `vafast`, `va264`, `va265`.

`-w` option records only an window.
`-m` option records audio.

`x264`, `x265`, `nvfast`, `vafast` options set paramater for possibility fastness.
`vp8`, `vp9` options are faster.
Other hardware accelarated options are for balanced (re-encoding needless) recording.

# Advance

If you want change paramater, change audio codec, and more,
you edit the script.
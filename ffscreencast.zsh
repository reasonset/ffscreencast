#!/bin/zsh

### Script settings.

mic_codec=libopus
mic_bitrate=256k
framerate=24
probing=(-analyzeduration 10M -probesize 100M)

### Set Save directory

typeset SAVE_DIR=$(xdg-user-dir VIDEOS)
if [[ -z "$SAVE_DIR" ]]
then
  SAVE_DIR=$HOME
fi

### video codec collection

video_x264=(-c:v libx264 -preset:v ultrafast -qp 0)
video_x264g=(-c:v libx264 -preset:v ultrafast -crf 24)
video_x265=(-c:v libx265 -preset:v ultrafast -qp 0)
video_vp8=(-c:v libvpx -qmin 4 -qmax 50 -crf 10)
video_vp9=(-c:v libvpx-vp9 -crf 31 -b:v 0)
video_nv264=(-c:v h264_nvenc -profile:v main -preset:v default -qp 23)
video_nv265=(-c:v hevc_nvenc -profile:v main -preset:v default -qp 27)
video_va264=(-vf 'format=nv12,hwupload' -c:v h264_vaapi -qp 23)
video_va265=(-vf 'format=nv12,hwupload' -c:v hevc_vaapi -qp 27)
ext="mkv"
typeset -a video_opts

# set

base_param=()

case $1 in
x264)
  video_opts=($video_x264)
  ;;
x264good)
  video_opts=($video_x264g)
  ;;
x265)
  video_opts=($video_x265)
  ;;
vp8)
  video_opts=($video_vp8)
  ;;
vp9)
  video_opts=($video_vp9)
  ;;
nvfast)
  video_opts=($video_nvfast)
  ;;
nv264)
  video_opts=($video_nv264)
  ;;
nv265)
  video_opts=($video_nv265)
  ;;
vafast)
  video_opts=($video_vafast)
  base_param=(-vaapi_device /dev/dri/renderD128)
  ext="mp4"
  ;;
va264)
  video_opts=($video_va264)
  base_param=(-vaapi_device /dev/dri/renderD128)
  ext="mp4"
  ;;
va265)
  video_opts=($video_va265)
  base_param=(-vaapi_device /dev/dri/renderD128)
  ;;
*)
  print 'You must set vcodec for $1.' >&2
  print 'Avilable formats: x264, x264good, x265, vp8, vp9, nv264, nv265, va264, va265.' >&2
  exit 1
esac
  

### CODE ###

even_round() {
  perl -n -e '/(\d+)(.)(\d+)/; print( $1 % 2 == 0 ? $1 : $1 - 1 ); print $2; print( $3 % 2 == 0 ? $3 : $3 - 1 )' <<< "$1"
}

integer wmode=0
typeset -a micarg=()

for i in "$@"
do
  #Window mode ( -w option. )
  if [[ $i == "-w" ]]
  then
    integer wmode=1
  fi
  
  #Pulse mic
  if [[ $i == "-m" ]]
  then
    mic_arg=(-f alsa -i pulse -c:a $mic_codec -b:a $mic_bitrate)
  fi
done

if (( wmode == 1 ))
then
  base_param+=(-show_region 1 -f x11grab)
  xwininfo=$(xwininfo -frame)
  geo=$(perl -n -e '/geometry (\d+x\d+)/; print $1;' <<< "$xwininfo")
  corn=$(perl -n -e  '/Corners:\s+\+(\d+)\+(\d+)/ && print $1 . "," . $2;' <<< "$xwininfo")
  
  ffmpeg $probing $base_param -video_size $(even_round $geo) -framerate $framerate -i "$DISPLAY+$(even_round $corn)" $mic_arg[@] $video_opts "$SAVE_DIR/$(date +"%y%m%d%H%M%S")".$ext
else
  base_param+=(-f x11grab)
  geo=$(xwininfo -root | perl -n -e '/geometry (\d+x\d+)/ && print $1;')
  ffmpeg $probing $base_param -video_size $(even_round $geo) -framerate $framerate -i "$DISPLAY" $mic_arg[@] $video_opts "$SAVE_DIR/$(date +"%y%m%d%H%M%S")".$ext
fi

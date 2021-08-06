#! /bin/bash

VS_VBR="1500k"
VS_FPS="60"
VS_QUALITY="fast"
VS_RTMP_SERVER="rtmp://a.rtmp.youtube.com/live2"
VS_AUDIO_SOURCE="http://xxx:8000/radio.mp3"
VS_VIDEO_SOURCE="./cover.gif"

KEY="xxx"


ffmpeg \
    -re -f lavfi -i "movie=filename=${VS_VIDEO_SOURCE}:loop=0, setpts=N/(FRAME_RATE*TB)" \
    -thread_queue_size 512 -i "${VS_AUDIO_SOURCE}" \
    -map 0:v:0 -map 1:a:0 \
    -map_metadata:g 1:g \
    -vcodec libx264 -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -preset ${VS_QUALITY} -r ${VS_FPS} -g $((${VS_FPS} * 2)) -b:v ${VS_VBR} \
    -acodec libmp3lame -ar 44100 -threads 6 -qscale:v 3 -b:a 320000 -bufsize 512k \
    -f flv "${VS_RTMP_SERVER}/$KEY"

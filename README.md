# FFmpeg Alpine

Alpine container with ffmpeg compiled with:

```
--enable-gpl
--enable-libfdk-aac
--enable-libmp3lame
--enable-libopus
--enable-libtheora
--enable-libvorbis
--enable-libvpx
--enable-libx264
--enable-libx265
--enable-nonfree
```

## Usage

Image meant to be used with multi stage builds as follows:

```Dockerfile
FROM vilsol/ffmpeg-alpine as build

FROM alpine:edge

# ffmpeg
COPY --from=build /root/bin/ffmpeg /bin/ffmpeg
COPY --from=build /root/bin/ffprobe /bin/ffprobe

# x265
COPY --from=build /usr/local/ /usr/local/

RUN apk add --no-cache \
	libtheora \
	libvorbis \
	x264-libs \
	fdk-aac \
	lame \
	opus \
	libvpx \
	libstdc++ \
	numactl \
	nasm
```
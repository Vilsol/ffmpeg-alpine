# FFmpeg Alpine

Alpine container with ffmpeg compiled with:

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

## Usage

Image meant to be used with multi stage builds as follows:

	FROM vilsol/ffmpeg-alpine as build

	FROM alpine

	RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

	RUN apk add --no-cache \
		libtheora \
		libvorbis \
		x264-libs \
		x265 \
		fdk-aac@testing \
		lame \
		opus \
		libvpx

	COPY --from=build /root/bin/ffmpeg /bin/ffmpeg
	COPY --from=build /root/bin/ffprobe /bin/ffprobe
	COPY --from=build /root/bin/ffserver /bin/ffserver
	COPY --from=build /root/bin/nasm /bin/nasm
	COPY --from=build /root/bin/ndisasm /bin/ndisasm
FROM alpine:edge as build

RUN set -x \
	&& apk add --no-cache \
		autoconf \
		automake \
		g++ \
		make \
		gcc \
		libc-dev \
		libtheora-dev \
		libtool \
		libvorbis-dev \
		pkgconfig \
		texinfo \
		wget \
		zlib-dev \
		yasm \
		x264-dev \
		fdk-aac-dev \
		lame-dev \
		opus-dev \
		libvpx-dev \
		coreutils \
		nasm \
		bash \
		cmake \
		git \
		numactl-dev \
	&& git clone --depth=1 --branch=3.3 https://bitbucket.org/multicoreware/x265_git.git ~/x265_git \
	&& cd ~/x265_git/build/linux \
	&& MAKEFLAGS="-j8" bash multilib.sh \
	&& cd 8bit \
	&& make install \
	&& cp libx265.so.* /usr/local/lib/ \
	&& cd ~/ \
	&& rm -rf ~/x265_git \
	&& mkdir ~/ffmpeg_sources \
	&& cd ~/ffmpeg_sources \
	&& wget -q http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
	&& tar xjf ffmpeg-snapshot.tar.bz2 \
	&& cd ffmpeg \
	&& PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--pkg-config-flags="--static" \
		--extra-cflags="-I$HOME/ffmpeg_build/include" \
		--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
		--bindir="$HOME/bin" \
		--enable-gpl \
		--enable-libfdk-aac \
		--enable-libmp3lame \
		--enable-libopus \
		--enable-libtheora \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libx264 \
		--enable-libx265 \
		--enable-nonfree \
		--disable-doc \
	&& PATH="$HOME/bin:$PATH" make -j8 \
	&& make install \
	&& hash -r \
	&& rm -rf ~/ffmpeg_sources \
	&& rm -rf ~/ffmpeg_build \
	&& rm -rf /usr/local/include \
	&& apk del \
		autoconf \
		automake \
		g++ \
		make \
		gcc \
		libc-dev \
		libtheora-dev \
		libtool \
		libvorbis-dev \
		pkgconfig \
		texinfo \
		wget \
		zlib-dev \
		yasm \
		x264-dev \
		fdk-aac-dev \
		lame-dev \
		opus-dev \
		libvpx-dev \
		coreutils \
		nasm \
		bash \
		cmake \
		git \
		numactl-dev
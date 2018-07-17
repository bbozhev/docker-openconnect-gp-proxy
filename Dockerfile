FROM debian:9-slim as builder
WORKDIR /openconnect
RUN apt update
RUN apt-get upgrade -y
RUN apt-get install -y \
	build-essential \ 
	gettext \
	autoconf \
	automake \
	libproxy-dev \
	libxml2-dev \
	libtool \
	vpnc-scripts \
	pkg-config \
	libgnutls28-dev \
	git \
	ocproxy \
	polipo
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/dlenski/openconnect.git /docker/openconnect
RUN cd /docker/openconnect \
	./autogen.sh \
	./configure \
	make \ 
	make install \
	ldconfig
ADD openconnect-gp-proxy.sh /docker/openconnect-gp-proxy.sh
ADD hipreport.sh /docker/hipreport.sh
ENTRYPOINT ["/docker/openconnect-gp-proxy.sh"]

# Expose port 8123 for the polipo authenticating http proxy 
EXPOSE 8123

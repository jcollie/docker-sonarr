FROM registry.fedoraproject.org/fedora:31

ENV LANG C.UTF-8

RUN dnf -y update && \
    rm -rf /usr/share/doc /usr/share/man /var/cache/dnf

RUN dnf -y install bind-utils curl gettext libmediainfo libzen mono-devel sqlite && \
    rm -rf /usr/share/doc /usr/share/man /var/cache/dnf

RUN groupadd -g 5000 media
RUN useradd -u 5000 -g 5000 -d /source -M media

RUN mkdir /source /torrent /usenet /drone /config

ENV XDG_CONFIG_HOME /config
ENV HOME /config

VOLUME /media
VOLUME /torrent
VOLUME /usenet
VOLUME /drone
VOLUME /config

EXPOSE 8989

ARG BRANCH=phantom-develop
ARG VERSION=3.0.3.892

RUN curl -o /tmp/Sonarr.tar.gz http://download.sonarr.tv/v3/phantom-develop/${VERSION}/Sonarr.phantom-develop.${VERSION}.linux.tar.gz && \
    tar --extract --file /tmp/Sonarr.tar.gz --directory /source --strip-components 1 && \
    rm /tmp/Sonarr.tar.gz

CMD ["/usr/bin/mono", "/source/Sonarr.exe", "-nobrowser", "-data=/config"]

FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-inspircd"

RUN apt-get update && \
	apt-get -y install --no-install-recommends gnutls-bin iproute2 curl && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/inspircd
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="inspircd"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 6667 6697 7000 7001

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
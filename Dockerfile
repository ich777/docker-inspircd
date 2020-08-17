FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

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
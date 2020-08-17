FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends gnutls-bin iproute2 curl && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/inspircd
ENV INSP_NET_SUFFIX=".example.com"
ENV INSP_NET_NAME="Omega"
ENV INSP_ADMIN_NAME="Jonny English"
ENV INSP_ADMIN_NICK="MI5"
ENV INSP_ADMIN_EMAIL="jonny.english@example.com"
ENV INSP_ENABLE_DNSBL="yes"
ENV INSP_CONNECT_PASSWORD="SUPERSECRET"
ENV INSP_CONNECT_HASH="hmac-sha256"
ENV INSP_OPER_NAME="oper"
ENV INSP_OPER_PASSWORD_HASH="SUPERSECRET"
ENV INSP_OPER_HOST="*@*"
ENV INSP_OPER_HASH="hmac-sha256"
ENV INSP_OPER_SSLONLY="yes"
ENV INSP_TLS_CN="irc.example.com"
ENV INSP_TLS_MAIL="nomail@example.com"
ENV INSP_TLS_UNIT="Server Admins"
ENV INSP_TLS_ORG="Example IRC Network"
ENV INSP_TLS_LOC="Example City"
ENV INSP_TLS_STATE="Example State"
ENV INSP_TLS_COUNTRY="XZ"
ENV INSP_TLS_DURATION="365"
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
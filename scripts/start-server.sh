#!/bin/bash
INSPIRCD_ROOT="${DATA_DIR}"

LAT_V="$(curl -s https://api.github.com/repos/ich777/inspircd/releases/latest | grep tag_name | cut -d '"' -f4)"
CUR_V="$(${DATA_DIR}/bin/inspircd --version 2>/dev/null | grep "InspIRCd-" | cut -d '-' -f2)"
if [ -z $LAT_V ]; then
	if [ -z $CUR_V ]; then
		echo "---Can't get latest version of InspIRCd, falling back to v3.7.0---"
		LAT_V="3.7.0"
	else
		echo "---Can't get latest version of InspIRCd, falling back to v$CUR_V---"
	fi
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
	echo "---InspIRCd not found, downloading and installing v$LAT_V...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz "https://github.com/ich777/inspircd/releases/download/$LAT_V/InspIRCd-v$LAT_V.tar.gz" ; then
		echo "---Successfully downloaded InspIRCd v$LAT_V---"
	else
		echo "---Something went wrong, can't download InspIRCd v$LAT_V, putting container into sleep mode!---"
		sleep infinity
	fi
	tar -C ${DATA_DIR} --strip-components=1 -xf ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz
	rm ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz
elif [ "$CUR_V" != "$LAT_V" ]; then
	echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz "https://github.com/ich777/inspircd/releases/download/$LAT_V/InspIRCd-v$LAT_V.tar.gz" ; then
		echo "---Successfully downloaded InspIRCd v$LAT_V---"
	else
		echo "---Something went wrong, can't download InspIRCd v$LAT_V, putting container into sleep mode!---"
		sleep infinity
	fi
	echo "---Moving configruation---"
	mv ${DATA_DIR}/conf/ /tmp/
	tar -C ${DATA_DIR} --strip-components=1 --overwrite -xf ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz
	rm ${DATA_DIR}/InspIRCd-v$LAT_V.tar.gz
	echo "---Restoring configuration---"
	rm -R ${DATA_DIR}/conf
	mv /tmp/conf/ ${DATA_DIR}/
elif [ "$CUR_V" == "$LAT_V" ]; then
	echo "---InspIRCd v$CUR_V up-to-date---"
fi

echo "---Prepare Server---"
echo "---Checking if TLS Certificate is in place...---"
if [ ! -e $INSPIRCD_ROOT/conf/cert.pem ] && [ ! -e $INSPIRCD_ROOT/conf/key.pem ]; then
    echo "---TLS Certificate not found, generating please wait!---"
    cat > /tmp/cert.template <<EOF
cn              = "${INSP_TLS_CN:-irc.example.com}"
email           = "${INSP_TLS_MAIL:-nomail@irc.example.com}"
unit            = "${INSP_TLS_UNIT:-Example Server Admins}"
organization    = "${INSP_TLS_ORG:-Example IRC Network}"
locality        = "${INSP_TLS_LOC:-Example City}"
state           = "${INSP_TLS_STATE:-Example State}"
country         = "${INSP_TLS_COUNTRY:-XZ}"
expiration_days = ${INSP_TLS_DURATION:-365}
tls_www_client
tls_www_server
signing_key
encryption_key
cert_signing_key
crl_signing_key
code_signing_key
ocsp_signing_key
time_stamping_key
EOF
    /usr/bin/certtool --generate-privkey --bits 4096 --sec-param normal --outfile $INSPIRCD_ROOT/conf/key.pem
    /usr/bin/certtool --generate-self-signed --load-privkey $INSPIRCD_ROOT/conf/key.pem --outfile $INSPIRCD_ROOT/conf/cert.pem --template /tmp/cert.template
    rm /tmp/cert.template
else
    echo "---TLS Certificate found, continuing!---"
fi

echo "---Checking if Diffie–Hellman parameters file is in place...---"
if [ ! -e $INSPIRCD_ROOT/conf/dhparams.pem ]; then
    echo "---Diffie–Hellman parameters file not in place, generating please wait---"
    /usr/bin/certtool --generate-dh-params --sec-param normal --outfile $INSPIRCD_ROOT/conf/dhparams.pem
else
    echo "---Diffie–Hellman parameters file found, continuing!---"
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Starting InspIRCd---"
cd $INSPIRCD_ROOT
$INSPIRCD_ROOT/bin/inspircd --nofork $@
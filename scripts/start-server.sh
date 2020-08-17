#!/bin/bash
INSPIRCD_ROOT="${DATA_DIR}"
sleep infinity

## TODO
cd ${DATA_DIR}
wget -q -nc --show-progress --progress=bar:force:noscroll -O OUTPUT "URL"
tar -C ${DATA_DIR} --strip-components=1 -xf ${DATA_DIR}/InspIRCd-v*.tar.gz
rm ${DATA_DIR}/InspIRCd-v*.tar.gz

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

echo "---Starting InspIRCd---"
cd $INSPIRCD_ROOT
$INSPIRCD_ROOT/bin/inspircd --nofork $@
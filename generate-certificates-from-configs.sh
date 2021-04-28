#!/bin/bash

rm certs/*

# variables
DH_STRONG=certs/dh-strong.pem
SERIAL=certs/serial
DB=certs/index.txt
CA_CERT_PEM=certs/cacert.pem
CA_CERT_CRT=certs/cacert.crt
TMP_KEY=certs/tempkey.pem
TMP_REQ=certs/tempreq.pem
SERVER_KEY=certs/server_key.pem
SERVER_CRT=certs/server_crt.pem

CA_CONF=caconfig.cnf
LOCALHOST_CONF=localhost.cnf
DAYS=1825

# Create the Certificate Database
echo '01' > $SERIAL && touch $DB

# Create the CA
openssl req -x509 -newkey rsa:2048 -days $DAYS -config $CA_CONF -outform PEM -out $CA_CERT_PEM
openssl x509 -in $CA_CERT_PEM -out $CA_CERT_CRT

# Create the localhost certs
openssl req -newkey rsa:2048 -config $LOCALHOST_CONF -keyout $TMP_KEY -keyform PEM -outform PEM -out $TMP_REQ
openssl rsa < $TMP_KEY > $SERVER_KEY

# Sign the localhost cert
openssl ca -in $TMP_REQ -out $SERVER_CRT -config $CA_CONF

echo
echo "Creating Diffie-Hellman strong key"
openssl dhparam -out $DH_STRONG 2048
echo "Done."

echo ""
echo "----- Don't forget to open your browser and install your CA cert -----"
echo ""

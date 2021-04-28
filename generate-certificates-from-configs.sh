#!/bin/bash

## This file is experimental. I do not promise that it will work for you.

rm certs/*

# variables
DH_STRONG=certs/dh-strong.pem
SERIAL=certs/serial
DB=certs/index.txt
CA_CERT_PEM=certs/cacert.pem
CA_CERT_CRT=certs/cacert.crt
TMP_KEY=certs/temp.key
TMP_REQ=certs/temp.req
SERVER_KEY=certs/server.key
SERVER_CRT=certs/server.crt

CA_CONF=caconfig.cnf
LOCALHOST_CONF=localhost.cnf

# Create the Certificate Database
echo '01' > $SERIAL && touch $DB

# Create the CA
openssl req -x509 -newkey rsa -config $CA_CONF -out $CA_CERT_PEM
openssl x509 -in $CA_CERT_PEM -out $CA_CERT_CRT

# Create the server key
openssl req -newkey rsa -config $LOCALHOST_CONF -keyout $TMP_KEY -out $TMP_REQ
openssl rsa < $TMP_KEY > $SERVER_KEY

# Sign the server cert
openssl ca -in $TMP_REQ -config $CA_CONF -out $SERVER_CRT

# echo
# echo "Creating Diffie-Hellman strong key"
# openssl dhparam -out $DH_STRONG 2048
# echo "Done."

echo ""
echo "----- Don't forget to open your browser and install your CA cert -----"
echo ""

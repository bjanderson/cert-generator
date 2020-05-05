#!/bin/bash

# guidance from https://www.sslshopper.com/article-most-common-openssl-commands.html
# and https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec

rm certs/*

# set values for certificate DNs
# note: CN is set to different values in the sections below
ORG="000_DEV_ORG"

# set values that the commands will share
CA_CRT=certs/ca.crt
CA_KEY=certs/ca.key
CA_SRL=certs/ca.srl

SERVER_CRT=certs/server.crt
SERVER_CSR=certs/server.csr
SERVER_KEY=certs/server.key

LOCALHOST_CRT=certs/localhost.crt
LOCALHOST_CSR=certs/localhost.csr
LOCALHOST_KEY=certs/localhost.key

USER_CRT=certs/user.crt
USER_CSR=certs/user.csr
USER_KEY=certs/user.key
USER_P12=certs/user.p12

DH_STRONG=dh-strong.pem

V3_EXT=v3.ext
KEY_BITS=2048
VALID_DAYS=360

##################################
# ROOT CERTIFICATE AUTHORITY
##################################
echo
echo "Create CA certificate..."
CN="DEV CA"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:$KEY_BITS -out $CA_KEY
openssl req -new -x509 -days $VALID_DAYS -key $CA_KEY -subj "/CN=$CN/O=$ORG" -out $CA_CRT
echo "Done."

##################################
# SERVER CERTIFICATE
##################################
echo
echo "Creating server certificate..."
CN="000_DEV_SERVER"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:$KEY_BITS -out $SERVER_KEY
openssl req -new -key $SERVER_KEY -subj "/CN=$CN/O=$ORG" -out $SERVER_CSR
openssl x509 -days $VALID_DAYS -req -in $SERVER_CSR -CAcreateserial -CA $CA_CRT -CAkey $CA_KEY -out $SERVER_CRT  -extfile $V3_EXT
echo "Done."

##################################
# LOCALHOST CERTIFICATE
##################################
echo
echo "Creating localhost certificate..."
CN="localhost"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:$KEY_BITS -out $LOCALHOST_KEY
openssl req -new -key $LOCALHOST_KEY -subj "/CN=$CN/O=$ORG" -out $LOCALHOST_CSR
openssl x509 -days $VALID_DAYS -req -in $LOCALHOST_CSR -CAcreateserial -CA $CA_CRT -CAkey $CA_KEY -out $LOCALHOST_CRT  -extfile $V3_EXT
echo "Done."

##################################
# USER CERTIFICATE
##################################

echo
echo "Creating user certificate..."
CN="000_DEV_USER"
USER_ID="testuser1"
P12_PASSWORD=
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:$KEY_BITS -out $USER_KEY
openssl req -new -key $USER_KEY -subj "/CN=$CN/O=$ORG/UID=$USER_ID" -out $USER_CSR
openssl x509 -days $VALID_DAYS -req -in $USER_CSR -CAcreateserial -CA $CA_CRT -CAkey $CA_KEY -out $USER_CRT -extfile $V3_EXT
openssl pkcs12 -in $USER_CRT -inkey $USER_KEY -export -password pass:$P12_PASSWORD -out $USER_P12
echo "Done."

##################################
# DH STRONG
##################################

echo
echo "Creating Diffie-Hellman strong key..."
openssl dhparam -out $DH_STRONG 2048
echo "Done."

echo
echo "----- Don't forget to open your browser and install your $CA_CRT and $USER_P12 certificates -----"
echo

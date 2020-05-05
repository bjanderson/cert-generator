#!/bin/bash

rm *.pem
rm *.crt
rm serial*
rm index.txt*

# variables
DH_STRONG=dh-strong.pem

# Create the Certificate Database
echo '01' > serial && touch index.txt

# Create the CA
openssl req -x509 -newkey rsa:2048 -out cacert.pem -outform PEM -days 1825 -config caconfig.cnf
openssl x509 -in cacert.pem -out cacert.crt

# Create the localhost certs
openssl req -newkey rsa:2048 -keyout tempkey.pem -keyform PEM -out tempreq.pem -outform PEM -config localhost.cnf
openssl rsa < tempkey.pem > server_key.pem

# Sign the localhost cert
openssl ca -in tempreq.pem -out server_crt.pem -config caconfig.cnf


echo
echo "Creating Diffie-Hellman strong key"
openssl dhparam -out $DH_STRONG 2048
echo "Done."

echo
echo "----- Don't forget to open your browser and install your CA cert -----"
echo

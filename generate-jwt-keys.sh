#!/bin/bash

JWT_PRIVATE=certs/jwtRS256.key
JWT_PUBLIC=certs/jwtRS256.key.pub

rm $JWT_PRIVATE
rm $JWT_PUBLIC

ssh-keygen -t rsa -b 2048 -f $JWT_PRIVATE

# Don't add passphrase

openssl rsa -in $JWT_PRIVATE -pubout -outform PEM -out $JWT_PUBLIC

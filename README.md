These are bash scripts, which are intended to be run in a linux environment.

To run the scripts you need to have openssl installed.

The first time you run the scripts you might need to make them executable, so run:

    chmod 755 generate-certs.sh
    chmod 755 generate-jwt-keys.sh

To run the scripts just type:

    ./generate-certs.sh

or

    ./generate-jwt-keys.sh

respectively.

-----

Note: generate-certificates-from-configs.sh is experimental and probably won't work for you.

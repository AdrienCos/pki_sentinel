# Sentinel PKI generator

This repo hosts all the code used to simpliy the generation of SSL certificates for the experiemntal setup of Sentinel. The private keys of the CA and the client certificates have been willingly added to the repo, as this SSL network is only intended to be used for experimental purposes. 

## How to use it

* (Optional) To create a brand new key hierarchy, create a new folder `$CA_DIR`, copy `example-ca/config` to it and edit it to match your needed config

* (Optional) Generate your CA key by runnning `./scripts/new-ca.sh $CA_DIR $CA_HUMAN_NAME`

* Generate a new client key with `./scripts/new-client.sh $CA_DIR $CERT_NAME`
    * For a server key, replace `new-client.sh` with `new-server.sh`

* Sign the client/server certificate with `./scripts/sign-end.sh $CA_DIR $TYPE $CERT_NAME`

* (Optional) Verify your signed certificate with `openssl verify -CAfile $CA_DIR/$CA_DIR $CA_DIR/$TYPE/$CERT_NAME`
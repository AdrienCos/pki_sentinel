#!/bin/bash
# Sign an client/server CSR using a yubikey

# Setup openssl path and use opensc-pkcs11 to interact with yubikey
# OPENSSL_BIN=`which openssl`
#OPENSSL_ENGINE="engine dynamic -pre SO_PATH:/usr/local/lib/engines/engine_pkcs11.so -pre ID:pkcs11 \
#    -pre LIST_ADD:1 -pre LOAD -pre MODULE_PATH:/usr/local/lib/opensc-pkcs11.so"

if [ "$#" -ne 3 ]; then 
    echo "Usage: $0 CA_NAME TYPE END_NAME"
    echo "Where TYPE is client or server as appropriate"
    exit
fi

# Setup variables
export DIR=$1
export TYPE=$2
export END_NAME=$3

set -e


# Load config
. $DIR/config

# Load helpers
. ./scripts/common.sh


if [[ "$OSTYPE" == "linux-gnu" ]]; then
    CONFIG="scripts/engine-nix.conf"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG="scripts/engine-osx.conf"
fi

echo "Signing end certificate: $DIR/$TYPE/$END_NAME.crt"

set -e

# Run sign command
$OPENSSL_BIN x509 -CAkey $DIR/$DIR.key \
    -sha512 -CA $DIR/$DIR.crt -req -extensions v3_req -extfile $DIR/$TYPE/$END_NAME.conf \
    -in $DIR/$TYPE/$END_NAME.csr -days=$EXPIRY_DAYS -out $DIR/$TYPE/$END_NAME.crt



echo "Signed end certificate: $DIR/$TYPE/$END_NAME.crt"

echo "Appended $DIR/$DIR.crt to $DIR/$TYPE/$END_NAME.crt"
cat $DIR/$DIR.crt >> $DIR/$TYPE/$END_NAME.crt

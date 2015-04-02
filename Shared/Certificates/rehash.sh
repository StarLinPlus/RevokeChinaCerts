#!/bin/bash

SOURCE_DIR=$(dirname "$0")

pushd "$SOURCE_DIR" >/dev/null

for pem in $(ls *.pem); do
  mv "$pem" "$(openssl x509 -in "$pem" -noout -sha1 -fingerprint | sed -e 's/^.*=//g' -e 's/://g').pem"
done

for severity in High Medium Low; do
  for pem in $(cat "Severity.${severity}.txt"); do
    echo "${pem}.pem"
    echo "--------------------------------------------"
    echo
    openssl x509 -in "${pem}.pem" -noout -text -nameopt oneline,utf8,-esc_msb -certopt no_header,no_validity,no_sigdump,ext_error | sed -e '/Modulus/,/Exponent/d'
    echo
    echo
    echo
  done > "Severity.${severity}.md"
done

popd >/dev/null

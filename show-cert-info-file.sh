#!/bin/bash
if [ $# -ne 1 ]; then
  >&2 echo "Usage: $0 /path/to/cert_file"
  exit 1
fi

cert_file="$1"
certs=$(cat $cert_file)
count=$(echo "$certs" | grep -c '^-----BEGIN CERTIFICATE-----')
i=1
while [ $i -le $count ]; do
  echo === cert $i ===
  echo "$certs" | awk '/^-----BEGIN CERTIFICATE-----/ {cert_id++}
/^-----BEGIN CERTIFICATE-----/,/^-----END CERTIFICATE-----/ {if (cert_id==target_cert_id) print}' target_cert_id=$i \
  | openssl x509 -dates -subject -subject_hash -ext subjectAltName -issuer -issuer_hash -noout

  i=$(( $i + 1 ))
done

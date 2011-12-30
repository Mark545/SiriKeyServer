#!/usr/bin/env bash

if [ "${commonName}" == "" ]
then
  commonName="SiriKeyServer"
fi

# Feel free to change any of these
countryName="US"
stateOrProvinceName="California"
localityName=""
organizationName="Siri Key Server --> Firebolt 55439 Github"
organizationalUnitName=""
emailAddress=""

echo "IMPORTANT! If You Are Asked For A Password, Just Enter The Word pass "
echo "EVEN MORE IMPORTANT! As The Common Name For The Certificates, Type This: "
echo "guzzoni.apple.com [For Common Name When Asked]"
sleep 2
openssl genrsa -des3 -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.crt
openssl genrsa -des3 -out server.key 4096
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.passless.crt
openssl rsa -in server.key -out server.key.insecure
mv server.key server.key.secure
mv server.key.insecure server.passless.key

echo "Done!"
echo "--> Made By Firebolt55439  On Github <--"
echo "-------------------------------------------------------------"
echo ""
echo "Please install server.passless.crt onto your phone!"
echo "You can do this by emailing the file to yourself Or With The iPhone Configuration Utility"
echo ""
echo "-------------------------------------------------------------"
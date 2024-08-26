#!/bin/sh

idp_certificate=$(sed 's/.*CERTIFICATE-*\(.*\)-*.*$/\1/g' keys/idp.crt \
               | tr -d ' \n')
sp_certificate=$(sed 's/.*CERTIFICATE-*\(.*\)-*.*$/\1/g' keys/sp.crt \
               | tr -d ' \n')
sp_privkey="$(cat keys/sp.key)"

duo_url=$1
nso_url=$2

sed "s#@IDP_CERTIFICATE@#$idp_certificate#g" cisco-nso-saml2-auth.xml.template \
| sed "s#@SP_CERTIFICATE@#$sp_certificate#g" \
| sed "s#@DUO_METAURL@#$duo_url#g" \
| sed "s#@NSO_URL@#$nso_url#g" \
| gawk -v r="$sp_privkey" '{gsub(/@SP_PRIVKEY@/,r)}1' \
> cisco-nso-saml2-auth.xml

cp cisco-nso-saml2-auth.xml NSO-vol/NSO1/run/.
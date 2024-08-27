# NSO SSO DUO Intergration PoC - Containerized
This repository is a demo code for the integration of DUO and NSO SSO with NSO Containerized NSO installation. This example is setup with Assertion Encryption/Decryption. You may also find a repository with native installation version below.
* Native Example: https://github.com/NSO-developer/nso-sso-duo-integration---containerzed-nso 
* Duo Integration Package: https://github.com/NSO-developer/nso-sso-duo-integration-package 

## Prerequisites
The following must be done before using the repository  
1. Setup a duo admin account. If you do not have one, you can apply for 30 days trail on https://duo.com/. 
2. Install Microsoft Server 2019 and setup on-prem Active Directory - AD with Domain Service and LDAP enabled. Otherwise have one of the SAML2.0 Cloud IDP like Microsoft EntraID(Azure AD).
3. If you are using on-prem AD, install DUO proxy with the guide - https://duo.com/docs/authproxy-reference and connect on-prem AD to the DUO with the guide - https://duo.com/docs/sso#active-directory
Sample Config of the Duo Proxy can be found as below  
```
[main]
debug=true

[ad_client]
host=1.1.11.1
service_account_username="nsoduossotest\administrator"
service_account_password=password
search_dn=OU=nso,DC=nsoduossotest,DC=com
auth_type=plain
bind_dn=uid=administrator,dc=nsoduossotest,dc=com
username_attribute=uid

[sso]
rikey=1234567
service_account_username=nsoduossotest\administrator
service_account_password=

[cloud]
ikey=1234567
skey=1234567
api_host=api.com
service_account_username=nsoduossotest\administrator
service_account_password=password
```
4. Remember to setup user on AD in different Orgnization. The organization must be under the "search_dn" otherwise the domain is not possible to lookup.
For full AD setup consider to read the following guide
https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/authentication/find_ad_search_base_c.html
https://www.cloudns.net/
https://techcommunity.microsoft.com/t5/sql-server-blog/step-by-step-guide-to-setup-ldaps-on-windows-server/ba-p/385362
https://www.youtube.com/watch?v=MHsI8hJmggI&t=1412s
If all connection between AD and DUO works fine. We can get started with setup the DUO to NSO SSO  

Consider to watch the following video before setup the DUO SSO - https://www.youtube.com/watch?v=-7lchiP9V3o&t=745s  

5. Enter DUO SSO configuration process in the admin panel by choosing "Protect an Application" -> "Generic SAML Service Provider" 
6. Obtain two URL 
First one is the DUO Meta data URL(DUO_URL). You can get this URL from the DUO SSO configuration - https://duo.com/docs/sso-generic
Second one is NSO web interface public access URL(NSO_URL). This URL cannot be localhost or any internal access IP/URL. It must be accessable via external network. If you cannot do that, consider use ngrok as container - https://hub.docker.com/r/ngrok/ngrok.
7. Finish rest of the step from the guide  - https://duo.com/docs/sso-generic
Now we can get started with the NSO configuration through our PoC code here.  

## Tested Enviorment
NSO Version: >=6.3.0

## Use the PoC code.
1. For this demo we included the NSO 6.3.1 container images in ./images. To start the demo:
```
DUO_URL="<DUO_URL>" NSO_URL="<NSO_URL>" make clean all
```
2. Test the setup by enter your NSO_URL in the browser.
3. Click on cisco-nso-saml2-auth to enter the SAML SSO phase.
If you ever see "No Auth Method", it means the scripts/authenticate python script has crashed due to some misconfiguration or bug in the packages. Troubleshoot by using "logger.info()" function. The log will be print into the "NSO-log-vol/NSO1/ncs-python-saml2-auth.log"  
4. If everything works fine, the SAML with enter ACS phase than redirect to the NSO WebUI One. 

### Guide and Demo Video
* Deployment Guide: [Deployment Guide](https://github.com/NSO-developer/nso-sso-duo-integration---containerzed-nso/blob/main/extra/doc/DUO%20Deployment%20Guide.pdf)
* Native: [NSO SSO DUO Integration - Native](https://youtu.be/V-BlBHqbHPw)
* Containerized NSO:  [NSO SSO DUO Integration - Containerized](https://youtu.be/oZaoPolIBWA)


### Copyright and License Notice
``` 
Copyright (c) 2024 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
``` 
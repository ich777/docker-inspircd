# InspIRCd in Docker optimized for Unraid

InspIRCd is a modular Internet Relay Chat (IRC) server written in C++

It was created from scratch to be stable, modern and lightweight. It provides a tunable number of features through the use of an advanced but well documented module system. By keeping core functionality to a minimum we hope to increase the stability, security and speed of InspIRCd while also making it customisable to the needs of many different users.

**NOTE:** If you want to change the hostname turn on 'Advanced View' and at the 'Extra-Parameters' change '--hostname=YOURPREFERREDHOSTNAME'

The container will create a TLS certificate at first start or if the certificate isn't found in the 'conf/' directory, after it is created you can import your own certificate.

**HASH CREATION NOTICE:** Read the discription from the variable 'Operator Password Hash' how to create the hash from your password.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /nzbhydra2 |
| INSP_NET_SUFFIX | Suffix used behind the server name (in this format '.example.com') | .example.com |
| INSP_NET_NAME | Name advertised as network name | InspIRCD |
| INSP_ADMIN_NAME | Name showed by the /admin command | Jonny English |
| INSP_ADMIN_NICK | Nick showed by the /admin command | MI5 |
| INSP_ADMIN_EMAIL | E-mail shown by the /admin command | jonny.english@example.com |
| INSP_ENABLE_DNSBL | Set to no to disable DNSBLs (DNS-based block list - set to 'yes' or 'no') | yes |
| INSP_CONNECT_PASSWORD | Password either as plaintext, or hash value - if you don't want a password leave this variable empty (Make sure you escape special chars like $ or & if needed) | empty |
| INSP_CONNECT_HASH | Hashing algorithm for the Connection Password - if you don't entered a password leave this variable empty (e.g. hmac-sha256, hmac-md5, hmac-ripemd160, md5, ripemd160, sha256) | empty |
| INSP_OPER_NAME | Oper name | oper |
| INSP_OPER_HOST | Hosts allowed to oper up (If you don't want to connect OP's from outside change for example to '*@localhost' or what your hostname matches that the OP should connect) | *@* |
| INSP_OPER_PASSWORD_HASH | Hash value for your oper password hash (to generate a password hash create the server without the hash, connect to the InspIRCd and type in: '/mkpasswd HASHMALGORITHM PASSORD' eg: '/mkpasswd hmac-sha256 superstronpassword') | YOURHASHEDPWD |
| INSP_OPER_HASH | Hashing algorithm for the Operator Password - if you don't entered a password leave this variable empty (e.g. hmac-sha256, hmac-md5, hmac-ripemd160, md5, ripemd160, sha256) | hmac-sha256 |
| INSP_OPER_SSLONLY | Allow oper up only while using TLS (set to 'yes' or 'no') | yes |
| INSP_TLS_CN | Common name of the certificate | irc.example.com |
| INSP_TLS_MAIL | Mail address represented in the certificate | nomail@example.com |
| INSP_TLS_UNIT | Unit responsible for the service | Server Admins |
| INSP_TLS_ORG | Organisation name | Example IRC Network |
| INSP_TLS_LOC | City name | Example City |
| INSP_TLS_STATE | State name | Example State |
| INSP_TLS_COUNTRY | Country Code by ISO 3166-1 (to get the country code visit: https://en.wikipedia.org/wiki/ISO_3166-1) | XZ |
| INSP_TLS_DURATION | Duration until the certificate expires | 365 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name InspIRCd -d \
	-p 6667:6667 -p 6697:6697 -p 7000:7000 -p 7001:7001 \
	--env 'INSP_NET_SUFFIX=.example.com' \
	--env 'INSP_NET_NAME=InspIRCD' \
	--env 'INSP_ADMIN_NAME=Jonny English' \
	--env 'INSP_ADMIN_NICK=MI5' \
	--env 'INSP_ADMIN_EMAIL=jonny.english@example.com' \
	--env 'INSP_ENABLE_DNSBL=yes' \
	--env 'INSP_OPER_NAME=oper' \
	--env 'INSP_OPER_HOST=*@*' \
	--env 'INSP_OPER_PASSWORD_HASH=YOURHASHEDPWD' \
	--env 'INSP_OPER_HASH=hmac-sha256' \
	--env 'INSP_OPER_SSLONLY=yes' \
	--env 'INSP_TLS_CN=irc.example.com' \
	--env 'INSP_TLS_MAIL=nomail@example.com' \
	--env 'INSP_TLS_UNIT=Server Admins' \
	--env 'INSP_TLS_ORG=Example IRC Network' \
	--env 'INSP_TLS_LOC=Example City' \
	--env 'INSP_TLS_STATE=Example State' \
	--env 'INSP_TLS_COUNTRY=XZ' \
	--env 'INSP_TLS_DURATION=365' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /path/to/inspircd:/inspircd \
	ich777/inspircd
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!
 
#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/
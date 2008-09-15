#!/bin/bash
#
# Check that the CERT is writable and of the wrong size and we aint' full
#

CERT=/usr/share/rhn/RHNS-CA-CERT
BACKUP=$CERT.old

TARGET_MD5=383e79587bd29deb4c5fd6039d981657

verify_cert() {
    FILE=$1

    [ ! -e $FILE ] && return 1

    MD5=$(md5sum $FILE | cut -d' ' -f 1)
    [ "$MD5" != "$TARGET_MD5" ] && return 1

    return 0
}

test_ssl() {
    cat <<EOF | python
import sys
import socket

try:
    from rhn import rpclib
except ImportError:
    import xmlrpclib
    rpclib = xmlrpclib

ServerURL = "https://xmlrpc.rhn.redhat.com/XMLRPC"
CAFile = "$CERT"

Server = rpclib.Server(ServerURL)
try:
    Server.use_CA_chain(CAFile)
except NotImplementedError:
    Server.add_trusted_cert(CAFile)

print "Testing SSL connectivity against %s ..." % (ServerURL,)

try:
    ret = Server.registration.welcome_message()
except socket.sslerror:
    print """
    Connectivity test ERROR: SSL Handshake failed

    This error can be caused by one or more of the following:
    - failure to update the RHN Certificate Authority file, which is
      located at $CERT
    - the time/date on this computer is out of sync. Please check your
      system's time and update it accordingly.

    Despite this error, the file $CERT
    has been updated to allow 'up2date' and 'rhn_register' to function
    properly.  Should you choose, you may restore a backup of your
    previous cert from the $BACKUP file.
    """
    ret = None
except:
    print """
    Connectivity test ERROR: Failed to connect to server

    This error can be caused by one or more of the following:
    - lack on Internet connectivity;
    - running behind a proxy server. Please try running up2date
      instead to test SSL functionality.

    Despite this error, the file $CERT
    has been updated to allow 'up2date' and 'rhn_register' to function
    properly.  Should you choose, you may restore a backup of your
    previous cert from the $BACKUP file.
    """
    ret = None

if not ret:
    sys.exit(1)

print "Connectivity OK, test succeeded"
EOF
}


if [ ! -w $CERT ] ; then
    echo The script cannot write to $CERT
    echo 'Please run the command as root (in a shell -- use the "su" command)'
    exit 1
fi

if [ "`df /usr/share/rhn | grep '100%'`" != "" ] ; then
    echo The partition containing /usr/share/rhn/ is full.
    echo The script cannot be run, please free some space first.
    exit 1
fi

if verify_cert $CERT ; then
    echo "The file $CERT has already been updated."
    echo "No further action is necessary."
    exit 0
fi

if [ -e $BACKUP -a ! -w $BACKUP ]; then
  echo "Unable to create backup file: $BACKUP"
  exit 1
elif [ ! -e $BACKUP -a ! -w $(dirname $BACKUP) ]; then
  echo "Unable to create backup file: $BACKUP"
  exit 1
fi

# echo Saving old CERT to $BACKUP
cp -af $CERT $BACKUP

cat > /usr/share/rhn/RHNS-CA-CERT << EOF
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 0 (0x0)
        Signature Algorithm: md5WithRSAEncryption
        Issuer: C=US, ST=North Carolina, L=Research Triangle Park, O=Red Hat, Inc., OU=Red Hat Network Services, CN=RHNS Certificate Authority/Email=rhns@redhat.com
        Validity
            Not Before: Aug 23 22:45:55 2000 GMT
            Not After : Aug 28 22:45:55 2003 GMT
        Subject: C=US, ST=North Carolina, L=Research Triangle Park, O=Red Hat, Inc., OU=Red Hat Network Services, CN=RHNS Certificate Authority/Email=rhns@redhat.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (1024 bit)
                Modulus (1024 bit):
                    00:c0:68:2b:12:30:e2:21:2d:22:c6:72:71:5b:bf:
                    17:a0:93:10:e9:9b:e3:c9:8d:3b:2d:ac:c4:bb:95:
                    3b:e0:ca:55:32:dc:95:c2:10:b3:04:b2:51:fb:e8:
                    85:61:16:34:a5:b4:1d:67:5c:a7:77:f4:f0:92:da:
                    b4:8b:af:95:93:62:f3:66:29:ae:c0:88:b7:64:84:
                    0e:48:90:60:f8:60:3e:00:7f:54:dd:17:a6:ac:18:
                    e0:42:de:7c:be:90:81:f7:f4:05:85:0a:08:cc:d5:
                    f2:9f:fc:24:8b:77:a5:3d:e9:48:a9:ef:0f:3b:63:
                    a3:fe:a6:83:4c:e8:dc:0b:77
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                54:15:CD:9F:2C:F7:EC:0D:1F:D2:A8:BE:4C:07:AC:88:3E:FB:9B:0A
            X509v3 Authority Key Identifier: 
                keyid:54:15:CD:9F:2C:F7:EC:0D:1F:D2:A8:BE:4C:07:AC:88:3E:FB:9B:0A
                DirName:/C=US/ST=North Carolina/L=Research Triangle Park/O=Red Hat, Inc./OU=Red Hat Network Services/CN=RHNS Certificate Authority/Email=rhns@redhat.com
                serial:00

            X509v3 Basic Constraints: 
                CA:TRUE
    Signature Algorithm: md5WithRSAEncryption
        93:01:88:88:67:67:91:8c:9e:d0:12:14:90:71:12:87:55:0a:
        f2:52:1b:ad:f2:d3:07:1d:af:70:99:bb:b0:cd:80:23:c9:ed:
        2b:73:e9:63:b1:d0:b3:8c:60:c5:42:64:a6:c1:95:56:90:c5:
        35:06:03:58:f5:8e:2b:d9:f9:a9:a0:10:a9:99:f7:15:42:92:
        a5:50:d7:11:07:f1:02:d5:e0:70:e4:55:6e:2a:ce:25:f8:5d:
        cd:0b:2f:10:61:f8:f6:20:42:cc:c3:89:f8:8a:4f:82:24:12:
        cf:39:7f:21:a8:2c:8d:52:97:52:c5:f7:5f:42:a5:87:09:66:
        b0:cc
-----BEGIN CERTIFICATE-----
MIIEMDCCA5mgAwIBAgIBADANBgkqhkiG9w0BAQQFADCBxzELMAkGA1UEBhMCVVMx
FzAVBgNVBAgTDk5vcnRoIENhcm9saW5hMR8wHQYDVQQHExZSZXNlYXJjaCBUcmlh
bmdsZSBQYXJrMRYwFAYDVQQKEw1SZWQgSGF0LCBJbmMuMSEwHwYDVQQLExhSZWQg
SGF0IE5ldHdvcmsgU2VydmljZXMxIzAhBgNVBAMTGlJITlMgQ2VydGlmaWNhdGUg
QXV0aG9yaXR5MR4wHAYJKoZIhvcNAQkBFg9yaG5zQHJlZGhhdC5jb20wHhcNMDAw
ODIzMjI0NTU1WhcNMDMwODI4MjI0NTU1WjCBxzELMAkGA1UEBhMCVVMxFzAVBgNV
BAgTDk5vcnRoIENhcm9saW5hMR8wHQYDVQQHExZSZXNlYXJjaCBUcmlhbmdsZSBQ
YXJrMRYwFAYDVQQKEw1SZWQgSGF0LCBJbmMuMSEwHwYDVQQLExhSZWQgSGF0IE5l
dHdvcmsgU2VydmljZXMxIzAhBgNVBAMTGlJITlMgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MR4wHAYJKoZIhvcNAQkBFg9yaG5zQHJlZGhhdC5jb20wgZ8wDQYJKoZIhvcN
AQEBBQADgY0AMIGJAoGBAMBoKxIw4iEtIsZycVu/F6CTEOmb48mNOy2sxLuVO+DK
VTLclcIQswSyUfvohWEWNKW0HWdcp3f08JLatIuvlZNi82YprsCIt2SEDkiQYPhg
PgB/VN0XpqwY4ELefL6Qgff0BYUKCMzV8p/8JIt3pT3pSKnvDztjo/6mg0zo3At3
AgMBAAGjggEoMIIBJDAdBgNVHQ4EFgQUVBXNnyz37A0f0qi+TAesiD77mwowgfQG
A1UdIwSB7DCB6YAUVBXNnyz37A0f0qi+TAesiD77mwqhgc2kgcowgccxCzAJBgNV
BAYTAlVTMRcwFQYDVQQIEw5Ob3J0aCBDYXJvbGluYTEfMB0GA1UEBxMWUmVzZWFy
Y2ggVHJpYW5nbGUgUGFyazEWMBQGA1UEChMNUmVkIEhhdCwgSW5jLjEhMB8GA1UE
CxMYUmVkIEhhdCBOZXR3b3JrIFNlcnZpY2VzMSMwIQYDVQQDExpSSE5TIENlcnRp
ZmljYXRlIEF1dGhvcml0eTEeMBwGCSqGSIb3DQEJARYPcmhuc0ByZWRoYXQuY29t
ggEAMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEEBQADgYEAkwGIiGdnkYye0BIU
kHESh1UK8lIbrfLTBx2vcJm7sM2AI8ntK3PpY7HQs4xgxUJkpsGVVpDFNQYDWPWO
K9n5qaAQqZn3FUKSpVDXEQfxAtXgcORVbirOJfhdzQsvEGH49iBCzMOJ+IpPgiQS
zzl/IagsjVKXUsX3X0KlhwlmsMw=
-----END CERTIFICATE-----

Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 0 (0x0)
        Signature Algorithm: md5WithRSAEncryption
        Issuer: C=US, ST=North Carolina, L=Raleigh, O=Red Hat, Inc., OU=Red Hat Network, CN=RHN Certificate Authority/Email=rhn-noc@redhat.com
        Validity
            Not Before: Sep  5 20:45:16 2002 GMT
            Not After : Sep  9 20:45:16 2007 GMT
        Subject: C=US, ST=North Carolina, L=Raleigh, O=Red Hat, Inc., OU=Red Hat Network, CN=RHN Certificate Authority/Email=rhn-noc@redhat.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (1024 bit)
                Modulus (1024 bit):
                    00:b3:16:b7:c5:f5:b9:69:51:1f:cd:b4:3d:70:cf:
                    60:57:85:a4:2a:a7:5d:28:22:0e:ec:19:e2:92:f7:
                    48:97:a6:a6:1f:51:95:83:11:8f:9a:98:a2:90:e0:
                    cb:4a:24:19:94:a8:8a:4b:88:b4:06:6c:ce:77:d7:
                    15:3b:3c:cd:66:83:cf:23:1d:0d:bc:0a:0c:cb:1f:
                    cb:40:fb:f3:d9:fe:2a:b4:85:2c:7b:c9:a1:fe:f3:
                    8f:68:1d:f2:12:b1:a4:16:19:ce:0f:b8:9a:9c:d9:
                    bc:5f:49:62:b2:95:93:ce:5d:2e:dd:79:3c:f1:5b:
                    a6:b7:a2:b5:39:0d:8e:12:31
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                7F:1B:64:A1:2E:02:C5:A8:7D:B8:D1:B1:8B:06:9D:A3:A9:50:63:92
            X509v3 Authority Key Identifier: 
                keyid:7F:1B:64:A1:2E:02:C5:A8:7D:B8:D1:B1:8B:06:9D:A3:A9:50:63:92
                DirName:/C=US/ST=North Carolina/L=Raleigh/O=Red Hat, Inc./OU=Red Hat Network/CN=RHN Certificate Authority/Email=rhn-noc@redhat.com
                serial:00

            X509v3 Basic Constraints: 
                CA:TRUE
    Signature Algorithm: md5WithRSAEncryption
        28:4d:42:e5:34:22:dd:c6:86:63:04:75:52:67:17:45:72:f2:
        3b:21:2b:45:59:72:73:f7:59:36:9d:57:43:c6:dc:94:0f:0e:
        ff:13:5c:4f:50:37:85:b2:e4:c2:1f:35:9f:74:f4:e7:53:fb:
        a1:06:b8:39:ce:e4:0a:86:7b:5f:28:5d:c7:11:9e:12:a5:d6:
        b9:6c:e9:18:09:d5:f0:42:e7:54:b5:91:9e:23:ad:12:7a:aa:
        72:7c:39:3c:83:f8:75:a4:7b:03:92:ff:2a:d4:c5:76:19:12:
        fa:b4:3b:b0:89:2c:95:8c:01:90:0d:d8:ba:06:05:61:00:ac:
        95:da
-----BEGIN CERTIFICATE-----
MIID7jCCA1egAwIBAgIBADANBgkqhkiG9w0BAQQFADCBsTELMAkGA1UEBhMCVVMx
FzAVBgNVBAgTDk5vcnRoIENhcm9saW5hMRAwDgYDVQQHEwdSYWxlaWdoMRYwFAYD
VQQKEw1SZWQgSGF0LCBJbmMuMRgwFgYDVQQLEw9SZWQgSGF0IE5ldHdvcmsxIjAg
BgNVBAMTGVJITiBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnJobi1ub2NAcmVkaGF0LmNvbTAeFw0wMjA5MDUyMDQ1MTZaFw0wNzA5MDkyMDQ1
MTZaMIGxMQswCQYDVQQGEwJVUzEXMBUGA1UECBMOTm9ydGggQ2Fyb2xpbmExEDAO
BgNVBAcTB1JhbGVpZ2gxFjAUBgNVBAoTDVJlZCBIYXQsIEluYy4xGDAWBgNVBAsT
D1JlZCBIYXQgTmV0d29yazEiMCAGA1UEAxMZUkhOIENlcnRpZmljYXRlIEF1dGhv
cml0eTEhMB8GCSqGSIb3DQEJARYScmhuLW5vY0ByZWRoYXQuY29tMIGfMA0GCSqG
SIb3DQEBAQUAA4GNADCBiQKBgQCzFrfF9blpUR/NtD1wz2BXhaQqp10oIg7sGeKS
90iXpqYfUZWDEY+amKKQ4MtKJBmUqIpLiLQGbM531xU7PM1mg88jHQ28CgzLH8tA
+/PZ/iq0hSx7yaH+849oHfISsaQWGc4PuJqc2bxfSWKylZPOXS7deTzxW6a3orU5
DY4SMQIDAQABo4IBEjCCAQ4wHQYDVR0OBBYEFH8bZKEuAsWofbjRsYsGnaOpUGOS
MIHeBgNVHSMEgdYwgdOAFH8bZKEuAsWofbjRsYsGnaOpUGOSoYG3pIG0MIGxMQsw
CQYDVQQGEwJVUzEXMBUGA1UECBMOTm9ydGggQ2Fyb2xpbmExEDAOBgNVBAcTB1Jh
bGVpZ2gxFjAUBgNVBAoTDVJlZCBIYXQsIEluYy4xGDAWBgNVBAsTD1JlZCBIYXQg
TmV0d29yazEiMCAGA1UEAxMZUkhOIENlcnRpZmljYXRlIEF1dGhvcml0eTEhMB8G
CSqGSIb3DQEJARYScmhuLW5vY0ByZWRoYXQuY29tggEAMAwGA1UdEwQFMAMBAf8w
DQYJKoZIhvcNAQEEBQADgYEAKE1C5TQi3caGYwR1UmcXRXLyOyErRVlyc/dZNp1X
Q8bclA8O/xNcT1A3hbLkwh81n3T051P7oQa4Oc7kCoZ7XyhdxxGeEqXWuWzpGAnV
8ELnVLWRniOtEnqqcnw5PIP4daR7A5L/KtTFdhkS+rQ7sIkslYwBkA3YugYFYQCs
ldo=
-----END CERTIFICATE-----

Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 0 (0x0)
        Signature Algorithm: md5WithRSAEncryption
        Issuer: C=US, ST=North Carolina, L=Raleigh, O=Red Hat, Inc., OU=Red Hat Network, CN=RHN Certificate Authority/emailAddress=rhn-noc@redhat.com
        Validity
            Not Before: Aug 29 02:10:55 2003 GMT
            Not After : Aug 26 02:10:55 2013 GMT
        Subject: C=US, ST=North Carolina, L=Raleigh, O=Red Hat, Inc., OU=Red Hat Network, CN=RHN Certificate Authority/emailAddress=rhn-noc@redhat.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (1024 bit)
                Modulus (1024 bit):
                    00:bf:61:63:eb:3d:8b:2b:45:48:e6:c2:fb:7c:d2:
                    21:21:b8:ec:90:93:41:30:7c:2c:8d:79:d5:14:e9:
                    0e:7e:3f:ef:d6:0a:9b:0a:a6:02:52:01:2d:26:96:
                    a4:ed:bd:a9:9e:aa:08:03:c1:61:0a:41:80:ea:ae:
                    74:cc:61:26:d0:05:91:55:3e:66:14:a2:20:b3:d6:
                    9d:71:0c:ab:77:cc:f4:f0:11:b5:25:33:8a:4e:22:
                    9a:10:36:67:fa:11:6d:48:76:3a:1f:d2:e3:44:7b:
                    89:66:be:b4:85:fb:2f:a6:aa:13:fa:9a:6d:c9:bb:
                    18:c4:04:af:4f:15:69:89:9b
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
            69:44:27:05:DC:2E:ED:A5:F4:81:C4:D7:78:45:E7:44:5D:F8:87:47
            X509v3 Authority Key Identifier: 
            keyid:69:44:27:05:DC:2E:ED:A5:F4:81:C4:D7:78:45:E7:44:5D:F8:87:47
            DirName:/C=US/ST=North Carolina/L=Raleigh/O=Red Hat, Inc./OU=Red Hat Network/CN=RHN Certificate Authority/emailAddress=rhn-noc@redhat.com
            serial:00

            X509v3 Basic Constraints: 
            CA:TRUE
    Signature Algorithm: md5WithRSAEncryption
        23:c9:ca:07:9f:5e:96:39:83:e0:4e:da:dd:47:84:30:ca:d4:
        d5:38:86:f9:de:88:83:ca:2c:47:26:36:ab:f4:14:1e:28:29:
        de:7d:10:4a:5e:91:3e:5a:99:07:0c:a9:2e:e3:fb:78:44:49:
        c5:32:d6:e8:7a:97:ff:29:d0:33:ae:26:ba:76:06:7e:79:97:
        17:0c:4f:2d:2a:8b:8a:ac:41:59:ae:e9:c4:55:2d:b9:88:df:
        9b:7b:41:f8:32:2e:ee:c9:c0:59:e2:30:57:5e:37:47:29:c0:
        2d:78:33:d3:ce:a3:2b:dc:84:da:bf:3b:2e:4b:b6:b3:b6:4e:
        9e:80
-----BEGIN CERTIFICATE-----
MIID7jCCA1egAwIBAgIBADANBgkqhkiG9w0BAQQFADCBsTELMAkGA1UEBhMCVVMx
FzAVBgNVBAgTDk5vcnRoIENhcm9saW5hMRAwDgYDVQQHEwdSYWxlaWdoMRYwFAYD
VQQKEw1SZWQgSGF0LCBJbmMuMRgwFgYDVQQLEw9SZWQgSGF0IE5ldHdvcmsxIjAg
BgNVBAMTGVJITiBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnJobi1ub2NAcmVkaGF0LmNvbTAeFw0wMzA4MjkwMjEwNTVaFw0xMzA4MjYwMjEw
NTVaMIGxMQswCQYDVQQGEwJVUzEXMBUGA1UECBMOTm9ydGggQ2Fyb2xpbmExEDAO
BgNVBAcTB1JhbGVpZ2gxFjAUBgNVBAoTDVJlZCBIYXQsIEluYy4xGDAWBgNVBAsT
D1JlZCBIYXQgTmV0d29yazEiMCAGA1UEAxMZUkhOIENlcnRpZmljYXRlIEF1dGhv
cml0eTEhMB8GCSqGSIb3DQEJARYScmhuLW5vY0ByZWRoYXQuY29tMIGfMA0GCSqG
SIb3DQEBAQUAA4GNADCBiQKBgQC/YWPrPYsrRUjmwvt80iEhuOyQk0EwfCyNedUU
6Q5+P+/WCpsKpgJSAS0mlqTtvameqggDwWEKQYDqrnTMYSbQBZFVPmYUoiCz1p1x
DKt3zPTwEbUlM4pOIpoQNmf6EW1Idjof0uNEe4lmvrSF+y+mqhP6mm3JuxjEBK9P
FWmJmwIDAQABo4IBEjCCAQ4wHQYDVR0OBBYEFGlEJwXcLu2l9IHE13hF50Rd+IdH
MIHeBgNVHSMEgdYwgdOAFGlEJwXcLu2l9IHE13hF50Rd+IdHoYG3pIG0MIGxMQsw
CQYDVQQGEwJVUzEXMBUGA1UECBMOTm9ydGggQ2Fyb2xpbmExEDAOBgNVBAcTB1Jh
bGVpZ2gxFjAUBgNVBAoTDVJlZCBIYXQsIEluYy4xGDAWBgNVBAsTD1JlZCBIYXQg
TmV0d29yazEiMCAGA1UEAxMZUkhOIENlcnRpZmljYXRlIEF1dGhvcml0eTEhMB8G
CSqGSIb3DQEJARYScmhuLW5vY0ByZWRoYXQuY29tggEAMAwGA1UdEwQFMAMBAf8w
DQYJKoZIhvcNAQEEBQADgYEAI8nKB59eljmD4E7a3UeEMMrU1TiG+d6Ig8osRyY2
q/QUHigp3n0QSl6RPlqZBwypLuP7eERJxTLW6HqX/ynQM64munYGfnmXFwxPLSqL
iqxBWa7pxFUtuYjfm3tB+DIu7snAWeIwV143RynALXgz086jK9yE2r87Lku2s7ZO
noA=
-----END CERTIFICATE-----
EOF
chown root:root $CERT
chmod 644 $CERT

if verify_cert $CERT; then
    # check ssl, let the python script message failure
    if ! test_ssl; then
	exit 1;
    fi
    # RH9's rhn_register is part of up2date, so it doesn't exist; so
    # just tell user to run up2date in that case

    echo
    echo "The file $CERT has been successfully updated."
    if [ ! -e /etc/sysconfig/rhn/systemid -a -e /usr/sbin/rhn_register ]; then
	echo "Please register for updates by running 'rhn_register'."
    else
	echo "Please run 'up2date' to download the latest updates."
    fi
    exit 0
fi

echo An error has occured, restoring $CERT
cp -fa $BACKUP $CERT

echo Please go to https://rhn.redhat.com/help/latest-up2date.pxt for 
echo manual installation.

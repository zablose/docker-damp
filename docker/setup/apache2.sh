#!/usr/bin/env bash

set -ev

domain=${ARG_DOMAIN}
certs=/etc/apache2/certs
crt=${certs}/${domain}.crt
key=${certs}/${domain}.key

mkdir ${certs}

tee ${certs}/certs.conf <<EOF

[req]
req_extensions     = req_ext
distinguished_name = req_distinguished_name
prompt             = no

[req_distinguished_name]
commonName=*.${domain}

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${domain}
DNS.2 = *.${domain}

EOF

openssl req -x509 -config ${certs}/certs.conf -nodes -days 365 -newkey rsa:2048 -sha256 -keyout ${key} -out ${crt}
ln -sr ${crt} /usr/local/share/ca-certificates/${domain}.crt
update-ca-certificates

file=/etc/apache2/apache2.conf
sed -i -e 's~^<Directory\s/var/www/>$~<Directory /home/web/>~' ${file}
sed -i -e "s~^ErrorLog.*$~ErrorLog $ZDAMP_LOG~" ${file}

tee -a /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>

    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

tee -a /etc/apache2/sites-available/001-index.conf <<EOF
<IfModule mod_ssl.c>
<VirtualHost *:443>

    ServerName ${domain}
    ServerAlias www.${domain}
    ServerAdmin admin@${domain}
    DocumentRoot /home/web/public

    <Directory "/home/web/public">
            RewriteEngine on
            RewriteBase /
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule ^(.*)\$ index.php?url=\$1 [QSA,L]
    </Directory>

    SSLCertificateFile ${crt}
    SSLCertificateKeyFile ${key}

</VirtualHost>
</IfModule>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

ln -sr /etc/apache2/sites-available/001-index.conf /etc/apache2/sites-enabled/001-index.conf

ln -sr /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
ln -sr /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load
ln -sr /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load
ln -sr /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf

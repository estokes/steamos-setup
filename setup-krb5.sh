#! /bin/bash

cp ~deck/etc/krb5.conf /etc/krb5.conf
cp ~deck/etc/krb5.keytab /etc/krb5.keytab
mkdir -p /etc/samba
cp ~deck/etc/samba/smb.conf /etc/samba

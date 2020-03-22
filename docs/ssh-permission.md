# SSH Permission denied on Correct Password Authentication

If it happens you can not access to the server through SSH and it shows you `Permission denied (publickey,gssapi-keyex,gssapi-with-mic)`. You need to configure the SSH on Centos `/etc/ssh/sshd_config`.

Uncomment the server's /etc/ssh/sshd_config:

```config
#To enable password authentication
PasswordAuthentication yes

#To enable root login, uncomment
PermitRootLogin yes

#To enable ssh key login, uncomment
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```

Then restart the SSH service :

```sh
service --full-restart sshd
```
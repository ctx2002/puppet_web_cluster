#1 /bin/bash
USER=keepalived_script

cat /etc/passwd | grep ${USER} >/dev/null 2>&1
if [ $? -eq 1 ] ; then
    echo "User not Exists"
fi

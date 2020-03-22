#!/bin/bash

# This scripts allows to extract all vars from roles
# It will scan all roles/*/defaults/*.yml and put inside host_vars/all.yml

set -o xtrace

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../

# Generate a random password.
PASSWD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c8`
SALT=`< /dev/urandom tr -dc A-Za-z0-9 | head -c16`

# Prepare group_vars/all.
TMP_VARS=`mktemp`
echo -e "# Updated on `date`" >> $TMP_VARS
find roles/*/defaults/*.yml -type f -exec cat {} \; | egrep -e '^\w*:' | sort -u | sed 's/^/#/g;s/\[$/[]/g;s/{$/{}/g' >> $TMP_VARS
echo -en '\n' >> $TMP_VARS
perl -i -p -e "s/^#(apache2_http_port):.*/\1: \"80\"/g" $TMP_VARS

cat $TMP_VARS >> ../ansible/inventories/dev/host_vars/all.yml
cat $TMP_VARS >> ../ansible/inventories/prod/host_vars/all.yml


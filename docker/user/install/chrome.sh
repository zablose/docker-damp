#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

if [[ "${DAMP_ADD_CHROME}" != "true" ]]
then
    echo 'Skipping Chrome installation ...'
    exit 0
fi

driver_file=chromedriver_linux64.zip
driver_url=https://chromedriver.storage.googleapis.com
driver_version=$(curl -s ${driver_url}/LATEST_RELEASE)
apt_source=/etc/apt/sources.list.d/google-chrome.list

echo 'Installing Chrome ...'

if [[ ! -f "${apt_source}" ]]
then
    {
        curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee ${apt_source}
        sudo apt-get -y update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
            dbus-x11 \
            google-chrome-stable
    } | sudo tee /var/log/damp-chrome-install.log 1>/dev/null
fi

echo 'Installing Chrome Driver ...'

if [[ ! -f '/usr/local/bin/chromedriver' ]]
then
    log=/var/log/damp-chrome-driver-install.log
    {
        sudo wget -O ${driver_file} ${driver_url}/${driver_version}/${driver_file} -o ${log}
        sudo unzip ${driver_file} chromedriver -d /usr/local/bin/
        rm -f ${driver_file}
    } | sudo tee -a ${log} 1>/dev/null
fi

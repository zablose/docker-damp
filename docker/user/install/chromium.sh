#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

if [[ "${DAMP_ADD_CHROMIUM}" != "true" ]]
then
    echo 'Skipping Chromium installation ...'
    exit 0
fi

if [[ -z "${DAMP_CHROMIUM_POSITION}" ]]
then
    echo 'Chromium branch base position "DAMP_CHROMIUM_POSITION" is empty!'
    exit 1
fi

url=https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${DAMP_CHROMIUM_POSITION}

browser_zip=chrome-linux.zip
driver_zip=chromedriver_linux64.zip

chromium=/opt/google/chrome-linux/chrome

echo 'Installing Chromium ...'

if [[ ! -f "${chromium}" ]]
then
    {
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            chromium
        sudo apt-get remove -y chromium
        sudo curl -s ${url}/${browser_zip} -o ${browser_zip}
        sudo unzip ${browser_zip} -d /opt/google/
        sudo rm -f ${browser_zip}
        sudo ln -sr ${chromium} /usr/bin/chromium
    } | sudo tee -a /var/log/damp-chromium-install.log 1>/dev/null
fi

echo 'Installing Chrome Driver ...'

if [[ ! -f '/usr/local/bin/chromedriver' ]]
then
    {
        sudo curl -s ${url}/${driver_zip} -o ${driver_zip}
        sudo unzip -j ${driver_zip} -d /usr/local/bin/
        sudo rm -f ${driver_zip}
    } | sudo tee -a /var/log/damp-chromedriver-install.log 1>/dev/null
fi

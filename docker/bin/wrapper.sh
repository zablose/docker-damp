#!/usr/bin/env bash

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

wrapper_start()
{
    {
        echo "Setting up ..."
        bash $HOME/setup/setup.sh

        echo "Starting MariaDB ..."
        sudo /etc/init.d/mysql start

        echo "Starting Apache2 ..."
        sudo /etc/init.d/apache2 start
    } >> ${DAMP_LOG} 2>&1
}

wrapper_stop()
{
    {
        echo "Stopping Apache2 ..."
        sudo /etc/init.d/apache2 stop

        echo "Stopping MariaDB ..."
        sudo /etc/init.d/mysql stop
    } >> ${DAMP_LOG} 2>&1
}

tail -f ${DAMP_LOG} &
echo "Tailing log ..." >> ${DAMP_LOG} 2>&1

wrapper_start

echo "Waiting for termination signal to stop container gracefully." >> ${DAMP_LOG} 2>&1

trap "wrapper_stop; exit 0" SIGTERM
while kill -0 "$$" > /dev/null 2>&1; do
    wait
done

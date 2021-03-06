#!/usr/bin/env bash

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

wrapper_start()
{
    {
        echo "Starting DAMP!"

        echo "Setting up ..."
        bash $HOME/setup/setup.sh

        echo "Starting MariaDB ..."
        sudo /etc/init.d/mysql start

        echo "Starting Apache2 ..."
        sudo /etc/init.d/apache2 start

        echo "Running post setup ..."
        bash $HOME/setup/post-setup.sh

        echo "DAMP started!"
    } >> ${DAMP_LOG} 2>&1
}

wrapper_stop()
{
    {
        echo "Stopping DAMP!"

        echo "Stopping Apache2 ..."
        sudo /etc/init.d/apache2 stop

        echo "Stopping MariaDB ..."
        sudo /etc/init.d/mysql stop

        echo "DAMP stopped!"
    } >> ${DAMP_LOG} 2>&1
}

tail -f ${DAMP_LOG} &
echo "Tailing log from '${DAMP_LOG}'." >> ${DAMP_LOG} 2>&1

wrapper_start

echo "Waiting for termination signal to stop container gracefully." >> ${DAMP_LOG} 2>&1

trap "wrapper_stop; sleep 1; exit 0" SIGTERM
while kill -0 "$$" > /dev/null 2>&1; do
    wait
done

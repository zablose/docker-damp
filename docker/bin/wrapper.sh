#!/usr/bin/env bash

now()
{
    echo $(date "+[%Y-%m-%d %H:%M:%S]")
}

wrapper_start()
{
    {
        echo "$(now) Setting up ..."
        bash -i $HOME/setup/setup.sh


        echo "$(now) Starting MariaDB ..."
        sudo /etc/init.d/mysql start

        echo "$(now) Starting Apache2 ..."
        sudo /etc/init.d/apache2 start
    } >> ${ZDAMP_LOG} 2>&1
}

wrapper_stop()
{
    {
        echo "$(now) Stopping Apache2 ..."
        sudo /etc/init.d/apache2 stop

        echo "$(now) Stopping MariaDB ..."
        sudo /etc/init.d/mysql stop
    } >> ${ZDAMP_LOG} 2>&1
}

tail -f ${ZDAMP_LOG} &
echo "$(now) Tailing local log ..." >> ${ZDAMP_LOG} 2>&1

wrapper_start

echo "$(now) Waiting for termination signal to stop container gracefully." >> ${ZDAMP_LOG} 2>&1

trap "wrapper_stop; exit 0" SIGTERM
while kill -0 "$$" > /dev/null 2>&1; do
    wait
done

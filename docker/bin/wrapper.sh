#!/usr/bin/env sh

trap wrapper_stop HUP INT QUIT TERM

wrapper_start()
{
    {
        echo "Starting ..."
        bash -i $HOME/setup/setup.sh
        sudo /etc/init.d/mysql start
        sudo /etc/init.d/apache2 start
    } >> ${ZDAMP_LOG} 2>&1

    tail -f ${ZDAMP_LOG}
}

wrapper_stop()
{
    {
        echo "Stopping ..."
        echo "Signal: $?"
        sudo /etc/init.d/apache2 stop
        sudo /etc/init.d/mysql stop
    } >> ${ZDAMP_LOG} 2>&1
}

wrapper_start

#!/bin/bash

function install_ntp()
{
  ## http://www.debianadmin.com/ntp-server-and-client-configuration-in-debian.html

  apt-get install ntp -y

  #remove ntp server lines
  sed -i".bak" '/^server/d' /etc/ntp.conf
  #add the local ntp server
  echo "server ntp.mydomain.com iburst" >> /etc/ntp.conf

  /etc/init.d/ntp stop
  /etc/init.d/ntp start

  sleep 10

  # make the hardware clock be read as LOCAL time rather than UTC. This fixes a problem
  # of windows setting the hardware clock to local time when linux usually reads the hardware clock
  # as UTC. Linux was giving a kerberos time skew error before this change.
  sed -i 's/^UTC$/LOCAL/' /etc/adjtime

  ntpq -p
  ntpdc -p
}

install_ntp

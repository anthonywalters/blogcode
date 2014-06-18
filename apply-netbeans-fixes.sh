#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, exiting" 2>&1
  exit 1
fi

if [[ ! -f /opt/netbeans-8.0/bin/netbeans ]];
then
  echo "netbeans is not installed in /opt/netbeans-8.0"
  echo "Download and install it under the /opt directory, and then re-run this script"
  echo "https://netbeans.org/downloads/index.html"
  echo "exiting script, fixes not applied"
  exit 1
fi

#apply permissions fixes
find /opt/glassfish-4.0 -type d -exec chmod -v go+rx {} \;
find /opt/glassfish-4.0 -type f -exec chmod -v go+r {} \;
find /opt/glassfish-4.0 -executable -type f -exec chmod -v go+x {} \;
find /opt/netbeans-8.0 -type d -exec chmod -v go+rx {} \;
find /opt/netbeans-8.0 -type f -exec chmod -v go+r {} \;
find /opt/netbeans-8.0 -executable -type f -exec chmod -v go+x {} \;
find /opt/apache-tomcat-8.0.3 -type d -exec chmod -v go+rx {} \;
find /opt/apache-tomcat-8.0.3 -type f -exec chmod -v go+r {} \;
find /opt/apache-tomcat-8.0.3 -executable -type f -exec chmod -v go+x {} \;

mkdir -p /root/work

## Add an entry to the system menu
## Permissions to make the icon are fucked up by the netbeans installer
## This is a work around to make the icon
XDG_DESKTOP_MENU="`which xdg-desktop-menu 2> /dev/null`"
UPDATE_MENUS="`which update-menus 2> /dev/null`"

cp -v /usr/share/applications/netbeans-8.0.desktop /root/work/
chmod 644 /root/work/netbeans-8.0.desktop
xdg-desktop-menu uninstall netbeans-8.0.desktop

if [ ! -x "$XDG_DESKTOP_MENU" ]; then
 echo "Error: Could not find xdg-desktop-menu" >&2
fi
"$XDG_DESKTOP_MENU" install /root/work/netbeans-8.0.desktop

if [ -x "$UPDATE_MENUS" ]; then
  update-menus
fi

#add a workaround for this bug
#https://netbeans.org/bugzilla/show_bug.cgi?id=227754
if grep -q '^export DESKTOP_SESSION=mate$' /opt/netbeans-8.0/etc/netbeans.conf
then
  echo "Environment variable already added to /opt/netbeans-8.0/etc/netbeans.conf skipping."
else
  echo "adding export DESKTOP_SESSION=mate to /opt/netbeans-8.0/etc/netbeans.conf"
  echo "export DESKTOP_SESSION=mate" >> /opt/netbeans-8.0/etc/netbeans.conf
fi

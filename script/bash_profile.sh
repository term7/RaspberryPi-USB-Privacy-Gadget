#!/bin/sh
# GWII (global web interface info)

if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi

#ALIASES:

# Wifi-AP
alias ap-on="if ! ifconfig wlan0 &> /dev/null; then printf '\nWifi-AP Disconnected! Please attach the required USB Dongle...\n\n'; else sudo systemctl start hostapd.service; fi"
alias ap-off="if ! ifconfig wlan0 &> /dev/null; then printf '\nWifi-AP Disconnected! Please attach the required USB Dongle...\n\n'; else sudo systemctl stop hostapd.service; fi"

echo
echo "   .~~.   .~~.      $(tput setaf 1)VPN................: `protonvpn status | sed -n -e '/Status/{p;n;}' | sed 's/^\s*Status/Status/' | sed 's/ //g' | sed 's/Status://g'` (`protonvpn status | sed -n -e '/Country/{p;n;}' | sed 's/^\s* Country/Country/' | sed 's/ //g' | sed 's/Country://g'` : `protonvpn status | sed -n -e '/Server/{p;n;}' | sed 's/^\s*Server/Server/' | sed 's/ //g' | sed 's/Server://g'`)$(tput setaf 2)"
echo "$(tput setaf 2)  '. \ ' ' / .'$(tput setaf 1)"
echo "   .~ .~~~..~.      IP Addresses.......: usb0   `ip -4 addr show usb0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`"
echo "  : .~.'~'.~. :                          eth0   `ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`"
echo " ~ (   ) (   ) ~                         wlan0  `ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`"
echo "( : '~'.~.'~' : )                        wlan1  `if [ "$(cat /sys/class/net/wlan1/operstate)" == "dormant" ]; then printf Disconnected; elif ! ifconfig wlan1 &> /dev/null; then printf Unplugged; else printf %s "$(ip -4 addr show wlan1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"; fi`"
echo " ~ .~ (   ) ~. ~                         ext    `if [ "$(cat /sys/class/net/wlan1/operstate)" == "up" ]; then dig +short myip.opendns.com @resolver1.opendns.com; else printf Unreachable; fi`"
echo "  (  : '~' :  )"
echo "   '~ .~~~. ~'      Wifi-AP............: `if [ $(systemctl is-active hostapd) =  'active' ]; then printf  Connected; else printf Disconnected; fi` (wlan0 : OctoBaer)"
echo "       '~'          Wifi-AP............: ap-on/off"
echo
echo
printf "\e[0;32m--------------------------------------------------------------------------------\n"
echo

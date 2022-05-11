#!/bin/sh
# GWII (global web interface info)

if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi

#ALIASES:

# Wifi-AP
alias ap-on="if ! ifconfig wlan0 &> /dev/null; then printf '\nWifi-AP Disconnected! Please attach the required USB Dongle...\n\n'; else sudo systemctl start hostapd.service; fi"
alias ap-off="if ! ifconfig wlan0 &> /dev/null; then printf '\nWifi-AP Disconnected! Please attach the required USB Dongle...\n\n'; else sudo systemctl stop hostapd.service; fi"

protonvpn status > ~/.tmp
if [ "$(head -1 ~/.tmp)" = "Status:       Connected" ]; then sed -i -e 's/Status:       //g' -e 's/Server:       //g' -e 's/Country:      //g' -e '2,3d;5,7d;9,12d' ~/.tmp; fi;
if [ "$(head -1 ~/.tmp)" = "Status:     Disconnected" ]; then sed -i -e 's/Status:     //g' -e '2 c\ ' -e '3 c\ ' ~/.tmp; fi
if [ "$(head -1  ~/.tmp | cut -c -3)" = "[!]" ]; then sed -i -e '1 c\ERROR' -e '2,12d' ~/.tmp && echo -e "\n \n " >> ~/.tmp; fi

echo
echo "   .~~.   .~~.      $(tput setaf 1)VPN................: $(head -1 ~/.tmp) ($(sed '3q;d' ~/.tmp) : $(sed '2q;d' ~/.tmp))";
echo "$(tput setaf 2)  '. \ ' ' / .'$(tput setaf 1)";
echo "   .~ .~~~..~.      IP Addresses.......: usb0   `ip -4 addr show usb0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`";
echo "  : .~.'~'.~. :                          eth0   `ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`";
echo " ~ (   ) (   ) ~                         wlan0  `ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`";
echo "( : '~'.~.'~' : )                        wlan1  `if [ "$(cat /sys/class/net/wlan1/operstate)" = "dormant" ]; then printf Dormant; elif [ "$(cat /sys/class/net/wlan1/operstate)" = "down" ]; then printf Down; elif [ "$(cat /sys/class/net/wlan1/operstate)" = "up" ]; then printf %s "$(ip -4 addr show wlan1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"; fi`";
echo " ~ .~ (   ) ~. ~                         ext    `if [ "$(cat /sys/class/net/eth0/operstate)" = "up" ]; then printf %s "$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)"; elif [ "$(cat /sys/class/net/wlan1/operstate)" = "dormant" ]; then printf Disconnected; elif [ "$(cat /sys/class/net/wlan1/operstate)" = "down" ]; then printf Disconnected; elif [ "$(cat /sys/class/net/wlan1/operstate)" = "up" ]; then printf %s "$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)"; fi`";
echo "  (  : '~' :  )";
echo "   '~ .~~~. ~'      Wifi-AP............: `if [ $(systemctl is-active hostapd) =  'active' ]; then printf  Connected; else printf Disconnected; fi` (wlan0 : OctoBaer)";
echo "       '~'          Wifi-AP............: ap-on/off";
echo
echo
printf "\e[0;32m--------------------------------------------------------------------------------\n"
echo

rm ~/.tmp

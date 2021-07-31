# RaspberryPi: Privacy Gadget
*A portable RaspberryPi USB Ethernet Gadget that safeguards your Privacy*

This repository functions as a guide and as a step-by-step tutorial that will help you to configure a RaspberryPi 4 as a USB Ethernet Gadget that routes all of your Mac's internet traffic through a VPN while blocking all sorts of ads and trackers and spoofing its own device identity.

## INTRODUCTION

When Apple made macOS BigSur publicly available in autumn 2020, we realized that our installation of Little Snitch (a host based firewall) partially stopped working. More specifically we noticed, that all Apple Processes were not filtered anymore. Strange. When we researched this problem online we came across a blog post by Jeffrey Paul ([Your Computer Isn't Yours](https://sneak.berlin/20201112/your-computer-isnt-yours/#updates)), a security researcher based in Berlin. We strongly recommend reading this article before you decide to setup your own Raspberry Pi Privacy Gadget!

A very short summary: modern macOS operating systems have the capability to bypass internal firewalls and VPN's, a possibility that is built into the operating system. Furthermore, each Apple Computer constantly connects to both Apple Servers and 3rd parties (i.e. Akamai) to transmit hashes of apps that are being used - whenever they are being used. Apple uses these hashes to prevent any malicious apps (and other 'blacklisted apps') from launching, if the online certificate check fails. Apple claims that this is only a security feature to combat malicious apps. While this might be true, it also means that Apple always knows when you are online, where you are while you are online, for how long you use specific software, i.e. Photoshop, or whenever you start the Tor Browser. Over time this practice amounts to a tremendous amount of data that paints a pretty accurate picture of your digital life and habits, physical movements and activity patterns. All this data can potentially be correlated with other big data, collected by corporations like Google, Microsoft, Facebook, etc. As Jeffrey Paul correctly points out:

*Since October of 2012, Apple is a partner in the US military intelligence community’s PRISM spying program, which grants the US federal police and military unfettered access to this data without a warrant, any time they ask for it.*

We think this is a very upsetting development, another dangerous move toward surveillance captilism, that violates the privacy of all Apple Users.

Admittedly there was huge critzism toward Apple, which is why some of these intrusions, i.e. the ContentFilterExclusionList that allowed native Apple Apps to bypass local Firewalls and VPN's, has since been revoked ([A Wall without a Hole](https://blog.obdev.at/a-wall-without-a-hole/)).

According to Apple, [privacy](https://www.apple.com/privacy/) is a fundamental human right:

*Privacy is a fundamental human right. At Apple, it’s also one of our core values. Your devices are important to so many parts of your life. What you share from those experiences, and who you share it with, should be up to you. We design Apple products to protect your privacy and give you control over your information. It’s not always easy. But that’s the kind of innovation we believe in.*

Yet we think claiming to deeply care about user privacy, while being part of programs like [PRISM](https://en.wikipedia.org/wiki/PRISM_(surveillance_program)#Extent_of_the_program), shows a double-standard that should not be tolerated.

Who guarantees that something like a ContentFilterExclusionList won't suddenly re-surface with the next update?
We think Apple cannot be trusted with our user data, which is the reason why we set up a Raspberry Pi Ethernet Gadget as a portable external network filtering device to make data-harvesting as difficult as as possible.

As Jeffrey Paul points out: Your computer is not yours.
But it should be!


#### RECOMMENDED READING:

Jeffrey Paul:<br/>
[https://sneak.berlin/20201112/your-computer-isnt-yours/#updates](https://sneak.berlin/20201112/your-computer-isnt-yours/#updates)

Apple:<br/>
[https://www.apple.com/privacy/](https://www.apple.com/privacy/)<br/>
[https://www.apple.com/legal/transparency/](https://www.apple.com/legal/transparency/)

PRISM:<br/>
[https://en.wikipedia.org/wiki/PRISM_(surveillance_program)](https://en.wikipedia.org/wiki/PRISM_(surveillance_program))<br/>
[https://www.reuters.com/article/us-apple-fbi-icloud-exclusive/exclusive-apple-dropped-plan-for-encrypting-backups-after-fbi-complained-sources-idUSKBN1ZK1CT](https://www.reuters.com/article/us-apple-fbi-icloud-exclusive/exclusive-apple-dropped-plan-for-encrypting-backups-after-fbi-complained-sources-idUSKBN1ZK1CT)

Objective Development:<br/>
[https://blog.obdev.at/a-wall-without-a-hole/](https://blog.obdev.at/a-wall-without-a-hole/)<br/>
[https://blog.obdev.at/a-hole-in-the-wall/](https://blog.obdev.at/a-hole-in-the-wall/)
<br/><br/>

<p align="center">
  <img src="/png/Privacy_Gadget.png" title="Privacy Gadget">
</p>

*One Pi to rule them all.*

## WHAT THIS RASPBERRY PI USB ETHERNET GADGET DOES:

This Raspberry Pi Privacy Gadget functions like a portable router that allows you to monitor and controll all network traffic, including native Apple processes. If you follow our guide, your Mac will be connected via USB-C to the Raspberry Pi, while the Raspberry Pi connects to the internet.

FEATURES:

1) Enhanced Tracking Protection: We use an existing project, the [Pi-hole](https://pi-hole.net/), as a DNS filter that blocks all requests to Apple servers, Akami, iCloud, etc. It is easy to disable, re-enable, fine-tune and configure these filters via a Web-Interface. I.e. we want to allow software updates. An additional benefit is the original purpose of the Pi-hole: It was designed as an ad blocker. As such it allows you to install blocklists that block known ads and trackers. Further you can  create your own custom blocklists and allowlists.
2) Encrypted DNS: We implement encrypted DNS via [Unbound](https://nlnetlabs.nl/projects/unbound/about/) and [Stubby](https://dnsprivacy.org/wiki/display/DP/About+Stubby) (DNS-over-TLS). Our DNS porviders of choice are [blahdns](https://blahdns.de/) and [CZ.NIC](https://www.nic.cz/odvr/). You can use our configuration or choose your own providers.
3) VPN: Setup your etherent gadget to route all traffic, without exception, through a VPN. We use [ProtonVPN](https://protonvpn.com/) as an example. ProtonVPN features a built-in killswitch to prevent leaks. It has been [independently audited](https://protonvpn.com/blog/open-source/) and is protected by strong Swiss privacy laws. However, feel free to use any VPN provider you [trust](https://privacytools.io/providers/vpn/) - or configure your Ethernet Gadget to route all traffic through Tor. It is your choice.
4) Hidden Wifi Hotspot: In our configuration we use an additional external Wifi Antenna. This frees our built-in Wifi card to be configured as a hidden hotspot that can be used to share the same internet connection with your other devices (i.e. your smartphone). The hotspot is configured via [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) and [hostapd](https://undeadly.org/cgi?action=article&sid=20051008150710).
5) Firewall: IP-tables. The optional [ASN_IPFire_Script](https://notabug.org/maloe/ASN_IPFire_Script) by [Mike Kuketz](https://www.kuketz-blog.de/) and maloe can be used to block entire IP-Address ranges of known data collectors, such as Facebook.
6) Rasndomized Device Identity: Any public Wifi you connect to, from now on will only log the MAC Address and the hostname of your Ethernet Gadget, instead of your Mac's MAC Address. We randomize its MAC-Address during each reboot to further enhance your privacy. Our USB Ethernet Gadget also picks a random hostname from a dictionary during each reboot.

This proposed setup only works reliable if all internet connectios are routed through the Raspberry Pi USB Ethernet Gadget, which is why we include additional instructions for a simple launch daemon that will switch off your Mac's wifi as soon as possible during the boot process (by default your Mac is configured in such a way that it starts Wifi every time you do a reboot).


## SETUP

- [01 - Prerequisites](#01---Prerequisites)
- [02 - Setup new User and delete User Pi](#02---Setup-new-User-and-delete-User-Pi)
- [03 - Configure external Wifi Adapter](#03---Configure-external-Wifi-Adapter)
- [04 - Setup USB-Ethernet Gadget](#04---Setup-USB-Ethernet-Gadget)
- [05 - Install Pi-Hole](#05---Install-Pi-Hole)
- [06 - Configure Encrypted DNS](#06---Configure-Encrypted-DNS)
- [07 - Setup Blocklists](#07---Setup-Blocklists)
- [08 - VPN](#08---VPN)
- [09 - Hidden Wifi Access Point](#09---Wifi-Access-Point)
- [10 - Firewall](#10---Firewall)
- [11 - Randomized Device Identity](#11---Randomized-Device-Identity)
- [12 - Optional Custom Login Information](#12---Optional-Custom-Login-Information)
- [13 - Disable Wifi on MacOS](#13---Disable-Wifi-on-MacOS)
- [14 - To Do](#14---To-Do)


# 01 - Prerequisites

#### HARDWARE:

We use a Raspberry Pi 4B (8Gb). The USB-C cable needs to be of good quality and support fast data transfers. We use the USB-C cable of an external SSD drive (G-DRIVE). Further we use this tiny Wifi-Adapter: [Alfa AWUS036ACS](https://www.alfa.com.tw/products/awus036acs?variant=36473965969480). It is fast and reliable. If you choose to use this adapter you will have to compile the required kernel module. We included the necessary steps in this guide. However, there are other wifi adapters that work natively on the Raspberry Pi. Further you will need a fast SD Card (i.e. 32GB by SanDisk).

#### OPTIONAL:

A case for the Raspberry Pi and a cooling system. We can recommend the [Pibow Case](https://shop.pimoroni.com/products/pibow-coupe-4) and the lightweight [Fanshim](https://shop.pimoroni.com/products/fan-shim?_pos=1&_sid=bc5f6629a&_ss=r) by Pimoroni.

#### OPERATING SYSTEM:

You will need a clean install of *Raspberry Pi OS - Lite* without desktop environment. Instructions how to install it on a micro SD-Card can be found [on this site](https://www.raspberrypi.org/software/). To complete this guide with a Raspberry Pi 4, we recommend you download the latest 64bit system [here](https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2021-05-28/2021-05-07-raspios-buster-arm64-lite.zip).

#### CONNECT TO THE INTERNET AND UPDATE:

Before you start following this guide, you should log into your Raspberry Pi, connect to the internet and update your installation.
After flushing the operating system onto your SD-Card, open the Terminal.app on your Mac and execute the following command to enable ssh access:
`touch /Volumes/boot/ssh`

Then enable internet connectivity by creating this file:
`nano /Volumes/boot/wpa_supplicant.conf`

Insert:

```
ctrl_interface=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=de

network={
    ssid="your-network"
    scan_ssid=1
    psk="your-wifi-password"
    key_mgmt=WPA-PSK
    priority=1
}
```

IMPORTANT: Change the value *ssid* to the network you want to connect to, and *psk* to the required Wifi password and adjust the country code to your location!

Next insert the SD-Card into your Raspberry Pi and boot it up.
There are several ways to find your Raspberry Pi on your local network. You could log into your router and look up its address.
Another way is this command:<br>
`arp -a`

Once you find the local IP address of your Pi, open a terminal window and connect via ssh, i.e.:<br>
`ssh pi@192.168.8.168` (The default password is *raspberry*)

Once you are logged in, update your Raspberry Pi:<br>
`sudo apt update && sudo apt upgrade -y`

#### ADDITIONAL STEPS:

You might want to update your timezone and locales by executing the following commands:

`export LANGUAGE="en_GB.UTF-8"`<br>
`export LANG="en_GB.UTF-8"`<br>
`export LC_ALL="en_GB.UTF-8"`

Also select your desired locales with this command:<br>
`sudo dpkg-reconfigure locales`

Then edit */etc/default/locale*:<br>
`sudo nano /etc/default/locale`

For British English, insert:

`LANG=en_GB.UTF-8`<br>
`LC_ALL=en_GB.UTF-8`<br>
`LANGUAGE=en_GB.UTF-8`

To set your timezone, i.e.:<br>
`sudo timedatectl set-timezone Europe/Berlin`



# 02 - Setup new User and delete User Pi

For security reasons we recommend to setup a new admin account and delete the standard user *pi*. For this guide we use an admin account called *baer*.

To create the user *baer* with all privileges, log into your Raspberry Pi via SSH and execute the following commands (you will be asked to create a password for your new user):

`sudo adduser baer`<br>
`sudo usermod -a -G adm,tty,dialout,cdrom,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi,sudo baer`

Then log into your new user account:<br>
`su - baer`

Once you are logged in, change `pi` to `baer` in  */etc/systemd/system/autologin@.service*:<br>
`sudo nano /etc/systemd/system/autologin@.service`

Finally, to make absolutely sure your new user will be logged in on boot, run:

`sudo raspi-config`

Navigate to *1 System Options* and select *Boot / Auto login*. Make sure you select user *workstation* to automatically log into desktop.
Please note that [raspi-config](https://www.raspberrypi.org/documentation/configuration/raspi-config.md) is constantly being developed. The location of the required menu item might change! Then, reboot your Raspberry Pi.

Finally delete user *pi*:

`sudo pkill -u pi`<br>
`sudo deluser -remove-home pi`

#### OPTIONAL BUT RECOMMENDED FOR SECURITY REASONS:

Require sudo password:<br>
`sudo nano /etc/sudoers.d/010_pi-nopasswd`

Change content to:

`baer ALL=(ALL) PASSWD: ALL`


# 03 - Configure external Wifi Adapter

If you use an external wifi adapter that works out of the box, you can skip this step.

We want to use a good external wifi adapter mainly for one reason: a good wifi adapter that supports USB3 connected to one of the Raspberry Pi's USB3 ports is faster and performs better than the built in wifi card. Our external Wifi Adapter is the [Alfa AWUS036ACS](https://www.alfa.com.tw/products/awus036acs?variant=36473965969480). Unfortunately this wifi antenna does not work out of the box. We need to compile its drivers. If you want to use another wifi adapter than the Alfa AWUS036ACS, that does not work out of the box you will have to research online how to compile the required driver.

Install dependencies:<br>
`sudo apt install git raspberrypi-kernel-headers dkms -y`

Then clone the required git repository:

`mkdir Compile`<br>
`cd Compile`<br>
`git clone -b v5.6.4.2 https://github.com/aircrack-ng/rtl8812au.git`<br>
`cd rtl*`

You will need to run those commands below which builds the ARM64 arch driver. If you run a 32-bit version of Raspian OS, you can find detailed instructions [here](https://github.com/aircrack-ng/rtl8812au).

`sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile`<br>
`sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile`<br>
`export ARCH=arm`<br>
`sed -i 's/^MAKE="/MAKE="ARCH=arm\ /' dkms.conf`<br>
`sudo make && sudo make install`

If you ever need to uninstall this driver:

`cd Compile/rtl*`<br>
`sudo make dkms_remove`

#### IMPORTANT:

After every update of the *raspberrypi-kernel-headers* you will have to recompile this driver, because each update of the *raspberrypi-kernel-headers* will delete it!

DRIVER OPTIONS:

Create */etc/modprobe.d/88XXau.conf*:<br>
`sudo nano /etc/modprobe.d/88XXau.conf`

Insert:

```
# /etc/modprobe.d/88XXau.conf
#
# Purpose: Allow easy access to specific driver options.
# To see all options that are available:
#
# -----
#
# $ ls /sys/module/88XXau/parameters/
#
# Edit the following line to change options:
options 88XXau rtw_drv_log_level=0 rtw_led_ctrl=1 rtw_vht_enable=1 rtw_power_mgnt=1 rtw_switch_usb_mode=1
#
# After editing is complete, save this file and reboot to activate the changes.
#
# Documentation:
#
# -----
#
# Log level options: ( rtw_drv_log_level )
#
# 0 = NONE (default)
# 1 = ALWAYS
# 2 = ERROR
# 3 = WARNING
# 4 = INFO
# 5 = DEBUG
# 6 = MAX
#
# Note: You can save a log file that only includes RTW log entries by running the following in a terminal:
#
# $ sudo ./save-log.sh
#
# -----
#
# LED control options: ( rtw_led_ctrl )
#
# 0 = Always off
# 1 = Normal blink (default)
# 2 = Always on
#
# -----
#
# VHT enable options: ( rtw_vht_enable )
#
#  0 = Disable
#  1 = Enable (default)
#  2 = Force auto enable (use caution)
#
# Notes:
# - Unless you know what you are doing, don't change the default for rtw_vht_enable.
# - A non-default setting can degrade performance greatly in some operational modes.
# - For 5 GHz band AP mode, setting this option to 2 will allow 80 MHz channel width.
#
# -----
#
# Power saving options: ( rtw_power_mgnt )
#
# 0 = Disable power saving
# 1 = Power saving on, minPS (default)
# 2 = Power saving on, maxPS
#
# Note: Extensive testing has shown that the default setting works well.
#
# -----
#
# USB mode options: ( rtw_switch_usb_mode )
#
# 0 = No switch
# 1 = Switch from usb 2.0 to usb 3.0
# 2 = Switch from usb 3.0 to usb 2.0 (default)
```

These options for example let you turn off the blinking LED of the Wifi-Adapter. More importantly they enable you to switch the adapter from USB2 to USB3.


#### ASSIGN PERSISTENT NAMES TO WIFI ADAPTERS:

We noticed, that sometimes the external wifi adapter is called wlan0, sometimes wlan1. However we want to assign a persistent reliable name across reboots. To achieve this we decided we always plug our wifi adapter into the upper USB3 port. Next we edit these udev rules:

`sudo ln -nfs /dev/null /etc/systemd/network/99-default.link`

Next create a new rule */etc/udev/rules.d/70-persistent-net.rules*:

`sudo nano /etc/udev/rules.d/70-persistent-net.rules`

Insert:

```
# Layout Raspberry Pi 4B:
#
# +-------+-------+-----+
# |       | wlan1 |     |
# +-------+-------+ RJ45|
# | wlan3 | wlan2 |     |
# +-------+-------+-----+
# | wlan0 | ............. => (onboard wifi)
#
# Based on output: udevadm info -a /sys/class/net/wlan1


ACTION=="add", SUBSYSTEM=="net", SUBSYSTEMS=="sdio", KERNELS=="mmc1:0001:1", NAME="wlan0"
ACTION=="add", SUBSYSTEM=="net", SUBSYSTEMS=="usb",  KERNELS=="1-1.1",       NAME="wlan1"
ACTION=="add", SUBSYSTEM=="net", SUBSYSTEMS=="usb",  KERNELS=="1-1.2",       NAME="wlan2"
#ACTION=="add", SUBSYSTEM=="net", SUBSYSTEMS=="usb",  KERNELS=="1-1.4",       NAME="wlan3"
```

This ensures that the onboard wifi will always be called *wlan0* and any wifi adapter plugged into the upper USB3 port will be called *wlan1*.

#### RESOURCES:

[https://github.com/aircrack-ng/rtl8812au](https://github.com/aircrack-ng/rtl8812au)


# 04 - Setup USB-Ethernet Gadget

First we will configure the Raspberry Pi as a USB-Ethernet device that connects to your Mac via USB-C. We need to configure the Pi to load additional modules so that usb0 (the direct connection to our Mac via USB-C) becomes available as a network interface. Further we assign a static IP-address to this interface. Then we set up routing and masquerading via iptables to route traffic from our external Wifi-Adapter to our new usb0 interface.
For the usb0 interface to become available with each reboot we also need to create a script and a system service that executes this script every time the Raspberry Pi boots up.

#### INSTALL DEPENDENCIES AND CONFIGURE REQUIRED MODULES:

Make sure *rpi-eeprom* and other dependencies are installed:

`sudo apt install rpi-eeprom -y`<br>
`sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent`

First edit */boot/config.txt*:<br>
`sudo nano /boot/config.txt`

Insert this line at the end of the file:<br>
`dtoverlay=dwc2`

Next edit */boot/cmdline.txt*:<br>
`sudo nano /boot/cmdline.txt`

Insert:<br>
`modules-load=dwc2`

IMPORTANT:<br>
Do not start a new line. Insert at the end of the long line, the only separation should be a single space.

Then edit */etc/modules*:<br>
`sudo nano /etc/modules`

Insert at the bottom in a new line:<br>
`libcomposite`

#### CONFIGURE ROUTING, MASQUERADING AND STATIC IP:

Now we have defined the required modules. Next we assign a static IP-address to *usb0* by editing */etc/dhcpcd.conf*:<br>
`sudo nano /etc/dhcpcd.conf`

Insert at the end of the file:

```
interface usb0
    static ip_address=192.168.77.1/24
```

Now we need to enable routing and masquerading to forward internet traffic from wlan1 to other interfaces.

`sudo nano /etc/sysctl.d/routed-ap.conf`

Insert:

`# Enable IPv4 routing`<br>
`net.ipv4.ip_forward=1`

Also find and edit a line in */etc/sysctl.conf*:<br>
`sudo nano /etc/sysctl.conf`

Edit:<br>
`net.ipv4.ip_forward=1`

Execute these commands to set the required iptables:

`sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE`<br>
`sudo netfilter-persistent save

The Raspberry Pi is supposed to function similiar to a portable router. To achieve this we will use *dnsmasq* as a DNS forwarder and DHCP server. However, we have to keep in mind that we also want to use the *Pi-hole* (see next step) as an ad blocker and network filter. The *Pi-hole* comes bundled with its own version of *dnsmasq*, which will be in conflict with any other existing installation of *dnsmasq*. Thus, for now we will only set up our configuration files without installing *dnsmasq*:

Create configuration folder and main configuration file:<br>
`sudo mkdir /etc/dnsmasq.d`<br>
`sudo nano /etc/dnsmasq.conf`

Insert:<br>
`conf-dir=/etc/dnsmasq.d`

Next create the configuration file for *usb0*:<br>
`sudo nano /etc/dnsmasq.d/00-dnsmasq.conf`

Insert:

```
# USB Gadget
interface=usb0  # USB interface
dhcp-range=set:usb0,192.168.77.2,192.168.77.21,255.255.255.0,24h
dhcp-option=set:usb0,3,192.168.77.1
                # Default Gateway
address=/access.tardigrade/192.168.77.1
                # Alias for this router
```

#### SCRIPT AND SYSTEM SERVICE TO ENABLE USB0 AT BOOT:

Finally we also need to create a script that enables our *usb0* interface:<br>
`sudo nano /root/usb.sh`

Insert:

```
#!/bin/bash

cd /sys/kernel/config/usb_gadget/
mkdir -p pi4
cd pi4
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol
mkdir -p strings/0x409
echo "fedcba9877543777" > strings/0x409/serialnumber
echo "Term7" > strings/0x409/manufacturer
echo "Tardigrade" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
# see gadget configurations below
# End functions
mkdir -p functions/ecm.usb0
HOST="00:dc:c8:f7:75:14" # "HostPC"
SELF="00:dd:dc:eb:6d:a1" # "BadUSB"
echo $HOST > functions/ecm.usb0/host_addr
echo $SELF > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
udevadm settle -t 5 || :
ls /sys/class/udc > UDC

# Start USB Gadget
ifconfig usb0 up
```

Make */root/usb.sh* executable:<br>
`sudo chmod +X /root/usb.sh`

Create System Service to bring up USB interface on boot:<br>
`sudo nano /lib/systemd/system/usb.service`

Insert:

```
[Unit]
Description=USB Gadget
After=network.target

[Service]
ExecStart=/bin/bash /root/usb.sh

[Install]
WantedBy=multi-user.target
```

Enable service and unblock wlan:

`sudo systemctl enable usb.service`<br>
`sudo rfkill unblock wlan`

#### RESOURCES:

For this part of this guide we used these two resources:

Official Raspberry Pi documentation:
[https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md](https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md)

Tutorial by Ben Hardill:
[https://www.hardill.me.uk/wordpress/2019/11/02/pi4-usb-c-gadget/](https://www.hardill.me.uk/wordpress/2019/11/02/pi4-usb-c-gadget/)

We would like to thank the Raspberry Pi Foundation and Ben Hardill for the great tutorials that made this privacy gadget possible!


# 05 - Install Pi-hole

*Pi-hole is a Linux network-level advertisement and Internet tracker blocking application which acts as a DNS sinkhole and in our configuration also as a DHCP server, intended for use on a private network. It is designed for low-power embedded devices with network capability, such as the Raspberry Pi.*
[Pi-hole](https://pi-hole.net/)

#### INITIAL SETUP:

`cd Compile`<br>
`git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole`<br>
`cd "Pi-hole/automated install/"`<br>
`sudo bash basic-install.sh`<br>

During the installation process you will be asked to enter your preferred DNS Provider, IPv4 address, default gateway, DHCP-Range, etc.
Please enter the following information when prompted:

<p align="center">
  <img src="/png/Pi-hole_01.png" title="Welcome">
</p>
Ok

<p align="center">
  <img src="/png/Pi-hole_02.png" title="About">
</p>
Ok

<p align="center">
  <img src="/png/Pi-hole_03.png" title="Static IP Needed">
</p>
Ok: We already configured our static IP!
:-)

<p align="center">
  <img src="/png/Pi-hole_04.png" title="Select Interface">
</p>
Select wlan1: it is configured to be our intert facing interface.
Ok

<p align="center">
  <img src="/png/Pi-hole_05.png" title="Custom DNS">
</p>
DNS Provider, Select Custom: we will change this later, but for now we stick with CZ.NIC
Ok

<p align="center">
  <img src="/png/Pi-hole_06.png" title="Upstream DNS Provider">
</p>
Upstream DNS Provider: 193.17.47.1, 185.43.135.1
Ok

<p align="center">
  <img src="/png/Pi-hole_07.png" title="Is DNS correct?">
</p>
Select Yes

<p align="center">
  <img src="/png/Pi-hole_08.png" title="Blocklists">
</p>
OK: We will add more later!

<p align="center">
  <img src="/png/Pi-hole_09.png" title="Select Protocols">
</p>
OK

<p align="center">
  <img src="/png/Pi-hole_10.png" title="Use current settings?">
</p>
Important: Select No

<p align="center">
  <img src="/png/Pi-hole_11.png" title="Enter IPv4 Address">
</p>
Enter IPv4 Address: 192.168.77.1/24 *(This is the static IP we assigned to USB0)*
OK

<p align="center">
  <img src="/png/Pi-hole_12.png" title="Default Gateway">
</p>
Enter default gateway: 192.168.77.1
OK

<p align="center">
  <img src="/png/Pi-hole_13.png" title="Settings Correct?">
</p>
OK

<p align="center">
  <img src="/png/Pi-hole_14.png" title="Admin Interface">
</p>
Select On
OK

<p align="center">
  <img src="/png/Pi-hole_15.png" title=web server">
</p>
Select On
OK

<p align="center">
  <img src="/png/Pi-hole_16.png" title=log queries">
</p>
Select On:  *(We want to see what addresses our Mac connects to!)*
OK

<p align="center">
  <img src="/png/Pi-hole_17.png" title=privacy mode">
</p>
Select 0:  Show everything *(We want to see everything. There are no other users in this setup which is why this is ok!)*
OK

After a short installation period you will see this window:

<p align="center">
  <img src="/png/Pi-hole_18.png" title=passwd">
</p>
Write down your password!
OK


To enable your Pi-hole as your dhcp server, execute the following command:<br>
`sudo pihole -a enabledhcp "192.168.77.2" "192.168.77.21" "192.168.77.1" "24" "baer"`

If you want to change the password of your Pi-hole, execute this comand:<br>
`pihole -a -p`

To update the Pi-hole after each reboot, edit */etc/cron.d/pihole*:<br>
`sudo nano /etc/cron.d/pihole`

Change the first configuration line to:<br>
`@reboot root    PATH="$PATH:/usr/sbin:/usr/local/bin/" pihole updateGravity >/var/log/pihole_updateGravity.log || cat /var/log/pihole_updateGravity.log`

#### REBOOT:

Now it is time to reboot your Raspberry Pi:<br>
`sudo reboot now`

On your Mac, open System Preferences -> Network Settings
After a short while your Raspberry Pi should show up as *Tardigrade*. If it appears with a green dot (*Connected*), you should be able to browse the internet, even if your Mac's WI-FI is switched off.

<p align="center">
  <img src="/png/Network-Settings.png" title="Network-Settings">
</p>

You should now be able to log into your Privacy Gadget directly via SSH with either of these commands:

`ssh baer@192.168.77.1`<br>
`ssh baer@access.tardigrade`

#### RESOURCES:

A very big THANK YOU to the developers of the Pi-hole. This is a great project!
[https://pi-hole.net/](https://pi-hole.net/)


# 06 - Configure Encrypted DNS

We use *unbound* as a validating, recursive caching DNS server and *stubby* as an upstream DNS stub resolver. Our *Pi-hole* will have to be configured to use *unbound* for its DNS requests, while *unbound* needs to be configured to forward fresh requests to *stubby*:

First we configure *unbound* (*unbound* will use port 7397).  Because *unbound* caches DNS requests locally, repeated future DNS requests will be faster, more private and more secure. Further, we will setup *stubby* as an upstream DNS resolver (*stubby* will use port 9053). We do this, because if a DNS request is not in the *unbound* cache, *unbound* will have to perform an online DNS lookup. However, instead of directly requesting the required DNS information, i.e. from a Google Server, we forward this request to our installation of *stubby*, an upstream DNS resolver that can handle encrypted DNS requests. We will configure in *stubby* to contact a privacy respecting DNS service of our choice that also supports enrypted DNS (DNS-over-TLS) and that has a *no logs policy*. We use [blahdns](https://blahdns.de/) and [CZ.NIC](https://www.nic.cz/odvr/).
You can use our configuration or choose your own providers.
Finally we will configure our *Pi-hole* to forward all DNS requests to *unbound* instead of connecting directly to a DNS resolver. 

First we install *unbound* and *stubby*:

`sudo apt install unbound stubby -y`

#### CONFIGURE UNBOUND:

Download *unbound root hints*:<br>
`wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints`

Then create the configuration file for *unbound*:<br>
`sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf`

Insert:

```
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0
    root-hints: "/var/lib/unbound/root.hints"
    do-not-query-localhost:  no

    interface: 127.0.0.1
    port: 7397
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # Suggested by the unbound man page to reduce fragmentation reassembly problems
    edns-buffer-size: 1472

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10

forward-zone:
    name: "."
        forward-addr: 127.0.0.1@9053
        forward-addr: ::1@9053
```

#### CONFIGURE STUBBY:

Next we configure *stubby* to listen to requests made by *unbound* and to forward these DNS requests to [blahdns](https://blahdns.de/) and [CZ.NIC](https://www.nic.cz/odvr/):

`sudo mv /etc/stubby/stubby.yml /etc/stubby/stubby_original.yml`<br>
`sudo nano /etc/stubby/stubby.yml`

Insert:

```
################################################################################
######################## STUBBY YAML CONFIG FILE ###############################
################################################################################
resolution_type: GETDNS_RESOLUTION_STUB
dnssec_return_status: GETDNS_EXTENSION_TRUE

dns_transport_list:
  - GETDNS_TRANSPORT_TLS

tls_authentication: GETDNS_AUTHENTICATION_REQUIRED
tls_query_padding_blocksize: 256
edns_client_subnet_private : 1
idle_timeout: 10000

listen_addresses:
  - 127.0.0.1@9053
  - 0::1@9053


round_robin_upstreams: 1
upstream_recursive_servers:
############################ DEFAULT UPSTREAMS  ################################

#IPv4 ODVR
   - address_data: 193.17.47.1
     tls_auth_name: "odvr.nic.cz"
   - address_data: 185.43.135.1
     tls_auth_name: "odvr.nic.cz"

#IPv4 BLAHDNS
   - address_data: 192.53.175.149
     tls_auth_name: "dot-sg.blahdns.com"
   - address_data: 45.91.92.121
     tls_auth_name: "dot-ch.blahdns.com"
   - address_data: 139.162.112.47
     tls_auth_name: "dot-jp.blahdns.com"
   - address_data: 78.46.244.143
     tls_auth_name: "dot-de.blahdns.com"
   - address_data: 95.216.212.177
     tls_auth_name: "dot-fi.blahdns.com"

#IPv6 ODVR
   - address_data: 2001:148f:ffff::1
     tls_auth_name: "odvr.nic.cz"
   - address_data: 2001:148f:fffe::1
     tls_auth_name: "odvr.nic.cz"

#IPv6 BLAHDNS
   - address_data: 2400:8901::f03c:92ff:fe27:870a
     tls_auth_name: "dot-sg.blahdns.com"
   - address_data: 2a0e:dc0:6:23::2
     tls_auth_name: "dot-ch.blahdns.com"
   - address_data: 2400:8902::f03c:92ff:fe27:344b 
     tls_auth_name: "dot-jp.blahdns.com"
   - address_data: 2a01:4f8:c17:ec67::1 
     tls_auth_name: "dot-de.blahdns.com"
   - address_data: 2a01:4f9:c010:43ce::1
     tls_auth_name: "dot-fi.blahdns.com"
```

#### CONFIGURE PI-HOLE TO USE UNBOUND:

To configure *Pi-hole* to use *unbound*, we log into the *pi-hole web interface*. Here you can also install additional blocklists, setup your own custom blocklists, view query logs, etc.

To log into your *Pi-hole*, open your Mac's web browser and enter this address into the address bar:<br>
`http://192.168.77.1/admin/index.php?login`

<p align="center">
  <img src="/png/Pi-hole_Login.png" title="Pi-hole Login">
</p>

To log in, enter the password that was generated at the final step of the *Pi-hole* installation process, unless you already changed your password earlier. If you did, use the password you have set up.

Then, navigate to *Settings* and click on *DNS*.

<p align="center">
  <img src="/png/Pi-hole_DNS.png" title="Pi-hole DNS">
</p>

Make sure all boxes for pre-configured DNS providers are unchecked!
Further, delete all Upstream DNS Servers. Then enter the local address of your *unbound* installation as your only Custom DNS Server:<br>
`127.0.0.1#7397`

Since you are already checking your DNS settings, scroll down and make sure that your *Pi-hole* listens on all interfaces!

<p align="center">
  <img src="/png/Pi-hole_Interfaces.png" title="Pi-hole Interfaces">
</p>

#### RESOURCES:

Pi-Hole & Unbound:
[https://docs.pi-hole.net/guides/dns/unbound/](https://docs.pi-hole.net/guides/dns/unbound/)



# 07 - Setup Blocklists

Still in your *Pi-hole* web interface, navigate to *Group Management / Adlists*. Here you can add new blocklists. We strongly recommend [Steven Black's](https://github.com/StevenBlack/hosts) blocklist for fakenews, gambling, social trackers:

[https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-social/hosts](https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-social/hosts)

Further we recommend this malware and phishing blocklist by [Phishing Army](https://phishing.army/):
[https://phishing.army/download/phishing_army_blocklist_extended.txt](https://phishing.army/download/phishing_army_blocklist_extended.txt)

<p align="center">
  <img src="/png/Pi-hole_Adlists.png" title="Pi-hole Adlists">
</p>

Under *Blacklist Management* you can set your own custom blocklists. In this example we block ALL CONNECTIONS to apple servers and related 3rd parties.
We use RegEx filters for:

*apple, icloud, akamai, mzstatic, aapling, oscp*

<p align="center">
  <img src="/png/Pi-hole_Blocklists.png" title="Pi-hole Blocklists">
</p>

#### IMPORTANT - PLEASE NOTICE:

If you block *apple, icloud, akamai, mzstatic, aapling, oscp* via RegEx, your Mac won't be able to check for Updates, download Updates, connect to iCloud or to  the App-Store. FaceTime, Messages and other native macOS Apps won't be able to connect. This may be exactly what you want, but probably not. It requires a lot of patience, work and effort to fine-tune your custom filters. I.e. check your Query Log reqularly when you try to check for updates, to see which connections are blocked. Then try to whitelist specific processes which are required to perform an update.
Alternatively you could also log into your `Ph-hole` web interface and temporarily disable all RegEx Filters, then check for updates and re-enable your custom blocklists once you are done.


# 08 - VPN

Next we configure our etherent gadget to route all traffic, without exception, through a VPN. We use [ProtonVPN](https://protonvpn.com/) as an example. ProtonVPN features a built-in killswitch to prevent leaks. It has been [independently audited](https://protonvpn.com/blog/open-source/) and is protected by strong Swiss privacy laws.
If you want to use ProtonVPN as well, you first have to visit their [website](https://protonvpn.com/) and open account. You can use a [free account](https://protonvpn.com/support/how-to-create-free-vpn-account/) or choose one of the paid options.

To install ProtonVPN, execute the following two commands:<br>
`sudo apt install openvpn dialog python3-pip python3-setuptools -y`<br>
`sudo pip3 install protonvpn-cli`

To forward all traffic through the VPN we also need to setup the required iptable rule:<br>
`sudo iptables -t nat -A POSTROUTING -o proton0 -j MASQUERADE`<br>
`sudo netfilter-persistent save`

You need to initialize ProtonVPN only once. In future your RaspberryPi will connect automatically:<br>
`sudo protonvpn init`

You will be asked to enter your ProtonVPN username, your password and to choose your ProtonVPN subscription plan (enter whatever plan you purchased, i.e. *Free*, *Basic* or *Plus*) to complete the initialization.

To configure ProtonVPN run the following command:<br>
`sudo protonvpn configure`

Here you can change all of your settings, i.e. change the DNS Management of your VPN service or change the default protocol (we recommend TCP), etc. Please consider that the *Kill Switch* may interfere with your *Pi-hole* in a negative way. If you suddenly cannot connect anymore, we recommend you disable the *Kill Switch* and try again. The *Pi-hole* will most likely bypass your VPN's DNS-settings if you disable the *Kill Switch* (we did not test this).

To check the connection status of ProtonVPN, execute:<br>
`protonvpn status`

#### CREATE SYSTEM SERVICE TO START PROTONVPN AT BOOT:

`sudo nano /etc/systemd/system/protonvpn.service`

Insert:

```
[Unit]
Description=Proton VPN
After=syslog.target network-online.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/usr/local/bin/protonvpn c --sc
ExecStop=/usr/local/bin/protonvpn d
ExecReload=/usr/local/bin/protonvpn c --sc
Environment=SUDO_USER=baer
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
```

#### PLEASE NOTICE:

Unless you subscribed for a *Plus Membership* the above system service won't work, as it attempts to use ProtonVPN's [secure core](https://protonvpn.com/support/secure-core-vpn/) which is only available to paying *Plus Members*. If you always want to connect to the fastest server (any membership), insert these lines instead:

```
[Unit]
Description=Proton VPN
After=syslog.target network-online.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/usr/local/bin/protonvpn c --fastest
ExecStop=/usr/local/bin/protonvpn d
ExecReload=/usr/local/bin/protonvpn c --fastest
Environment=SUDO_USER=baer
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
```

If you always want to connect to a random server, replace *--fastest* with *--random*.
You can edit this command in your System Service according to your own preferences. To see all available options, run:<br>
`protonvpn -h`

Enable and start *protonvpn.service*:

`sudo systemctl enable protonvpn.service`<br>
`sudo systemctl start protonvpn.service`

#### IMPORTANT:

If all DNS requests were handled by *ProtonVPN* (i.e. if you enabled *DNS-leak Protection* and *Kill Switch*), your *Pi-hole* suddenly would stop filtering ads and trackers as long as you use the VPN. This is the reason why we do not recommend to use the *Kill Switch* in this specific setup. Also we recommend you disable *DNS Managment* in the ProtonVPN settings because we want our *Pi-hole* to manage all DNS requests to filter ads, trackers and malware - even while we use our VPN Service. This also is the  reason why we did configure our *Pi-hole* to listen on ALL INTERFACES and why we chose to setup encrypted DNS with trustworth, privacy respecting partners (hopefully).

To make sure the `Pi-hole` does filter VPN traffic as well, we need to add the VPN interface to its configuration (*dnsmasq*):<br>
`sudo nano /etc/dnsmasq.d/03-protonvpn.conf`

Insert:<br>
`interface=proton0 # VPN interface`

#### OPTIONAL:

IPv6 may be a privacy risk (we neither confirm nor oppose this claim). If you are unsure, you may disable IPv6 altogether to prevent DNS leaks:<br>
`sudo nano /etc/sysctl.conf`

Insert at the end:
```
# Disable IPv6

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

To make your changes take effect, run this command or reboot your device:
`sudo sysctl -p`

Another thing to do to protect your privacy, may be to connect to a privacy respecting time server, i.e. from [dismail.de](https://dismail.de/):<br>
`sudo nano /etc/systemd/timesyncd.conf`

Below `[Time]`, insert:<br>
`NTP=ntp1.dismail.de ntp2.dismail.de ntp3.dismail.de`

Reboot your device to make your changes take effect.



# 09 - Hidden Wifi Access Point

Sometimes, i.e. when you wiggle the USB-C cable, your connection to the RaspberryPi Privacy Gadget may become interrupted. If there was also a *Hidden Wifi Access Point*, you would still be able to connect to your *Privacy Gadget*, even if the USB-C connection was interrupted.
Another benefit of a *Hidden Wifi Access Point* is, that you could share the internet conenction of the *Privacy Gadget*, i.e. with your Smartphone as well. Simply log in and all traffic on your Smartphone will be filtered and routed through your VPN.
Also you could connect your *Privacy Gadget* to a power bank in your backback, connect to its *Hidden Wifi Access Point* and enjoy all its benefits.
In out setup we use the RaspberryPi's built-in Wifi Card as Access Point.

Install the required software:<br>
`sudo apt install hostapd -y`

Then execute these commands:<br>
`sudo rfkill unblock wlan`<br>
`sudo systemctl unmask hostapd`

Next, add the wifi interface to *dhcpcd.conf*:<br>
`sudo nano /etc/dhcpcd.conf`

Add these lines at the end:

```
interface wlan0
    static ip_address=192.168.79.1/24
    nohook wpa_supplicant
```

We also need to add the interface to our *Pi-hole* configuration (*dnsmasq*):<br>
`sudo nano /etc/dnsmasq.d/00-dnsmasq.conf`

Insert at the end:

```
# Wifi-AP
interface=wlan0 # Access Point
dhcp-range=set:wlan0,192.168.79.2,192.168.79.21,24h
                # Pool of IP addresses served via DHCP
dhcp-option=wlan0,3,192.168.79.1
                # Default Gateway
```

Finally we configure our *Hidden Wifi Access Point*:<br>
`sudo nano /etc/hostapd/hostapd.conf`

Insert:

```
country_code=US
interface=wlan0
ssid=HiddenAP
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=2
wpa=2
wpa_passphrase=Passphrase_for_my_hidden_AP!
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

Change the country code to your location and pick an ssid and wpa_passphrase of your choice!
In this setup your Wifi hotspot will be hidden. This means it will not automatically show up in your list of available networks. Instead you need to select *other* in your Mac's Network list and type both, *Network Name* and *Password* in order to connect.
If you want your *Hidden Wifi Access Point* to be a *Visible Wifi Access Point*, change the parameter behind `ignore_broadcast_ssid` to `0`.


# 10 - Firewall

It is important to secure your Raspberry Pi. For that purpose we configure a firewall via iptables. To make it easier for you we set up iptable scripts that you can run at any moment to enable your firewall rules, and also to delete them if you run into connectivity problems. We cover some firewall rules we think are important. Feel free to edit and expand on these scripts. We provide a separate script for both IPv4 and IPv6 connections.

`mkdir Script`<br>
`mkdir Script/iptables`<br>
`sudo nano Script/iptables/iptables.sh`

Insert:

```
#/bin/sh

# Allow DNS and HTTP needed for name resolution (Pi-hole) and accessing the Web interface:
iptables -A INPUT -i usb0 -p tcp --destination-port 53 -j ACCEPT
iptables -A INPUT -i usb0 -p udp --destination-port 53 -j ACCEPT
iptables -A INPUT -i usb0 -p tcp --destination-port 80 -j ACCEPT

# Allow SSH only via USB and Wifi-AP:
iptables -A INPUT -i usb0 -p tcp --destination-port 1985 -j ACCEPT
iptables -A INPUT -i wlan0 -p tcp --destination-port 1985 -j ACCEPT
iptables -A INPUT -i wlan1 -p tcp --destination-port 1985 -j DROP
iptables -A INPUT -i wlan2 -p tcp --destination-port 1985 -j DROP

# Allow TCP/IP to do three-way handshakes:
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow loopback traffic:
iptables -I INPUT -i lo -j ACCEPT

# Since there only can be a wired connection between the Pi and your computer, allow all traffic on usb0:
iptables -I INPUT -i usb0 -j ACCEPT

# Allow Wifi-AP:
iptables -I INPUT -i wlan0 -j ACCEPT

# Reject all access from anywhere else:
iptables -P INPUT DROP

# Block HTTPS advertisements to improve blocking ads that are loaded via HTTPS and also deal with QUIC:

iptables -A INPUT -p udp --dport 80 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp --dport 443 -j REJECT --reject-with icmp-port-unreachable

# Block Ping Requests:
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Save iptables
netfilter-persistent save
```

For IPv6:
`sudo nano Script/iptables/ip6tables.sh`

Insert:

```
#/bin/sh

# Allow DNS and HTTP needed for name resolution (Pi-hole) and accessing the Web interface:
ip6tables -A INPUT -i usb0 -p tcp --destination-port 53 -j ACCEPT
ip6tables -A INPUT -i usb0 -p udp --destination-port 53 -j ACCEPT
ip6tables -A INPUT -i usb0 -p tcp --destination-port 80 -j ACCEPT

# Allow SSH only via USB and Wifi-AP:
ip6tables -A INPUT -i usb0 -p tcp --destination-port 1985 -j ACCEPT
ip6tables -A INPUT -i wlan0 -p tcp --destination-port 1985 -j ACCEPT
ip6tables -A INPUT -i wlan1 -p tcp --destination-port 1985 -j DROP
ip6tables -A INPUT -i wlan2 -p tcp --destination-port 1985 -j DROP

# Allow TCP/IP to do three-way handshakes:
ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow loopback traffic:
ip6tables -I INPUT -i lo -j ACCEPT

# Since there only can be a wired connection between the Pi and your computer, allow all traffic on usb0:
ip6tables -I INPUT -i usb0 -j ACCEPT

# Allow Wifi-AP:
ip6tables -I INPUT -i wlan0 -j ACCEPT

# Reject all access from anywhere else:
ip6tables -P INPUT DROP

# Block HTTPS advertisements to improve blocking ads that are loaded via HTTPS and also deal with QUIC:

ip6tables -A INPUT -p udp --dport 80 -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset
ip6tables -A INPUT -p udp --dport 443 -j REJECT --reject-with icmp6-port-unreachable

# Block Ping Requests:
ip6tables -A INPUT -p icmp -j DROP

# Save ip6tables
netfilter-persistent save
```

This script will flush all your IPv4 firewall rules:
`sudo nano Script/iptables/flush_iptables.sh`

Insert:

```
#bin/sh

# Accept all traffic first to avoid ssh lockdown  via iptables firewall rules #
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush All Iptables Chains/Firewall rules #
iptables -F

# Delete all Iptables Chains #
iptables -X

# Flush all counters too #
iptables -Z

# Flush and delete all nat and mangle #
#iptables -t nat -F
#iptables -t nat -X
#iptables -t mangle -F
#iptables -t mangle -X
#iptables iptables -t raw -F
#iptables -t raw -X

# Save iptables
netfilter-persistent save
```

The same for IPv6:
`sudo nano Script/iptables/flush_iptables.sh`

Insert:

```
#bin/sh

# Accept all traffic first to avoid ssh lockdown  via iptables firewall rules #
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT

# Flush All Iptables Chains/Firewall rules #
ip6tables -F

# Delete all Iptables Chains #
ip6tables -X

# Flush all counters too #
ip6tables -Z

# Flush and delete all nat and  mangle #
#ip6tables -t nat -F
#ip6tables -t nat -X
#ip6tables -t mangle -F
#ip6tables -t mangle -X
#ip6tables iptables -t raw -F
#ip6tables -t raw -X

# Save ip6tables
netfilter-persistent save
```

Make all scripts executable:
`sudo chmod +x Script/iptables/iptables.sh`
`sudo chmod +x Script/iptables/ip6tables.sh`
`sudo chmod +x Script/iptables/flush_iptables.sh`
`sudo chmod +x Script/iptables/flush_ip6tables.sh`

Finally, to enable your firewall run these two commands:
`sudo Script/iptables/iptables.sh`
`sudo Script/iptables/ip6tables.sh`

#### OPTIONAL: ASN SCRIPT TO BLOCK ENTIRE IP-ADDRESS RANGES:

This [ASN_IPFire_Script](https://notabug.org/maloe/ASN_IPFire_Script) can be used to block entire IP-Address ranges that belong to companies that you don't want to be tracked by. It will effectively prevent any connection to the company you specify:

`cd Script/iptables`<br>
`git clone https://notabug.org/maloe/ASN_IPFire_Script.git`<br>
`sudo mv ASN* ASN`<br>
`cd ASN`<br>
`rm -r old`<br>
`rm asn_ipfire_v0.7.7_beta2_termux.sh`<br>

Next we need to create our own custom configuration file, we will use *Facebook* as an example for this script:

`sudo mv asn_script.conf asn_script_backup.conf`<br>
`sudo nano asn_script.conf`

Insert:

```
#######################################################################
## Configuration file for ASN-IPFire-Script v0.7.12 (asn_ipfire.sh)  ##
#######################################################################

downloadtool=wget
timeout=30

iptables_path="/sbin/iptables"
outputline="$iptables_path -A OUTPUT -d %network% -j REJECT # %company% Nr.%number%"

#Specify the tracking company you want to block:
output_file="Facebook.sh"
```

To collect the IP-address range of *Facebook* and create a file with the required IP-tables commands, run the following command:<br>
`sudo bash asn_ipfire.sh --custom Facebook`

Next make this file executable:<br>
`sudo chmod +X Facebook.sh`

Now run this script tp block all IP-Addresses connected to *Facebook*:<br>
`sudo bash Facebook.sh`

To make these changes permanenent, run the following command:<br>
`sudo netfilter-persistent save`

#### USEFULL IPTABLES COMMANDS:

View current iptables routing rules:<br>
`sudo iptables -t nat -v -L -n --line-number`

View current iptables rules:<br>
`sudo iptables -L -n -v`

#### TO DO:

In future we will add a simple script here, that makes blocking IP-Address ranges in our setup easier (only one command).

#### RESOURCES:

In this part of our guide, we refer to the ASN IPFire Script by maloe and a blog post by Mike Kuketz:

[ASN_IPFire_Script](https://notabug.org/maloe/ASN_IPFire_Script)<br>
[ASN-Skript: Datensammler haben ausgeschnüffelt – IPFire Teil3](https://www.kuketz-blog.de/asn-skript-datensammler-haben-ausgeschnueffelt-ipfire-teil3/)


# 11 - Randomized Device Identity

If you are connected to a public Wifi, the service provider may log your devices MAC address and its hostname. Over time this information can be used to profile and to track you. If you are using a VPN, the service provider won't be able anymore to see which websites you visit - only that you use a VPN. To further anonymize our Privacy Gadget we decided to spoof its MAC address with every reboot. Further we wrote a short script that picks a random word from a dictionary as a hostname during each reboot.


#### SPOOF MAC ADDRESS:

Download *macchanger*:<br>
`sudo apt install macchanger -y`

IMPORTANT!
During the installation process: select no when asked if *macchanger* should automatically generate new MAC addresses. We will set up a system service that does this job better:<br>
`sudo nano /etc/systemd/system/spoofmac@.service`

Insert:

```
[Unit]
Description=changes mac for %I
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
ExecStart=/usr/bin/macchanger -r %I
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Now we enable the System Service to individually randomize the MAC Addresses of both Wifi-Cards:

`sudo systemctl enable spoofmac@wlan0.service`
`sudo systemctl enable spoofmac@wlan1.service`


#### RANDOMIZE HOSTNAME:

First we download a dictionary and move it to the required location:

`wget http://gwicks.net/textlists/ukenglish.zip`<br>
`unzip ukenglish.zip`<br>
`rm ukenglish.zip`<br>
`sudo mv ukenglish.txt /usr/share/dict/`

Create a script that randomized the hostname:<br>
`sudo nano /root/hostname.sh`

Insert:

```
#!/bin/bash

# Random Hostname Generator

ALL_NON_RANDOM_WORDS=/usr/share/dict/ukenglish.txt
non_random_words=`cat $ALL_NON_RANDOM_WORDS | wc -l`

NEW_HOSTNAME=$(WORD=`od -N3 -An -i /dev/urandom |
awk -v f=0 -v r="$non_random_words" '{printf "%i\n", f + r * $1 / 16777216}'` 
sed `echo $WORD`"q;d" $ALL_NON_RANDOM_WORDS
  let "X = X + 1")

# Change Static Hostname
hostnamectl set-hostname $NEW_HOSTNAME
head -n -1 /etc/hosts > /etc/tmp
mv /etc/tmp /etc/hosts
echo -e "127.0.1.1      $NEW_HOSTNAME" >> /etc/hosts
```

Make this script executable:<br>
`sudo chmod +X /root/hostname.sh`

Then we also create a System Service that runs our script each time you boot up the RaspberryPi:<br>
`sudo nano /etc/systemd/system/hostname.service`

Insert:

```
[Unit]
Description=Random Hostname
Wants=network-pre.target
Before=network-pre.target

[Service]
ExecStart=/bin/bash /root/hostname.sh

[Install]
WantedBy=multi-user.target
```

Finally enable the service:<br>
`sudo systemctl enable hostname.service`

# 12 - Optional Custom Login Information


#### MESSAGE OF THE DAY

We use a dynamic message of the day to display system information once we log into our Privacy Gadget via ssh. To set up dynamic *motd* run the following commands:

`sudo mkdir /etc/update-motd.d`<br>
`cd /etc/update-motd.d`<br>
`sudo touch 00-header && sudo touch 10-sysinfo && sudo touch 90-footer`<br>
`sudo chmod +x /etc/update-motd.d/*`<br>
`sudo rm /etc/motd`<br>
`sudo rm /etc/update-motd.d/10-uname`<br>
`sudo ln -s /var/run/motd /etc/motd `

We use figlet to display our hostname:<br>
`sudo apt install figlet -y`

Next edit:<br>
`sudo nano /etc/pam.d/ssh`

Insert:

```
session    optional     pam_motd.so  motd=/run/motd.dynamic
# session    optional     pam_motd.so noupdate
```

Next remove the original *motd system service*

`sudo rm /lib/systemd/system/motd.service`<br>
`sudo systemctl daemon-reload`

Now we create the dynamic *motd header*:<br>
`sudo nano /etc/update-motd.d/00-header`

Insert:

```
#!/bin/sh
[ -r /etc/lsb-release ] ; /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] ; [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

echo "--------------------------------------------------------------------------------"

printf "\n"
figlet $(hostname)
printf "* %s (%s).\n" "$DISTRIB_DESCRIPTION" "$(uname -rm)"
printf "\n"

echo "--------------------------------------------------------------------------------

                                                     ..
                                     .ckdl'        .oKO;
                                      .kWMMKxxkkkxkXMWd.
                              .      .:OWMMMWNXKXXNMMW0l.
                            ,k0d.    ;OWMNKkl;'....,cdKWWKo..'coo'
                            ,0WWk. .dXMNx,.           .lKMWK0NMWXc
                           .;kWMW0kXWW0:        .;cl;.  ,0MMWKd:.
                  .'.   .lOXWMMMWWNKkc.        .xNMMWO'  :XMNl
                 oXNKOxxXMWKxlc::;'.           'OWMMMK;  '0MWo
                 'lx0XWMMXo.              ..    'oxkd,   ,KMWx.
                    .cXMWo      .'.    .cOKKOl.         .xWMMNKkd;.
                     ,KMNc     ,ONXo.  '0MMMMK,        'kWMXkk0XW0'
                     .kWMO'    'xK0c    ,dkkd;       .lKMWO,  ..'.
                      ,0MWKl.    ..                'oKWMXo.
                    .:xXMMMWKxc,.             .':oONMMMMK;
                   'OMWXOdokXWMNKOkdolllllooxOKNWMN0dlkWMK;
                    ,c:.    .:o0WMMWWWMMMMMMMNKkdc,.  .dXXl
                     '        .dWMKc,;;;l0WMM0;         ..
                              ;KMNl      ,d0MWx.
                              .ld:.        'ox:.


--------------------------------------------------------------------------------"
```

Below the header we insert some system information:<br>
`sudo nano /etc/update-motd.d/10-sysinfo`

Insert:

```
#!/bin/bash

date=`date`
load=`cat /proc/loadavg | awk '{print $1}'`
memory_usage=`free -m | awk '/Mem:/ { total=$2; used=$3 } END { printf("%3.1f%%", used/total*100)}'`
processes=`ps aux | wc -l`
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }'`
temperature=`/usr/bin/vcgencmd measure_temp | cut -c "6-9"`
time=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`

echo
echo "System Information: $date"
echo
printf "\e[1;36mSystem Load:\t%s\t     Memory Usage:\t%s\n" $load $memory_usage
printf "Processes:\t%s\t     Swap Usage:\t%s\n" $processes $swap_usage
printf "CPU Temp.:\t%s°C\t     System Uptime:\t%s\n\e[0m" $temperature "$time"
echo
```

Finally we create the *motd footer*:<br>
`sudo nano /etc/update-motd.d/90-footer`

Insert:

```
#!/bin/sh

[ -f /etc/motd.tail ] ; cat /etc/motd.tail || true

echo "--------------------------------------------------------------------------------"
```


#### CUSTOM BASH_PROFILE

Further we edited a publicly available *.bash_profile* to display information related to VPN connectivity status, Wifi-AP, external IP-Address. etc. once we log into our Privacy Gadget via ssh. Further we added an *Alias* that allows you to switch your Wifi-AP on and off with two simple commands: *ap-on* and *ap-off*. Here you can insert your own *Aliases* as shortcuts to more complex commands.

`sudo nano .bash_profile`

Insert:

```
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
```

# 13 - Disable Wifi on MacOS

If you want to make sure that all your internet traffic is only routed through your RaspberryPi Privacy Gadget, we recomend you disable your Mac's Wifi on boot (you can always switch it on manually). This cannot be done via your Mac's System Settings. Your Mac will always automatically switch on your Wifi and try to connect to known networks.
This is why we need to configure a *startup deamon* on our Mac that switches off Wifi before it can try to connect to known networks.

On your Mac, open a Terminal window and type the following command:<br>
`sudo nano /Library/LaunchAgents/off.networksetup.plist`

Insert:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>off.networksetup</string>
    <key>LaunchOnlyOnce</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
        <string>networksetup</string>
        <string>-setairportpower</string>
        <string>en0</string>
        <string>off</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

At last we set file ownership and permissions:

`sudo chown root:wheel /Library/LaunchAgents/off.networksetup.plist`<br>
`sudo chmod 644 /Library/LaunchAgents/off.networksetup.plist`<br>

You do not need to load this *daemon* now. If you do, it will switch off your Mac's Wifi adapter immideately. From now on, will be loaded automatically during each reboot. However, if you want to try it out, execute the following command:

`sudo launchctl load /Library/LaunchAgents/off.networksetup.plist`

# 14 - To Do

We are planning to create a simple web interface that makes it easy for you to connect to new Wifi-Networks, block and allow IP-Address Ranges with your ASN Script. etc.


#### RECOMMENDATIONS:

We do recommend you secure your SSH configuration, i.e. by changing the default ssh port - maybe you even want to use a hardware key (i.e. Yubikey) to log into your Raspberry Pi.




## MIT License

Copyright (c) 2021 term7

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

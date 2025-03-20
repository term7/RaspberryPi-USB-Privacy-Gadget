# Going Dark: USB Privacy Gadget based on a Raspberry Pi
*A portable RaspberryPi USB Ethernet Gadget that safeguards your Privacy*

Are you aware of the growing concerns among European law enforcement about people [going dark](https://home-affairs.ec.europa.eu/networks/high-level-group-hlg-access-data-effective-law-enforcement_en)? The so-called High Level Group (HLG) is actively working to undermine end-to-end encryption, pushing for backdoor access to encrypted messaging apps, cloud storage, and email services. EDRi has dissected the critical flaws in this approach: [https://edri.org/?s=going+dark](https://edri.org/?s=going+dark)

If you haven’t gone dark yet, now is the time!

This repository is both a guide and a step-by-step tutorial for configuring a Raspberry Pi 4 as a USB Ethernet Gadget. It forces your computer to route all internet traffic through either a WireGuard VPN or a Tor Transparent Proxy while filtering outbound traffic, blocking ads and trackers, and spoofing its device identity for enhanced privacy.

- [01 INTRODUCTION](#01-introduction)
- [02 FEATURES](#02-features)
- [03 PREREQUISITES](#03-prerequisites)
- [04 USER ACCESS CONTROL](#04-user-access-control)
- [05 HARDEN SSH CONFIGURATION](#05-harden-ssh-configuration)
- [06 UNATTENDED UPGRADES](#06-unattended-upgrades)
- [07 DISABLE IPv6](#07-disable-ipv6)
- [08 RANDOM MAC ADDRESS](#08-random-mac-address)
- [09 RANDOM HOSTNAME](#09-random-hostname)
- [10 SETUP USBC ETHERNET GADGET](#10-setup-usbc-ethernet-gadget)
- [11 SETUP WIRELESS HOTSPOT](#11-setup-wireless-hotspot)
- [12 SETUP NTP](#12-setup-ntp)
- [13 DHCP & DNS WITH UNBOUND AND ADGUARDHOME](#13-dhcp-&-dns-with-unbound-and-adguardhome)
- [14 NGINX REVERSE PROXY AND SSL](#14-nginx-reverse-proxy-and-ssl)
- [15 CONFIGURE ADGUARDHOME](#15-configure-adguardhome)
- [16 DNS BLOCKLISTS](#16-dns-blocklists)
- [17 FIREWALL](#17-firewall)
- [18 WIREGUARD VPN](#18-wireguard-vpn)
- [19 TOR TRANSPARENT PROXY](#19-tor-transparent-proxy)
- [20 LOCAL WEB CONTROL INTERFACE](#20-local-web-control-interface)

* * *

## 01 INTRODUCTION

We first came up with the idea for this Raspberry Pi Ethernet Gadget five years ago, when Apple publicly released macOS Big Sur in the fall of 2020. During the transition, we noticed that our installation of Little Snitch—a host-based firewall—had partially stopped working. More specifically, all Apple processes were no longer being filtered. Strange.

As we investigated the issue online, we came across a blog post by security researcher Jeffrey Paul, titled [Your Computer Isn't Yours](https://sneak.berlin/20201112/your-computer-isnt-yours/#updates). His findings shed light on the problem, and we highly recommend reading this article before setting up your own Raspberry Pi Privacy Gadget.

In short: modern macOS versions have a built-in capability to bypass internal firewalls and VPNs. Additionally, every Apple computer continuously connects to both Apple’s servers and third parties (such as Fastly) to transmit hashes of apps being used—every time they are launched.<br>
Apple claims this feature exists solely to prevent malicious or blacklisted apps from running if an online certificate check fails. While this may be true, it also means Apple can always determine when you’re online, where you are, how long you use specific software (e.g., VMWare Fusion), and even when you launch privacy-focused tools like the Tor Browser.<br>
Over time, this data collection builds a highly detailed profile of your digital habits, physical movements, and activity patterns. Worse, this information can potentially be correlated with other big data sources from corporations like Google, Microsoft, and Facebook. As Jeffrey Paul aptly points out:

*Since October of 2012, Apple is a partner in the US military intelligence community’s PRISM spying program, which grants the US federal police and military unfettered access to this data without a warrant, any time they ask for it.*

We see this as a deeply concerning development: yet another step toward surveillance capitalism that undermines the privacy of all Apple users.

To be fair, Apple has faced significant criticism for these practices. As a result, some of these intrusions, such as the ContentFilterExclusionList, which allowed native Apple apps to bypass local firewalls and VPNs — have since been revoked: [A Wall without a Hole](https://blog.obdev.at/a-wall-without-a-hole/).

According to Apple, [privacy](https://www.apple.com/privacy/) is a fundamental human right:

*Privacy is a fundamental human right. At Apple, it’s also one of our core values. Your devices are important to so many parts of your life. What you share from those experiences, and who you share it with, should be up to you. We design Apple products to protect your privacy and give you control over your information. It’s not always easy. But that’s the kind of innovation we believe in.*

Yet, claiming to deeply care about user privacy while participating in programs like [PRISM](https://en.wikipedia.org/wiki/PRISM_(surveillance_program)#Extent_of_the_program), exposes a double-standard that should not be tolerated.

Who’s to say something like the ContentFilterExclusionList won’t quietly return in a future update?
We believe Apple cannot be trusted with our data. That’s why we built the Raspberry Pi Ethernet Gadget—a portable external network filtering device designed to make data harvesting as difficult as possible.

As Jeffrey Paul rightly points out: Your computer is not yours.<br>
But it should be!

* * *

On February 21, 2025, Apple disabled its Advanced Data Protection (ADP) feature for UK customers, likely in response to a secretive UK government directive issued under the Investigatory Powers Act of 2016. ​Already on 7 February 2025, the [Washington Post](https://www.washingtonpost.com/technology/2025/02/07/apple-encryption-backdoor-uk/) reported on a leaked document that anticipated Apple's move.

This directive, known as a Technical Capability Notice, compelled Apple to provide backdoor access to encrypted iCloud data, effectively undermining the end-to-end encryption that ADP offers. In compliance, Apple ceased offering this feature to new UK users and announced plans to disable it for existing users. 

*"The UK Government has given themselves the power to serve companies anywhere in the world notices that order them to undermine the security of their users, products, or services in secret. The company can’t tell anyone, they can’t even publicly say they’ve received one. They can’t say if they disagree, they can’t let users know they’ve been affected, and they can’t question the power in open court because the secret order is, well, secret. The notice affects millions of people, who aren’t allowed to find out it exists.”*

[Privacy International](https://privacyinternational.org/news-analysis/5530/apple-and-long-secret-arm-uk-government)

Apple has since filed an [appeal](https://www.ft.com/content/3d8fe709-f17a-44a6-97ae-f1bbe6d0dccd?utm_source=chatgpt.com) with the Investigatory Powers Tribunal, challenging the legality of the government's order. The outcome of this appeal could have significant implications for user privacy and the extent of government surveillance powers in the UK. 

However, this effectively means that all data stored in the cloud by UK customers is no longer end-to-end encrypted. Instead, Apple retains the encryption keys, meaning the company must hand them over upon receiving a warrant.

This is not just a policy change: it is an outright assault on encryption and online privacy as a whole.

#### RECOMMENDED READING:

Privacy International:<br>
[https://privacyinternational.org/news-analysis/5530/apple-and-long-secret-arm-uk-government](https://privacyinternational.org/news-analysis/5530/apple-and-long-secret-arm-uk-government)
[https://privacyinternational.org/explainer/5531/pis-opinion-how-uk-government-making-security-harder-everyone](https://privacyinternational.org/explainer/5531/pis-opinion-how-uk-government-making-security-harder-everyone)

The Washington Post:<br>
[https://www.washingtonpost.com/technology/2025/02/07/apple-encryption-backdoor-uk/](https://www.washingtonpost.com/technology/2025/02/07/apple-encryption-backdoor-uk/)

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

* * *

## 02 FEATURES

**GOING DARK: This Raspberry Pi Privacy Gadget acts as a portable router, giving you complete control over all network traffic—including native Apple processes. By following our guide, your Mac’s Wi-Fi will be completely disabled. Instead, it will connect to the Raspberry Pi via USB-C, while the Raspberry Pi manages the internet connection.**

**1) MODE 1: Network-Wide Filtering with AdGuardHome**

 In this mode, your Ethernet Gadget filters all traffic through AdGuardHome, a self-hosted DNS sinkhole designed to block ads, trackers, and malicious domains across your entire network. To further enhance privacy, we configure Unbound as the upstream DNS resolver, ensuring that your queries are resolved privately without relying on third-party DNS providers. Additionally, we install extensive blocklists, including our own Ultimate Apple Blocklist, which blocks all domains owned by Apple. WARNING: Enabling this blocklist will break Apple services and software. Proceed with caution.

**2) MODE 2: Encrypted VPN Tunnel with WireGuard (Optional Setup)**

In this mode, you can use your Raspberry Pi as a WireGuard client, allowing it to establish a secure, encrypted VPN tunnel. You can connect to your home router (RECOMMENDED - if WireGuard is installed and configured) or to any other WireGuard server of your choice (NOT RECOMMENDED). Even with the VPN enabled, AdGuardHome will continue filtering ads and trackers before forwarding DNS requests through the encrypted tunnel. This ensures both privacy and security while maintaining full network-wide ad blocking.

**3) MODE 3: Tor Transparent Proxy**

In this mode, all your internet traffic is routed through a Tor Transparent Proxy, providing anonymity by passing your connections through the Tor network. Even in this setup, AdGuardHome continues filtering ads and trackers before traffic enters the Tor network, enhancing privacy and reducing unnecessary connections. Important Note: This is not necessarily the recommended approach for anonymity. If your goal is to browse the web privately, it is strongly advised to use the Tor Browser instead, as it provides additional protections that a transparent proxy cannot.

**4) Wireless Hotspot Support**

In addition to connecting your Mac via USB, your Raspberry Pi Privacy Gadget can also function as a wireless hotspot, allowing other devices—such as smartphones—to connect and use MODE 1, MODE 2, or MODE 3 for enhanced privacy and security. Important Note: If you want to connect the Raspberry Pi to a Wi-Fi network while running a hotspot, you’ll need an additional Wi-Fi adapter.<br>
For this tutorial, we use the [ALFA AWUS036ACM](https://www.alfa.com.tw/products/awus036acm_1?_pos=1&_ss=r&variant=40320133464136), which works out of the box and provides stable dual-band Wi-Fi connectivity.

**5) Hardened Security**

To ensure maximum security, we implement multiple layers of protection:

- Firewall Protection with nftables – We configure nftables as a robust firewall, dynamically managed via NetworkManager’s dispatcher to seamlessly adapt between MODE 1, MODE 2, and MODE 3, ensuring secure and reliable operation.
- Hardened SSH Configuration – Secure access is enforced through a carefully hardened SSH setup, reducing attack vectors and improving overall system integrity.
- User Access Control – We establish separate admin and standard user accounts, following best security practices to limit privileges and reduce risks.
- Automated Security Updates – Unattended upgrades ensure that critical software remains up to date, minimizing vulnerabilities and enhancing system resilience.

**6) Randomized Device Identity**

Whenever you connect to a public Wi-Fi network, only your Raspberry Pi Ethernet Gadget’s identity will be logged — not your Mac’s. This prevents network operators from tracking your actual device.

To further enhance privacy:

- MAC Address Randomization – The Ethernet Gadget generates a new, random MAC address on every reboot, making device tracking significantly harder.
- Random Hostname Generation – On each reboot, the Ethernet Gadget selects a random hostname from a predefined dictionary, preventing easy identification.

These measures ensure that your digital footprint remains as anonymous as possible when connecting to public networks.

**7) Privacy Respecting NTP Server**

To maintain accurate system time without compromising privacy, we configure the Raspberry Pi Ethernet Gadget to use privacy-respecting NTP servers from [ntppool.org](https://www.ntppool.org/en/use.html).

Key Features:
- Privacy-Focused Time Synchronization – Ensures system time is updated via trusted NTP servers while avoiding centralized, privacy-invasive time sources.
- Extended Offline Support – Configured to handle longer periods of downtime, allowing the device to reconnect to the internet even after being switched off for an extended period.
- Local Time Server for Connected Devices – Clients using the Raspberry Pi Ethernet Gadget can sync their system time directly from the Pi’s built-in NTP server.
- Optional: For even more reliability, we recommend installing a hardware clock (RTC module) to prevent synchronization issues.

**8) Local Web Interface**

To simplify management, we set up a local web interface that allows you to:

- Easily switch between MODE 1, MODE 2, and MODE 3
- Connect the Raspberry Pi to external Wi-Fi networks without using terminal commands
- Enable or disable the Hotspot with a single click

This intuitive interface provides seamless control over your Raspberry Pi Ethernet Gadget, making it easy to configure settings directly from your browser.

* * *

## 03 PREREQUISITES

#### HARDWARE:

For this setup, we use a Raspberry Pi 4B (8GB). To ensure stable performance, it's essential to use a high-quality USB-C cable that supports fast data transfer. Additionally, we use the [ALFA AWUS036ACM](https://www.alfa.com.tw/products/awus036acm_1?_pos=1&_ss=r&variant=40320133464136). If you choose a different external WiFi adapter, ensure it is compatible with Raspberry Pi OS and update the interface name in this tutorial accordingly! A reliable microSD card is crucial for smooth operation. Avoid cheap, low-quality brands. We highly recommend SanDisk A1-rated cards, as they offer excellent performance. High-endurance microSD cards are also a great option—they are fast enough and provide outstanding durability based on our experience. A 32GB card is more than sufficient for this setup.

#### OPTIONAL:

An active cooling system to prevent overheating, especially during hot summer days. We recommend the [EP-0163 Ice Tower](https://wiki.52pi.com/index.php?title=EP-0163) for efficient cooling. A Real-Time Clock (RTC) module, such as the [RV3028](https://shop.pimoroni.com/products/rv3028-real-time-clock-rtc-breakout?variant=27926940549203), is useful for maintaining accurate time synchronization, especially when the Raspberry Pi stays switched off or offline for a prolonged period of time. It fits neatly alongside the EP-0163 Ice Tower.

#### INSTALL RASPBERRY Pi OS (Headless Setup)

**1. Download and Install the Raspberry Pi Imager**

- Get the official [Raspberry Pi Imager](https://downloads.raspberrypi.org/imager/imager_latest.dmg)  and install Raspberry Pi OS Lite (64-bit), based on Debian Bookworm.

**2. Enable SSH and Configure Network**

- We recommend a headless setup, meaning you won't need an external monitor, mouse, or keyboard. Instead, you can complete the entire setup from your computer.
- The advantage of a headless setup is that it skips the Welcome Wizard and allows you to remotely access the Raspberry Pi immediately after the first boot.
- To achieve this, make sure to set up the username, password, and network configuration through the OS customization settings in Raspberry Pi Imager. For this tutorial we use **Username: term7** as username. If you choose a different username, make sure to replace it accordingly whenever it appears in this tutorial.
- If you're unfamiliar with setting up a Raspberry Pi for the first time, follow our detailed headless installation guide: [Headless Raspberry Pi OS Setup Guide](https://term7.info/intro-raspberry-pi/#PI-IMAGER)

**3. Update Your System**

- After installation, update your Raspberry Pi OS as described in the tutorial linked above. There’s no need to follow additional steps from that guide.<br>

**4. Additional Tweaks**

However, if you're interested, you might want to check out: [Z-Ram Tweaks](https://term7.info/intro-raspberry-pi/#Z-RAM): These optimizations can improve system performance, especially on low-memory setups.<br>
[MOTD Tweaks](https://term7.info/intro-raspberry-pi/#MOTD): Customizing the Message of the Day (MOTD) can enhance your login experience with useful system info. Both tweaks are optional but can be beneficial.<br>
Skip the sections on user access management, SSH hardening, and firewall setup. These will be fully covered in this tutorial!

#### EXPAND FILE SYSTEM AND ENABLE PREDICTABLE INTERFACE NAMES

To configure your Raspberry Pi, open the Raspberry Pi Configuration Tool by running:
```
sudo raspi-config
```

**1. Expand Filesystem**

- Navigate to 6. Advanced Options → A1 Expand Filesystem.
- This ensures that the full storage capacity of your SD card is available.

**2. Enable Predictable Network Interface Names**

- Go to 6. Advanced Options → A2 Network Interface Names.
- Enable predictable network interface names. This is crucial for this tutorial!

We are working with the built-in WiFi (*wlan0*) and an external WiFi adapter (*wlx00c0caae6319*), which is the predictable interface name for the ALFA AWUS036ACM. By enabling predictable network interface names, we can reliably distinguish between the built-in and external WiFi adapters. Without this setting, the external WiFi card might occasionally be assigned wlan0 instead of the built-in WiFi, which could cause issues with our firewall and routing configurations.

* * *

## 04 USER ACCESS CONTROL

We establish separate admin and standard user accounts, following best security practices to limit privileges and reduce risks. The admin account (admin) is reserved for system maintenance and configuration, while the standard user account (term7) is used for everyday tasks with minimal permissions.

By enforcing the principle of least privilege (PoLP), we enhance security and minimize potential attack vectors: This setup allows us to disable root login via SSH, adding an extra layer of defense. Even if an attacker manages to gain access, they won’t have admin rights by default, significantly reducing the risk of system compromise.

#### 1. CREATE NEW ADMIN USER:

To create a dedicated admin account, run the following command:
```
sudo adduser admin
```

The only required detail is a strong password. We highly recommend using a password manager such as KeePassXC to store and manage your credentials securely.

If you prefer generating a strong password directly from the command line, use:
```
openssl rand -base64 48 | cut -c1-32
```

This command generates a 32-character random password using OpenSSL’s RNG, which follows NIST SP 800-90A/B/C standards and uses ChaCha20 (or AES-CTR in older versions), ensuring cryptographic strength. The output is unpredictable and highly resistant to brute-force attacks.

Once the admin user is created, add it to all essential groups to ensure it has access to required system functions:
```
sudo usermod -a -G adm,tty,dialout,cdrom,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi,sudo,term7 admin
```

#### 2. REMOVE SUDO PRIVILEGES FROM THE STANDARD USER:

To enhance security, remove sudo privileges from term7 and transfer them to admin, while ensuring that sudo now requires a password:

```
sudo sed -i 's/term7/admin/g' /etc/sudoers.d/010_pi-nopasswd
```
```
sudo sed -i 's/NOPASSWD: //g' /etc/sudoers.d/010_pi-nopasswd
```

To enhance security, we will remove our standard user (term7 in this example) from the sudo group, ensuring it no longer has administrative privileges. First, log in as the new admin user:
```
su admin
```

Now, execute the following command to remove term7 from the sudo group (replace term7 with your actual standard username):
```
sudo deluser term7 sudo
```

#### ALLOW THE STANDARD USER TO SHUTDOWN AND REBOOT YOUR RASPBERRY PI:

Although term7 no longer has full sudo access, we want to allow it to reboot and shut down the Raspberry Pi without switching to admin. Run the following command to create a new sudo policy file:
```
echo "term7 ALL = NOPASSWD: /usr/sbin/reboot, /usr/sbin/shutdown" | sudo tee /etc/sudoers.d/common_users > /dev/null
```

This grants term7 password-free access to the reboot and shutdown commands.
If you want to allow additional commands without requiring sudo, simply edit the file: `/etc/sudoers.d/common_users`

* * *

## 05 HARDEN SSH CONFIGURATION

By default, you can still SSH directly into your admin account, which is a security risk. To strengthen SSH security, we will modify the SSH configuration.

**Port Hardening**
- Change the default SSH port (to port 6666)

**Strong Cryptographic Algorithms:**
- Cyphers for strong encryption (chacha20-poly1305, aes256-gcm)
- Secure Key Exchange (curve25519-sha256, diffie-hellman-group16-sha512)
- MACs to protect against cryptographic vulnerabilities (hmac-sha2-512-etm)

**Strict Authentication Controls**
- Disable direct root login
- Restrict SSH access to specific users (term7)
- Limits Authentication Attempts & Sessions (MaxAuthTries 2, MaxSessions 2)
- Enforce SSH key authentication
- Disable Password Login
- Disable challenge-response authentication (prevents brute-force attacks)

**Session Hardening**
- Timeout and Inactivity Control (ClientAliveInterval 300, ClientAliveCountMax 2)
- Prevent Empty Password Logins

**Enhanced Logging and Monitoring**
- Logging: Capture failed authentication attempts, IP addresses, and suspicious activities
- Enable Warning Banner

#### Preparation: Setting Up SSH Key Authentication for Secure Access

SSH key authentication is more secure than password-based authentication. It uses a pair of cryptographic keys:

*Private key → Stays securely on your Mac.*<br>
*Public key → Is copied to your Raspberry Pi.*

Once configured, only your Mac can log into the Raspberry Pi — unless your private key is compromised.

#### 1. Generate a New SSH Key Pair on Your Mac

Open Terminal on your Mac and run:<br>
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

It uses the Ed25519 algorithm, which is faster and more secure than RSA. Please use your real email for reference.

**Advanced Security**<br>
For an even stronger setup, consider using a hardware security key such as a [Nitrokey](https://www.nitrokey.com/products/nitrokeys) or [YubiKey](https://www.yubico.com/products/yubikey-5-overview/). However, these require additional setup and are beyond the scope of this tutorial. We might cover them in a separate guide in the future.

#### 2. Copy the Public Key to Your Raspberry Pi

Run this command, replacing 192.168.1.123 with your Raspberry Pi’s actual local IP address:
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub term7@192.168.1.123
```

If ssh-copy-id is not installed on macOS, manually copy the key using:
```
cat ~/.ssh/id_ed25519.pub | ssh term7@192.168.1.123 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
```

#### 3. Configure SSH on Your Mac for Easier Access

Still on your Mac, edit your SSH configuration file:
```
nano ~/.ssh/config
```

Make sure this line is present: `IdentityFile ~/.ssh/id_ed25519`

This ensures your Mac always uses the correct private key (id_ed25519) for authentication and prevents SSH from prompting for a password if key authentication is set up correctly.

#### 4. Log Back into Your Raspberry Pi Standard User Account

After setting up SSH key authentication, you need to set the correct permissions on your .ssh directory and the authorized_keys file to ensure SSH works securely:
```
ssh term7@192.168.1.123
```

Replace `192.168.1.123` with your actual Raspberry Pi IP!

#### 5. Set the Correct SSH Directory and File Permissions

In your standard user account, run the following commands on your Raspberry Pi:

```
chmod 700 ~/.ssh
```
```
chmod 600 ~/.ssh/authorized_keys
```

This ensures that only the user (term7) has access to the `.ssh` directory and that only the user can read and write `authorized_keys`.

#### 6. Setup Warning Banner

Now log into your admin account:
```
su admin
```

To display a security warning banner before login, download and replace the `/etc/issue.net` file with our pre-configured version from the repository:
```
sudo curl -L -o /etc/issue.net "https://codeberg.org/term7/Going-Dark/raw/branch/main/Pi%20Configuration%20Files/ssh/issue.net"
```

You can edit the banner text to match your requirements:
```
sudo nano /etc/issue.net
```

#### 7. Harden SSH configuration

The fastest way to harden your SSH configuration is to replace it with our pre-configured file from this repository.

However, before making any changes, create a backup to avoid getting locked out in case anything goes wrong. Run this command to create a backup:
```
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

If anything goes wrong, you can restore the original file. To download our hardened configuration, run this command:
```
sudo curl -L -o /etc/ssh/sshd_config "https://codeberg.org/term7/Going-Dark/raw/branch/main/Pi%20Configuration%20Files/ssh/sshd_config"
```

This overwrites your current standard SSH configuration file. **IMPORTANT**: If you use a different standard username than *term7*, you must update this line: `AllowUsers term7`

To check and edit the file before applying changes, open it in Nano:
```
sudo nano /etc/ssh/sshd_config
```

Find and replace `term7` with your actual username, then save (**CTRL + X**, then **Y**, then **Enter**).

#### 8. Apply and Test the New SSH Configuration

After making necessary changes, restart the SSH service:
```
sudo systemctl restart ssh
```

Do **NOT** log out yet! On your Mac, open a new terminal window and test SSH access:
```
ssh term7@192.168.1.123 -p 6666
```
Don't forget to replace `192.168.1.123` with your actual Raspberry Pi IP!

If the connection works fine, your new hardened SSH configuration is successfully applied!<br>
Since you are still logged in on your original terminal window, you can troubleshoot any issues if something doesn't work.

#### 9. Recover from an Issue (If Needed)

If something goes wrong and you do get locked out, restore your backup. Access your Raspberry Pi locally (use keyboard & monitor). Then type the following commands:

```
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
```
```
sudo systemctl restart ssh
```

This will restore your previous working SSH configuration.

* * *

## 06 UNATTENDED UPGRADES

Keeping your Raspberry Pi up-to-date is crucial for security and stability. Instead of manually updating, we set up unattended upgrades to automatically install security and system updates. Since our Raspberry Pi is only powered on when we work on our Mac, we need to ensure updates run after every reboot. Additionally, because we will install *AdGuardHome* (which requires time to apply filter lists), we introduce a 2-minute delay before the update process starts.

#### 1. Install Required Packages:

To set up unattended upgrades, use the following command to install the required software packages:
```
sudo apt install -y unattended-upgrades apt-listchanges
```

#### 2. Enable Raspberry Pi OS Updates:

By default, Debian security updates are included. However, we need to add Raspberry Pi updates manually. Run this command to modify the `50unattended-upgrades` file:

```
sudo sed -i '/"origin=Debian,codename=${distro_codename}-security,label=Debian-Security";/a\
        "origin=Raspbian,codename=${distro_codename},label=Raspbian";\
        "origin=Raspberry Pi Foundation,codename=${distro_codename},label=Raspberry Pi Foundation";' /etc/apt/apt.conf.d/50unattended-upgrades
```

#### 3. Ensure Updates Run After Every Reboot:

Create a systemd timer that waits 2 minutes after boot before running updates:

```
echo '[Unit]
Description=Unattended Upgrades Timer

[Timer]
OnBootSec=2min
Unit=unattended-upgrades.service

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/unattended-upgrades.timer > /dev/null
```

This prevents updates from running too early while *AdGuardHome* is still initializing.<br>
Now, create the systemd service that will execute unattended upgrades:

```
echo '[Unit]
Description=Unattended Upgrades
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/unattended-upgrade -d

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/unattended-upgrades.service > /dev/null
```

#### 4. Enable and Start the Timer

To activate the systemd timer and service, run:

```
sudo systemctl daemon-reload
```
```
sudo systemctl enable unattended-upgrades.timer
```
```
sudo systemctl start unattended-upgrades.timer
```

After rebooting, check if the timer is active:
```
systemctl list-timers --all | grep unattended-upgrades
```

If you see an entry, the timer is working.

To check if updates were applied, view the unattended upgrade logs:
```
journalctl -u unattended-upgrades --no-pager
```

* * *

## 07 DISABLE IPv6

While IPv6 offers advantages, using both IPv4 and IPv6 (dual-stack networking) significantly complicates firewall configurations and increases security risks.

#### Why diable IPv6?

- **Larger Attack Surface** → Both IPv4 and IPv6 require separate firewall rules, increasing complexity and risk of misconfiguration.
- **Tracking Risks** → IPv6 can embed a device's MAC address in its IP (EUI-64 format), allowing attackers and advertisers to track device movements across networks.
- **Privacy Concerns** → Without IPv6 Privacy Extensions, addresses remain static, reducing anonymity compared to dynamic IPv4 addresses.

Since we do not need IPv6, we will completely disable it to improve security and simplify network configurations.

#### 1. Disable IPv6 at System Level:

Permanently disable IPv6 by modifying `/etc/sysctl.conf`:
```
echo -e "\n# Disable IPv6:\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf > /dev/null
```

Modify boot parameters in `/boot/firmware/cmdline.txt` to prevent IPv6 from loading at boot:
```
sudo sed -i 's/$/ ipv6.disable=1/' /boot/firmware/cmdline.txt
```

For the changes to take effect, reboot the system:
```
sudo reboot now
```

#### 2. Remove IPv6 Entries from /etc/hosts:

Since IPv6 is now disabled, remove any local IPv6 addresses from `/etc/hosts` to prevent unnecessary resolution attempts:
```
sudo sed -i '/::/d' /etc/hosts
```

* * *

## 08 RANDOM MAC ADDRESS

By default, modern Raspberry Pi OS uses *NetworkManager* to handle network interfaces, DHCP, and Wi-Fi settings. To improve privacy and reduce the risk of tracking, we will enable *NetworkManager’s* built-in MAC address randomization feature.

#### 1. Enable MAC Address Randomization:

Create a configuration file to enable random MAC addresses for both Wi-Fi and Ethernet:

```
echo '[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}' | sudo tee /etc/NetworkManager/conf.d/00-randomize.conf > /dev/null
```

#### 2. Verify MAC Address Randomization:

To check if the MAC address is changing dynamically, run:
```
sudo nmcli device show | grep GENERAL.HWADDR
```

Now, reboot your Raspberry Pi:
```
sudo reboot now
```

After the system restarts, run the following command again:
```
sudo nmcli device show | grep GENERAL.HWADDR
```

If the MAC address differs from the previous output, the randomization setup is working correctly.

**⚠️ IMPORTANT: A side effect of MAC address randomization is that your router may assign a different IP address to your Raspberry Pi. If you're using SSH, you may need to check your Raspberry Pi’s new IP address and update your SSH connection accordingly.**

* * *

## 09 RANDOM HOSTNAME

Many networks log hostnames alongside MAC addresses and IP addresses. If your hostname remains static, it creates a consistent fingerprint that can be used to track your device across different networks. This means, even if MAC address randomization is enabled, a fixed hostname could still be used to identify your device. This is why we use an English Dictionary to pick a random word for our Raspberry Pi at each reboot before the network becomes online.

#### 1. Prepare File Locations and Download Dictionary

First we create the folders where we want to store our scripts and our dictionary:

```
[ -d ~/tools ] || mkdir ~/tools && [ -d ~/tools/dict ] || mkdir ~/tools/dict
```
```
[ -d ~/script ] || mkdir ~/script && [ -d ~/script/randhost ] || mkdir ~/script/randhost
```

Download and unzip our *UK English dictionary*:
```
curl -L https://codeberg.org/term7/Going-Dark/raw/branch/main/misc/Dictionary/ukenglish.zip -o ~/tools/dict/ukenglish.zip && unzip -o ~/tools/dict/ukenglish.zip -d ~/tools/dict/ && rm ~/tools/dict/ukenglish.zip
```

#### 2. Create the Script to Randomize the Hostname

Create the hostname randomization script:

```
echo '#!/bin/bash

# Random Hostname Generator
ALL_NON_RANDOM_WORDS=/home/admin/tools/dict/ukenglish.txt

# Count the number of words in the dictionary
non_random_words=$(wc -l < "$ALL_NON_RANDOM_WORDS")

# Generate a random index and select a word
WORD_INDEX=$(od -N3 -An -i /dev/urandom | awk -v r="$non_random_words" "{print int(1 + r * \$1 / 16777216)}")
NEW_HOSTNAME=$(sed -n "${WORD_INDEX}p" "$ALL_NON_RANDOM_WORDS")

# Change Static Hostname
hostnamectl set-hostname "$NEW_HOSTNAME"

# Update /etc/hosts safely
sed -i "/127.0.1.1/c\127.0.1.1       $NEW_HOSTNAME" /etc/hosts' | sudo tee /home/admin/script/randhost/hostname.sh > /dev/null
```

Ensure the script has the correct ownership and permissions:

```
sudo chmod 700 /home/admin/script/randhost/hostname.sh
```
```
sudo chown root:root /home/admin/script/randhost/hostname.sh
```

#### 3. Create a System Service to Run the Script on Boot

```
echo '[Unit]
Description=Random Hostname Generator
Wants=network-pre.target
Before=network-pre.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash /home/admin/script/randhost/hostname.sh
RemainAfterExit=yes
Restart=on-failure
RestartSec=5

[Install]
WantedBy=network-pre.target' | sudo tee /etc/systemd/system/hostname.service > /dev/null
```
#### 4. Enable and Start the Service and Verify the New Hostname

Enable the service:

```
sudo systemctl daemon-reload
```
```
sudo systemctl enable hostname.service
```

#### 5. Test the Service

Manually start the service:
```
sudo systemctl start hostname.service
```

Check the current hostname:
```
hostname
```

If you see a different hostname than before, the setup is working correctly. From now on, your Raspberry Pi will randomly select a new hostname from the dictionary on each reboot.

* * *

## 10 SETUP USBC ETHERNET GADGET

In this section we will configure your Raspberry Pi as a *USB-C Ethernet Gadget*, allowing it to share its internet connection with your computer over USB.

To configure your Raspberry Pi as a *USB-C Ethernet Gadget*, we need to:

- Enable the DWC2 USB controller and configure kernel boot parameters.
- Allow NetworkManager to manage the USB interface (usb0).
- Configure usb0 with a static IP and disable IPv6.
- Enable IPv4 forwarding for network sharing.

#### 1. Enable the DWC2 USB Controller

To enable ethernet gadget mode, we need to enable the DWC2 USB controller and configure kernel boot parameters. Append the required overlay to `/boot/firmware/config.txt`:
```
sudo sed -i '$a\dtoverlay=dwc2' /boot/firmware/config.txt
```

Modify `/boot/firmware/cmdline.txt` to load the required kernel modules:
```
sudo sed -i 's/$/ rootwait modules-load=dwc2,g_ether quiet/' /boot/firmware/cmdline.txt
```

#### 2. Allow NetworkManager to Manage usb0

By default, NetworkManager may ignore the gadget interface (*usb0*). We need to modify udev rules to allow it. Copy and modify the required udev rules to allow *NetworkManager* to manage the gadget interface:

```
sudo cp /usr/lib/udev/rules.d/85-nm-unmanaged.rules /etc/udev/rules.d/85-nm-unmanaged.rules
```
```
sudo sed -i '/ENV{DEVTYPE}=="gadget"/s/ENV{NM_UNMANAGED}="1"/ENV{NM_UNMANAGED}="0"/' -i /etc/udev/rules.d/85-nm-unmanaged.rules
```

#### 3. Configure usb0 as a Static Interface in NetworkManager

We will assign a static IP (`192.168.77.1/24`) to *usb0* and enable network sharing.<br>
Create and configure the interface:

```
sudo nmcli con add type ethernet ifname usb0 con-name usb0-static
```
```
sudo nmcli con modify usb0-static ipv4.addresses 192.168.77.1/24 ipv4.method shared
```
```
sudo nmcli con modify usb0-static connection.autoconnect yes connection.autoconnect-priority 50
```

Since IPv6 is disabled globally, disable it for this interface as well:
```
sudo nmcli connection modify usb0-static ipv6.method disable
```

Ensure a consistent MAC address for *usb0*, the only interface for which we do not want MAC randomization:
```
sudo nmcli connection modify usb0-static ethernet.cloned-mac-address permanent
```

#### 4. Enable IPv4 Forwarding

To allow internet sharing from Raspberry Pi's Wi-Fi to the connected computer, enable IPv4 forwarding. Modify `/etc/sysctl.conf` to enable IPv4 forwarding:<br>
```
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
```

This allows forwarding network packets for sharing internet via *usb0*.

#### 5. Apply Changes and Reboot

All changes take effect after the next reboot:<br>
```
sudo reboot now
```

#### 6. Verify Internet Access via Raspberry Pi USB-C Ethernet Gadget

After reboot, you should be able to connect to the Raspberry Pi via USB and access the internet.

 Connect via SSH using *usb0*:<br>
```
ssh term7@192.168.77.1 -p 6666
```

Verify the connection on your computer: Go to **System Settings** → **Network** and look for **RNDIS/Ethernet Gadget**. You should see a green dot with the status: **Connected**.

Since you connected your Raspberry Pi to Wi-Fi earlier as part of [03 - PREREQUISITES](#03-prerequisites), your computer should now access the internet via the Raspberry Pi. Switch off your Mac's Wi-Fi to test if it works.

* * *

## 11 SETUP WIRELESS HOTSPOT

In this setup, we want to configure wlan0 as a wireless hotspot that can be started manually rather than running continuously. This provides greater control over network availability and helps optimize system performance.

Since we do not want wlan0 to be used for internet access, we will configure our external Wi-Fi adapter — the ALFA AWUS036ACM — to handle the internet connection instead.

#### Why Use an External Wi-Fi Adapter?

The ALFA AWUS036ACM provides significantly better bandwidth compared to the Raspberry Pi’s built-in Wi-Fi (wlan0), especially when connected to a USB 3.0 port. Using an external adapter ensures faster speeds and improved stability, making it the preferred choice for connecting to the internet.

Because we enabled predictable network interface names (see [03 - PREREQUISITES](#03-prerequisites)), our external Wi-Fi adapter is assigned the interface name: wlx00c0caae6319

Important: If you are using a different external Wi-Fi adapter, its interface name will be different. You should replace wlx00c0caae6319 with your actual interface name throughout this tutorial, in all firewall configuration files and any network-related commands or settings.

#### 1. Verify Your External Wi-Fi Adapter:

Before proceeding, make sure your external Wi-Fi adapter is plugged in and properly connected to your Raspberry Pi. To find out the interface name of your Wi-Fi adapters, run the following command:<br>
`nmcli device status`

Look for your external Wi-Fi adapter in the output. It will typically have a name starting with wlx or wlan. If you're unsure which one is your external adapter, compare it to the built-in Wi-Fi (wlan0), as the external one should have a different name.

#### 2. Rename Preconfigured External Connections and Disable IPv6:

To standardize connection names and disable IPv6, run:

`sudo nmcli con modify preconfigured connection.id "Wi-Fi"`<br>
`sudo nmcli con modify "Wired connection 1" connection.id "Ethernet"`

Disable IPv6 on both connections:

`sudo nmcli connection modify Ethernet ipv6.method disable`<br>
`sudo nmcli connection modify Wi-Fi ipv6.method disable`

#### 3. Configure External Wi-Fi Adapter (wlx00c0caae6319) for Internet Access:

Modify the Wi-Fi connection to use the external adapter:

`sudo nmcli con down Wi-Fi`<br>
`sudo nmcli con modify Wi-Fi ifname wlx00c0caae6319`

Start the external Wi-Fi connection:<br>
`sudo nmcli con up Wi-Fi`

Now, your external Wi-Fi adapter should be handling the internet connection.

#### 4. Create the wlan0 Hotspot:

Add a new hotspot connection (ONION):<br>
`sudo nmcli con add con-name Hotspot ifname wlan0 type wifi ssid "ONION"`

 Configure the hotspot as an access point with network sharing:

`sudo nmcli con modify Hotspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared`<br>
`sudo nmcli con modify Hotspot ipv4.addresses 192.168.37.1/24`

Set up Wi-Fi security for the hotspot:

`sudo nmcli con modify Hotspot wifi-sec.key-mgmt wpa-psk`
`sudo nmcli con modify Hotspot wifi-sec.proto rsn`
`sudo nmcli con modify Hotspot wifi-sec.pairwise ccmp`
`sudo nmcli con modify Hotspot wifi-sec.group ccmp`
`sudo nmcli con modify Hotspot wifi-sec.auth-alg open`
`sudo nmcli con modify Hotspot wifi-sec.pmf optional`
`sudo nmcli con modify Hotspot wifi-sec.psk "your-own-strong-wifi-password"`

Disable IPv6 for the hotspot:<br>
`sudo nmcli connection modify Hotspot ipv6.method disable`

Prevent automatic connection at startup:<br>
`sudo nmcli connection modify Hotspot connection.autoconnect no`

The hotspot is now configured, but will only start when manually enabled.

#### 5. Connect Your Devices to the Hotspot:

To start the hotspot:<br>
`sudo nmcli con up Hotspot`

To stop the hotspot:<br>
`sudo nmcli con down Hotspot`

Your Raspberry Pi is now acting as a manually controlled wireless hotspot.<br>
After starting the hotspot, you can connect your smartphone or other devices using:

- SSID: ONION
- Password: "your-own-strong-wifi-password"

* * *

## 12 SETUP NTP

By default, the Raspberry Pi synchronizes time using the Debian NTP pool servers. However, we want to set up a local NTP server on the Raspberry Pi to provide network time synchronization for connected clients Additionally, we will configure our Raspberry Pi to use privacy-respecting external NTP servers from ntppool.org, ensuring accurate and secure time synchronization.

For more details, visit: [NTP Pool Project](https://www.ntppool.org/en/use.html)

#### 1. Download & Apply NTP Configuration:

To simplify the setup, download our pre-configured NTP configuration file from our repository:<br>
`curl -L -o /etc/ntpsec/ntp.conf https://codeberg.org/term7/Going-Dark/src/branch/main/Pi%20Configuration%20Files/ntp/ntp.conf`

This configuration:<br>
- Sets up the Raspberry Pi as an NTP server for local network clients.
- Uses multiple external time servers for redundancy.
- Prevents major time synchronization issues after long offline periods.


#### 2. Potential Issues:

If the Raspberry Pi remains offline for an extended period, its internal clock may drift significantly. Our current settings prevent NTP from rejecting its own local clock after long downtimes. Without these settings, a large time discrepancy could cause the Raspberry Pi to become unable to connect to the internet.<br>
If the Raspberry Pi loses internet access, it will continue serving time to local clients based on the last known good sync. However, over time, clock drift errors may accumulate, potentially affecting internet connectivity and secure connections (e.g., TLS/SSL certificates may become invalid due to incorrect system time). To mitigate this issue, we strongly recommend installing a Real-Time Clock (RTC) module, that keeps track of time even when the device is powered off.

Even though local clients are allowed to sync from the Raspberry Pi, they may still prefer external NTP servers such as Apple, Google, or Microsoft. To ensure all network devices use the Raspberry Pi for time synchronization, we will later configure NetworkManager to use its built-in dnsmasq as a DHCP server. This setup broadcasts the Raspberry Pi's NTP settings to all DHCP clients, ensuring they automatically use the Raspberry Pi for time synchronization. It should eliminate the need for manual configuration on each device.

However, if you want to configure your Mac to use the Raspberry Pi as its NTP server, open a new terminal window and disable automatic time setting for the moment:<br>
`sudo systemsetup -setusingnetworktime off`

Note: This command may produce 'Error:-99' due to Apple's System Integrity Protection (SIP). However, despite this error, our testing has shown that the setting is still applied correctly.

The next command is a bit of a hack because Apple does not document support for multiple lines in this command. Officially, systemsetup -setnetworktimeserver only accepts a single line. However, despite being undocumented, this method does not produce errors and correctly formats the configuration file in our experience. We want to set up the [NTP Pool Project](https://www.ntppool.org/en/use.html) as secondary servers if the Raspberry Pi Ethernet Gadget is not available:

```
sudo systemsetup -setnetworktimeserver "192.168.77.1
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org"
```

If you prefer to avoid this undocumented method, you can manually enter multiple time servers in System Settings > Date & Time. Separate each entry with a comma and end each with a period, e.g.:
192.168.77.1, 0.pool.ntp.org, 1.pool.ntp.org, 2.pool.ntp.org, 3.pool.ntp.org

If you only want to synchronise time via your Raspberry Pi and adhere to the correct syntax as documented by Apple, use this command:<br>
`sudo systemsetup -setnetworktimeserver "192.168.77.1"`

Finally re-enable automatic time setting: <br>
`sudo systemsetup -setusingnetworktime off`

Verify whether automatic time setting is enabled:<br>
`sudo systemsetup -getusingnetworktime`

To check if macOS is using the correct settings, run:<br>
`sudo systemsetup -getnetworktimeserver`

However, this command only returns the first server in the list!

#### 3. Optional - Install an RTC Module for Reliable Offline Timekeeping:

In this guide, we will set up the [RV3028 RTC Module](https://shop.pimoroni.com/products/rv3028-real-time-clock-rtc-breakout?variant=27926940549203). If you use a different RTC module, follow the respective installation instructions.

Install required packages:<br>
`sudo apt install -y git python3-smbus`

Create a build directory and navigate into it:<br>
`[ -d ~/build ] || mkdir ~/build && cd ~/build`

Clone & Install the RV3028 Python Library:

`git clone https://github.com/pimoroni/rv3028-python`<br>
`cd rv3028-python`<br>
`sudo ./install.sh --unstable`

Move example scripts to a dedicated folder:

`sudo mv ~/Pimoroni/* ~/build/rv3028-python/examples`<br>
`sudo rm -R /home/admin/Pimoroni`

Enable I2C communication:<br>
`sudo sed -i 's/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/' /boot/firmware/config.txt`

Furthermore, to enable the RV3028 RTC, we need to load the correct kernel overlay. Run the following command to append the required overlay to /boot/firmware/config.txt:<br>
`sudo sed -i '$a\dtoverlay=i2c-rtc,rv3028,backup-switchover-mode=1' /boot/firmware/config.txt`

Reboot your Raspberry Pi for changes to take effect:<br>
`sudo reboot now`

The Raspberry Pi uses a fake hardware clock (software-based) by default. Since we now have a real RTC, remove it to avoid conflicts:

`sudo apt -y remove fake-hwclock`<br>
`sudo update-rc.d -f fake-hwclock remove`

Finally, configure NTP (ntpsec) to read time from the RTC module:<br>
`sudo sed -i 's/^#rtcfile \/dev\/rtc0/rtcfile \/dev\/rtc0/' /etc/ntpsec/ntp.conf`

Restart NTP to apply changes:<br>
`sudo systemctl restart ntpsec`

* * *

## 13 DHCP & DNS WITH UNBOUND AND ADGUARDHOME

In this section, we will configure DHCP and DNS. In the next chapter, we will set up [NGINX as a Reverse Proxy](#14-nginx-reverse-proxy-and-ssl) to serve the AdGuardHome web interface and enable SSL encryption for both local HTTPS access and secure communication with AdGuardHome’s fallback DNS servers.<br>
Following that, we will walk you through the full configuration of [AdGuardHome](#15-configure-adguardhome), followed by a brief discussion on blocklists.<br>
Finally, we will configure the [Firewall](#17-firewall).

**⚠ IMPORTANT:<br>
Completing these chapters correctly is crucial! Any misconfiguration could cause DNS issues, potentially leading to loss of internet connectivity for your Raspberry Pi and its connected clients — or even lock you out completely. Even small mistakes or skipped steps may result in certain aspects of the setup not working as expected. Proceed carefully and follow each step precisely.**

#### AdGuardHome:
We will install AdGuardHome - a DNS sinkhole that filters ads, tracking domains, and malicious websites. It enhances privacy and security by blocking unwanted content at DNS level.

#### NetworkManager’s Built-in Dnsmasq:
We will configure NetworkManager and its built-in dnsmasq to manage both DHCP and DNS for the usb0 Ethernet Gadget and the wlan0 Hotspot. This will allow all connected clients to have their DNS queries forwarded to AdGuardHome, ensuring filtered and secure DNS resolution.

#### Unbound:
Unbound is a validating (DNSSEC) and recursive DNS server that caches queries to improve efficiency. Later, we will configure AdGuardHome to use Unbound as its sole upstream DNS server. The primary concern with traditional DNS resolvers is trust. When using a third-party DNS provider, we must trust that they are not recording, analyzing, or selling our DNS query data. By deploying Unbound, we eliminate this dependency, gaining the following advantages:

Privacy: Unbound performs full recursive resolution, meaning it starts the DNS lookup process at the root name servers and follows the hierarchy until it reaches the authoritative name server responsible for the requested domain. This eliminates reliance on a centralized DNS middleman that could log or analyze our queries.

Speed: AdGuardHome already includes a built-in DNS cache, but combining it with Unbound’s advanced caching features—such as aggressive-nsec, prefetch, and serve-expired—further reduces query response times and enhances overall performance.

The Drawback: Lack of Encryption:

One major downside of avoiding a DNS middleman is the lack of encryption. Queries to root name servers and authoritative DNS servers are sent in plain text over UDP/TCP on port 53, making them susceptible to interception and analysis.<br>
To mitigate this risk, one option is to encrypt DNS queries using DNS-over-TLS (DoT). However, in the setup described here, we will not use this option because root name servers do not (yet) support DoT or DoH (DNS-over-HTTPS).<br>
This means that if we choose to avoid third-party DNS resolvers, we must also forgo encryption. That said, DNSSEC (enabled in Unbound) still provides security benefits by ensuring that DNS responses are authentic (coming from the legitimate DNS server) and untampered (ensuring data integrity). While this does not encrypt queries, it does prevent DNS spoofing and man-in-the-middle attacks by verifying that responses are legitimate.

#### 1. Install AdGuardHome:

Before installing AdGuardHome, create a build directory and navigate into it:<br>
`[ -d ~/build ] || mkdir ~/build && cd ~/build`

Run the following command to download and extract the latest AdGuardHome release:
`curl -sSL https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz | tar -xz`

Then, navigate into the extracted directory and start the installation:
`cd AdGuardHome && sudo ./AdGuardHome -s install`

Note: We will configure AdGuardHome later in the guide. At this stage, the installation is only preparing the system.

#### 2. Configure NetworkManager and NetworManager's built-in Dnsmasq:

To properly manage DHCP and DNS with NetworkManager, we first need to configure its general settings and then set up Dnsmasq for both standard and shared network interfaces.

Run the following command to create and update /etc/NetworkManager/NetworkManager.conf:

```
echo '[main]
plugins=ifupdown,keyfile
dns=dnsmasq
dhcp=dnsmasq

[ifupdown]
managed=false' | sudo tee /etc/NetworkManager/NetworkManager.conf > /dev/null
```

This ensures that NetworkManager uses Dnsmasq for DHCP and DNS.

NetworkManager uses two different configuration folders for Dnsmasq:

- Standard Interfaces (/etc/NetworkManager/dnsmasq.d/) → Used for lo (localhost).
- Shared Interfaces (/etc/NetworkManager/dnsmasq-shared.d/) → Used for shared networks like wlan0 and usb0.

We need to configure both.

Create the following configuration file to ensure that all DNS requests are forwarded to AdGuardHome and apply security features:

```
echo '# Redirect DNS to Adguard (localhost)
proxy-dnssec
server=127.0.0.1#5357
no-resolv
edns-packet-max=1232

# Prevent DNS leaks and block Bogus Private IP Responses
domain-needed
bogus-priv

# Prevent DNS rebinding attacks
stop-dns-rebind

# Prevent External Access to Local DNS
local-service

# Ensure Hostnames Resolve Properly
expand-hosts' | sudo tee /etc/NetworkManager/dnsmasq.d/00_dnsmasq-adguard.conf > /dev/null
```

Create a configuration file for shared interfaces to redirect DNS queries to AdGuardHome and enable EDNS Client Subnet (ECS):

```
echo '# Redirect DNS to Adguard
proxy-dnssec
server=127.0.0.1#5357
no-resolv

# Enable EDNS Client Subnet (ECS) to pass client details
add-mac
add-subnet=32,128
edns-packet-max=1232

# Prevent DNS leaks and block Bogus Private IP Responses
domain-needed
bogus-priv

# Prevent DNS rebinding attacks
stop-dns-rebind

# Prevent External Access to Local DNS
local-service

# Ensure Hostnames Resolve Properly
expand-hosts' | sudo tee /etc/NetworkManager/dnsmasq-shared.d/00_dnsmasq-shared_adguard.conf > /dev/null
```

Set up DHCP settings for usb0 (single-client device) and wlan0 (Wi-Fi hotspot):

```
echo '########################################
# DHCP/DNS for usb0 -> ONlY ONE CLIENT #
########################################

# Assign static IP to WORKSTATION:
dhcp-host=WORKSTATION,192.168.77.77

# DHCP range:
dhcp-range=set:usb0,192.168.77.10,192.168.77.255,255.255.255.0,24h

# Default Gateway:
dhcp-option=tag:usb0,3,192.168.77.1

# DNS server:
dhcp-option=tag:usb0,6,192.168.77.1

# NTP server:
dhcp-option=tag:usb0,option:ntp-server,192.168.77.1

# Request hostnames:
dhcp-option=tag:usb0,12

############################################
# DHCP/DNS for wlan0 -> REQUEST  HOSTNAMES #
############################################

# DHCP range:
dhcp-range=set:wlan0,192.168.37.10,192.168.37.250,255.255.255.0,24h

# Default Gateway:
dhcp-option=tag:wlan0,3,192.168.37.1

# DNS server:
dhcp-option=tag:wlan0,6,192.168.37.1

# NTP server:
dhcp-option=tag:wlan0,option:ntp-server,192.168.37.1

# Request hostnames:
dhcp-option=tag:wlan0,12' | sudo tee /etc/NetworkManager/dnsmasq-shared.d/01_usb0-wlan0.conf > /dev/null
```

To ensure your Mac appears as a distinct client in AdGuardHome, we need to assign it a static IP address (see configuration above). However, since MAC address randomization is enabled on our laptop, we cannot use its MAC address as an identifier. Instead, we will set a fixed hostname, WORKSTATION, which will allow us to reliably assign a static IP. Open a Terminal on your Mac and run the following commands to configure the hostname:

`sudo scutil --set HostName WORKSTATION`
`sudo scutil --set LocalHostName WORKSTATION`
`sudo scutil --set ComputerName WORKSTATION`
`dscacheutil -flushcache`

#### 3. Install and configure Unbound:

sudo apt install -y unbound unbound-anchor

Our Unbound configuration is designed for a privacy-focused, high-performance recursive DNS resolver with DNSSEC validation, enhanced caching, and security hardening. Download our pre-configured Unbound configuration file from our repository:<br>
`curl -L -o /etc/ntpsec/ntp.conf https://codeberg.org/term7/Going-Dark/src/branch/main/Pi%20Configuration%20Files/unbound/unbound-dnssec.conf`

Privacy & Security Features:

- Eliminates reliance on external DNS providers by performing full recursive resolution (queries start at root servers).
- Prevents DNS leaks by blocking queries for local/private IPs.
- Enhances DNSSEC validation to ensure authenticity of DNS responses.
- Defends against DNS spoofing and rebinding attacks.
- Limits query data exposure to upstream servers with QNAME minimization.
- Blocks metadata requests to obscure server details.
- Implements rate limiting to prevent abuse.

Performance Enhancements:

- Aggressive caching with long TTLs.
- Prefetching enabled to speed up repeated queries.
- Optimized threading & memory usage
- Minimizes DNS response sizes to reduce network overhead.

Next, we will create a second configuration file to define local zones and enable reverse lookups for wlan0 and usb0, allowing local hostname resolution within our network:

```
echo 'server:
    # Serve static local websites:
    local-zone: "adguard.home." static
    local-data: "adguard.home. IN A 192.168.77.1"

    #PTR Record for localhost
    local-data-ptr: "127.0.0.1 localhost"
    
    # Allow reverse lookups for wlan0 (192.168.37.x)
    local-zone: "37.168.192.in-addr.arpa." transparent
    local-data-ptr: "192.168.37.1 hotspot.local"

    # Allow reverse lookups for usb0 (192.168.77.x)
    local-zone: "77.168.192.in-addr.arpa." transparent
    local-data-ptr: "192.168.77.1 usb0.local"

# Allow Unbound to read hostnames from DHCP leases
auth-zone:
    name: "37.168.192.in-addr.arpa."
    zonefile: "/var/lib/unbound/unbound-wlan0.zone"
        fallback-enabled: yes

auth-zone:
    name: "77.168.192.in-addr.arpa."
    zonefile: "/var/lib/unbound/unbound-usb0.zone"
    fallback-enabled: yes' | sudo tee /etc/unbound/unbound.conf.d/local-zones.conf > /dev/null
```

This configuration is particularly useful for the following reasons:<br>
AdGuardHome will be able to log client hostnames (if provided by the client). This allows us to see which client is connecting to which domain in the query log.<br>
Later in this guide, we will configure an Nginx reverse proxy to serve the AdGuardHome web interface. Having local hostname resolution ensures that the web interface can be accessed reliably via a local domain name instead of an IP address:

This setup does not work out of the box due to two key issues: NetworkManager generates a zone file that is incompatible with Unbound’s syntax. To resolve this, we need a script that translates the lease file into a format that Unbound can read.<br>
Furthermore Dnsmasq needs to trigger this script whenever a new client connects. This ensures automatic updates to Unbound’s zone file, keeping hostname resolution accurate.

Prepare the Script Storage Location:<br>
`[ -d ~/script ] || mkdir ~/script && [ -d ~/script/DNS ] || mkdir ~/script/DNS`

Now, create the script that translates NetworkManager’s lease file into an Unbound-compatible format:

```
echo '#!/bin/bash

# Loop through each interface (wlan0 and usb0)
for iface in wlan0 usb0; do
    # Define lease file and corresponding Unbound zone file paths for the interface
    LEASE_FILE="/var/lib/NetworkManager/dnsmasq-${iface}.leases"
    UNBOUND_ZONE_FILE="/var/lib/unbound/unbound-${iface}.zone"

    # If the lease file doesn't exist or is empty, create a placeholder zone file
    if [[ ! -s "$LEASE_FILE" ]]; then
        echo "; Unbound generated zone file - No active leases found" > "$UNBOUND_ZONE_FILE"
        continue
    fi

    # Initialize a new Unbound zone file with a header comment
    echo "; Unbound generated zone file from dnsmasq leases" > "$UNBOUND_ZONE_FILE"

    # Process each lease entry in the lease file
    while read -r LEASE_TIME MAC_ADDR IP HOSTNAME CLIENTID; do
        # Skip the entry if the IP address is missing
        if [[ -z "$IP" ]]; then
            continue
        fi

        # Set hostname to 'UNKNOWN' if it's missing or a placeholder '*'
        if [[ -z "$HOSTNAME" || "$HOSTNAME" == "*" ]]; then
            HOSTNAME="UNKNOWN"
        fi

        # Convert the IP address into PTR record format (reverse order)
        PTR_IP=$(echo "$IP" | awk -F. '{print $4"."$3"."$2"."$1}')
        # Append the PTR record to the Unbound zone file
        echo "$PTR_IP.in-addr.arpa. 86400 IN PTR $HOSTNAME." >> "$UNBOUND_ZONE_FILE"
    done < "$LEASE_FILE"
done

# Reload Unbound to apply the updated zone files
systemctl reload unbound' | sudo tee /home/admin/script/DNS/update-unbound-leases.sh > /dev/null
```

Make this script executable:<br>
`sudo chmod +x ~/script/DNS/update-unbound-leases.sh`

Configure dnsmasq to run the script automatically whenever a client connects:

`echo "" | sudo tee -a /etc/NetworkManager/dnsmasq-shared.d/00_dnsmasq-shared_adguard.conf > /dev/null`<br>
`echo "# Script to reconfigure Unbound zonefile for PTR requests" | sudo tee -a /etc/NetworkManager/dnsmasq-shared.d/00_dnsmasq-shared_adguard.conf > /dev/null`<br>
`echo "dhcp-script=/home/admin/script/DNS/update-unbound-leases.sh" | sudo tee -a /etc/NetworkManager/dnsmasq-shared.d/00_dnsmasq-shared_adguard.conf > /dev/null`

#### 4. Enforcing Local DNS and Updating Hosts:

To ensure all DNS queries are routed through AdGuardHome and Unbound, we need to configure NetworkManager to use our local resolver:

`sudo nmcli con modify Wi-Fi ipv4.dns 127.0.0.1`<br>
`sudo nmcli con modify Ethernet ipv4.dns 127.0.0.1`

Next, we update /etc/hosts to define local hostname mappings to ensure that local hostnames resolve correctly:<br>
`sudo sed -i '/127.0.0.1/s/$/\n192.168.77.1    adguard.home usb0.local\n192.168.37.1    hotspot.local/' /etc/hosts`

* * *

## 14 NGINX REVERSE PROXY AND SSL

In this section, we will configure NGINX as a reverse proxy for the AdGuardHome web interface. This will allow us to serve the interface securely while enabling additional customization options.

#### 1. Install NGINX:

First, install NGINX, a modern and lightweight web server:<br>
`sudo apt install -y nginx`

By default, NGINX is configured to listen on IPv6, but since we have previously disabled IPv6 on this system, the nginx.service will fail to start. To prevent this, we need to modify the default configuration file and disable IPv6 support:<br>
`sudo sed -i 's/^\(\s*listen \[::\]:80 default_server;\)/# \1/' /etc/nginx/sites-available/default`

#### 2. Self-signed Certificate:

The goal is to access AdguardHome using the local address:<br>
https://adguard.home

In the previous chapter, we enabled reverse lookup via Unbound. Now, we need to set up encryption using a self-signed certificate, which will be used by NGINX to serve adguard.home over HTTPS. Additionally, this certificate will allow AdGuardHome to support encrypted DNS queries via DNS over HTTPS (DoH) as a fallback method alongside our Unbound configuration.

Run the following command to ensure the required directories exist:<br>
`[ -d ~/tools ] || mkdir ~/tools && [ -d ~/tools/CA ] || mkdir ~/tools/CA && [ -d ~/tools/CA/SSL ] || mkdir ~/tools/CA/SSL`

Change into the Certificate Authority (CA) configuration folder:<br>
`cd ~/tools/CA`

Create a self-signed Certificate Authority (CA) key and certificate (valid for 100 years):<br>
`openssl req -x509 -new -nodes -keyout term7-CA.key -out term7-CA.pem -days 36500 -subj "/CN=term7-CA"`

Move into the SSL configuration folder:<br>
`cd ~/tools/CA/SSL`

Create an OpenSSL configuration file for adguard.home:

```
echo '[ req ]
default_bits       = 2048
default_md         = sha256
prompt             = no
distinguished_name = req_distinguished_name
req_extensions     = v3_req

[ req_distinguished_name ]
CN = adguard.home

[ v3_req ]
subjectAltName = @alt_names
extendedKeyUsage = serverAuth

[ alt_names ]
DNS.1 = adguard.home
IP.1 = 192.168.77.1' | sudo tee /home/admin/tools/CA/SSL/openssl-san.cnf > /dev/null
```

Now, generate the private key for adguard.home:<br>
`openssl genrsa -out adguard.home.key 2048`

Create a Certificate Signing Request (CSR):<br>
`openssl req -new -key adguard.home.key -out adguard.home.csr -config openssl-san.cnf``


Sign the Certificate Signing Request (CSR) with the Local Certificate Authority (CA):<br>
´openssl x509 -req -in adguard.home.csr -CA ../term7-CA.pem -CAkey ../term7-CA.key -CAcreateserial -out adguard.home.crt -days 36500 -extensions v3_req -extfile openssl-san.cnf´

Create the Full-Chain Certificate:<br>
`cat adguard.home.crt ../term7-CA.pem > adguard.home-fullchain.crt`

Finally we configure our system to trust the Local Certificate Authority (CA). Copy the CA certificate to the system's trusted certificate directory:<br>
`sudo cp ~/tools/CA/term7-CA.pem /usr/local/share/ca-certificates/term7-CA.crt`

Update the system's certificate store:<br>
`sudo update-ca-certificates`

Since we have enforced strict user access control, root login is not allowed. To transfer the certificate, we first copy it to our standard user account:<br>
`sudo cp ~/tools/CA/term7-CA.pem /home/term7/`

Now, on your Mac, open a new Terminal window and run the following command to securely copy the certificate to your Downloads folder. Once the transfer is complete, we immediately delete it from the Raspberry Pi:<br>
`scp -P 8519 term7@192.168.77.1:term7-CA.pem ~/Downloads/ && ssh -p 8519 term7@192.168.77.1 "rm term7-CA.pem"`

Once the certificate is transferred, install it as a trusted root certificate on macOS by running the following command:<br>
`sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/Downloads/term7-CA.pem`

This command adds the certificate to the macOS System Keychain and marks it as trusted for all users. By doing so, it ensures that the certificate is recognized as a Root Certificate Authority, allowing you to access https://adguard.home without encountering security warnings.

#### 3. Configure NGINX as a reverse proxy for AdGuardHome:

Next, we configure NGINX to serve as a reverse proxy for the AdGuardHome web interface and to forward DNS-over-HTTPS (DoH) requests between connected clients and AdGuardHome.<br>
Run the following command to create the configuration:

```
echo 'server {
    listen 443 ssl http2;

    server_name adguard.home;

    ssl_certificate /home/admin/tools/CA/SSL/adguard.home.crt;
    ssl_certificate_key /home/admin/tools/CA/SSL/adguard.home.key;

    # Proxy AdGuardHome Web Interface
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Proxy DNS-over-HTTPS (DoH) Requests to AdGuardHome
    location /dns-query {
        proxy_pass https://127.0.0.1:7443/dns-query$is_args$args;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;

        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # Preserve query strings
        proxy_redirect off;
    }
}

server {
    listen 80;
    server_name adguard.home;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}' | sudo tee /etc/nginx/sites-available/nginx-adguard > /dev/null
```

Enable the NGINX configuration:<br>
`sudo ln -s /etc/nginx/sites-available/nginx-adguard /etc/nginx/sites-enabled/`

Test the configuration for syntax errors:<br>
`sudo nginx -t`

If the test is successful, restart NGINX:<br>
`sudo systemctl restart nginx`

* * *

## 15 CONFIGURE ADGUARDHOME

å
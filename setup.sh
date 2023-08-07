#!/bin/bash
[[ ! -f /usr/bin/jq ]] && {
        echo "Downloading jq file!"
        wget -q --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" -O /usr/bin/jq
        chmod +x /usr/bin/jq
        wget -qO- https://raw.githubusercontent.com/KDevN9/tempmail/main/mail.sh >/usr/bin/mail
        chmod +x /usr/bin/mail
}
[[ ! -f "/etc/tmpm" ]] && {
        mkdir -p /etc/tmpm/
}

wget -qO- https://raw.githubusercontent.com/KDevN9/tempmail/main/menu.sh >/usr/bin/menu
chmod +x /usr/bin/menu

cat >/etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat >/etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service
neofetch --ascii_distro virus echo && echo "AutoScript TempMail by XDevMY" && echo "type menu to setup bot"
clear
rm -f setup.sh
system will restart in 3 seconds
sleep 3
reboot

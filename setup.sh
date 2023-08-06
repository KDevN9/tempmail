#!/bin/bash
[[ ! -f /usr/bin/jq ]] && {
red "Downloading jq file!"
wget -q --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" -O /usr/bin/jq
chmod +x usr/bin/jq
wget -qO- https://raw.githubusercontent.com/KDevN9/tempmail/main/mail.sh > /usr/bin/mail
}
[[ ! -f "/etc/tmpm" ]] && mkdir -p /etc/tmpm/

echo "Welcome To Temp Mail Generator Bot Setup"
sleep 3
echo -ne "Input your Bot TOKEN : " 
        read token
        echo "$token" > /etc/tmpm/token.txt

[[ ! -e "/etc/tmpm/BotApi.sh" ]] wget -qO- https://raw.githubusercontent.com/KDevN9/tempmail/main/BotAPI.sh > /etc/tmpm/BotAPI.sh 

        clear
        echo -e "Info...\n"
        fun_bot1() {
			[[ "$(grep -wc "devbot" "/etc/rc.local")" = '0' ]] && {
			    sed -i '$ i\screen -dmS devbot mail' /etc/rc.local >/dev/null 2>&1
			}
        }
        screen -dmS devbot mail >/dev/null 2>&1
        fun_bot1
        [[ $(ps x | grep "devbot" | grep -v grep | wc -l) != '0' ]] && echo -e "\nBot successfully activated !" || echo -e "\nError1! Information not valid !"
        sleep 2
        menu
        } || {
       clear
        echo -e "Info...\n"
        fun_bot2() {
            screen -r -S "devbot" -X quit >/dev/null 2>&1
            [[ $(grep -wc "devbot" /etc/rc.local) != '0' ]] && {
                sed -i '/devbot/d' /etc/rc.local
            }
            sleep 1
        }
        fun_bot2
        echo -e "\nBot Mail Stopped!"
        sleep 2
        menu
    }
}
#!/bin/bash
echo "Welcome To Temp Mail Generator Bot Setup"
sleep 3
echo -ne "Input your Bot TOKEN : "
read token
echo "$token" >/etc/tmpm/token.txt

[[ ! -e "/etc/tmpm/BotApi.sh" ]] && {
        wget -qO- https://raw.githubusercontent.com/KDevN9/tempmail/main/BotAPI.sh >/etc/tmpm/BotAPI.sh
}

clear
echo -e "Info...\n"
fun_bot1() {
        [[ "$(grep -wc "devbot" "/etc/rc.local")" = '0' ]] && {
                sed -i '$ i\screen -dmS devbot mail' /etc/rc.local >/dev/null 2>&1
        }
}
screen -dmS devbot mail >/dev/null 2>&1
fun_bot1
[[ $(ps x | grep "devbot" | grep -v grep | wc -l) != '0' ]] && {
        echo -e "\nBot successfully activated !" || echo -e "\nError1! Information not valid !"
        sleep 2
} ||
        {
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
        }

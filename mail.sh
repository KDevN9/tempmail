#!/bin/bash
toket=$(cat /etc/tmpm/token.txt)
source /etc/tmpm/BotAPI.sh
ShellBot.init --token $toket --monitor --return map --flush
ShellBot.username

msgWelcome() {
    local msg
    msg="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    msg+="Welcome <b>${message_from_first_name[$id]}</b>\n\n"
    msg+="To generate temporary email [ /mail ]\n"
    msg+="To contact administrator [ /admin ]\n"
    msg+="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
        --text "$(echo -e $msg)" \
        --parse_mode html
    return 0
}

genMail() {
    curl --request GET \
  --url 'https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=1' > /etc/tmpm/mail.txt >> /etc/tmpm/recentmail.txt
  generated=$(cat /etc/tmpm/mail.txt)
            local env_msg
        env_msg="━━━━━━━━━━━━━━━━━━━━━\n"
        env_msg+="<b> Your Generated Temp Mail : <code> $generated</code></b>\n"
        env_msg+="━━━━━━━━━━━━━━━━━━━━━\n\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$env_msg" \
            --reply_markup "$keyboard1" \
            --parse_mode html
        return 0
    }

refMail() {
    log=$(cat /etc/tmpm/mail.txt  awk '{print $1}')
    dom=$(cat /etc/tmpm/mail.txt  awk '{print $3}')
    curl --request GET \
  --url "https://www.1secmail.com/api/v1/?action=getMessages&login=$log&domain=$dom" > /etc/tmpm/message.txt
  mess=$(cat /etc/tmpm/message.txt)
            local env_msg
        env_msg="━━━━━━━━━━━━━━━━━━━━━\n"
        env_msg+="<b> Your Temp Mail Message : <code> $mess</code></b>\n"
        env_msg+="━━━━━━━━━━━━━━━━━━━━━\n\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$env_msg" \
            --reply_markup "$keyboard1" \
            --parse_mode html
        return 0
    }

recMail(){
    recent=$(cat /etc/tmpm/recentmail.txt)
                local env_msg
        env_msg="━━━━━━━━━━━━━━━━━━━━━\n"
        env_msg+="<b> Your Recently Created Mail : <code> $recent</code></b>\n"
        env_msg+="━━━━━━━━━━━━━━━━━━━━━\n\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$env_msg" \
            --reply_markup "$keyboard1" \
            --parse_mode html
        return 0
}

unset menu
menu=''
ShellBot.InlineKeyboardButton --button 'menu' --line 1 --text 'Refresh Message 📧' --callback_data 'reffmess'
ShellBot.InlineKeyboardButton --button 'menu' --line 1 --text 'Recently Created Mail 📧' --callback_data 'recma'
ShellBot.InlineKeyboardButton --button 'menu' --line 2 --text 'Generate New Mail 📧' --callback_data 'genma'
ShellBot.regHandleFunction --function refMes --callback_data _reffmess
ShellBot.regHandleFunction --function recMail --callback_data _recma
ShellBot.regHandleFunction --function genMail --callback_data _genma
unset keyboard1
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'menu')"


while :; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 35
    for id in $(ShellBot.ListUpdates); do
        (
            ShellBot.watchHandle --callback_data ${callback_query_data[$id]}
            [[ ${message_chat_type[$id]} != 'private' ]] && {
                   ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "⛔ only run this command on private chat / pm on bot")" \
                        --parse_mode html
                   >$CAD_ARQ
                   break
                   ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
            }
            CAD_ARQ=/tmp/cad.${message_from_id[$id]}
            echotoprice=/tmp/price
            if [[ ${message_entities_type[$id]} == bot_command ]]; then
                case ${message_text[$id]} in
                *)
                    :
                    comando=(${message_text[$id]})
                    [[ "${comando[0]}" = "/mail" ]] && genMail
                    ;;
                esac
            fi
#!/bin/sh
# Based on https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/vpn-wireguard-wg

connection_status() {
    if [ -f "$config" ]; then
        connection=$(sudo wg show "$config_name" 2>/dev/null | head -n 1 | awk '{print $NF }')

        if [ "$connection" = "$config_name" ]; then
            echo "1"
        else
            echo "2"
        fi
    else
        echo "3"
    fi
}

config=~/wireguard/wg0.conf
config_name=$(basename "${config%.*}")

case "$1" in
--toggle)
    if [ "$(connection_status)" = "1" ]; then
        sudo wg-quick down "$config" 2>/dev/null
    else
        sudo wg-quick up "$config" 2>/dev/null
    fi
    ;;
*)
    if [ "$(connection_status)" = "1" ]; then
        echo "VPN: up"
    elif [ "$(connection_status)" = "3" ]; then
        echo "VPN: Config not found!"
    else
        echo "VPN: down"
    fi
    ;;
esac

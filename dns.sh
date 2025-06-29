#!/bin/bash
clear
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Please run as root.${NC}"
    exit 1
fi

BACKUP_FILE="/etc/resolv.conf.backup"
CUSTOM_DNS_FILE="$HOME/.dns_custom.conf"

echo -e "${GREEN}"
cat << "EOF"
▄▖▄▖▖▖▄▖▄▖  ▄ ▖ ▖▄▖  ▄▖▄▖▄▖▖ ▄▖
▐ ▌▌▚▘▐ ▌   ▌▌▛▖▌▚   ▐ ▌▌▌▌▌ ▚ 
▐ ▙▌▌▌▟▖▙▖  ▙▘▌▝▌▄▌  ▐ ▙▌▙▌▙▖▄▌
EOF
echo -e "${NC}"

# ===== لیست DNSها =====
declare -A dns_servers=(
    ["Begzar"]="185.55.226.26 185.55.225.25"
    ["Cloudflare"]="1.1.1.1 1.0.0.1"
    ["Electro"]="78.157.42.100 78.157.42.101"
    ["Google"]="8.8.8.8 8.8.4.4"
    ["Hamrah Aval"]="208.67.220.200 208.67.222.222"
    ["IranTelecom 1"]="4.4.4.4 4.2.2.4"
    ["IranTelecom 2"]="195.46.39.39 195.46.39.40"
    ["Irancell 1"]="109.69.8.51"
    ["Irancell 2"]="74.82.42.42"
    ["Level3"]="209.244.0.3 209.244.0.4"
    ["Mobinnet"]="10.44.8.8 8.8.8.8"
    ["OpenDNS"]="208.67.222.222 208.67.220.220"
    ["ParsOnline"]="46.224.1.221 46.224.1.220"
    ["Radar"]="10.202.10.10 10.202.10.11"
    ["Server.ir"]="194.104.158.48 194.104.158.78"
    ["Shatel Users"]="85.15.1.14 85.15.1.15"
    ["Shecan"]="178.22.122.100 185.51.200.2"
    ["Swiss"]="176.10.118.132 176.10.118.133"
    ["Tajikistan"]="45.81.37.0 45.81.37.1"
    ["Telecommunication"]="91.239.100.100 89.233.43.71"
    ["Kuwait"]="94.187.170.2 94.187.170.3"
    ["Spain"]="195.235.194.7 195.235.194.8"
    ["Service 403"]="10.202.10.202 10.202.10.102"
    ["Other Operators"]="199.85.127.10 199.85.126.10"
    ["Hostiran"]="172.29.2.100 172.29.2.100"
)

# ===== بارگذاری DNSهای سفارشی =====
load_custom_dns() {
    if [[ -f "$CUSTOM_DNS_FILE" ]]; then
        while IFS="|" read -r name iplist; do
            if [[ -n "$name" && -n "$iplist" ]]; then
                dns_servers["$name"]="$iplist"
            fi
        done < "$CUSTOM_DNS_FILE"
    fi
}

# ===== افزودن DNS سفارشی =====
add_custom_dns() {
    read -p "Enter a name for your custom DNS: " custom_name
    read -p "Enter first DNS IP: " ip1
    read -p "Enter second DNS IP (or press Enter to skip): " ip2

    if [[ -z "$ip1" ]]; then
        echo -e "${RED}[✘] First IP is required.${NC}"
        return
    fi

    dns_value="$ip1"
    [[ -n "$ip2" ]] && dns_value+=" $ip2"

    dns_servers["$custom_name"]="$dns_value"
    echo "$custom_name|$dns_value" >> "$CUSTOM_DNS_FILE"
    echo -e "${GREEN}[✔] Custom DNS '$custom_name' saved permanently.${NC}"
}

# ===== بک‌آپ =====
backup_dns() {
    if [[ ! -f "$BACKUP_FILE" ]]; then
        cp /etc/resolv.conf "$BACKUP_FILE"
        echo -e "${YELLOW}[Backup]${NC} resolv.conf saved."
    fi
}

# ===== تنظیم DNS =====
set_dns() {
    local dns="$1"
    backup_dns
    echo "# Set by dns.sh" > /etc/resolv.conf
    for ip in $dns; do
        echo "nameserver $ip" >> /etc/resolv.conf
    done
    echo -e "${GREEN}[✔] DNS applied: $dns${NC}"
}

# ===== بازگردانی =====
restore_dns() {
    if [[ -f "$BACKUP_FILE" ]]; then
        cp "$BACKUP_FILE" /etc/resolv.conf
        echo -e "${GREEN}[✔] DNS restored to original.${NC}"
    else
        echo -e "${RED}[✘] No backup found.${NC}"
    fi
}

# ===== نمایش DNS فعلی =====
show_current_dns() {
    echo -e "${BLUE}===== Current DNS Settings =====${NC}"
    if [[ -f /etc/resolv.conf ]]; then
        grep "^nameserver" /etc/resolv.conf | while read -r line; do
            ip=$(echo "$line" | awk '{print $2}')
            name="Unknown"
            for key in "${!dns_servers[@]}"; do
                for dns_ip in ${dns_servers[$key]}; do
                    if [[ "$ip" == "$dns_ip" ]]; then
                        name="$key"
                    fi
                done
            done
            echo -e "${YELLOW}DNS: $ip${NC} → ${GREEN}$name${NC}"
        done
    else
        echo -e "${RED}[✘] /etc/resolv.conf not found!${NC}"
    fi
}

# ===== منوی دستی =====
manual_menu() {
    echo -e "${BLUE}Checking DNS response times...${NC}"
    declare -a results

    for name in "${!dns_servers[@]}"; do
        ip=$(echo "${dns_servers[$name]}" | cut -d ' ' -f1)
        ping_time=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d ' ' -f1 | cut -d'.' -f1)
        [[ "$ping_time" =~ ^[0-9]+$ ]] || ping_time=9999
        results+=("$ping_time|$name")
    done

    IFS=$'\n' sorted=($(sort -n <<<"${results[*]}"))
    unset IFS

    echo -e "\n${BLUE}===== Manual DNS Selection (Sorted by Speed) =====${NC}"
    declare -A index_map
    i=1
    for item in "${sorted[@]}"; do
        time="${item%%|*}"
        name="${item##*|}"
        dns="${dns_servers[$name]}"
        if [[ "$time" == "9999" ]]; then
            echo -e "${YELLOW}$i)${NC} $name → $dns ${RED}[No Response]${NC}"
        else
            echo -e "${YELLOW}$i)${NC} $name → $dns (${GREEN}${time} ms${NC})"
        fi
        index_map[$i]="$name"
        ((i++))
    done

    echo -e "${YELLOW}0)${NC} Restore default DNS"
    echo -e "${YELLOW}98)${NC} Add custom DNS"
    echo -e "${YELLOW}99)${NC} Quit"

    read -p "Choose a number: " choice
    if [[ "$choice" == "0" ]]; then
        restore_dns
    elif [[ "$choice" == "98" ]]; then
        add_custom_dns
    elif [[ "$choice" == "99" ]]; then
        echo "Exiting."
        exit 0
    elif [[ -n "${index_map[$choice]}" ]]; then
        set_dns "${dns_servers[${index_map[$choice]}]}"
    else
        echo -e "${RED}[!] Invalid choice.${NC}"
    fi
}

# ===== انتخاب اتومات =====
auto_select_dns() {
    echo -e "${BLUE}Checking DNS response times...${NC}"
    best_dns=""
    best_ping=99999

    for name in "${!dns_servers[@]}"; do
        ip=$(echo "${dns_servers[$name]}" | cut -d ' ' -f1)
        ping_time=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d ' ' -f1 | cut -d'.' -f1)

        if [[ "$ping_time" =~ ^[0-9]+$ ]]; then
            echo -e "$name → ${GREEN}${ping_time} ms${NC}"
            if [ "$ping_time" -lt "$best_ping" ]; then
                best_ping=$ping_time
                best_dns=$name
            fi
        else
            echo -e "$name → ${RED}No response${NC}"
        fi
    done

    if [[ -n "$best_dns" ]]; then
        echo -e "\n${GREEN}[✔] Best DNS: $best_dns → $best_ping ms${NC}"
        set_dns "${dns_servers[$best_dns]}"
    else
        echo -e "${RED}[✘] No working DNS found.${NC}"
    fi
}

# ===== بارگذاری DNSهای شخصی =====
load_custom_dns

# ===== منوی اصلی =====
while true; do
    echo -e "\n${BLUE}===== DNS Configuration Menu =====${NC}"
    echo -e "${YELLOW}1)${NC} Automatically select fastest DNS"
    echo -e "${YELLOW}2)${NC} Manually choose from ranked list"
    echo -e "${YELLOW}3)${NC} Show current DNS settings"
    echo -e "${YELLOW}4)${NC} Restore default DNS"
    echo -e "${YELLOW}5)${NC} Add custom DNS"
    echo -e "${YELLOW}99)${NC} Quit"

    read -p "Choose mode: " mode

    case "$mode" in
        1) auto_select_dns ;;
        2) manual_menu ;;
        3) show_current_dns ;;
        4) restore_dns ;;
        5) add_custom_dns ;;
        99) echo "Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid option.${NC}" ;;
    esac
done

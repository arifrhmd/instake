#!/usr/bin/env bash
#
# PHOTOS

Photos() {
    local url=$1
    local id=${url/https:\/\/www.instagram.com\/p\//}
    echo -e "${GREEN}[-]${CYAN} Starting with id :${YELLOW} ${id/\//}"
    local data=$(curl -s -A "$useragent" "$url" | grep 'window._sharedData')
    if [[ -z "$data" ]]; then
        echo -e "${RED}[-]${YELLOW} Failed to get content"
        echo -e "${RED}[-]${YELLOW} Check your connection${N}"
        exit 0
    fi
    local username=$(echo "$data" | grep -Po '"username":"\K[^"]*' | tail -1)
    echo -e "${GREEN}[-]${CYAN} Posted by ${YELLOW}$username"
    local get=$(echo "$data" | grep -Po '750},{"src":"\K[^"]*' | sed 's/\\u00.*//g' | sort -u)
    local count=$(echo "$get" | wc -l)
    echo -e "${GREEN}[-]${CYAN} Total media : ${YELLOW}$count"
    echo -e "${GREEN}[-]${CYAN} Output directory : ${YELLOW}${output_dir}/photos"
    echo -e "${GREEN}[-]${CYAN} Starting download ..."
    for i in ${get}; do
        local name=$(echo "$i" | awk -F/ '{print $9}')
        name2=$(echo "$name" | sed 's/?.*//g')
        curl -s -A "$useragent" "$i" -o "${output_dir}/photos/${username}_${name2}"
        echo -e "${GREEN}[-]${CYAN} Saved : ${YELLOW}${username}_${name2}"
    done
    echo -e "${GREEN}[~]${CYAN} DONE \n"
    echo -ne "${Y1}[c]${CYAN}ontinue/${P1}[e]${CYAN}xit : "
    read option
    case $option in
        c)
            bash ${0}
            ;;
        e)
            echo -ne "${N}"
            exit 0
            ;;
        *)
            echo -ne "${N}"
            exit 0
            ;;
    esac
}

echo -ne "${GREEN}[>]${CYAN} Insert URL : "
read url

Photos "$url"
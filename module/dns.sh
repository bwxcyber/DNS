#!/bin/bash
read -p $'Name: ' sub
read -p $'IPv4 address: ' ip
dns="${sub}.${site}"

Proxied(){
read -p $'Proxied [Y/n] > ' proxied
if [[ $proxied == Y || $proxied == y ]]; then
set -euo pipefail
zone=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${site}&status=active" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
record=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
if [[ "${#record}" -le 10 ]]; then
     record=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records" \
          -H "X-Auth-Email: ${mail}" \
          -H "X-Auth-Key: ${api}" \
          -H "Content-Type: application/json" \
          --data '{"type":"A","name":"'${dns}'","content":"'${ip}'","proxied":true}' | jq -r .result.id)
fi

result=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records/${record}" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${ip}'","proxied":true}')

elif [[ $proxied == N || $proxied == n ]]; then
set -euo pipefail
zone=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${site}&status=active" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
record=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
if [[ "${#record}" -le 10 ]]; then
     record=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records" \
          -H "X-Auth-Email: ${mail}" \
          -H "X-Auth-Key: ${api}" \
          -H "Content-Type: application/json" \
          --data '{"type":"A","name":"'${dns}'","content":"'${ip}'","proxied":false}' | jq -r .result.id)
fi

result=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records/${record}" \
     -H "X-Auth-Email: ${mail}" \
     -H "X-Auth-Key: ${api}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${ip}'","proxied":false}')

else
echo -e "${r}Option not available!${n}"
Proxied

fi
}

Proxied
echo -e "Adding DNS ${g}${dns}${n}"

#!/bin/bash
rm -rf .cf; mkdir .cf
read -p $'Email: ' input_mail; echo "${input_mail}" >> .cf/mail
read -p $'Global API Key: ' input_api; echo "${input_api}" >> .cf/api
read -p $'Site or Domain: ' input_site; echo "${input_site}" >> .cf/site

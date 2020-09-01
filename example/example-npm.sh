#!/usr/bin/env bash

# install bash-base from npmjs only if not installed:
bash-base 2>/dev/null || npm install -g bash-base

# verify the installation:
#man -P cat bash-base

### import it
source bash-base

SHORT_DESC='an example shell script to show how to use bash-base '

response=$(curl -sS 'https://restcountries.eu/rest/v2/regionalbloc/eu' --compressed)
string_pick_to_array '{"name":"' '","topLevelDomain' countryNames "$response"

print_header collect information
args_parse $# "$@" firstName lastName age sex country

args_valid_or_read firstName '^[A-Za-z ]{2,}$' "Your first name (only letters)"
args_valid_or_read lastName '^[A-Za-z ]{2,}$' "Your last name (only letters)"
args_valid_or_read age '^[0-9]{1,2}$' "Your age (maxim 2 digits))"
args_valid_or_select_pipe sex 'man|woman' "Your sex"
args_valid_or_select country countryNames "Which country"

args_confirm firstName lastName age sex country

print_header say hello
cat <<-EOF
	Hello $(string_upper_first "$firstName") $(string_upper "$lastName"),
	nice to meet you.
EOF

# you can run this script with -h to get the help usage
#     ./example-npm.sh -h

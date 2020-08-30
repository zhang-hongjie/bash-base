#!/usr/bin/env bash

### Import common lib
source src/bash-base.sh


SHORT_DESC='an example shell script to show how to use bash-base '

response=$(curl -sS 'https://restcountries.eu/rest/v2/regionalbloc/eu' --compressed )
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


### Constants
THIS_SCRIPT_NAME="$(basename "$0")"
export THIS_SCRIPT_NAME
COLOR_BOLD_BLACK=$'\e[1;30m'        #Header
COLOR_BOLD_RED=$'\e[1;91m'          #Error, KO
export COLOR_BOLD_GREEN=$'\e[1;32m' #OK
COLOR_BLUE=$'\e[0;34m'              #Value
COLOR_END=$'\e[0m'                  #Others: reset to default

### Functions string_xxx

function string_trim() {
	echo "${1:-$(cat)}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' #trim ' '
}

# Usage:
#   string_length " as fd "
#   string_length < logfile
#   echo " add " | string_length
function string_length() {
	expr "${1:-$(cat)}" : '.*'
}

# Usage:
#   string_sub " as fd " 2
#   string_sub < logfile
#   echo " add " | string_sub
function string_sub() {
	local start=$1
	local length=$2
	local string="${3:-$(cat)}"
	echo "${string:$start:$length}"
}

# Usage:
#   string_before_first " as fd " "s f"
#   string_before_first "str" < logfile
#   echo " add " | string_before_first "str"
function string_before_first() {
	local tokenString=$1
	local string="${2:-$(cat)}"
	echo "${string%%${tokenString}*}" # Remove the first - and everything following it
}

# Usage:
#   string_after_first " as fd " "s f"
#   string_after_first "token" < logfile
#   echo " add " | string_after_first "token"
function string_after_first() {
	local tokenString=$1
	local string="${2:-$(cat)}"
	echo "${string#*${tokenString}}" # Remove everything up to and including first -
}

# Usage:
#   string_index_first " as fd " "s f"
#   string_index_first "token" < logfile
#   echo " add " | string_index_first "token"
# Return:
#   the positive index of first place of token in string, -1 if not existed
function string_index_first() {
	local tokenString=$1
	local string="${2:-$(cat)}"
	prefix="${string%%${tokenString}*}"
	[ "${string}" == "${prefix}" ] && echo -1 || echo ${#prefix}
}

# Usage:
#   escape preserved char of regex, normally for preprocess of sed token
#   escape_sed 'a$'
function escape_sed() {
	echo "${1}" | sed 's/\//\\\//g' | sed 's/\&/\\\&/g' | sed 's/\./\\\./g' | sed 's/\^/\\\^/g' | sed 's/\[/\\\[/g' | sed 's/\$/\\\$/g'
}
export -f escape_sed

# Usage:
#    string_replace 'a' 'b' 'aaa'   ==> 'bbb'
#    string_replace '$' 'b' 'a$a'   ==> 'aba'
#    string_replace '\*' 'b' 'a*a'  ==> 'aba'
function string_replace() {
	local from to
	from=$(escape_sed "${1}")
	to=$(escape_sed "${2}")
	echo "${3:-$(cat)}" | sed -e "s/${from}/${to}/g"
}

# Usage:
#   string_replace_regex 'a*' 'b' 'a*a' ==> 'b*b'
#   string_replace_regex 'a*' 'b' "aaa" ==> 'b'
#   string_replace_regex '*' 'b' 'a*a'  ==> 'aba'
function string_replace_regex() {
	echo "${3:-$(cat)}" | sed -e "s/$1/$2/g"
}

# Usage:
#   str="a|b|c"
#   string_split_to_array '|' newArray "$str"
#
#   branchesToSelectString=$(git branch -r --list  'origin/*')
#   string_split_to_array $'\n' branchesToSelectArray "${branchesToSelectString}"
function string_split_to_array() {
	local newArrayVarName="$2"
	local string="${3:-$(cat)}"

	IFS=$1
	tmp=("${string}")

	command="${newArrayVarName}=(\${tmp[@]})"
	eval "${command}"

	unset IFS
}

### Functions array_xxx

# Usage:
#   array_join '|' "${branchesToSelect3[@]}"
function array_join() {
	IFS=$1
	shift
	echo "$*"
	unset IFS
}

# Usage:
#   array_describe arrayVarName
function array_describe() {
	declare -p "$1" | string_after_first "=" | tr '"' "'"
}

# Usage:
#   arr=("a" "b" "c" "ab" "f" "g")
#   array_contains arr "ab"
#
#   array_contains ${validValuesVarName} ${value}
function array_contains() {
	local array="$1[@]"
	local seeking="$2"
	local exitCode=1
	for element in "${!array}"; do
		if [[ ${element} == "${seeking}" ]]; then
			exitCode=0
			break
		fi
	done
	return $exitCode
}

# Usage:
#   arr=("a" "b" "c" "ab" "f" "g")
#   array_remove arr "ab"
#
#   array_remove ${validValuesVarName} ${value}
function array_remove() {
	local arrayVarName="$1"
	local seeking="$2"

	eval "string='$'{${arrayVarName}[@]}"
	command="tmp=(\"${string}\")"
	eval "${command}"

	for index in "${!tmp[@]}"; do
		if [[ "${tmp[$index]}" == "${seeking}" ]]; then
			unset tmp["${index}"]
		fi
	done

	string="\${tmp[@]}"
	command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

# Usage:
#   arr=(" a " " b c ")
#   array_map arr newArray "string_trim | wc -m | string_trim"
#   declare -p newArray
function array_map() {
	local array="$1[@]"
	local newArrayVarName="$2"
	local piped_operators="$3"

	tmp=()
	for element in "${!array}"; do
		mapped_value=$(eval "echo '${element}' | ${piped_operators}")
		tmp+=("${mapped_value}")
	done

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

# Usage:
#    array_append myarr "ele ment1" "ele ment2"
#    array_append myarr "ele ment3" "ele ment4"
function array_append() {
	local arrayVarName="$1"
	shift
	for elementToAppend in "$@"; do
		command="$arrayVarName+=(\"${elementToAppend}\")"
		eval "${command}"
	done
}

### Functions args_xxx

# Usage:
#   args_parse $# "$@" positionalVarName1 positionalVarName2 ...
function args_parse() {
	nbArgValues=$1
	shift 1
	nbPositionalVarNames=$(($# - nbArgValues))

	while getopts ":qh" option; do
		case ${option} in
		q)
			modeQuiet="true"
			;;
		h)
			echo -e "${USAGE}"
			exit 0
			;;
		\?)
			echo -e "${COLOR_BOLD_RED}Error: invalid option: -$OPTARG ${COLOR_END}" >&2
			;;
		esac
	done
	shift $((OPTIND - 1))

	nbPositionalArgValues=$((nbArgValues - OPTIND + 1))
	positionalArgValues=("${@:1:nbPositionalArgValues}")
	positionalVarNames=("${@:nbPositionalArgValues+1:nbPositionalVarNames}")
	for i in $(seq 0 $((nbPositionalVarNames - 1))); do
		eval "${positionalVarNames[i]}='${positionalArgValues[i]}'"
	done
}

# Usage:
#   show the name and value of variables
#   var1="value 1"
#   var2="value 2"
#   args_print var1 var2
function args_print() {
	for varName in "$@"; do
		varValue=$(eval echo '$'"${varName}")
		varValueOutput=$([[ -z "${varValue}" ]] && echo "${COLOR_BOLD_RED}<NULL>${COLOR_END}" || echo "${COLOR_BLUE}${varValue}${COLOR_END}")
		printf "%-30.30s%s\n" "${varName}:" "${varValueOutput}"
	done
}

# Usage:
#   arr=("a" "b" "c" "ab" "f" "g")
#   value="abc"
#   args_valid_or_select value arr "Which app"
#   declare -p value
function args_valid_or_select() {
	local valueVarName validValuesVarName prompt value validValues
	valueVarName="${1}"
	validValuesVarName=$2
	prompt="${3}"

	value=$(eval eval "echo '$'${valueVarName}")
	validValues=("${validValuesVarName[@]}")

	while ! array_contains "${validValuesVarName}" "${value}"; do
		echo -e "\n${prompt} ?"
		[[ -n "${value}" ]] && echo -e "${COLOR_BOLD_RED}The input '${value}' is not valid.${COLOR_END}"

		PS3="choose one by ${COLOR_BOLD_BLACK}number${COLOR_END} [1|2|...] ? "
		select value in "${!validValues}"; do
			break
		done
	done
	eval "${valueVarName}='${value}'"
	printf "Selected value: ${COLOR_BLUE}'%s'${COLOR_END}\n" "$(eval echo '$'"${valueVarName}")"
}

# Usage:
#    sel="abc"
#    args_valid_or_select_pipe sel "a|ab|d" "which value"
function args_valid_or_select_pipe() {
	local valueVarName validValues prompt
	valueVarName="${1}"
	validValues="${2}"
	prompt="${3}"

	string_split_to_array '|' newArray "$validValues"
	args_valid_or_select "${valueVarName}" newArray "$prompt"
}

# Usage:
#    args_valid_or_read destProjectSIA '^[0-9a-z]{3,3}$' "SIA (lowercase, 3 chars)"
#    args_valid_or_read destProjectIRN '^[0-9]{5,5}$' "IRN (only the 5 digits)"
#    args_valid_or_read destRootPackage '^.+$' "Destination root package" "${defaultDestRootPackage}"
function args_valid_or_read() {
	local value regExp prompt proposedValue
	value=$(eval eval "echo '$'$1")
	regExp=${2}
	prompt="${3}"
	proposedValue="${4}"

	if [[ -n "${proposedValue}" ]]; then
		prompt="${prompt} [${proposedValue}]"
		if [[ -z "${value}" && "${modeQuiet}" == "true" ]]; then
			value="${proposedValue}"
		fi
	fi
	while ! [[ ${value} =~ ${regExp} ]]; do
		[[ -n "${value}" ]] && echo -e "${COLOR_BOLD_RED}The input '${value}' is not valid, please input again.${COLOR_END}"
		read -r -p "${prompt}: " value
		if [[ -z "${value}" ]]; then
			value="${proposedValue}"
		fi
	done
	eval "${1}='${value}'"
	printf "Inputted value: ${COLOR_BLUE}'%s'${COLOR_END}\n" "$(eval echo '$'"${1}")"
}

# Usage:
#   a="correct value"
#   b="wrong value"
#   args_confirm a b
function args_confirm() {
	args_print "$@"
	if ! [[ "${modeQuiet}" == "true" ]]; then
		read -r -p "Continue ? [y/N] " response

		case "${response}" in
		[yY][eE][sS] | [yY])
			echo -e "Starting..."
			sleep 3s
			;;
		*)
			echo -e "Exiting..."
			exit 1
			;;
		esac
	fi
}

### Functions others

# Usage:
#   print_header "My header1"
#   print_header My header2
function print_header() {
	echo -e "${COLOR_BOLD_BLACK}\n### $* ${COLOR_END}"
}

# Usage:
#   'trap' or 'set -e' is not recommended
#    rm -fr "${destProjectPath}"
#    stop_if_failed "ERROR: can't delete the directory '${destProjectPath}' !"
function stop_if_failed() {
	if [[ $? -ne 0 ]]; then
		echo -e "${COLOR_BOLD_RED}${1} ${COLOR_END}\n"
		exit 1
	fi
}

# Usage:
#   declare_heredoc varName <<-EOF
#   ...
#   EOF
function declare_heredoc() {
	eval "$1='$(cat)'"
}

function functions_list() {
	grep "^[[:space:]]*function " "$0" | cut -d'(' -f1 | sed -e "s/function//"
}

function functions_list2() {
	declare -f
	#	declare -F
}

: '=pod
=head1 string_trim

=head4 NAME

    string_trim -- Remove the white chars from prefix and suffix

=head4 SYNOPSIS

    string_trim string_to_trim

=head4 EXAMPLES

    string_trim " as fd "
    string_trim < logfile
    echo " add " | string_trim
=cut'
function functions_list1() {
	declare -f
	#	declare -F
}

: '=pod
=head1 string_trim

=head4 NAME

    string_trim -- Remove the white chars from prefix and suffix

=head4 SYNOPSIS

    string_trim string_to_trim

=head4 EXAMPLES

    string_trim " as fd "
    string_trim < logfile
    echo " add " | string_trim
=cut'
function functions_list1() {
	declare -f
	#	declare -F
}

: '=pod
=head1 string_trim

NAME

    string_trim -- Remove the white chars from prefix and suffix

SYNOPSIS

    string_trim string_to_trim

EXAMPLES

    string_trim " as fd "
    string_trim < logfile
    echo " add " | string_trim
=cut'
function functions_list1() {
	declare -f
	#	declare -F
}

: '=pod
=head1 string_trim

NAME

    string_trim -- Remove the white chars from prefix and suffix

SYNOPSIS

    string_trim string_to_trim

EXAMPLES

    string_trim " as fd "
    string_trim < logfile
    echo " add " | string_trim
=cut'
function functions_list1() {
	declare -f
	#	declare -F
}

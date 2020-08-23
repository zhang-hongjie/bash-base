#!/usr/bin/env bash

# ## Constants
# - **THIS_SCRIPT_NAME:** the main script name
THIS_SCRIPT_NAME="$(basename "$0")"
# - **SED_NEW_LINE:** return and new line, used with sed
SED_NEW_LINE="\\$(echo -e '\r\n')"
# - **COLOR_BOLD_BLACK:** Header
COLOR_BOLD_BLACK=$'\e[1;30m'
# - **COLOR_BOLD_RED:** Error, KO
COLOR_BOLD_RED=$'\e[1;91m'
# - **COLOR_BOLD_GREEN:** OK
COLOR_BOLD_GREEN=$'\e[1;32m'
# - **COLOR_BLUE:** Value
COLOR_BLUE=$'\e[0;34m'
# - **COLOR_END:** for others, reset to default
COLOR_END=$'\e[0m'
export THIS_SCRIPT_NAME SED_NEW_LINE COLOR_BOLD_BLACK COLOR_BOLD_RED COLOR_BOLD_GREEN COLOR_BLUE COLOR_END

# ## Functions string_xxx

# @NAME
#     string_trim -- remove the white chars from prefix and suffix
# @SYNOPSIS
#     string_trim [string]
# @DESCRIPTION
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_trim " as fd "
#     string_trim < logfile
#     echo " add " | string_trim
# @SEE_ALSO
function string_trim() {
	echo "${1-$(cat)}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' #trim ' '
}

# @NAME
#     string_length -- return the string length
# @SYNOPSIS
#     string_length [string]
# @DESCRIPTION
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_length " as fd "
#     string_length < logfile
#     echo " add " | string_length
# @SEE_ALSO
function string_length() {
	local string index
	string="${1-$(cat)}"

	index=$(string_index_first $'\n' "${string}")
	[[ "${index}" -ge 0 ]] && expr "${string}" : '.*' || echo "${#string}"
}

function string_is_empty() {
	local string="${1-$(cat)}"

	[[ $(string_length "$string") -eq 0 ]]
}

# @NAME
#     string_sub -- extract a part of string and return
# @SYNOPSIS
#     string_sub startIndex subStringLength [string]
# @DESCRIPTION
#     **startIndex** the index of first character in string, 0 based, may negative
#     **subStringLength** the length of sub string, 0 based, may negative
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_sub -5 -1 " as fd "
#     string_sub 3 5 < temp_file.txt
#     echo ' as fd ' | string_sub 2 4
# @SEE_ALSO
function string_sub() {
	local startIndex=$1
	local subStringLength=$2
	local string="${3-$(cat)}"
	echo "${string:$startIndex:$subStringLength}"
}

# @NAME
#     string_index_first -- return the positive index of first place of token in string, -1 if not existed
# @SYNOPSIS
#     string_index_first tokenString [string]
# @DESCRIPTION
#     **tokenString** the string to search
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_index_first " as fd " "s f"
#     string_index_first "token" < logfile
#     echo " add " | string_index_first "token"
# @SEE_ALSO
#     string_before_first, string_after_first
function string_index_first() {
	local tokenString=$1
	local string="${2-$(cat)}"
	local prefix="${string%%${tokenString}*}"
	[ "${string}" == "${prefix}" ] && echo -1 || echo ${#prefix}
}

# @NAME
#     string_before_first -- find the first index of token in string, and return the sub string before it.
# @SYNOPSIS
#     string_before_first tokenString [string]
# @DESCRIPTION
#     **tokenString** the string to search
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_before_first " as fd " "s f"
#     string_before_first "str" < logfile
#     echo " add " | string_before_first "dd"
# @SEE_ALSO
#     string_index_first, string_after_first
function string_before_first() {
	local tokenString=$1
	local string="${2-$(cat)}"
	echo "${string%%${tokenString}*}" # Remove the first - and everything following it
}

# @NAME
#     string_after_first -- find the first index of token in string, and return the sub string after it.
# @SYNOPSIS
#     string_after_first tokenString [string]
# @DESCRIPTION
#     **tokenString** the string to search
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_after_first " as fd " "s f"
#     string_after_first "str" < logfile
#     echo " add " | string_after_first "dd"
# @SEE_ALSO
#     string_index_first, string_before_first
function string_after_first() {
	local tokenString=$1
	local string="${2-$(cat)}"
	echo "${string#*${tokenString}}" # Remove everything up to and including first -
}

# @NAME
#     escape_sed -- escape preserved char of regex, normally for preprocessing of sed token.
# @SYNOPSIS
#     escape_sed string
# @DESCRIPTION
#     **string** the string to process
# @EXAMPLES
#     escape_sed 'a$'
# @SEE_ALSO
#     string_replace
function escape_sed() {
	echo "${1}" | sed -e 's/\//\\\//g' -e 's/\&/\\\&/g' -e 's/\./\\\./g' -e 's/\^/\\\^/g' -e 's/\[/\\\[/g' -e 's/\$/\\\$/g'
}
export -f escape_sed

# @NAME
#     string_replace -- replace literally the token string to new string, not support regular expression
# @SYNOPSIS
#     string_replace tokenString newString [string]
# @DESCRIPTION
#     **tokenString** the string to search, the preserved character of regular expression will be escaped
#     **newString** the new value of replacing to, the preserved character of regular expression will be escaped
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_replace 'a' 'b' 'aaa'   ==> 'bbb'
#     string_replace '$' 'b' 'a$a'   ==> 'aba'
#     string_replace '\*' 'b' 'a*a'  ==> 'aba'
# @SEE_ALSO
#     escape_sed, string_replace_regex
function string_replace() {
	local tokenString newString
	tokenString=$(escape_sed "${1}")
	newString=$(escape_sed "${2}")
	echo "${3-$(cat)}" | sed -e "s/${tokenString}/${newString}/g"
}

# @NAME
#     string_replace_regex -- replace the token string to new string, support regular expression
# @SYNOPSIS
#     string_replace_regex tokenString newString [string]
# @DESCRIPTION
#     **tokenString** the string to search, support regular expression and its modern extension
#     **newString** the new value of replacing to, support [back-references](https://www.gnu.org/software/sed/manual/html_node/Back_002dreferences-and-Subexpressions.html)
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_replace_regex 'a*' 'b' 'a*a' ==> 'b*b'
#     string_replace_regex 'a*' 'b' "aaa" ==> 'b'
#     string_replace_regex '*' 'b' 'a*a'  ==> 'aba'
# @SEE_ALSO
#     string_replace
function string_replace_regex() {
	echo "${3-$(cat)}" | sed -E -e "s/$1/$2/g"
}

function string_match() {
	local value regExp
	value="$1"
	regExp=${2}

	[[ ${value} =~ ${regExp} ]]
}

# @NAME
#     string_split_to_array -- split a string to array by a delimiter character, then assign the array to a new variable name
# @SYNOPSIS
#     string_split_to_array IFS newArrayVarName [string]
# @DESCRIPTION
#     **IFS** the delimiter character
#     **newArrayVarName** the new variable name which the array will be assigned to
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     str="a|b|c"
#     string_split_to_array '|' newArray "$str"
#     
#     branchesToSelectString=$(git branch -r --list  'origin/*')
#     string_split_to_array $'\n' branchesToSelectArray "${branchesToSelectString}"
# @SEE_ALSO
#     array_join, array_describe, array_from_describe
function string_split_to_array() {
	local newArrayVarName="$2"
	local string="${3-$(cat)}"

	local IFS=$1
	local tmp=("${string}")

	local command="${newArrayVarName}=(\${tmp[@]})"
	eval "${command}"
	unset IFS
}

# ## Functions array_xxx

# @NAME
#     array_join -- join an array to string using IFS
# @SYNOPSIS
#     array_join IFS arrayValue...
# @DESCRIPTION
#     **IFS** the delimiter character
#     **arrayValue...** the values of an array
# @EXAMPLES
#     myArry=(" a " " b c ")
#     array_join '|' "${myArry[@]}" ==> " a | b c "
# @SEE_ALSO
#     string_split_to_array, array_describe, array_from_describe
function array_join() {
	local delimiter="$1"
	local array="$2[@]"

	local element result delimiterLength
	for element in "${!array}"; do
		result="${result}${element}${delimiter}"
	done

	delimiterLength=$(string_length "${delimiter}")
	string_is_empty "${result}" && echo '' || string_sub 0 $((0 - delimiterLength)) "${result}"
}

# @NAME
#     array_describe -- convert the array to its string representation
# @SYNOPSIS
#     array_describe arrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArray=("a" "b")
#     array_describe myArray ==> ([0]='a' [1]='b')
# @SEE_ALSO
#     string_split_to_array, array_join, array_from_describe
function array_describe() {
	declare -p "$1" | string_after_first "=" | tr '"' "'"
}

# @NAME
#     array_from_describe -- restore the array from its string representation, then assign it to a variable name
# @SYNOPSIS
#     array_from_describe newArrayVarName [string]
# @DESCRIPTION
#     **newArrayVarName** the new variable name which the array will be assigned to
#     **[string]** the string of array describe, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     array_from_describe myNewArray "([0]='a' [1]='b')"
#     array_from_describe myNewArray < fileNameContentString
# @SEE_ALSO
#     string_split_to_array, array_join, array_describe
function array_from_describe() {
	local newArrayVarName="$1"
	local string="${2-$(cat)}"

	local command="${newArrayVarName}=${string}"
	eval "${command}"
}

# @NAME
#     array_contains -- exit success code 0 if array contains element, fail if not.
# @SYNOPSIS
#     array_contains arrayVarName [seekingElement]
# @DESCRIPTION
#     **arrayVarName** the variable name of array to test
#     **[seekingElement]** the element to search in array, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     arr=("a" "b" "c" "ab" "f" "g")
#     array_contains arr "ab"
#     echo "ab" | array_contains arr
# @SEE_ALSO
#     array_remove
function array_contains() {
	local array="$1[@]"
	local seeking="${2-$(cat)}"

	local exitCode element
	exitCode=1
	for element in "${!array}"; do
		if [[ ${element} == "${seeking}" ]]; then
			exitCode=0
			break
		fi
	done
	return $exitCode
}

function array_sort() {
	local arrayVarName="$1"

	local sorted=($(array_join $'\n' ${arrayVarName} | sort))

	local string="\${sorted[@]}"
	local command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_sort_distinct() {
	local arrayVarName="$1"

	local sorted=($(array_join $'\n' ${arrayVarName} | sort -u))

	local string="\${sorted[@]}"
	local command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_length() {
	local arrayVarName="$1"
	local string command tmp

	eval "string='$'{${arrayVarName}[@]}"
	command="tmp=(\"${string}\")"
	eval "${command}"

	echo "${#tmp[@]}"
}

function array_reset_index() {
	local arrayVarName="$1"
	local string command tmp

	eval "string='$'{${arrayVarName}[@]}"
	command="tmp=(\"${string}\")"
	eval "${command}"

	string="\${tmp[@]}"
	command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_equals() {
	local arrayVarName1="$1"
	local arrayVarName2="$2"
	local ignoreOrder=${3:-true}
	local ignoreDuplicated=${4:-false}

	local tmp1 tmp2
	array_clone "$arrayVarName1" tmp1
	array_clone "$arrayVarName2" tmp2

	if [ "${ignoreOrder}" = true ]; then
		if [ "${ignoreDuplicated}" = true ]; then
			array_sort_distinct tmp1
			array_sort_distinct tmp2
		else
			array_sort tmp1
			array_sort tmp2
		fi
	else
		array_reset_index tmp1
		array_reset_index tmp2
	fi

	[ "$(array_describe tmp1)" == "$(array_describe tmp2)" ]
}

function array_intersection() {
	local array1="$1[@]"
	local arrayVarName2="$2"
	local newArrayVarName="$3"
	local ignoreOrderAndDuplicated=${4:-true}

	local tmp element2 string command
	tmp=()
	for element2 in "${!array1}"; do
		array_contains "$arrayVarName2" "$element2" && array_append tmp "$element2"
	done

	if [ "${ignoreOrderAndDuplicated}" = true ]; then
		array_sort_distinct tmp
	fi

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_subtract() {
	local array1="$1[@]"
	local arrayVarName2="$2"
	local newArrayVarName="$3"
	local ignoreOrderAndDuplicated=${4:-true}

	local tmp element2 string command
	tmp=()
	for element2 in "${!array1}"; do
		array_contains "$arrayVarName2" "$element2" || array_append tmp "$element2"
	done

	if [ "${ignoreOrderAndDuplicated}" = true ]; then
		array_sort_distinct tmp
	fi

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_union() {
	local array1="$1[@]"
	local array2="$2[@]"
	local newArrayVarName="$3"
	local ignoreOrderAndDuplicated=${4:-true}

	local tmp element2 string command
	tmp=()
	for element2 in "${!array1}"; do
		array_append tmp "$element2"
	done
	for element2 in "${!array2}"; do
		array_append tmp "$element2"
	done

	if [ "${ignoreOrderAndDuplicated}" = true ]; then
		array_sort_distinct tmp
	fi

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

# @NAME
#     array_append -- append some elements to original array
# @SYNOPSIS
#     array_append arrayVarName element...
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **element...** the elements to append to array
# @EXAMPLES
#     myArray=()
#     array_append myArray "ele ment1" "ele ment2"
# @SEE_ALSO
#     array_remove
function array_append() {
	local arrayVarName="$1"
	shift

	local elementToAppend command
	for elementToAppend in "$@"; do
		command="$arrayVarName+=(\"${elementToAppend}\")"
		eval "${command}"
	done
}

# @NAME
#     array_remove -- remove the element from the original array
# @SYNOPSIS
#     array_remove arrayVarName element
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **element** the element to remove from array
# @EXAMPLES
#     arr=("a" "b" "c" "ab" "f" "g")
#     array_remove arr "ab"
# @SEE_ALSO
#     array_contains, array_append
function array_remove() {
	local arrayVarName="$1"
	local element="$2"

	local string command tmp index
	eval "string='$'{${arrayVarName}[@]}"
	command="tmp=(\"${string}\")"
	eval "${command}"

	for index in "${!tmp[@]}"; do
		if [[ "${tmp[$index]}" == "${element}" ]]; then
			unset tmp["${index}"]
		fi
	done

	string="\${tmp[@]}"
	command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_clone() {
	local arrayVarName="$1"
	local arrayVarName2="$2"

	array_from_describe "$arrayVarName2" "$(array_describe "$arrayVarName")"
}

# @NAME
#     array_map -- apply the specified map operation on each element of array, and assign the result array to a new variable name
# @SYNOPSIS
#     array_map arrayVarName newArrayVarName pipedOperators
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **newArrayVarName** the variable name of result array
#     **pipedOperators** a string of operations, if multiple operations will be apply on each element, join them by pipe '|'
# @EXAMPLES
#     arr=(" a " " b c ")
#     array_map arr newArray "string_trim | wc -m | string_trim"
# @SEE_ALSO
function array_map() {
	local array="$1[@]"
	local newArrayVarName="$2"
	local pipedOperators="$3"

	local tmp element mapped_value string command
	tmp=()
	for element in "${!array}"; do
		mapped_value=$(eval "echo '${element}' | ${pipedOperators}")
		tmp+=("${mapped_value}")
	done

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

function array_filter() {
	local array="$1[@]"
	local newArrayVarName="$2"
	local regExp=$3

	local tmp element string command
	tmp=()
	for element in "${!array}"; do
		if [[ ${element} =~ ${regExp} ]]; then
			array_append tmp "${element}"
		fi
	done

	string="\${tmp[@]}"
	command="${newArrayVarName}=(\"${string}\")"
	eval "${command}"
}

# ## Functions args_xxx

# @NAME
#     args_parse -- parse the script argument values to positional variable names, process firstly the optional param help(-h) / quiet(-q) if existed
# @SYNOPSIS
#     args_parse $# "$@" positionalVarName...
# @DESCRIPTION
#     **positionalVarName...** some new variable names to catch the positional argument values
# @EXAMPLES
#     args_parse $# "$@" newVar1 newVar2 newVar3
# @SEE_ALSO
function args_parse() {
	local nbArgValues nbPositionalVarNames option OPTARG OPTIND nbPositionalArgValues positionalArgValues positionalVarNames

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
			print_error "invalid option: -$OPTARG" >&2
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

# @NAME
#     args_valid_or_select -- test whether the value contains by the array, if not contained, require to select a new one from array and assign it to the value variable name
# @SYNOPSIS
#     args_valid_or_select valueVarName arrayVarName prompt
# @DESCRIPTION
#     **valueVarName** the variable name of the value to valid and the new value assign to,
#     **arrayVarName** the variable name of array
#     **prompt** the prompt message to show when requiring to select a new one from array
# @EXAMPLES
#     arr=("a" "b" "c" "ab" "f" "g")
#     appName="abc"
#     args_valid_or_select appName arr "Which app"
#     varEmpty=""
#     args_valid_or_select varEmpty arr "Which app"
# @SEE_ALSO
#     args_valid_or_select_pipe, args_valid_or_read
function args_valid_or_select() {
	local valueVarName validValuesVarName prompt value validValues PS3
	valueVarName="${1}"
	validValuesVarName=$2
	prompt="${3}"

	value=$(eval eval "echo '$'${valueVarName}")
	validValues=("${validValuesVarName[@]}")

	while ! array_contains "${validValuesVarName}" "${value}"; do
		echo -e "\n${prompt} ?"
		[[ -n "${value}" ]] && print_error "the input '${value}' is not valid."

		PS3="choose one by ${COLOR_BOLD_BLACK}number${COLOR_END} [1|2|...] ? "
		select value in "${!validValues}"; do
			break
		done
	done
	eval "${valueVarName}='${value}'"
	printf "Selected value: ${COLOR_BLUE}'%s'${COLOR_END}\n" "$(eval echo '$'"${valueVarName}")"
}

# @NAME
#     args_valid_or_select_pipe -- test whether the value contains by the array, if not contained, require to select a new one from array and assign it to the value variable name
# @SYNOPSIS
#     args_valid_or_select_pipe valueVarName strValidValues prompt
# @DESCRIPTION
#     **valueVarName** the variable name of the value to valid and the new value assign to,
#     **strValidValues** values joined by pipe '|'
#     **prompt** the prompt message to show when requiring to select a new one from array
# @EXAMPLES
#     sel="abc"
#     args_valid_or_select_pipe sel "a|ab|d" "which value"
# @SEE_ALSO
#     args_valid_or_select, args_valid_or_read
function args_valid_or_select_pipe() {
	local valueVarName validValues prompt newArray
	valueVarName="${1}"
	validValues="${2}"
	prompt="${3}"

	string_split_to_array '|' newArray "$validValues"
	args_valid_or_select "${valueVarName}" newArray "$prompt"
}

# @NAME
#     args_valid_or_read -- test whether the value matched the valid regular expression, if not matched, require input a new one and assign it to the value variable name
# @SYNOPSIS
#     args_valid_or_read valueVarName strRegExp prompt [proposedValue]
# @DESCRIPTION
#     **valueVarName** the variable name of the value to valid and the new value assign to,
#     **strRegExp** a string of regular expression to be used for validation
#     **prompt** the prompt message to show when requiring to read a new one from stdin
#     **[proposedValue]** the proposed spare value to show for user, or to used when quite mode
# @EXAMPLES
#     args_valid_or_read destProjectSIA '^[0-9a-z]{3,3}$' "SIA (lowercase, 3 chars)"
#     args_valid_or_read destProjectIRN '^[0-9]{5,5}$' "IRN (only the 5 digits)"
#     args_valid_or_read destRootPackage '^.+$' "Destination root package" "${defaultDestRootPackage}"
# @SEE_ALSO
#     args_valid_or_select, args_valid_or_select_pipe
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
		[[ -n "${value}" ]] && print_error "the input '${value}' is not valid, please input again."
		read -r -p "${prompt}: " value
		if [[ -z "${value}" ]]; then
			value="${proposedValue}"
		fi
	done
	eval "${1}='${value}'"
	printf "Inputted value: ${COLOR_BLUE}'%s'${COLOR_END}\n" "$(eval echo '$'"${1}")"
}

# @NAME
#     args_print -- show the name and value of variables
# @SYNOPSIS
#     args_print variableName...
# @DESCRIPTION
#     **variableName...** some existed variable names to show its value
# @EXAMPLES
#     var1="value 1"
#     var2="value 2"
#     args_print var1 var2
# @SEE_ALSO
#     args_confirm
function args_print() {
	local varName varValue varValueOutput
	for varName in "$@"; do
		varValue=$(eval echo '$'"${varName}")
		varValueOutput=$([[ -z "${varValue}" ]] && print_error "<NULL>" || echo "${COLOR_BLUE}${varValue}${COLOR_END}")
		printf "%-30.30s%s\n" "${varName}:" "${varValueOutput}"
	done
}

# @NAME
#     args_confirm -- show the name and value of variables, and continue execute if confirmed by user, or exit if not
# @SYNOPSIS
#     args_confirm variableName...
# @DESCRIPTION
#     **variableName...** some existed variable names to show its value
# @EXAMPLES
#     a="correct value"
#     b="wrong value"
#     args_confirm a b
# @SEE_ALSO
#     args_print
function args_confirm() {
	local response
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

# ## Functions reflect_xxx

# @NAME
#     reflect_function_definitions_of_bash_base -- print the definitions of functions in bash-base and its caller script
# @SYNOPSIS
#     reflect_function_definitions_of_bash_base
# @DESCRIPTION
# @EXAMPLES
#     reflect_function_definitions_of_bash_base
# @SEE_ALSO
#     reflect_function_names_of_file
function reflect_all_function_definitions() {
	declare -f
}

# @NAME
#     reflect_function_names_of_file -- print the function names defined in a shell script file
# @SYNOPSIS
#     reflect_function_names_of_file file
# @DESCRIPTION
#     **file** the path of shell script file
# @EXAMPLES
#     reflect_function_names_of_file $0
#     reflect_function_names_of_file scripts/my_script.sh
# @SEE_ALSO
#     reflect_all_function_definitions
function reflect_function_names_of_file() {
	grep "^[[:space:]]*function " "$1" | cut -d'(' -f1 | sed -e "s/function//"
}

# @NAME
#     reflect_all_variables -- print all the variables
# @SYNOPSIS
#     reflect_function_names_of_file
# @DESCRIPTION
# @EXAMPLES
#     reflect_function_names_of_file
# @SEE_ALSO
function reflect_all_variables() {
	declare -p
}

# ## Functions doc_xxx

# @NAME
#     reflect_all_variables -- print all the variables
# @SYNOPSIS
#     reflect_function_names_of_file
# @DESCRIPTION
# @EXAMPLES
#     reflect_function_names_of_file
# @SEE_ALSO
function doc_lint_script_comment() {
	local fromShellFile="$1"
	local element functionComments arrFunctions manTags element3 arrComments intersection counter
	# shell format
	docker run -it --rm -v "$(pwd)":/project -w /project jamesmstone/shfmt -l -w "${fromShellFile}"

	# format the comment
	sed -E -i '' \
		-e "s/^#[[:space:]]*/#/g" \
		-e "s/^#/#     /g" \
		-e "s/^#[[:space:]]*@/# @/g" \
		-e "s/^#[[:space:]]*!/#!/g" \
		-e "s/^#[[:space:]]*-/# -/g" \
		-e "s/^#[[:space:]]*(#+)/# \1/g" \
		"${fromShellFile}"

	# valid comment tags by man page convention
	functionComments=$(grep -e '^# @' -e '^function ' "${fromShellFile}" | string_replace_regex '\(\)|#' '' | string_trim)
	string_split_to_array "{" arrFunctions "${functionComments}"
	manTags=('@NAME' '@SYNOPSIS' '@DESCRIPTION' '@EXAMPLES' '@SEE_ALSO')
	for element3 in "${arrFunctions[@]}"; do
		string_split_to_array $'\n' arrComments "${element3}"
		array_intersection manTags arrComments intersection false
		array_equals manTags intersection false
		if [[ $? -ne 0 ]]; then
			((counter++))
			declare -p manTags intersection
			print_error "the comments is not the same as template for ${arrComments[-1]}"
		fi
	done

	if ((counter > 0)); then
		echo "there are ${counter} functions has invalid comments in file ${fromShellFile}"
		exit 1
	fi
}

# @NAME
#     doc_comment_to_markdown -- convert the shell script comment to markdown file
# @SYNOPSIS
#     doc_comment_to_markdown fromShellFile toMarkdownFile
# @DESCRIPTION
#     **fromShellFile** the path of source shell script file
#     **toMarkdownFile** the path of destination markdown file
# @EXAMPLES
#     doc_comment_to_markdown src/bash-base.sh docs/reference.md
# @SEE_ALSO
#     doc_markdown_to_manpage, doc_check_script_comment
function doc_comment_to_markdown() {
	local fromShellFile="$1"
	local toMarkdownFile="$2"

	grep '^\s*#' "${fromShellFile}" |
		string_trim |
		string_replace_regex '^#' '' |
		string_replace_regex '!.*' '' |
		string_trim |
		string_replace_regex '@NAME' "${SED_NEW_LINE}---${SED_NEW_LINE}@NAME" |
		string_replace_regex '@' "${SED_NEW_LINE}##### " |
		cat >"${toMarkdownFile}"
}

# @NAME
#     doc_markdown_to_manpage -- use pandoc to generate man page from markdown, use man section 1
# @SYNOPSIS
#     doc_markdown_to_manpage fromMarkdownFile toManPageFile [strManHeader] [pandocVersion]
# @DESCRIPTION
#     **fromMarkdownFile** the path of source markdown file
#     **toManPageFile** the path of destination man file
#     **[strManHeader]** optional, the string of man page header, default to empty string
#     **[pandocVersion]** optiona, lthe pandoc version to use, default to 2.10
# @EXAMPLES
#     doc_markdown_to_manpage docs/reference.md man/bash-base 'bash-base function reference man page'
# @SEE_ALSO
#     doc_comment_to_markdown, doc_check_script_comment
function doc_markdown_to_manpage() {
	local fromMarkdownFile="$1"
	local toManPageFile="$2"
	local strManHeader="${3:-''}"
	local pandocVersion="${4:-2.10}"

	docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) pandoc/core:${pandocVersion} -f markdown -t man --standalone "{fromMarkdownFile}" --variable=section:1 --variable=header:"${strManHeader}" -o ${toManPageFile}.1
	man "${toManPageFile}.1"
}

# ## Functions others

# @NAME
#     print_header -- print the header value with prefix '\n###' and bold font
# @SYNOPSIS
#     print_header string
# @DESCRIPTION
#     **string** the string of header title
# @EXAMPLES
#     print_header "My header1"
# @SEE_ALSO
function print_header() {
	echo -e "${COLOR_BOLD_BLACK}\n### $* ${COLOR_END}"
}

function print_error() {
	echo -e "${COLOR_BOLD_RED}ERROR: $* ${COLOR_END}"
}
# @NAME
#     stop_if_failed -- stop the execute if last command exit with fail code (no zero)
# @SYNOPSIS
#     stop_if_failed string
# @DESCRIPTION
#     'trap' or 'set -e' is not recommended
#     **string** the error message to show
# @EXAMPLES
#     rm -fr "${destProjectPath}"
#     stop_if_failed "ERROR: can't delete the directory '${destProjectPath}' !"
# @SEE_ALSO
function stop_if_failed() {
	if [[ $? -ne 0 ]]; then
		print_error "${1}"
		exit 1
	fi
}

# @NAME
#     declare_heredoc -- stop the execute if last command exit with fail code (no zero)
# @SYNOPSIS
#     declare_heredoc newVarName <<-EOF
#     ...
#     EOF
# @DESCRIPTION
#     **newVarName** the variable name, the content of heredoc will be assigned to it
# @EXAMPLES
#     declare_heredoc records <<-EOF
#     record1
#     record2
#     EOF
# @SEE_ALSO
function declare_heredoc() {
	eval "$1='$(cat)'"
}

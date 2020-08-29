#!/usr/bin/env bash

NEW_LINE_SED="\\$(echo -e '\r\n')" # Constant: the return and new line character, used with sed
COLOR_BOLD_BLACK=$'\e[1;30m'       # Constant: color for printing Header
COLOR_BOLD_RED=$'\e[1;91m'         # Constant: color for printing message of Error/KO
COLOR_BOLD_GREEN=$'\e[1;32m'       # Constant: color for printing message of OK
COLOR_BLUE=$'\e[0;34m'             # Constant: color for printing Value
COLOR_END=$'\e[0m'                 # Constant: color for others, reset to default
export NEW_LINE_SED COLOR_BOLD_BLACK COLOR_BOLD_RED COLOR_BOLD_GREEN COLOR_BLUE COLOR_END

THIS_SCRIPT_NAME="$(basename "$0")" # the main script name
SHORT_DESC=''                       # redefine it to show your script short description in the 'NAME' field of generated -h response
USAGE=''                            # redefine it in your script only if the generated -h response is not good for you

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

# @NAME
#     string_is_empty -- exit success code 0 if the string is empty
# @SYNOPSIS
#     string_is_empty [string]
# @DESCRIPTION
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_is_empty " as fd "
#     string_is_empty < logfile
#     echo " add " | string_is_empty
# @SEE_ALSO
#     string_length
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
#     string_match -- test if the string match the regular expression
# @SYNOPSIS
#     string_match regExp [string]
# @DESCRIPTION
#     **regExp** the regular expression
#     **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
# @EXAMPLES
#     string_match 'name;+' "name;name;"
# @SEE_ALSO
#     string_index_first
function string_match() {
	local value regExp
	regExp=${1}
	string="${2-$(cat)}"

	[[ ${string} =~ ${regExp} ]]
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

# @NAME
#     array_join -- join an array to string using delimiter string
# @SYNOPSIS
#     array_join delimiter arrayVarName
# @DESCRIPTION
#     **delimiter** the delimiter string
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArry=(" a " " b c ")
#     array_join '|' myArry ==> " a | b c "
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

# @NAME
#     array_sort -- sort the elements of array, save the result to original variable name
# @SYNOPSIS
#     array_sort arrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArray=('aa' 'bb' 'aa')
#     array_sort myArray ==> ([0]='aa' [1]='aa' [2]='bb')
# @SEE_ALSO
#     array_sort_distinct
function array_sort() {
	local arrayVarName="$1"

	local sorted=($(array_join $'\n' ${arrayVarName} | sort))

	local string="\${sorted[@]}"
	local command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

# @NAME
#     array_sort_distinct -- remove the duplicated elements of array, sort and save the result to original variable name
# @SYNOPSIS
#     array_sort_distinct arrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArray=('aa' 'bb' 'aa')
#     array_sort_distinct myArray ==> ([0]='aa' [1]='bb')
# @SEE_ALSO
#     array_sort
function array_sort_distinct() {
	local arrayVarName="$1"

	local sorted=($(array_join $'\n' ${arrayVarName} | sort -u))

	local string="\${sorted[@]}"
	local command="${arrayVarName}=(\"${string}\")"
	eval "${command}"
}

# @NAME
#     array_length -- return the number of elements of array
# @SYNOPSIS
#     array_length arrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArray=('aa' 'bb' 'aa')
#     array_length myArray ==> 3
# @SEE_ALSO
function array_length() {
	local arrayVarName="$1"
	local string command tmp

	eval "string='$'{${arrayVarName}[@]}"
	command="tmp=(\"${string}\")"
	eval "${command}"

	echo "${#tmp[@]}"
}

# @NAME
#     array_reset_index -- reset the indexes of array to the sequence 0,1,2..., save the result to original variable name
# @SYNOPSIS
#     array_reset_index arrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of the array to be processed
# @EXAMPLES
#     myArray=([2]='a' [5]='c' [11]='dd')
#     array_reset_index myArray ==> ([0]='a' [1]='c' [2]='dd')
# @SEE_ALSO
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

# @NAME
#     array_equals -- test if the elements of 2 array are equal, ignore the array index
# @SYNOPSIS
#     array_equals arrayVarName1 arrayVarName2 [ignoreOrder] [ignoreDuplicated]
# @DESCRIPTION
#     **arrayVarName1** the variable name of an array
#     **arrayVarName2** the variable name of another array to compare with
#     **[ignoreOrder]** optional, a boolean value true/false, indicate whether ignore element order when compare, default true
#     **[ignoreDuplicated]** optional, a boolean value true/false, indicate whether ignore element duplicated when compare, default false
# @EXAMPLES
#     myArray1=('aa' [3]='bb' 'aa')
#     myArray2=('aa' 'aa' 'bb')
#     array_equals myArray1 myArray2 false && echo Y || echo N ==> N
#     array_equals myArray1 myArray2 true && echo Y || echo N ==> Y
# @SEE_ALSO
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

# @NAME
#     array_intersection -- calcul the intersection of 2 arrays, and save the result to a new variable
# @SYNOPSIS
#     array_intersection arrayVarName1 arrayVarName2 newArrayVarName [ignoreOrderAndDuplicated]
# @DESCRIPTION
#     **arrayVarName1** the variable name of an array
#     **arrayVarName2** the variable name of another array
#     **newArrayVarName** the name of new variable to save the result
#     **[ignoreOrderAndDuplicated]** optional, a boolean value true/false, indicate whether ignore element duplicated and order them when save the result, default true
# @EXAMPLES
#     myArray1=('aa' [3]='bb' 'aa' 'cc')
#     myArray2=('aa' 'aa' 'dd' 'bb')
#     array_intersection myArray1 myArray2 newArray
#     array_intersection myArray1 myArray2 newArray false
# @SEE_ALSO
#     array_subtract, array_union
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

# @NAME
#     array_subtract -- calcul the subtract of 2 arrays, and save the result to a new variable
# @SYNOPSIS
#     array_subtract arrayVarName1 arrayVarName2 newArrayVarName [ignoreOrderAndDuplicated]
# @DESCRIPTION
#     **arrayVarName1** the variable name of an array
#     **arrayVarName2** the variable name of another array
#     **newArrayVarName** the name of new variable to save the result
#     **[ignoreOrderAndDuplicated]** optional, a boolean value true/false, indicate whether ignore element duplicated and order them when save the result, default true
# @EXAMPLES
#     myArray1=('aa' [3]='bb' 'aa' 'cc')
#     myArray2=('aa' 'aa' 'dd' 'bb')
#     array_subtract myArray1 myArray2 newArray
#     array_subtract myArray1 myArray2 newArray false
# @SEE_ALSO
#     array_intersection, array_union
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

# @NAME
#     array_union -- calcul the union of 2 arrays, and save the result to a new variable
# @SYNOPSIS
#     array_union arrayVarName1 arrayVarName2 newArrayVarName [ignoreOrderAndDuplicated]
# @DESCRIPTION
#     **arrayVarName1** the variable name of an array
#     **arrayVarName2** the variable name of another array
#     **newArrayVarName** the name of new variable to save the result
#     **[ignoreOrderAndDuplicated]** optional, a boolean value true/false, indicate whether ignore element duplicated and order them when save the result, default true
# @EXAMPLES
#     myArray1=('aa' [3]='bb' 'aa' 'cc')
#     myArray2=('aa' 'aa' 'dd' 'bb')
#     array_union myArray1 myArray2 newArray
#     array_union myArray1 myArray2 newArray false
# @SEE_ALSO
#     array_intersection, array_union
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

# @NAME
#     array_clone -- clone an array, including index/order/duplication/value, and assign the result array to a new variable name
# @SYNOPSIS
#     array_clone arrayVarName newArrayVarName
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **newArrayVarName** the variable name of result array
# @EXAMPLES
#     arr=(" a " " b c ")
#     array_clone arr newArray
# @SEE_ALSO
function array_clone() {
	local arrayVarName="$1"
	local arrayVarName2="$2"

	array_from_describe "$arrayVarName2" "$(array_describe "$arrayVarName")"
}

# @NAME
#     array_map -- apply the specified map operation on each element of array, and assign the result array to a new variable name
# @SYNOPSIS
#     array_map arrayVarName pipedOperators [newArrayVarName]
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **pipedOperators** a string of operations, if multiple operations will be apply on each element, join them by pipe '|'
#     **[newArrayVarName]** optional, the variable name of result array, if absent, the mapped array will be joined by newline and printed to stdout
# @EXAMPLES
#     arr=(" a " " b c ")
#     array_map arr "string_trim | wc -m | string_trim" newArray
# @SEE_ALSO
function array_map() {
	local array="$1[@]"
	local pipedOperators="$2"
	local newArrayVarName="$3"

	local tmp element mapped_value string command
	tmp=()
	for element in "${!array}"; do
		escaped="${element//\'/\'"\'"\'}" # escape the single quote
		mapped_value="$(eval "echo '${escaped}' | ${pipedOperators}")"
		tmp+=("${mapped_value}")
	done

	if [[ -n "${newArrayVarName}" ]]; then
		string="\${tmp[@]}"
		command="${newArrayVarName}=(\"${string}\")"
		eval "${command}"
	else
		array_join $'\n' tmp
	fi
}

# @NAME
#     array_filter -- filter the elements of an array, and assign the result array to a new variable name
# @SYNOPSIS
#     array_filter arrayVarName regExp [newArrayVarName]
# @DESCRIPTION
#     **arrayVarName** the variable name of array to process
#     **regExp** a string of regular expression pattern
#     **[newArrayVarName]** optional, the variable name of result array, if absent, the mapped array will be joined by newline and printed to stdout
# @EXAMPLES
#     arr=("NAME A" "NAME B" "OTHER")
#     array_filter arr 'NAME' newArray
# @SEE_ALSO
function array_filter() {
	local array="$1[@]"
	local regExp="$2"
	local newArrayVarName="$3"

	local tmp element string command
	tmp=()
	for element in "${!array}"; do
		if [[ ${element} =~ ${regExp} ]]; then
			array_append tmp "${element}"
		fi
	done

	if [[ -n "${newArrayVarName}" ]]; then
		string="\${tmp[@]}"
		command="${newArrayVarName}=(\"${string}\")"
		eval "${command}"
	else
		array_join $'\n' tmp
	fi
}

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
	local nbArgValues nbPositionalVarNames option showUsage OPTARG OPTIND nbPositionalArgValues positionalArgValues positionalVarNames
	local element validCommand description defaultUsage

	nbArgValues=$1
	shift 1
	nbPositionalVarNames=$(($# - nbArgValues))

	while getopts ":qh" option; do
		case ${option} in
		q)
			modeQuiet="true"
			;;
		h)
			showUsage="true"
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

	# Generate default usage response for -h
	declare_heredoc defaultUsage <<-EOF
		${COLOR_BOLD_BLACK}NAME${COLOR_END}
		    ${THIS_SCRIPT_NAME} -- ${SHORT_DESC:-a bash script using bash-base}

		${COLOR_BOLD_BLACK}SYNOPSIS${COLOR_END}
		    ./${THIS_SCRIPT_NAME} [-qh] $(array_join ' ' positionalVarNames)

		${COLOR_BOLD_BLACK}DESCRIPTION${COLOR_END}
		    [-h]                help, print the usage
		    [-q]                optional, Run quietly, no confirmation
		$(
			for element in "${positionalVarNames[@]}"; do
				validCommand="$(grep "^\s*args_valid.* ${element} " "$0" | sed -e "s/\'//g")"
				if [[ -z ${validCommand} ]]; then
					description="a valid value for ${element}"
				else
					description=$(reflect_nth_arg 4 "${validCommand}")
					if [[ $validCommand =~ 'args_valid_or_select_pipe' ]]; then
						description="${description}, possible values: $(reflect_nth_arg 3 $validCommand)"
					fi
				fi

				printf "\n    %-20s%s" "${element} " "${description}"
			done
		)

		${COLOR_BOLD_BLACK}EXAMPLES${COLOR_END}
		    help, print the usage:
		        ./${THIS_SCRIPT_NAME} -h

		    run with params:
		        ./${THIS_SCRIPT_NAME} [-q] "$(array_join 'Value" "' positionalVarNames)Value"

		    run using wizard, input value for params step by step:
		        ./${THIS_SCRIPT_NAME}
	EOF

	if [[ $showUsage == "true" ]]; then
		echo -e "${USAGE:-$defaultUsage}"
		exit 0
	fi
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

# @NAME
#     reflect_nth_arg -- parse a string of arguments, then extract the nth argument
# @SYNOPSIS
#     reflect_nth_arg index arguments...
# @DESCRIPTION
#     **index** a number based on 1, which argument to extract
#     **arguments...** the string to parse, the arguments and may also including the command.
# @EXAMPLES
#     reflect_nth_arg 3 ab cdv "ha ho" ==>  "ha ho"
#
#     string="args_valid_or_read myVar '^[0-9a-z]{3,3}$' \"SIA\""
#     reflect_nth_arg 4 $string ==> "SIA"
# @SEE_ALSO
function reflect_nth_arg() {
	local index string args
	index=$1
	string="$(echo $* | string_replace_regex '(\\|\||\{|>|<|&)' '\\\1')"

	args=()
	eval 'for word in '${string}'; do args+=("$word"); done'
	echo "${args[$index]}"
}

# @NAME
#     reflect_get_function_definition -- print the definition of the specified function in system
# @SYNOPSIS
#     reflect_get_function_definition functionName
# @DESCRIPTION
#     **functionName** the specified function name
# @EXAMPLES
#     reflect_get_function_definition args_confirm
# @SEE_ALSO
#     reflect_function_names_of_file
function reflect_get_function_definition() {
	local functionName="$1"
	declare -f "$functionName"
}

# @NAME
#     reflect_function_names_of_file -- print the function names defined in a shell script file
# @SYNOPSIS
#     reflect_function_names_of_file shellScriptFile
# @DESCRIPTION
#     **shellScriptFile** the path of shell script file
# @EXAMPLES
#     reflect_function_names_of_file $0
#     reflect_function_names_of_file scripts/my_script.sh
# @SEE_ALSO
#     reflect_get_function_definition
function reflect_function_names_of_file() {
	local shellScriptFile="$1"
	grep -E '^[[:space:]]*(function)?[[:space:]]*[0-9A-Za-z_\-]+[[:space:]]*\(\)[[:space:]]*\{?' "${shellScriptFile}" | cut -d'(' -f1 | sed -e "s/function//"
}

# @NAME
#     reflect_function_definitions_of_file -- print the function definitions defined in a shell script file
# @SYNOPSIS
#     reflect_function_definitions_of_file shellScriptFile
# @DESCRIPTION
#     **shellScriptFile** the path of shell script file
# @EXAMPLES
#     reflect_function_definitions_of_file $0
#     reflect_function_definitions_of_file scripts/my_script.sh
# @SEE_ALSO
#     reflect_get_function_definition
function reflect_function_definitions_of_file() {
	local shellScriptFile="$1"
	sed -E -n '/^[[:space:]]*(function)?[[:space:]]*[0-9A-Za-z_\-]+[[:space:]]*\(\)[[:space:]]*\{?/,/^[[:space:]]*}/p' "${shellScriptFile}"
}

# @NAME
#     reflect_search_function -- search usable function by name pattern
# @SYNOPSIS
#     reflect_search_function functionNamePattern
# @DESCRIPTION
#     **functionNamePattern** the string of function name regular expression pattern
# @EXAMPLES
#     reflect_search_function args
#     reflect_search_function '^args_.*'
# @SEE_ALSO
#     reflect_search_variable
function reflect_search_function() {
	local functionNamePattern="$1"
	declare -f | grep -E '\s+\(\)\s+' | sed -E 's/[(){ ]//g' | grep -Ei "${functionNamePattern}"
}

# @NAME
#     reflect_search_variable -- search usable variable by name pattern
# @SYNOPSIS
#     reflect_search_variable variableNamePattern
# @DESCRIPTION
#     **variableNamePattern** the string of variable name regular expression pattern
# @EXAMPLES
#     reflect_search_variable COLOR
#     reflect_search_variable '^COLOR'
# @SEE_ALSO
#     reflect_search_function
function reflect_search_variable() {
	local variableNamePattern="$1"
	declare -p | grep -Eo '\s+\w+=' | sed -E 's/[= ]//g' | grep -Ei "${variableNamePattern}"
}

# @NAME
#     doc_lint_script_comment -- format the shell script, and check whether the comment is corrected man-styled
# @SYNOPSIS
#     doc_lint_script_comment shellScriptFile
# @DESCRIPTION
#     It's better format your shell script by `shfmt` firstly before using this function.
#
#     **shellScriptFile** the path of shell script file
# @EXAMPLES
#     shellScriptFile="src/bash-base.sh"
#     docker run -it --rm -v "$(pwd):/src" -w /src mvdan/shfmt -l -w "${shellScriptFile}"
#     doc_lint_script_comment "${shellScriptFile}"
# @SEE_ALSO
#     doc_comment_to_markdown, doc_markdown_to_manpage
function doc_lint_script_comment() {
	local shellScriptFile="$1"
	local element strAllFunctionsAndTheirTags arrAllFunctionsAndTheirTags manTags strFunctionAndItsTags arrFunctionAndItsTags intersection counter

	# format the comment
	sed -E -i \
		-e "s/^#[[:space:]]*/#/g" \
		-e "s/^#/#     /g" \
		-e "s/^#[[:space:]]*@/# @/g" \
		-e "s/^#[[:space:]]*!/#!/g" \
		-e "s/^#[[:space:]]*-/# -/g" \
		-e "s/^#[[:space:]]*(#+)/# \1/g" \
		"${shellScriptFile}"

	# valid comment tags by man page convention
	strAllFunctionsAndTheirTags=$(grep -e '^# @' -e '^function ' "${shellScriptFile}" | string_replace_regex '\(\)|#' '' | string_trim)
	string_split_to_array "{" arrAllFunctionsAndTheirTags "${strAllFunctionsAndTheirTags}"
	local manTags=('@NAME' '@SYNOPSIS' '@DESCRIPTION' '@EXAMPLES' '@SEE_ALSO')
	for strFunctionAndItsTags in "${arrAllFunctionsAndTheirTags[@]}"; do
		string_split_to_array $'\n' arrFunctionAndItsTags "${strFunctionAndItsTags}"
		array_intersection manTags arrFunctionAndItsTags intersection false
		array_equals manTags intersection false
		if [[ $? -ne 0 ]]; then
			((counter++))
			declare -p manTags intersection
			print_error "the comments is not the same as template for ${arrFunctionAndItsTags[-1]}"
		fi
	done

	if ((counter > 0)); then
		echo "there are ${counter} functions has invalid comments in file ${shellScriptFile}"
		exit 1
	fi
}

# @NAME
#     doc_comment_to_markdown -- convert the shell script man-styled comment to markdown file
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

	local md mdComment
	export md="$(
		grep '^#' "${fromShellFile}" |
			string_trim |
			string_replace_regex '^#!.*' '' |
			string_replace_regex '^#' '' |
			string_trim |
			sed '/./,$!d' | # Delete all leading blank lines at top of file (only).
			sed '1d' |      # Delete first line of file
			string_replace_regex '^(@NAME)' "${NEW_LINE_SED}---${NEW_LINE_SED}${NEW_LINE_SED}\1" |
			string_replace_regex '^(@SYNOPSIS|@EXAMPLES)' "${NEW_LINE_SED}\1${NEW_LINE_SED}\`\`\`" |
			string_replace_regex '^(@DESCRIPTION|@SEE_ALSO)' "\`\`\`${NEW_LINE_SED}${NEW_LINE_SED}\1" |
			string_replace_regex '^(\*\*)' "- \1"
	)"

	mdComment="[//]: # (This file is generated by bash-base function doc_comment_to_markdown, don't modify this file directly.)"
	echo -e "${mdComment}\n\n@NAME\n${md//${NEW_LINE_SED}/\\n}" | #NEW_LINE_SED is not compatible by pandoc
		string_replace_regex '@' "##### " >"${toMarkdownFile}"
}

# @NAME
#     doc_markdown_to_manpage -- use pandoc to generate man page from markdown, use man section 1
# @SYNOPSIS
#     doc_markdown_to_manpage fromMarkdownFile toManPageFile [strManHeader] [pandocVersion]
# @DESCRIPTION
#     **fromMarkdownFile** the path of source markdown file
#     **toManPageFile** the path of destination man file
#     **[strManHeader]** optional, the string of man page header, default to empty string
#     **[pandocVersion]** optiona, the pandoc version to use, default to 2.10
# @EXAMPLES
#     doc_markdown_to_manpage docs/reference.md man/bash-base 'bash-base function reference man page'
# @SEE_ALSO
#     doc_comment_to_markdown, doc_check_script_comment
function doc_markdown_to_manpage() {
	local fromMarkdownFile="$1"
	local toManPageFile="$2"
	local strManHeader="${3:-''}"
	local pandocVersion="${4:-2.10}"

	docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) pandoc/core:${pandocVersion} -f markdown -t man --standalone "${fromMarkdownFile}" --variable=section:1 --variable=header:"${strManHeader}" -o ${toManPageFile}.1
	man "${toManPageFile}.1"
}

# @NAME
#     print_header -- print the header value with prefix '\n###' and bold font
# @SYNOPSIS
#     print_header string
# @DESCRIPTION
#     **string** the string of header title
# @EXAMPLES
#     print_header "My header1"
# @SEE_ALSO
#     print_error
function print_header() {
	echo -e "${COLOR_BOLD_BLACK}\n### $* ${COLOR_END}"
}

# @NAME
#     print_error -- print the error message with prefix 'ERROR:' and font color red
# @SYNOPSIS
#     print_error string
# @DESCRIPTION
#     **string** the error message
# @EXAMPLES
#     print_error "my error message"
# @SEE_ALSO
#     print_header
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

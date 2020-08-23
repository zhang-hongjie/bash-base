
## Constants
- **THIS_SCRIPT_NAME:** the main script name
- **SED_NEW_LINE:** return and new line, used with sed
- **COLOR_BOLD_BLACK:** Header
- **COLOR_BOLD_RED:** Error, KO
- **COLOR_BOLD_GREEN:** OK
- **COLOR_BLUE:** Value
- **COLOR_END:** for others, reset to default
## Functions string_xxx
---##### NAME
string_trim -- remove the white chars from prefix and suffix
##### SYNOPSIS
string_trim [string]
##### DESCRIPTION
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_trim " as fd "
string_trim < logfile
echo " add " | string_trim
```##### SEE_ALSO
---##### NAME
string_length -- return the string length
##### SYNOPSIS
string_length [string]
##### DESCRIPTION
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_length " as fd "
string_length < logfile
echo " add " | string_length
```##### SEE_ALSO
---##### NAME
string_sub -- extract a part of string and return
##### SYNOPSIS
string_sub startIndex subStringLength [string]
##### DESCRIPTION
- **startIndex** the index of first character in string, 0 based, may negative
- **subStringLength** the length of sub string, 0 based, may negative
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_sub -5 -1 " as fd "
string_sub 3 5 < temp_file.txt
echo ' as fd ' | string_sub 2 4
```##### SEE_ALSO
---##### NAME
string_index_first -- return the positive index of first place of token in string, -1 if not existed
##### SYNOPSIS
string_index_first tokenString [string]
##### DESCRIPTION
- **tokenString** the string to search
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_index_first " as fd " "s f"
string_index_first "token" < logfile
echo " add " | string_index_first "token"
```##### SEE_ALSO
string_before_first, string_after_first
---##### NAME
string_before_first -- find the first index of token in string, and return the sub string before it.
##### SYNOPSIS
string_before_first tokenString [string]
##### DESCRIPTION
- **tokenString** the string to search
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_before_first " as fd " "s f"
string_before_first "str" < logfile
echo " add " | string_before_first "dd"
```##### SEE_ALSO
string_index_first, string_after_first
---##### NAME
string_after_first -- find the first index of token in string, and return the sub string after it.
##### SYNOPSIS
string_after_first tokenString [string]
##### DESCRIPTION
- **tokenString** the string to search
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_after_first " as fd " "s f"
string_after_first "str" < logfile
echo " add " | string_after_first "dd"
```##### SEE_ALSO
string_index_first, string_before_first
---##### NAME
escape_sed -- escape preserved char of regex, normally for preprocessing of sed token.
##### SYNOPSIS
escape_sed string
##### DESCRIPTION
- **string** the string to process
##### EXAMPLES```
escape_sed 'a$'
```##### SEE_ALSO
string_replace
---##### NAME
string_replace -- replace literally the token string to new string, not support regular expression
##### SYNOPSIS
string_replace tokenString newString [string]
##### DESCRIPTION
- **tokenString** the string to search, the preserved character of regular expression will be escaped
- **newString** the new value of replacing to, the preserved character of regular expression will be escaped
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_replace 'a' 'b' 'aaa'   ==> 'bbb'
string_replace '$' 'b' 'a$a'   ==> 'aba'
string_replace '\*' 'b' 'a*a'  ==> 'aba'
```##### SEE_ALSO
escape_sed, string_replace_regex
---##### NAME
string_replace_regex -- replace the token string to new string, support regular expression
##### SYNOPSIS
string_replace_regex tokenString newString [string]
##### DESCRIPTION
- **tokenString** the string to search, support regular expression and its modern extension
- **newString** the new value of replacing to, support [back-references](https://www.gnu.org/software/sed/manual/html_node/Back_002dreferences-and-Subexpressions.html)
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
string_replace_regex 'a*' 'b' 'a*a' ==> 'b*b'
string_replace_regex 'a*' 'b' "aaa" ==> 'b'
string_replace_regex '*' 'b' 'a*a'  ==> 'aba'
```##### SEE_ALSO
string_replace
---##### NAME
string_split_to_array -- split a string to array by a delimiter character, then assign the array to a new variable name
##### SYNOPSIS
string_split_to_array IFS newArrayVarName [string]
##### DESCRIPTION
- **IFS** the delimiter character
- **newArrayVarName** the new variable name which the array will be assigned to
- **[string]** the string to process, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
str="a|b|c"
string_split_to_array '|' newArray "$str"

branchesToSelectString=$(git branch -r --list  'origin/*')
string_split_to_array $'\n' branchesToSelectArray "${branchesToSelectString}"
```##### SEE_ALSO
array_join, array_describe, array_from_describe
## Functions array_xxx
---##### NAME
array_join -- join an array to string using IFS
##### SYNOPSIS
array_join IFS arrayValue...
##### DESCRIPTION
- **IFS** the delimiter character
- **arrayValue...** the values of an array
##### EXAMPLES```
myArry=(" a " " b c ")
array_join '|' "${myArry[@]}" ==> " a | b c "
```##### SEE_ALSO
string_split_to_array, array_describe, array_from_describe
---##### NAME
array_describe -- convert the array to its string representation
##### SYNOPSIS
array_describe arrayVarName
##### DESCRIPTION
- **arrayVarName** the variable name of the array to be processed
##### EXAMPLES```
myArray=("a" "b")
array_describe myArray ==> ([0]='a' [1]='b')
```##### SEE_ALSO
string_split_to_array, array_join, array_from_describe
---##### NAME
array_from_describe -- restore the array from its string representation, then assign it to a variable name
##### SYNOPSIS
array_from_describe newArrayVarName [string]
##### DESCRIPTION
- **newArrayVarName** the new variable name which the array will be assigned to
- **[string]** the string of array describe, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
array_from_describe myNewArray "([0]='a' [1]='b')"
array_from_describe myNewArray < fileNameContentString
```##### SEE_ALSO
string_split_to_array, array_join, array_describe
---##### NAME
array_contains -- exit success code 0 if array contains element, fail if not.
##### SYNOPSIS
array_contains arrayVarName [seekingElement]
##### DESCRIPTION
- **arrayVarName** the variable name of array to test
- **[seekingElement]** the element to search in array, if absent, it will be read from the standard input (CTRL+D to end)
##### EXAMPLES```
arr=("a" "b" "c" "ab" "f" "g")
array_contains arr "ab"
echo "ab" | array_contains arr
```##### SEE_ALSO
array_remove
---##### NAME
array_append -- append some elements to original array
##### SYNOPSIS
array_append arrayVarName element...
##### DESCRIPTION
- **arrayVarName** the variable name of array to process
- **element...** the elements to append to array
##### EXAMPLES```
myArray=()
array_append myArray "ele ment1" "ele ment2"
```##### SEE_ALSO
array_remove
---##### NAME
array_remove -- remove the element from the original array
##### SYNOPSIS
array_remove arrayVarName element
##### DESCRIPTION
- **arrayVarName** the variable name of array to process
- **element** the element to remove from array
##### EXAMPLES```
arr=("a" "b" "c" "ab" "f" "g")
array_remove arr "ab"
```##### SEE_ALSO
array_contains, array_append
---##### NAME
array_map -- apply the specified map operation on each element of array, and assign the result array to a new variable name
##### SYNOPSIS
array_map arrayVarName newArrayVarName pipedOperators
##### DESCRIPTION
- **arrayVarName** the variable name of array to process
- **newArrayVarName** the variable name of result array
- **pipedOperators** a string of operations, if multiple operations will be apply on each element, join them by pipe '|'
##### EXAMPLES```
arr=(" a " " b c ")
array_map arr newArray "string_trim | wc -m | string_trim"
```##### SEE_ALSO
## Functions args_xxx
---##### NAME
args_parse -- parse the script argument values to positional variable names, process firstly the optional param help(-h) / quiet(-q) if existed
##### SYNOPSIS
args_parse $# "$@" positionalVarName...
##### DESCRIPTION
- **positionalVarName...** some new variable names to catch the positional argument values
##### EXAMPLES```
args_parse $# "$@" newVar1 newVar2 newVar3
```##### SEE_ALSO
---##### NAME
args_valid_or_select -- test whether the value contains by the array, if not contained, require to select a new one from array and assign it to the value variable name
##### SYNOPSIS
args_valid_or_select valueVarName arrayVarName prompt
##### DESCRIPTION
- **valueVarName** the variable name of the value to valid and the new value assign to,
- **arrayVarName** the variable name of array
- **prompt** the prompt message to show when requiring to select a new one from array
##### EXAMPLES```
arr=("a" "b" "c" "ab" "f" "g")
appName="abc"
args_valid_or_select appName arr "Which app"
varEmpty=""
args_valid_or_select varEmpty arr "Which app"
```##### SEE_ALSO
args_valid_or_select_pipe, args_valid_or_read
---##### NAME
args_valid_or_select_pipe -- test whether the value contains by the array, if not contained, require to select a new one from array and assign it to the value variable name
##### SYNOPSIS
args_valid_or_select_pipe valueVarName strValidValues prompt
##### DESCRIPTION
- **valueVarName** the variable name of the value to valid and the new value assign to,
- **strValidValues** values joined by pipe '|'
- **prompt** the prompt message to show when requiring to select a new one from array
##### EXAMPLES```
sel="abc"
args_valid_or_select_pipe sel "a|ab|d" "which value"
```##### SEE_ALSO
args_valid_or_select, args_valid_or_read
---##### NAME
args_valid_or_read -- test whether the value matched the valid regular expression, if not matched, require input a new one and assign it to the value variable name
##### SYNOPSIS
args_valid_or_read valueVarName strRegExp prompt [proposedValue]
##### DESCRIPTION
- **valueVarName** the variable name of the value to valid and the new value assign to,
- **strRegExp** a string of regular expression to be used for validation
- **prompt** the prompt message to show when requiring to read a new one from stdin
- **[proposedValue]** the proposed spare value to show for user, or to used when quite mode
##### EXAMPLES```
args_valid_or_read destProjectSIA '^[0-9a-z]{3,3}$' "SIA (lowercase, 3 chars)"
args_valid_or_read destProjectIRN '^[0-9]{5,5}$' "IRN (only the 5 digits)"
args_valid_or_read destRootPackage '^.+$' "Destination root package" "${defaultDestRootPackage}"
```##### SEE_ALSO
args_valid_or_select, args_valid_or_select_pipe
---##### NAME
args_print -- show the name and value of variables
##### SYNOPSIS
args_print variableName...
##### DESCRIPTION
- **variableName...** some existed variable names to show its value
##### EXAMPLES```
var1="value 1"
var2="value 2"
args_print var1 var2
```##### SEE_ALSO
args_confirm
---##### NAME
args_confirm -- show the name and value of variables, and continue execute if confirmed by user, or exit if not
##### SYNOPSIS
args_confirm variableName...
##### DESCRIPTION
- **variableName...** some existed variable names to show its value
##### EXAMPLES```
a="correct value"
b="wrong value"
args_confirm a b
```##### SEE_ALSO
args_print
## Functions reflect_xxx
---##### NAME
reflect_function_definitions_of_bash_base -- print the definitions of functions in bash-base and its caller script
##### SYNOPSIS
reflect_function_definitions_of_bash_base
##### DESCRIPTION
##### EXAMPLES```
reflect_function_definitions_of_bash_base
```##### SEE_ALSO
reflect_function_names_of_file
---##### NAME
reflect_function_names_of_file -- print the function names defined in a shell script file
##### SYNOPSIS
reflect_function_names_of_file file
##### DESCRIPTION
- **file** the path of shell script file
##### EXAMPLES```
reflect_function_names_of_file $0
reflect_function_names_of_file scripts/my_script.sh
```##### SEE_ALSO
reflect_all_function_definitions
---##### NAME
reflect_all_variables -- print all the variables
##### SYNOPSIS
reflect_function_names_of_file
##### DESCRIPTION
##### EXAMPLES```
reflect_function_names_of_file
```##### SEE_ALSO
## Functions doc_xxx
---##### NAME
reflect_all_variables -- print all the variables
##### SYNOPSIS
reflect_function_names_of_file
##### DESCRIPTION
##### EXAMPLES```
reflect_function_names_of_file
```##### SEE_ALSO
---##### NAME
doc_comment_to_markdown -- convert the shell script comment to markdown file
##### SYNOPSIS
doc_comment_to_markdown fromShellFile toMarkdownFile
##### DESCRIPTION
- **fromShellFile** the path of source shell script file
- **toMarkdownFile** the path of destination markdown file
##### EXAMPLES```
doc_comment_to_markdown src/bash-base.sh docs/reference.md
```##### SEE_ALSO
doc_markdown_to_manpage, doc_check_script_comment
---##### NAME
doc_markdown_to_manpage -- use pandoc to generate man page from markdown, use man section 1
##### SYNOPSIS
doc_markdown_to_manpage fromMarkdownFile toManPageFile [strManHeader] [pandocVersion]
##### DESCRIPTION
- **fromMarkdownFile** the path of source markdown file
- **toManPageFile** the path of destination man file
- **[strManHeader]** optional, the string of man page header, default to empty string
- **[pandocVersion]** optiona, lthe pandoc version to use, default to 2.10
##### EXAMPLES```
doc_markdown_to_manpage docs/reference.md man/bash-base 'bash-base function reference man page'
```##### SEE_ALSO
doc_comment_to_markdown, doc_check_script_comment
## Functions others
---##### NAME
print_header -- print the header value with prefix '\n###' and bold font
##### SYNOPSIS
print_header string
##### DESCRIPTION
- **string** the string of header title
##### EXAMPLES```
print_header "My header1"
```##### SEE_ALSO
---##### NAME
stop_if_failed -- stop the execute if last command exit with fail code (no zero)
##### SYNOPSIS
stop_if_failed string
##### DESCRIPTION
'trap' or 'set -e' is not recommended
- **string** the error message to show
##### EXAMPLES```
rm -fr "${destProjectPath}"
stop_if_failed "ERROR: can't delete the directory '${destProjectPath}'
```##### SEE_ALSO
---##### NAME
declare_heredoc -- stop the execute if last command exit with fail code (no zero)
##### SYNOPSIS
declare_heredoc newVarName <<-EOF
...
EOF
##### DESCRIPTION
- **newVarName** the variable name, the content of heredoc will be assigned to it
##### EXAMPLES```
declare_heredoc records <<-EOF
record1
record2
EOF
```##### SEE_ALSO

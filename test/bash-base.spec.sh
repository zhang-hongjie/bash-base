#shellcheck shell=bash

Include "src/bash-base.sh"

array_equal() {
    local arrayName="$1"
    local expected="$2"

    actual=$(array_describe "${arrayName}")

    if [[ "${expected}" != "${actual}" ]]; then
        echo -e "# ${COLOR_BOLD_RED}KO${COLOR_END}: actual ${COLOR_BOLD_RED}\"${actual}\"${COLOR_END}, expected ${COLOR_BOLD_RED}\"${expected}\"${COLOR_END}" >&4
    fi

    [[ "${expected}" == "${actual}" ]]
}

preserve() {
    %preserve actual status output error;
}
AfterRun preserve

Describe 'string_split_to_array'
    It 'with variable'
        str="a b c"
        When call string_split_to_array ' ' actual "$str"
        The variable actual should satisfy array_equal actual "([0]='a' [1]='b' [2]='c')"
    End

    It 'with stdin'
        declare_heredoc lines <<-EOF
  origin/develop
  origin/integration
* origin/feature/52-new-feature
EOF
        When call string_split_to_array $'\n' actual "${lines}"
        The variable actual should satisfy array_equal actual "([0]='  origin/develop' [1]='  origin/integration' [2]='* origin/feature/52-new-feature')"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
 1. A D
 2. B
 3. C
EOF
        When call eval "string_split_to_array $'\n' actual < temp_file.txt"
        The variable actual should satisfy array_equal actual "([0]=' 1. A D' [1]=' 2. B' [2]=' 3. C')"

        rm -fr temp_file.txt
    End
End


Describe 'string_replace'
    Parameters
        "a" "b" "aaa" "bbb"
        "." "b" "a.a" "aba"
        "&" "b" "a&a" "aba"

        "/" "b" "a/a" "aba"
        "^" "b" "a^a" "aba"
        "[" "b" "a[a" "aba"

        '$' 'b' 'a$a' "aba"
        "]" "b" "a]a" "aba"
        "-" "b" "a-a" "aba"

        "+" "b" "a+a" "aba"
        "{" "b" "a{a" "aba"
        "}" "b" "a}a" "aba"

        "%" "b" "a%a" "aba"
        "!" "b" "a!a" "aba"

        '\*\*' 'b' 'a***a' "ab*a"
        'a\*' 'b' 'a***a' "b**a"
    End

    Example "replace $1 to $2 in $3"
        When call string_replace "$1" "$2" "$3"
        The output should eq "$4"
    End
End


Describe 'escape_sed'
    It '-'
        When call escape_sed 'a$'
        The output should eq 'a\$'
    End
End


Describe 'string_replace_regex'
    Parameters
        '**' 'b' 'a***a' "babab"
        'a*' 'b' 'a***a' "b*b*b*b"
        '*' 'b' 'a*a' "aba"

        'a*' 'b' 'a*a' "b*b"
        'a*' 'b' 'aaa' "b"
        '\$' 'b' 'a$a' "aba"
    End

    Example "replace $1 to $2 in $3"
        When call string_replace_regex "$1" "$2" "$3"
        The output should eq "$4"
    End
End


Describe 'string_trim'
    It 'with value'
        When call string_trim " as fd "
        The output should eq "as fd"
    End

    It 'with pipe'
        When call eval "echo ' add ' | string_trim"
        The output should eq "add"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
  A D
  B
  C
EOF
        When call eval "string_trim < temp_file.txt"
        The output should eq "A D
B
C"
        The output should eq $'A D\nB\nC'
        rm -fr temp_file.txt
    End
End


Describe 'string_length'
    It 'with value'
        When call string_length " as fd "
        The output should eq "7"
    End

    It 'with pipe'
        When call eval "echo ' add ' | string_length"
        The output should eq "5"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
  A D
  B
  C
EOF
        When call eval "string_length < temp_file.txt"
        The output should eq "13"
        rm -fr temp_file.txt
    End
End


Describe 'string_sub'
    It 'with value'
        When call string_sub 2 4 " as fd "
        The output should eq "s fd"
    End

    It 'with pipe'
        When call eval "echo ' as fd ' | string_sub 2 4"
        The output should eq "s fd"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
ABCD
EFGH
IJKL
EOF
        When call eval "string_sub 3 5 < temp_file.txt"
        The output should eq $'D\nEFG'
        rm -fr temp_file.txt
    End
End


Describe 'string_before_first'
    It 'with value'
        When call string_before_first "asd" "111asd222"
        The output should eq "111"
    End

    It 'with pipe'
        When call eval "echo ' as fd ' | string_before_first 's f'"
        The output should eq " a"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
ABCD
EFGH
IJKL
EOF
        func() { actual=$(string_before_first 'FGH' < temp_file.txt); }
        When run func
        The variable actual should eq $'ABCD\nE'
        rm -fr temp_file.txt
    End
End


Describe 'string_before_first'
    It 'with value'
        When call string_before_first "asd" "111asd222"
        The output should eq "111"
    End

    It 'with pipe'
        When call eval "echo ' as fd ' | string_before_first 's f'"
        The output should eq " a"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
ABCD
EFGH
IJKL
EOF
        func() { actual=$(string_before_first 'FGH' < temp_file.txt); }
        When run func
        The variable actual should eq $'ABCD\nE'
        rm -fr temp_file.txt
    End
End


Describe 'string_after_first'
    It 'with value'
        When call string_after_first "asd" "111asd222"
        The output should eq "222"
    End

    It 'with pipe'
        When call eval "echo ' as fd ' | string_after_first 's f'"
        The output should eq "d "
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
ABCD
EFGH
IJKL
EOF
        func() { actual=$(string_after_first "FGH" < temp_file.txt); }
        When run func
        The variable actual should eq $'\nIJKL'
        rm -fr temp_file.txt
    End
End


Describe 'string_index_first'
    It 'with value'
        When call string_index_first "asd22" "111asd222"
        The output should eq "3"
    End

    It 'with pipe'
        When call eval "echo ' as fd ' | string_index_first 's f'"
        The output should eq "2"
    End

    It 'with file'
        cat > temp_file.txt <<-EOF
ABCD
EFGH
IJKL
EOF
        func() { actual=$(string_index_first "FGH" < temp_file.txt); }
        When run func
        The variable actual should eq "6"
        rm -fr temp_file.txt
    End
End


Describe array_contains
    arr=("a" "b" "c" "ab" "f" "g")

    It 'found'
        When call array_contains arr "ab"
        The status should be success
    End

    It 'not found'
        When call array_contains arr "abc"
        The status should be failure
    End
End


Describe 'array_append'
    It '-'
        When call eval 'array_append myarr " ele ment1" " ele ment2 "; array_append myarr "ele ment3" "ele ment4 "'
        The variable myarr should satisfy array_equal myarr "([0]=' ele ment1' [1]=' ele ment2 ' [2]='ele ment3' [3]='ele ment4 ')"
    End
End


Describe 'array_map'
    arr=(" a " " b c ")

    It 'string_trim'
        When call array_map arr actual "string_trim"
        The variable actual should satisfy array_equal actual "([0]='a' [1]='b c')"
    End

    It 'string_trim | wc -m | string_trim'
        When call array_map arr actual "string_trim | wc -m | string_trim"
        The variable actual should satisfy array_equal actual "([0]='2' [1]='4')"
    End

    It 'sed'
        branchesArray=(
        "  origin/develop"
        "  origin/integration"
        "* origin/feature/52-new-feature")
        When call array_map branchesArray actual "sed -e 's/*//' -e 's/^[[:space:]]*//' -e 's/^origin\///' | string_trim"
        The variable actual should satisfy array_equal actual "([0]='develop' [1]='integration' [2]='feature/52-new-feature')"
    End
End


Describe 'array_join'
    It '-'
        arr=(" a " " b c ")
        When call array_join '|' "${arr[@]}"
        The output should eq " a | b c "
    End
End


Describe 'array_remove'
    It '-'
        arr=("a" " b" "c" "a b" "f" "g")
        When call array_remove arr "a b"
        The variable arr should satisfy array_equal arr "([0]='a' [1]=' b' [2]='c' [3]='f' [4]='g')"
    End
End


Describe 'array_describe'
    arr=("a" " b" "c" "a b" "f" "g")
    It 'with simple value'
        When call array_describe arr
        The output should eq "([0]='a' [1]=' b' [2]='c' [3]='a b' [4]='f' [5]='g')"
    End

    It 'with mapped value'
        branchesArray=("  origin/develop" "  origin/integration" "* origin/feature/52-new-feature")
        actual=($(
            for opt in "${branchesArray[@]}"; do
                echo -e "${opt//\*/}" | string_trim | sed -e 's/^origin\///' #trim ' ' and '*'
            done
        ))

        When call array_describe actual
        The output should eq "([0]='develop' [1]='integration' [2]='feature/52-new-feature')"
    End
End


Describe args_valid_or_select_pipe {
    It 'init value valid'
        sel="ab"
        When call args_valid_or_select_pipe sel "a|ab|d" "which value"
        The variable sel should eq "ab"
        The output should start with "Selected value: ${COLOR_BLUE}'ab'"
    End

    It 'init value invalid'
        sel="abc"
        When call eval 'yes 1 | args_valid_or_select_pipe sel "a|ab|d" "which value" | grep "Selected"'
        The output should eq "Selected value: ${COLOR_BLUE}'a'${COLOR_END}"
        The error should include "choose one by"
    End

    It 'init value invalid and save result to variable'
        sel="abc"
        func() { actual=$(yes 1 | args_valid_or_select_pipe sel "a|ab|d" "which value" | grep "Selected"); }
        When run func
        The variable actual should eq "Selected value: ${COLOR_BLUE}'a'${COLOR_END}"
        The error should include "choose one by"
    End
End


Describe args_valid_or_select {
    arr=("a" "ab" "d")
    It 'init valid'
        sel="ab"
        When call args_valid_or_select sel arr "which value"
        The variable sel should eq "ab"
        The output should start with "Selected value: ${COLOR_BLUE}'ab'"
    End

    It 'init value invalid'
        sel="abc"
        When call eval 'yes 1 | args_valid_or_select sel arr "which value" | grep "Selected"'
        The output should eq "Selected value: ${COLOR_BLUE}'a'${COLOR_END}"
        The error should include "choose one by"
    End
End


Describe args_valid_or_read
    It 'the value is unset'
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70022'${COLOR_END}"
    End

    It 'the value is empty'
        irn=""
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70022'${COLOR_END}"
    End

    It "the value is not valid"
        irn="225"
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70022'${COLOR_END}"
    End

    It "the value is valid"
        irn="70033"
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)'"
        The variable irn should eq "70033"
        The output should eq "Inputted value: ${COLOR_BLUE}'70033'${COLOR_END}"
    End

    It 'take proposedValue when the value is unset and modeQuiet is true'
        modeQuiet="true"
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' 70088 | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70088'${COLOR_END}"
    End

    It 'take proposedValue when the value is empty and modeQuiet is true'
        irn=""
        modeQuiet="true"
        When call eval "yes 70022 | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' 70088 | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70088'${COLOR_END}"
    End

    It 'take proposedValue when user input nothing'
        modeQuiet="false"
        When call eval "yes '' | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' 70088 | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70088'${COLOR_END}"
    End

    It 'not take proposedValue when value is valid'
        modeQuiet="false"
        irn="70033"
        When call eval "yes '' | args_valid_or_read irn '^[0-9]{5,5}$' 'IRN (only the 5 digits)' 70088 | grep 'Inputted'"
        The output should eq "Inputted value: ${COLOR_BLUE}'70033'${COLOR_END}"
    End
End


Describe args_parse
    It 'params'
        set -- "param 1" "param 2"

        When call args_parse $# "$@" var1 var2
        The value "$#" should eq "2"
        The value "$1" should eq "param 1"
        The variable var1 should eq "param 1"
        The variable var2 should eq "param 2"
    End

    It 'modeQuiet'
        set -- "-q"

        When call args_parse $# "$@" var1 var2
        The value "$#" should eq "1"
        The value "$1" should eq "-q"
        The variable var1 should eq ""
        The variable var2 should eq ""
        The variable modeQuiet should eq "true"
    End

    It 'print usage'
        set -- "-h"
        USAGE="Usage:..."

        When run args_parse $# "$@" var1 var2
        The value "$#" should eq "1"
        The value "$1" should eq "-h"
        The variable var1 should be undefined
        The variable var2 should be undefined
        The status should be success
        The output should eq "Usage:..."
    End

    It 'option invalid'
        set -- "-d"

        When run args_parse $# "$@" var1 var2
        The value "$#" should eq "1"
        The value "$1" should eq "-d"
        The variable var1 should be undefined
        The variable var2 should be undefined
        The status should be success
        The error should include "Error: invalid option: -d"
    End
End


Describe 'args_print'
    It '-'
        var1="value 1"
        var2="value 2"
        func() { actual=$(args_print var1 var2); }
        When run func
        The value "$(echo ${actual} | sed -e 's/ //g' -e 's/\n//g')" should eq "var1:${COLOR_BLUE}value1${COLOR_END}var2:${COLOR_BLUE}value2${COLOR_END}"
    End
End


Describe 'args_confirm'
    var1="value 1"
    var2="value 2"

    It 'modeQuiet true'
        modeQuiet="true"
        func() { actual=$(args_confirm var1 var2 && echo 'Excuting following code'); }
        When run func
        The value "$(echo ${actual} | sed -e 's/ //g' -e 's/\n//g')" should eq "var1:${COLOR_BLUE}value1${COLOR_END}var2:${COLOR_BLUE}value2${COLOR_END}Excutingfollowingcode"
    End

    It 'modeQuiet false and input y'
        modeQuiet="false"
        func() { actual=$(yes | args_confirm var1 var2 && echo 'Excuting following code'); }
        When run func
        The value "$(echo ${actual} | sed -e 's/ //g' -e 's/\n//g')" should eq "var1:${COLOR_BLUE}value1${COLOR_END}var2:${COLOR_BLUE}value2${COLOR_END}Starting...Excutingfollowingcode"
    End

    It 'modeQuiet false and input n'
        modeQuiet="false"
        func() { eval "yes 'n' | args_confirm var1 var2 && echo 'Excuting following code'"; }
        When run func
        The output should include "var1:                         ${COLOR_BLUE}value 1${COLOR_END}"
        The output should include "var2:                         ${COLOR_BLUE}value 2${COLOR_END}"
        The output should end with "Exiting..."
        The status should be failure
    End
End


Describe 'declare_heredoc'
    It '-'
        func() { declare_heredoc actual <<-EOF
 A B
 C
EOF
        }
        When run func
        The variable actual should eq $' A B\n C'
    End
End


Describe 'print_header'
    It '-'
        When call print_header abc
        The output should eq "${COLOR_BOLD_BLACK}
### abc ${COLOR_END}"
    End
End


fDescribe 'stop_if_failed'
    It 'no error'
        func() { eval "echo 'message normal'; stop_if_failed 'error occurred'"; }
        When run func
        The output should eq "message normal"
        The status should be success
    End

    It 'command not found'
        func() { eval "a_function_not_existed; stop_if_failed 'error occurred'"; }
        When run func
        The output should include "${COLOR_BOLD_RED}error occurred ${COLOR_END}"
        The error should include "a_function_not_existed: command not found"
        The status should be failure
    End

    It 'function exit with error'
        function a_function_exit_error() {
          return 1
        }
        func() { eval "a_function_exit_error; stop_if_failed 'error occurred'"; }
        When run func
        The output should include "${COLOR_BOLD_RED}error occurred ${COLOR_END}"
        The status should be failure
    End
End

#!/usr/bin/env bash

### Import common lib
#source ../src/bash-base.sh
source src/bash-base.sh

function __myNewFunction() {
  echo "this is my new function"
}

declare_heredoc USAGE <<-EOF
${COLOR_BOLD_BLACK}Usage:${COLOR_END}

    help, print this usage:
        ./${THIS_SCRIPT_NAME} -h

    bootstrap a project using params:
        ./${THIS_SCRIPT_NAME} [-q] <destProjectIRN> <destProjectSIA> <destGitRepoURL> [destProjectName destRootPackage destDatabaseName]
            -q                 Optional, Run quietly, no confirmation

    bootstrap a project using wizard:
        ./${THIS_SCRIPT_NAME}

${COLOR_BOLD_BLACK}Notes:${COLOR_END}
    Tested on Mac OSX, bash 3.2
EOF

### parse_arguments
args_parse $# "$@" myVar
args_valid_or_read myVar '^[0-9a-z]{3,3}$' "SIA (lowercase, 3 chars)"

#reflect_function_definitions_of_bash_base
#reflect_function_names_of_file $0
reflect_variables


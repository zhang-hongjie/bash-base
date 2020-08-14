#!/usr/bin/env bash

### Import common lib
source bash-base.sh


### Constants
BOILERPLATE_PROJECT_IRN="71012"
BOILERPLATE_PROJECT_SIA="skf"
BOILERPLATE_DATABASE_NAME="myapp"
BOILERPLATE_K8S_APP_NAME="api-java"
BOILERPLATE_ROOT_PACKAGE="com.renault.myapp"
BOILERPLATE_SONAR_KEY="boilerplate-springboot-java"
BOILERPLATE_GIT_REPO_URL="https://gitlabee.dt.renault.com/shared/boilerplate/api-springboot-java.git"

JAVA_RESERVED_WORDS=("abstract" "assert" "boolean" "break" "byte" "case" "catch" "char" "class" "const" \
"default" "do" "double" "else" "enum" "extends" "false" "final" "finally" "float" \
"for" "goto" "if" "implements" "import" "instanceof" "int" "interface" "long" "native" \
"new" "null" "package" "private" "protected" "public" "return" "short" "static" "strictfp" \
"super" "switch" "synchronized" "this" "throw" "throws" "transient" "true" "try" "void" \
"volatile" "while" "continue")

declare_heredoc USAGE <<-EOF
${COLOR_BOLD_BLACK}Usage:${COLOR_END}

    help, print this usage:
        ./${THIS_SCRIPT_NAME} -h

    bootstrap a project using params:
        ./${THIS_SCRIPT_NAME} [-q] <destProjectIRN> <destProjectSIA> <destGitRepoURL> [destProjectName destRootPackage destDatabaseName]
            -q                 Optional, Run quietly, no confirmation

            destProjectSIA     SIA (lowercase)
            destProjectIRN     IRN (only the numbers)
            destGitRepoURL     destination git repository URL (git or https), the default value of destProjectName/destDatabaseName/destRootPackage will be extracted from it

            destProjectName    Optional, destination project name, the default value is extracted from git repository URL
            destRootPackage    Optional, destination project root package, the default value is extracted from git repository URL
            destDatabaseName   Optional, destination project database name, the default value is extracted from git repository URL

        Example:
            ./${THIS_SCRIPT_NAME} pps 70002 https://gitlabee.dt.renault.com/irn-70002/pps-jira-client.git
            ./${THIS_SCRIPT_NAME} pps 70002 https://gitlabee.dt.renault.com/irn-70002/quality-sonar-adapter.git quality-sonar-adapter com.renault.quality.sonar sonar_adapter

    bootstrap a project using wizard:
        ./${THIS_SCRIPT_NAME}

${COLOR_BOLD_BLACK}Notes:${COLOR_END}
    Tested on Mac OSX, bash 3.2
EOF


### Functions

function replace () {
    echo -e "replace ${1} to ${2}"
    local from=$(escape_sed ${1})
    local to=$(escape_sed ${2})
    # in all sub folders except .git, do replacement only in the text files, not binary files
    find . \( -type d -name .git \) -prune -o -type f -exec grep -Iq . {} \; -print0 | xargs -0 sed -i '' -e "s/${from}/${to}/g"
}

function move_files() {
    local from=$(escape_sed ${boilerplateRootPackageDir})
    local to=$(escape_sed ${destRootPackageDir})
    toDir=$(echo ${1} | sed -e "s/${from}/${to}/g")
    mkdir -p $(dirname ${toDir})
    echo "mv ${1} ${toDir}"
    mv ${1} ${toDir}
}
export -f move_files

function normalize_package_name() {
    local packageName=$(eval eval "echo '$'${1}")
    for word in ${JAVA_RESERVED_WORDS[@]}; do
        packageName=$(echo ${packageName} | sed -e "s/\.${word}\./\.${word}_\./g")
    done
    eval "${1}='${packageName}'"
}


### parse_arguments
args_parse $# "$@" destProjectSIA destProjectIRN destGitRepoURL destProjectName destRootPackage destDatabaseName


print_header "Collect required info"
args_valid_or_read destProjectSIA '^[0-9a-z]{3,3}$' "SIA (lowercase, 3 chars)"
args_valid_or_read destProjectIRN '^[0-9]{5,5}$' "IRN (only the 5 digits)"
args_valid_or_read destGitRepoURL '^(https|git).+\.git$' "Destination git repository full URL when bootstrap project"

boilerplateProjectName=$(basename -s .git ${BOILERPLATE_GIT_REPO_URL})
defaultDestProjectName=$(basename -s .git ${destGitRepoURL})
args_valid_or_read destProjectName '^.+$' "Destination project name when bootstrap project" "${defaultDestProjectName}"

defaultDestRootPackage="com.renault.${destProjectName//[\-_]/.}"
normalize_package_name defaultDestRootPackage
args_valid_or_read destRootPackage '^.+$' "Destination project root package when bootstrap project" "${defaultDestRootPackage}"
normalize_package_name destRootPackage

defaultDestDatabaseName="${destProjectName//[\-]/_}"
args_valid_or_read destDatabaseName '^.+$' "Destination project database name when bootstrap project" "${defaultDestDatabaseName}"

export destRootPackageDir="${destRootPackage//\.//}"
export boilerplateRootPackageDir="${BOILERPLATE_ROOT_PACKAGE//\.//}"
destProjectPath="../${destProjectName}"
currentProjectName=$(basename $(pwd))

print_header "Confirm before continue"
if  [[ "${currentProjectName}" == "${boilerplateProjectName}" ]] && [[ "$(ls -A ${destProjectPath} 2> /dev/null)" ]] && [[ -s "${destProjectPath}" ]]; then
    echo -e "${COLOR_BOLD_RED}\nWARNING: the file or directory '${destProjectPath}' is not empty, these files will be deleted: "
    ls -lA ${destProjectPath}
    echo -e "${COLOR_END}"
fi
args_confirm destProjectSIA destProjectIRN destGitRepoURL boilerplateProjectName currentProjectName destProjectName destDatabaseName destRootPackage boilerplateRootPackageDir destRootPackageDir


if [[ "${currentProjectName}" == "${boilerplateProjectName}" ]]; then
    print_header "Rename current project directory from ${boilerplateProjectName} to ${destProjectName}"
    rm -fr "${destProjectPath}"
    stop_if_failed "ERROR: can't delete the directory '${destProjectPath}', verify the path or permission!"
    mv ../${currentProjectName} ../${destProjectName}
    stop_if_failed "ERROR: can't rename to the directory '${destProjectPath}', verify the path or permission!"
    cd "${destProjectPath}"
fi


print_header "Replace SIA/IRN/PackageName"
rm -fr .idea .gradle build out
replace "${BOILERPLATE_PROJECT_SIA}"  "${destProjectSIA}"
replace "${BOILERPLATE_PROJECT_IRN}"  "${destProjectIRN}"
replace "${boilerplateProjectName}"   "${destProjectName}"
replace "${BOILERPLATE_SONAR_KEY}"    "${destProjectName}"
replace "${BOILERPLATE_K8S_APP_NAME}" "${destProjectName}"


print_header "Correct package name, and move files to new package"
replace "${BOILERPLATE_ROOT_PACKAGE}"  "${destRootPackage}"
replace "${boilerplateRootPackageDir}" "${destRootPackageDir}"
find . -type d -path "*/${boilerplateRootPackageDir}" -print0 | xargs -0 -I {}  bash -c 'move_files "$@"' _ {}


### Database (shoud after package replacement, because the BOILERPLATE_DATABASE_NAME 'myapp' also contains by boilerplateRootPackage 'com.renault.myapp')
print_header "Replace database name"
replace "${BOILERPLATE_DATABASE_NAME}" "${destDatabaseName}"


print_header "Change origin and init commit"
currentGitRepoURL=$(git config --get remote.origin.url)
boilerplateGitRepoURLSubString='gitlabee.dt.renault.com/shared/boilerplate/api-springboot-java'
if [[ "${currentGitRepoURL}" == *"${boilerplateGitRepoURLSubString}"* ]]; then
    git remote set-url origin "${destGitRepoURL}"
    git remote -v
fi
rm -fr ${THIS_SCRIPT_NAME}
git checkout pull-from-boilerplate.sh
# Transfer used values to pull-from-boilerplate.sh
replace "<PLACEHOLDER_DEST_PROJECT_SIA>" "${destProjectSIA}"
replace "<PLACEHOLDER_DEST_PROJECT_IRN>" "${destProjectIRN}"
replace "<PLACEHOLDER_DEST_GIT_REPO_URL>" "${destGitRepoURL}"
replace "<PLACEHOLDER_DEST_PROJECT_NAME>" "${destProjectName}"
replace "<PLACEHOLDER_DEST_ROOT_PACKAGE>" "${destRootPackage}"
replace "<PLACEHOLDER_DEST_DATABASE_NAME>" "${destDatabaseName}"
git add -A
git commit -m "${destProjectName}: init commit by ${THIS_SCRIPT_NAME}"


print_header "Finished"
echo -e "the project ${COLOR_BOLD_BLACK}$(pwd)${COLOR_END} is ready now, you can push it to remote git repository with command: 'git push'"

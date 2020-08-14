#!/usr/bin/env bash

### Import common lib
source bash-base.sh


###  Constants
SRC_BOILERPLATE_REPO_URL="https://gitlabee.dt.renault.com/shared/boilerplate/api-springboot-java.git"
SRC_BOILERPLATE_BRANCH="develop"
SRC_BOILERPLATE_BOOTSTRAP_BRANCH="boilerplate_develop"
DEST_APP_BRANCH_MERGE_TO="feature/pump-from-boilerplate"

TAKE_THEIRS_WHEN_MERGE_CONFLICT=(\
"src/integTest/java/com/renault/quality/sonar/BaseDockerIT.java" \
"keycloak/boilerplate-oauth2-realm.json")

TAKE_OURS_WHEN_MERGE_CONFLICT=()

declare_heredoc USAGE <<-EOF
${COLOR_BOLD_BLACK}Usage:${COLOR_END}

    help, print this usage:
        ./${THIS_SCRIPT_NAME} -h

    pump from boilerplate using params:
        ./${THIS_SCRIPT_NAME} [-q] <destBaseBranch>
            -q                 Run quietly, no confirmation
            destBaseBranch     A branch ${DEST_APP_BRANCH_MERGE_TO} will be created, and the new changes of boilerplate will merge onto it. Please specific a base branch for it, the base branch must existed in origin. if not specified, the git default branch 'origin/HEAD' will be used.
        Example:
            ./${THIS_SCRIPT_NAME} integration

    pump from boilerplate using default parameter value:
        ./${THIS_SCRIPT_NAME}

${COLOR_BOLD_BLACK}Notes:${COLOR_END}
    Tested on Mac OSX, bash 3.2
EOF


### Functions

function resolve_conflicts_by_status() {
    local statusToProcess=${1}
    local processMethod=${2}
    local messageFormat=${3}

    files=$(git --no-pager diff --name-only --diff-filter=U)
    echo "${files}" | while read filePath; do
        statusActual=$(git status ${filePath})
        if $(grep -q "${statusToProcess}" <<< ${statusActual}); then
            printf "$(( ++counter )) ${messageFormat:-${statusToProcess}: }" ${filePath}
            eval "${processMethod} ${filePath}"
        fi
    done
    echo
}

function resolve_conflicts_take_theirs_by_list() {
    local statusToProcess=${1}

    files=$(git --no-pager diff --name-only --diff-filter=U)
    echo "${files}" | while read filePath; do
        statusActual=$(git status ${filePath})
        if $(grep -q "${statusToProcess}" <<< ${statusActual}); then
            for fileToTakeTheirs in ${TAKE_THEIRS_WHEN_MERGE_CONFLICT[@]}; do
                if [[ "${filePath}" == "${fileToTakeTheirs}" ]]; then
                    printf "$(( ++counter )) ${statusToProcess}: take theirs by list %s \n" ${filePath}
                    git checkout --theirs "${filePath}" 2>/dev/null
                    git add "${filePath}"
                fi
            done
        fi
    done
    echo
}

function resolve_conflicts_take_ours_by_list() {
    local statusToProcess=${1}

    files=$(git --no-pager diff --name-only --diff-filter=U)
    echo "${files}" | while read filePath; do
        statusActual=$(git status ${filePath})
        if $(grep -q "${statusToProcess}" <<< ${statusActual}); then
            for fileToTakeOurs in ${TAKE_OURS_WHEN_MERGE_CONFLICT[@]}; do
                if [[ "${filePath}" == "${fileToTakeOurs}" ]]; then
                    printf "$(( ++counter )) ${statusToProcess}: take ours by list %s \n" ${filePath}
                    git checkout --ours "${filePath}" 2>/dev/null
                    git add "${filePath}"
                fi
            done
        fi
    done
    echo
}


### parse_arguments
args_parse $# "$@" destBaseBranch


print_header "Collect required info"
if [[ -z ${destBaseBranch} ]]; then
    destBaseBranch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -z "${destBaseBranch}" ]]; then
        destBaseBranch="develop"
    fi
fi
strBranchesToSelect=$(git branch -r --list  'origin/*' | grep -v "feature\|hotfix\|origin/HEAD")
string_split_to_array $'\n' arrBranchesToSelect "${strBranchesToSelect}"
array_map arrBranchesToSelect arrBranchesToSelectCleaned "sed -e 's/*//' -e 's/^[[:space:]]*//' -e 's/^origin\///' | string_trim"
args_valid_or_select destBaseBranch arrBranchesToSelectCleaned "The base of merge request (normally it's develop or integration)"


print_header "Prepare git context"
git stash save &>/dev/null
git merge --abort 2>/dev/null


print_header "Confirm before continue"
git remote rm upstream  2>/dev/null
git remote add upstream "${SRC_BOILERPLATE_REPO_URL}"
git remote -v
git fetch upstream develop
git fetch origin "${destBaseBranch}"
changesToPumpFromBoilerplate=$(git --no-pager diff --name-only origin/${destBaseBranch}...upstream/develop)
if [[ -z "${changesToPumpFromBoilerplate}" ]]; then
    echo -e "\nNo changes to pump from boilerplate, exited.\n"
    exit 0
fi
mergeBase=$(git merge-base origin/${destBaseBranch} upstream/develop)
if [[ -z "${mergeBase}" ]]; then
    echo -e "\n${COLOR_BOLD_RED}Not found merge base, maybe lost git history of boilerplate in this project, \n this will be fixed automatically when this merge finished. ${COLOR_END}\n"
else
    echo -e "\nThe summery of changes to pump from boilerplate:\n"
    git --no-pager shortlog --no-merges upstream/develop --not ${mergeBase}
fi
args_confirm destBaseBranch


print_header "bootstrap boilerplate"
git checkout -B "${SRC_BOILERPLATE_BOOTSTRAP_BRANCH}" upstream/develop
#These are the values when bootstrap project, transferred by bootstrap-project.sh.
destProjectSIA="<PLACEHOLDER_DEST_PROJECT_SIA>"
destProjectIRN="<PLACEHOLDER_DEST_PROJECT_IRN>"
destGitRepoURL="<PLACEHOLDER_DEST_GIT_REPO_URL>"
destProjectName="<PLACEHOLDER_DEST_PROJECT_NAME>"
destRootPackage="<PLACEHOLDER_DEST_ROOT_PACKAGE>"
destDatabaseName="<PLACEHOLDER_DEST_DATABASE_NAME>"
./bootstrap-project.sh -q "${destProjectSIA}" "${destProjectIRN}" "${destGitRepoURL}" "${destProjectName}" "${destRootPackage}" "${destDatabaseName}"


print_header "Merge"
git checkout -B "${DEST_APP_BRANCH_MERGE_TO}" origin/${destBaseBranch}
git merge --allow-unrelated-histories --no-commit --no-ff -m "pump from boilerplate by ${THIS_SCRIPT_NAME}" "${SRC_BOILERPLATE_BOOTSTRAP_BRANCH}" &>/dev/null
if [[ $? -ne 0 ]]; then
    nbUnmergedFiles=$(git --no-pager diff --name-only --diff-filter=U | wc -l)
    if [[ "$nbUnmergedFiles" -gt 0 ]] ; then
          printf "${COLOR_BOLD_RED}\nThere are %s conflicts totally. ${COLOR_END}\n\n" ${nbUnmergedFiles}
          resolve_conflicts_by_status "deleted by us" "git rm"
          resolve_conflicts_by_status "added by us" "git rm" "deleted by them: " # Yes, it is really a "deleted by them", not "added by us"
          resolve_conflicts_by_status "added by them" "git add" "added by them: add '%s' \n"

          resolve_conflicts_take_theirs_by_list "both modified"
          resolve_conflicts_take_theirs_by_list "both added"

          resolve_conflicts_take_ours_by_list "both modified"
          resolve_conflicts_take_ours_by_list "both added"
    fi
    nbUnmergedFiles=$(git --no-pager diff --name-only --diff-filter=U | wc -l)
    if [[ "$nbUnmergedFiles" -eq 0 ]] ; then
        git merge --continue
        printf "\nAll conflicts have been resolved,\n"
    else
        git status
        printf "${COLOR_BOLD_RED}\nThere are %s conflicts to resolve manually, ${COLOR_END}\nafter resolved them and committed, " ${nbUnmergedFiles}
    fi
fi
echo -e "you need to push this branch '${DEST_APP_BRANCH_MERGE_TO}' to remote, and create a merge request.\n\n"
git remote rm upstream 2>/dev/null

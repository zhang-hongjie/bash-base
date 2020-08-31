#!/usr/bin/env bash

source src/bash-base.sh

shellScriptFile="src/bash-base.sh"
referencesMarkdownFile="docs/references.md"
referencesManPageFile="bash-bash.1"

# format script code
docker run --rm -v "$(pwd):/src" -w /src mvdan/shfmt -l -w "${shellScriptFile}"

# lint script comment
doc_lint_script_comment "${shellScriptFile}"
stop_if_failed 'the comment is not valid'

# generate references markdown from script comment
doc_comment_to_markdown "${shellScriptFile}" "${referencesMarkdownFile}"

# Use pandoc to generate man page from markdown, use man section 1
docker run --rm --volume "$(pwd):/data" --user "$(id -u):$(id -g)" pandoc/core:2.10 \
	-f markdown \
	-t man \
	--standalone \
	--variable=section:1 \
	--variable=header:"bash-base functions reference" \
	"${referencesMarkdownFile}" \
	-o "${referencesManPageFile}"

# print the result of man page
man "${referencesManPageFile}"

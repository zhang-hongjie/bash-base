#!/usr/bin/env bash

source src/bash-base.sh

# Extract shell comment to reference markdown
grep '^\s*#' src/bash-base.sh |
string_trim |
string_replace_regex '^#' '' |
string_replace_regex '!.*' '' |
string_trim |
string_replace_regex '@NAME' "${SED_NEW_LINE}---${SED_NEW_LINE}@NAME" |
string_replace_regex '@' "${SED_NEW_LINE}##### " |
cat > docs/reference.md

# Use pandoc to generate man page from markdown, use man section 1
docker run --rm --volume "$(pwd):/data" --user `id -u`:`id -g` pandoc/core:2.10 -f markdown -t man --standalone docs/reference.md --variable=section:1 --variable=header:'bash-base man page' -o man/bash-base.1
man man/bash-base.1

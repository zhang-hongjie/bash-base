#!/usr/bin/env bash

installDir=~/.bash-base
binDir=/usr/local/bin
manDir=/usr/local/share/man/man1

if [[ "$1" == "uninstall" ]]; then

	rm -r "${installDir}" && echo "# removed ${installDir}" >&2
	rm ${binDir}/bash-base* && echo "# removed ${binDir}/bash-base*" >&2
	rm ${manDir}/bash-base* && echo "# removed ${manDir}/bash-base*" >&2

else

	version=${1}
	if [[ -z ${version} || ${version} == "latest" ]]; then
		latest=$(basename "$(curl -fs -o/dev/null -w '%{redirect_url}' https://github.com/zhang-hongjie/bash-base/releases/latest)")
		version=${latest}
	fi

	installDir=${installDir}/${version}

	if [[ ! -f ${installDir}/src/bash-base.sh ]]; then
		echo "# version to install: ${version}" >&2

		mkdir -p "${installDir}"
		cd "${installDir}" || exit

		if ! wget --no-check-certificate https://github.com/zhang-hongjie/bash-base/archive/"${version}".tar.gz; then
			echo "# Download the version '${version}' failed" >&2
			exit 1
		fi
		tar xzf "${version}".tar.gz -C ./ --strip-components 1

		if [[ "$2" == "verify" ]]; then
			echo -e "# Verifying the installation (docker required):" >&2
			docker run --rm -v "$(pwd)":/bash-base -w /bash-base shellspec/shellspec:master-kcov --shell bash spec/*.sh >&2
		fi

		cat "${installDir}"/src/bash-base.sh

		ln -fs "${installDir}"/src/bash-base.sh ${binDir}/bash-base."${version}"
		ln -fs "${installDir}"/man/bash-base.1 ${manDir}/bash-base."${version}".1
		cat >&2 <<-EOF
			# the man page of this version: 'man bash-base.${version}', and you can import this version in one line in your script:
			# source bash-base.v2.3.3 2>/dev/null || source <(curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- ${version})

		EOF

		if [[ -n "${latest}" ]]; then
			ln -fs "${installDir}"/src/bash-base.sh ${binDir}/bash-base
			ln -fs "${installDir}"/man/bash-base.1 ${manDir}/bash-base.1
			cat >&2 <<-EOF
				# if you want always to use the latest version, the man page is: 'man bash-base', and import like this:
				# source bash-base 2>/dev/null || source <(curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash)
				# this way, your script will access github to check whether a newer version published during every time it launched.
				# if you don't like this behavior, you can specify a fixed version to use in your script.

			EOF
		fi

		echo -e "# Install successfully." >&2
	fi

fi

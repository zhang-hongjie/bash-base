#!/usr/bin/env bash

installDir=~/.bash-base
binDir=/usr/local/bin
manDir=/usr/local/share/man/man1

if [[ "$1" == "uninstall" ]]; then

	rm -r "${installDir}" && echo "removed ${installDir}"
	rm ${binDir}/bash-base* && echo "removed ${binDir}/bash-base*"
	rm ${manDir}/bash-base* && echo "removed ${manDir}/bash-base*"

else

	version=${1}
	if [[ -z ${version} || ${version} == "latest" ]]; then
	  latest=$(basename "$(curl -fs -o/dev/null -w '%{redirect_url}' https://github.com/zhang-hongjie/bash-base/releases/latest)")
	  version=${latest}
	fi

  installDir=${installDir}/${version}

	if [[ ! -f ${installDir}/src/bash-base.sh ]]; then
		echo "version to install: ${version}"

		mkdir -p "${installDir}"
		cd "${installDir}" || exit

		if ! $(wget --no-check-certificate https://github.com/zhang-hongjie/bash-base/archive/"${version}".tar.gz); then
		    echo "Download the version '${version}' failed"
		    exit 1
		fi
		tar xzf "${version}".tar.gz -C ./ --strip-components 1

    echo -e "\nFiles in $(pwd):$(ls -la)"

    if [[ "$2" == "verify" ]]; then
      echo -e "\nVerifying the installation (docker required):"
      docker run -it --rm -v "$(pwd)":/bash-base -w /bash-base shellspec/shellspec:master-kcov --shell bash spec/*.sh
    fi

		ln -fs "${installDir}"/src/bash-base.sh ${binDir}/bash-base."${version}"
		ln -fs "${installDir}"/man/bash-base.1 ${manDir}/bash-base."${version}".1

		if [[ -n "${latest}" ]]; then
			ln -fs "${installDir}"/src/bash-base.sh ${binDir}/bash-base
			ln -fs "${installDir}"/man/bash-base.1 ${manDir}/bash-base.1
		fi

    echo -e "\nInstall successfully."
#		echo "Import this version by: 'source bash-base.${version}', or 'source bash-base' if you want always the latest version."
		echo "The man page of this version: 'man bash-base.${version}', or 'man bash-base' if you want the latest version."
	fi

	source bash-base."${version}"

fi

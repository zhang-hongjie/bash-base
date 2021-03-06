# This project has been moved to [renault digital](https://github.com/renault-digital/bash-base). 

# Welcome to [bash-base](https://zhang-hongjie.github.io/bash-base)

[![License](https://img.shields.io/github/license/zhang-hongjie/bash-base.svg)](https://github.com/zhang-hongjie/bash-base/blob/master/LICENSE)
[![GitHub top language](https://img.shields.io/github/languages/top/zhang-hongjie/bash-base.svg)](https://github.com/zhang-hongjie/bash-base/search?l=Shell)
[![codecov](https://codecov.io/gh/zhang-hongjie/bash-base/branch/master/graph/badge.svg)](https://codecov.io/gh/zhang-hongjie/bash-base)
[![GitHub Actions Status](https://img.shields.io/github/workflow/status/zhang-hongjie/bash-base/cicd?label=GithubActions)](https://github.com/zhang-hongjie/bash-base/actions)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![GitHub release](https://img.shields.io/github/release/zhang-hongjie/bash-base.svg)](https://github.com/zhang-hongjie/bash-base/releases/latest)
[![npm package](https://img.shields.io/npm/v/bash-base.svg)](https://www.npmjs.com/package/bash-base)
[![Docker Cloud Build Status](https://img.shields.io/docker/pulls/zhj2074/bash-base.svg)](https://hub.docker.com/r/zhj2074/bash-base)
![GitHub commits since latest release](https://img.shields.io/github/commits-since/zhang-hongjie/bash-base/latest)


## What's bash-base?

A common lib for creating bash script easily like other program language.

- Rich functions to operate array/list/set/string/arguments/reflect/..., the functions can be used in console or script
- Just call bash-base function by name in your script, like other programing language, no need anymore to search "how to ... in bash"
- Parse and validation arguments easily & flexible, automatically generate help usage for your script, focus your script only on the business logical
- Make your script more compact & readability
- Available on github/npm/dockerhub


## Latest Update
See [CHANGELOG.md](CHANGELOG.md)


## How to use

### Get from github

#### Import bash-base directly from github during every execution

Simply write in console or script:

If to import latest version:
```
source <(curl -fsSL https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/src/bash-base.sh)
or
eval "$(curl -fsSL https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/src/bash-base.sh)"
```

If to import specific version:
```
source <(curl -fsSL https://raw.githubusercontent.com/zhang-hongjie/bash-base/v2.3.1/src/bash-base.sh)
or
eval "$(curl -fsSL https://raw.githubusercontent.com/zhang-hongjie/bash-base/v2.3.1/src/bash-base.sh)
```

Verify the import in console:
```
string_trim ' hello '
```

###### Notes
this way, your script need to access github when each time it launched.

#### Import bash-base using install.sh

The directory installed is `~/.bash-base`.

##### source or install the specific version in console or shell script:

- the man page of version v2.3.3:  `man bash-base.${version}`, 
- you can import this version in one line in your script:
```
source bash-base.v2.3.3 2>/dev/null || curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- v2.3.3"
```


##### but if you want always the latest version, source or install the latest version in console or shell script:
- the man page is: `man bash-base`,
- and import like this:
```
source bash-base 2>/dev/null || curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash
or
source bash-base 2>/dev/null || curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- latest
```

###### Notes:
this way, your script will access github to check whether a newer version published during every time it launched.
if you don't like this behavior, you need to specify a fixed version to use in your script.


##### Using param `verify` to check all functions of bash-base is compatible with your environment:
```
source bash-base 2>/dev/null || curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- latest verify
or
source bash-base 2>/dev/null || curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- v2.3.3 verify
```

##### To uninstall all versions of bash-base from your system:
```
curl -o- -L https://raw.githubusercontent.com/zhang-hongjie/bash-base/master/scripts/install.sh | bash -s -- uninstall
```

### Install from NPM

See [npm repackage](https://www.npmjs.com/package/bash-base)
```
npm install -g bash-base
```

verify the installation
```
man bash-base
```

or one line in your script:
```
# import, and install bash-base from npmjs only if not installed:
source bash-base 2>/dev/null || npm install -g bash-base && source bash-base
```

To uninstall:
```
npm uninstall -g bash-base
```

### Install from docker

See [docker hub](https://hub.docker.com/r/zhj2074/bash-base)

```
source <(docker run --rm zhj2074/bash-base)
``` 

Or specific a fixed version

```
source <(docker run --rm zhj2074/bash-base:2.3.2)
```

### Download only

download a specific version:

- from NPM: https://registry.npmjs.org/bash-base/-/bash-base-2.3.2.tgz
- from github: https://github.com/zhang-hongjie/bash-base/archive/v2.3.3.tar.gz

### Example
See [example](example) folder

### Reference
See [reference](docs/references.md)

### Specification
See [spec](spec) folder

## Contributing
See [How to contribute](CONTRIBUTING.md)

## License
[MIT](https://opensource.org/licenses/MIT).

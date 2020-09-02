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

A common lib for creating bash script easily.


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

### Install from NPM

See [npm repackage](https://www.npmjs.com/package/bash-base)
```
npm install -g bash-base
```

verify the installation
```
man bash-base
```

or simply write in your script:
```
# install bash-base from npmjs only if not installed:
bash-base 2>/dev/null || npm install -g bash-base

# import it
source bash-base
```

### Install from docker

See [docker hub](https://hub.docker.com/r/zhj2074/bash-base)

```
docker pull zhj2074/bash-base:latest
``` 

Or run directly

```
docker run -it zhj2074/bash-base:latest
```

### Example
See [example](example) folder

### Reference
See [reference](docs/references.md)

## Contributing
See [How to contribute](CONTRIBUTING.md)

## License
[MIT](https://opensource.org/licenses/MIT).

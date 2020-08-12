# bash-base

[![codecov](https://codecov.io/gh/zhang-hongjie/bash-base/branch/master/graph/badge.svg)](https://codecov.io/gh/zhang-hongjie/bash-base)

## 1. Semantic Versioning




https://semver.org/lang/zh-CN/

Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards compatible manner, and
- PATCH version when you make backwards compatible bug fixes.


Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

#### Why Use Semantic Versioning?
This is not a new or revolutionary idea. In fact, you probably do something close to this already. The problem is that “close” isn’t good enough. Without compliance to some sort of formal specification, version numbers are essentially useless for dependency management. By giving a name and clear definition to the above ideas, it becomes easy to communicate your intentions to the users of your software. Once these intentions are clear, flexible (but not too flexible) dependency specifications can finally be made.

A simple example will demonstrate how Semantic Versioning can make dependency hell a thing of the past. Consider a library called “Firetruck.” It requires a Semantically Versioned package named “Ladder.” At the time that Firetruck is created, Ladder is at version 3.1.0. Since Firetruck uses some functionality that was first introduced in 3.1.0, you can safely specify the Ladder dependency as greater than or equal to 3.1.0 but less than 4.0.0. Now, when Ladder version 3.1.1 and 3.2.0 become available, you can release them to your package management system and know that they will be compatible with existing dependent software.

As a responsible developer you will, of course, want to verify that any package upgrades function as advertised. The real world is a messy place; there’s nothing we can do about that but be vigilant. What you can do is let Semantic Versioning provide you with a sane way to release and upgrade packages without having to roll new versions of dependent packages, saving you time and hassle.

If all of this sounds desirable, all you need to do to start using Semantic Versioning is to declare that you are doing so and then follow the rules. Link to this website from your README so others know the rules and can benefit from them.





## 2. Conventional commits (semantic commit)



https://www.conventionalcommits.org/en/v1.0.0/

The commit contains the following structural elements, to communicate intent to the consumers of your library:

1. `fix`: a commit of the type fix patches a bug in your codebase (this correlates with <mark>PATCH</mark> in semantic versioning).

2. `feat`: a commit of the type feat introduces a new feature to the codebase (this correlates with <mark>MINOR</mark> in semantic versioning).

3. `BREAKING CHANGE`: a commit that has a footer BREAKING CHANGE:, or appends a `!` after the type/scope, introduces a breaking API change (correlating with <mark>MAJOR</mark> in semantic versioning). A BREAKING CHANGE can be part of commits of any type.

4. types other than `fix:` and `feat:` are allowed, for example <mark>@commitlint/config-conventional (based on the the Angular convention)</mark> recommends `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, and others.

5. footers other than `BREAKING CHANGE: <description>` may be provided and follow a convention similar to <mark>git trailer</mark> format.

**Additional types are not mandated by the Conventional Commits specification, and have no implicit effect in semantic versioning (unless they include a BREAKING CHANGE).**

A scope may be provided to a commit’s type, to provide additional contextual information and is contained within parenthesis, e.g., `feat(parser): add ability to parse arrays`.

https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines

Revert
If the commit reverts a previous commit, it should begin with revert: , followed by the header of the reverted commit. In the body it should say: This reverts commit <hash>., where the hash is the SHA of the commit being reverted.

#### Type
Must be one of the following:

- feat: 
    - A new feature, 
    - (new feature for the user, not a new feature for build script)
    - to indicate a new feature (MINOR) ex. v0.1.0
    - Add a new feature to the codebase (MINOR in semantic versioning).
    - is used to identify production changes related to new backward-compatible abilities or functionality.
    
- fix: 
    - A bug fix, 
    - (bug fix for the user, not a fix to a build script)
    - to indicate a bug fix (PATCH) ex . v0.0.1
    - Fix a bug (equivalent to a PATCH in Semantic Versioning).
    - is used to identify production changes related to backward-compatible bug fixes.

- docs: 
    - Documentation only changes, 
    - (changes to the documentation)
    - for updates to the documentation
    - is used to identify documentation changes related to the project - whether intended externally for the end users (in case of a library) or internally for the developers.
    
- style: 
    - Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc), 
    - (formatting, missing semi colons, etc; no production code change)
    - Code style change (semicolon, indentation...)
    - s used to identify development changes related to styling the codebase, regardless of the meaning - such as indentations, semi-colons, quotes, trailing commas and so on.
    
- refactor: 
    - Refactor code without changing public API.
    - A code change that neither fixes a bug nor adds a feature, 
    - (refactoring production code, eg. renaming a variable)
    - is used to identify development changes related to modifying the codebase, which neither adds a feature nor fixes a bug - such as removing redundant code, simplifying the code, renaming variables, etc.

- perf: 
    - A code change that improves performance
    - is used to identify production changes related to backward-compatible performance improvements.

- test: 
    - Adding missing or correcting existing tests, 
    - (adding missing tests, refactoring tests; no production code change)
    - Add test to an existing feature.
    - is used to identify development changes related to tests - such as refactoring existing tests or adding new tests.
    
- chore(now is build):
    - Update something without impacting the user (ex: bump a dependency in package.json).
    - Changes to the build process or auxiliary tools and libraries such as documentation generation, 
    - (updating grunt tasks etc; no production code change)
    - for updates that do not require a version bump (.gitignore, comments, etc.)
    - is used to identify development changes related to the build system (involving scripts, configurations or tools) and package dependencies.

- ci 
    - type is used to identify development changes related to the continuous integration and deployment system - involving scripts, configurations or tools.


BREAKING CHANGE — regardless of type, indicates a Major release (MAJOR) ex. v1.0.0



#### Scope
The scope could be anything specifying place of the commit change. For example $location, $browser, $compile, $rootScope, ngHref, ngClick, ngView, etc...

You can use * when the change affects more than a single scope.

#### Subject
The subject contains succinct description of the change:

use the imperative, present tense: "change" not "changed" nor "changes"
don't capitalize first letter
no dot (.) at the end
#### Body
Just as in the subject, use the imperative, present tense: "change" not "changed" nor "changes". The body should include the motivation for the change and contrast this with previous behavior.

#### Footer
The footer should contain any information about Breaking Changes and is also the place to reference GitHub issues that this commit closes.

`Breaking Changes` should start with the word `BREAKING CHANGE`: with a space or two newlines. The rest of the commit message is then used for this.

#### Why Use Conventional Commits
- Browsing History
Git provides us the power to browse the repository commit history - so we’re able to figure out what actually happened, who contributed and so on.

Let’s see how the conventions might ease up the browsing:

git log --oneline --grep "^feat\|^fix\|^perf"
We use the commit message type to filter out and so showing only the production changes (all of the messages that start with feat, fix or perf).

Another example:

git log --oneline --grep "^feat" | wc -l
We just print the total amount of feat changes.

The point is - the commit message format is very structured, what effectively allows us relying on that when scanning or filtering the commit history.

Namely, a better velocity! 💪🏻

- Automatically generating CHANGELOGs.
- Automatically determining a semantic version bump (based on the types of commits landed).
- Communicating the nature of changes to teammates, the public, and other stakeholders.
- Triggering build and publish processes.
- Making it easier for people to contribute to your projects, by allowing them to explore a more structured commit history.







## 3. Tools generat commit



### 3.0 Commitizen python

https://github.com/commitizen-tools/commitizen

commitizen-tools/commitizen: Create committing rules for projects auto bump versions and auto changelog generation

### 3.1 Commitizen node



http://commitizen.github.io/cz-cli/




Commitizen is a command line tool that helps format commit messages with a series of prompts that are used to generate a commit message. This tool can be installed globally with

    npm install commitizen -g
Additionally, this should be specified as a dev dependency in package.json

    npm init
    npm install commitizen --save-dev
Now, instead of committing with

    git commit
we use

    git cz
    
For our project we decided on using the cz-conventional-changelog, and we should also save this as a dev dependency.

    npm install cz-conventional-changelog --save-dev
    
    
Next we set up the adapter in package.json with

    commitizen init cz-conventional-changelog --save-dev --save-exact
result:
adds the config.commitizen key to the root of your package.json as shown here:
```
  "config": {
    "commitizen": {
      "path": "cz-conventional-changelog"
    }
  }
```
Or
Create a .czrc file in your home directory, with path referring to the preferred, globally installed, commitizen adapter

    echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
result:
```
{
  "path": "cz-conventional-changelog"
}
```



The format for cz-conventional-changelog is

    type(scope): JIRA-Ticket - Short description
    
    
    
##### commitizen global *Nix

```
$ npm i -g commitizen cz-conventional-changelog
$ echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc; 创造.czrc
$ cd non-node-git-repo
$ touch foo
git cz -a
```

In the above, if you used yarn to global install instead:

    yarn global add commitizen cz-conventional-changelog
Just remember to add yarn globals to your path:

    export PATH="$(yarn global bin):$PATH"
To make this easier to use you can alias a git commit command for example:

    alias gc='git cz -a'
If you are using WSL in Windows use wsltty as a terminal instead of the default to see emojis (among other things) in the terminal.

 

### 3.2 Intellij


https://plugins.jetbrains.com/plugin/9861-git-commit-template

49.8k
4.84





https://plugins.jetbrains.com/plugin/13389-conventional-commit
https://github.com/lppedd/idea-conventional-commit

8.1k
4.7





## 4. Tools valid commit message



### 4.1 Commitlint


https://dev.bleacherreport.com/how-we-use-commitizen-to-clean-up-commit-messages-a16790dcd2fd



Create a package.json if needed

    npm init

Install and configure if needed

    npm install --save-dev @commitlint/{cli,config-conventional}
    echo "module.exports = {extends: ['@commitlint/config-conventional']};" > commitlint.config.js

Test

    echo "abc" | commitlint





### 4.2 commitsar



https://github.com/unoplatform/uno/blob/master/.github/workflows/conventional-commits.yml

https://commitsar.tech/docs/usage/github

https://github.com/aevea/commitsar


#### GoBinaries

Running using https://gobinaries.com/

    curl -sf https://gobinaries.com/aevea/commitsar | sh
Or a specific version:

    curl -sf https://gobinaries.com/aevea/commitsar[@VERSION] | sh






https://gobinaries.com/binary/github.com/aevea/commitsar?os=windows&arch=386&version=v0.15.0
  
  
  
  
  
  
  
  
  
  

#### Binary

    - curl -L -O https://github.com/aevea/commitsar/releases/download/v0.15.0/commitsar_0.15.0_Darwin_x86_64.tar.gz
    - tar -xzf commitsar_0.15.0_Darwin_x86_64.tar.gz
    - ./commitsar



### 4.3 python Gitlint


Gitlint is a git commit message linter written in python: it checks your commit messages for style.
https://jorisroovers.com/gitlint/





## 5 commit message -> generate changelog



https://github.com/conventional-changelog/conventional-changelog

https://github.com/axetroy/vscode-changelog-generator


## 6. commit message -> release (change version automatically)



### 6.1 semantic-release

https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/README.md#ci-configurations


https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/travis.md



https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/travis.md

https://github.com/semantic-release/github





### 6.2 semantic-release plugins

https://semantic-release.gitbook.io/semantic-release/extending/plugins-list


#### 6.2.1 semantic-release Official plugins

- @semantic-release/commit-analyzer
    - **analyzeCommits**: Determine the type of release by analyzing commits with conventional-changelog
    
<mark>Note: this is already part of semantic-release and does not have to be installed separately</mark>



- @semantic-release/release-notes-generator
    - **generateNotes**: Generate release notes for the commits added since the last release with conventional-changelog

<mark>Note: this is already part of semantic-release and does not have to be installed separately</mark>



- @semantic-release/github
    - **verifyConditions**: Verify the presence and the validity of the GitHub authentication and release configuration
    - **publish**: Publish a GitHub release
    - **success**: Add a comment to GitHub issues and pull requests resolved in the release
    - **fail**: Open a GitHub issue when a release fails

<mark>Note: this is already part of semantic-release and does not have to be installed separately</mark>

- @semantic-release/npm
    - **verifyConditions**: Verify the presence and the validity of the npm authentication and release configuration
    - **prepare**: Update the package.json version and create the npm package tarball
    - **publish**: Publish the package on the npm registry
    
<mark>Note: this is already part of semantic-release and does not have to be installed separately</mark>

- @semantic-release/gitlab
    - **verifyConditions**: Verify the presence and the validity of the GitLab authentication and release configuration
    - **publish**: Publish a GitLab release

- @semantic-release/git
    - **verifyConditions**: Verify the presence and the validity of the Git authentication and release configuration
    - **prepare**: Push a release commit and tag, including configurable files

- @semantic-release/changelog
    - **verifyConditions**: Verify the presence and the validity of the configuration
    - **prepare**: Create or update the changelog file in the local project repository

- @semantic-release/exec
    - **verifyConditions**: Execute a shell command to verify if the release should happen
    - **analyzeCommits**: Execute a shell command to determine the type of release
    - **verifyRelease**: Execute a shell command to verifying a release that was determined before and is about to be published
    - **generateNotes**: Execute a shell command to generate the release note
    - **prepare**: Execute a shell command to prepare the release
    - **publish**: Execute a shell command to publish the release
    - **success**: Execute a shell command to notify of a new release
    - **fail**: Execute a shell command to notify of a failed release

- @semantic-release/apm
    - **verifyConditions**: Verify the presence of the ATOM_ACCESS_TOKEN environment variable and the apm CLI
    - **prepare**: Update the package.json version with npm version
    - **publish**: Publish the Atom package

#### 6.2.2 semantic-release Community plugins

- maven-semantic-release
    - **verifyConditions**: Verifies that the pom.xml file and other files exist and are setup to allow releases
    - **verifyRelease**: Checks and warns (does not error by default) if the version numbers found on maven central and within the Git project differ by quite a bit
    - **prepare**: Changes the version number in the pom.xml (or all pom.xml files in maven projects with multiple pom.xml files) and optionally creates a commit with this version number and pushes it to master
    - **publish**: Runs mvn deploy to deploy to maven central and optionally will update to next snapshot version and merge changes to development branch


- gradle-semantic-release
    - **verifyConditions**: Verify that project has a Gradle wrapper script, and build.gradle contains a task to publish artifacts.
    - **prepare**: Changes the version number in the gradle.properties
    - **publish**: Triggers Gradle to publish artifacts.



### 6.3 semantic-release configuration

https://semantic-release.gitbook.io/semantic-release/usage/configuration

semantic-release configuration consists of:
- Git repository (**URL** and options **release branches** and **tag format**)
- Plugins declaration and options
- Run mode (debug, dry run and local (no CI))

`Additionally, metadata of Git tags generated by semantic-release can be customized via standard Git environment variables.`


#### 6.3.1 Configuration file
semantic-release’s options, mode and plugins can be set via either:
- A **.releaserc** file, written in YAML or JSON, with optional extensions: .yaml/.yml/.json/.js
- A **release.config.js** file that exports an object
- A **release** key in the project's **package.json** file
- Alternatively, some options can be set via CLI arguments.
    - Note: CLI arguments take precedence over options configured in the configuration file.
    - Note: Plugin options cannot be defined via CLI arguments and must be defined in the configuration file.


#### 6.3.2 Options

##### 6.3.2.1 branches

Type: Array, String, Object

Default: 
```
[
    '+([0-9])?(.{+([0-9]),x}).x', 
    'master', 
    'next', 
    'next-major', 
    {name: 'beta', prerelease: true}, 
    {name: 'alpha', prerelease: true}
]
```
CLI arguments: --branches

The branches on which releases should happen. By default semantic-release will release:
- regular releases to the **default distribution channel** from **the branch master**
- regular releases to a **distribution channel matching the branch name** from **any existing branch with a name matching a maintenance release range (N.N.x or N.x.x or N.x with N being a number)**
- regular releases to the **next distribution channel** from **the branch next** if it exists
- regular releases  to the **next-major distribution channel** from **the branch next-major** if it exists
- prereleases to the **beta distribution channel** from **the branch beta** if it exists
- prereleases to the **alpha distribution channel** from **the branch alpha** if it exists

Note: If your repository does not have a release branch, then semantic-release will fail with an ERELEASEBRANCHES error message. If you are using the default configuration, you can fix this error by pushing a master branch.

Note: Once semantic-release is configured, any user with the permission to push commits on one of those branches will be able to publish a release. It is recommended to protect those branches, for example with GitHub protected branches.
See Workflow configuration for more details.




##### 6.3.2.2 plugins

Type: Array

Default: 
```
[
    '@semantic-release/commit-analyzer', 
    '@semantic-release/release-notes-generator', 
    '@semantic-release/npm', 
    '@semantic-release/github'
]
```

CLI arguments: -p, --plugins

Define the list of plugins to use. Plugins will run in series, in the order defined, for each steps if they implement it.

Plugins configuration can defined by wrapping the name and an options object in an array.
See Plugins configuration for more details.



##### 6.3.2.3 dryRun

Type: Boolean

 Default: false if running in a CI environment, true otherwise
 
 CLI arguments: -d, --dry-run
 
The objective of the dry-run mode is to get a preview of the pending release. Dry-run mode skips the following steps: prepare, publish, success and fail. In addition to this it prints the next version and release notes to the console.

Note: The Dry-run mode verifies the repository push permission, even though nothing will be pushed. The verification is done to help user to figure out potential configuration issues.

##### 6.3.2.4 ci

Type: Boolean

 Default: true
 
 CLI arguments: --ci / --no-ci
 
Set to false to skip Continuous Integration environment verifications. This allows for making releases from a local machine.

Note: The CLI arguments --no-ci is equivalent to --ci false.

##### 6.3.2.5 debug

Type: Boolean

 Default: false
 
 CLI argument: --debug
 
Output debugging information. This can also be enabled by setting the DEBUG environment variable to semantic-release:*.

Note: The debug is used only supported via CLI argument. To enable debug mode from the JS API use require('debug').enable('semantic-release:*').



#### 6.3.3 Existing version tags

semantic-release uses Git tags to determine the commits added since the last release. If a release has been published before setting up semantic-release you must make sure the most recent commit included in the last published release is in the release branches history and is tagged with the version released, formatted according to the tag format configured (defaults to vx.y.z).

If the previous releases were published with npm publish this should already be the case.
For example, if your release branch is master, the last release published on your project is 1.1.0 and the last commit included has the sha 1234567, you must make sure this commit is in master history and is tagged with v1.1.0.

```
# Make sure the commit 1234567 is in the release branch history
$ git branch --contains 1234567

# If the commit is not in the branch history it means that either:
# - you use a different branch than the one your release from before
# - or the commit sha has been rewritten (with git rebase)
# In both cases you need to configure your repository to have the last release commit in the history of the release branch

# List the tags for the commit 1234567
$ git tag --contains 1234567

# If v1.1.0 is not in the list you add it with
$ git tag v1.1.0 1234567
$ git push origin v1.1.0
```

### 6.4 Using semantic-release with GitHub Actions

https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/github-actions.md



#### 6.4.1 Environment variables
The Authentication environment variables can be configured with Secret Variables.

In this example an NPM_TOKEN is required to publish a package to the npm registry. GitHub Actions automatically populate a GITHUB_TOKEN environment variable which can be used in Workflows.

#### 6.4.2 Node project configuration
GitHub Actions support Workflows, allowing to run tests on multiple Node versions and publish a release only when all test pass.

Note: The publish pipeline must run on Node version >= 10.18.

##### .github/workflows/release.yml configuration for Node projects

The following is a minimal configuration for semantic-release with a build running on Node 12 when a new commit is pushed to a master branch. See Configuring a Workflow for additional configuration options.
```
name: Release
on:
  push:
    branches:
      - master
jobs:
  release:
    name: Release
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout
        uses: actions/checkout@v1
      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: 12
      - name: Install dependencies
        run: npm ci
      - name: Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npx semantic-release
```
##### Pushing package.json changes to a master branch
To keep package.json updated in the master branch, @semantic-release/git plugin can be used.

Note: Automatically populated GITHUB_TOKEN cannot be used if branch protection is enabled for the target branch. It is not advised to mitigate this limitation by overriding an automatically populated GITHUB_TOKEN variable with a Personal Access Tokens, as it poses a security risk. Since Secret Variables are available for Workflows triggered by any branch, it becomes a potential vector of attack, where a Workflow triggered from a non-protected branch can expose and use a token with elevated permissions, yielding branch protection insignificant. One can use Personal Access Tokens in trusted environments, where all developers should have the ability to perform administrative actions in the given repository and branch protection is enabled solely for convenience purposes, to remind about required reviews or CI checks.

##### Trigger semantic-release on demand
- Using GUI:

You can use Manual Triggers for GitHub Actions.

- Using HTTP:

Use repository_dispatch event to have control on when to generate a release by making an HTTP request, e.g.:
```
name: Release
on:
  repository_dispatch:
    types: [semantic-release]
jobs:
# ...
```
To trigger a release, call (with a Personal Access Tokens stored in GITHUB_TOKEN environment variable):
```
$ curl -v -H "Accept: application/vnd.github.everest-preview+json" -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/[org-name-or-username]/[repository]/dispatches -d '{ "event_type": "semantic-release" }'
```





### 6.5 semantic-release Example

https://www.wizeline.com/blog-continuous-deployment-with-semantic-release-and-github-actions/

#### 6.5.1 Semantic Release
Semantic Release is an Open-Source Software tool for automatically versioning your software with Semantic Versions based on your Git commit messages. It then releases/deploys the new version to the channel(s) you specify, for example, GitHub Release, NPM, PyPI, etc.


Since Semantic Release also generates release notes and maintains a CHANGELOG.md for you, adding quality git commit messages — including a detailed body — becomes increasingly valuable.

To set up Semantic Release in your project, you’ll first need to install semantic-release and its core plugins:
```
npm i -D semantic-release \
@semantic-release/commit-analyzer \
@semantic-release/release-notes-generator \
@semantic-release/npm \
@semantic-release/github \
@semantic-release/changelog \
@semantic-release/git
```
Next, inside your package.json specify the list of files that should be bundled up and distributed as part of the release. If you don’t want the package to be published to NPM make sure you also add "private": true.
```
"private": true,
"files": [
  "index.js",
  "CHANGELOG.md",
  "package.json",
  "package-lock.json"
]
```
Finally, create a `release.config.js` in your **repository root** to instruct Semantic Release on how to release our software.
```
module.exports = {
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    ["@semantic-release/npm", {
      "tarballDir": "release"
    }],
    ["@semantic-release/github", {
      "assets": "release/*.tgz"
    }],
    "@semantic-release/git"
  ],
  "preset": "angular"
}
```
Based on this configuration, Semantic Release performs the following steps:

1. **@semantic-release/commit-analyzer** analyzes your commit messages to determine the next semantic version.
2. **@semantic-release/release-notes-generator** generates release notes based on the commit messages since the last release.
3. **@semantic-release/changelog** creates and updates a CHANGELOG.md file based on the release notes generated.
4. **@semantic-release/npm** Updates the version in package.json and creates a tarball in the release directory based on the files specified in package.json. If the package isn’t marked as private in package.json, the new version of the package is published to NPM.
5. **@semantic-release/github** creates a GitHub release titled and tagged with the new version. The release notes are used in the description and the tarball created in the previous step is included as the release binary. It also adds a comment to any Issues and Pull Requests linked in the commit message.
6. **@semantic-release/git** commits the files modified in the previous steps (CHANGELOG.md, package.json, and package-lock.json) back to the repository. The commit is tagged with vMAJOR.MINOR.PATCH and the commit message body includes the generated release notes. Perform a git pull --rebase to get that commit locally.

The base Conventional Commit spec allows for feat and fix commit types, but the configuration above is using the angular preset. The Angular flavor of Conventional Commit adds support for additional commit types: build, chore, ci, docs, style, refactor, perf, and test. If you prefer not to use those additional commit types, simply remove that final line in the config.

If you want to test your configuration, create a GitHub personal access token and run 
    
    GITHUB_TOKEN=your-token npx semantic-release --dry-run.

At this point, you now have Semantic Release set up for your project, but it’s not yet running in response to changes to your repository — let’s do that now.


#### 6.5.2 GitHub Actions

GitHub Actions allows software developers to run actions in response to events in a GitHub repository. While there are plenty of useful events for automating your GitHub projects, the most common use case is running tests when commits are pushed to the repository or when Pull Requests are opened. Now that we have Semantic Release set up we can take it a step further and perform automated releases.

I’ve annotated the GitHub Actions workflow file with code comments that hopefully provide enough explanation. Store this file in `.github/workflows/test-release.yaml` from your root directory. GitHub will automatically create the Actions for you when you push the changes.
```
name: Test and release

# Run the workflow when a Pull Request is opened or when changes are pushed to master
on:
 pull_request:
 push:
  branches: [ master ]

jobs:
 test:
  runs-on: ubuntu-latest
  strategy:
   matrix:
    # Run the steps below with the following versions of Node.js
    node-version: [8.x, 10.x, 12.x]
  steps:
  # Fetch the latest commit
  - name: Checkout
   uses: actions/checkout@v2

  # Setup Node.js using the appropriate version
  - name: Use Node.js ${{ matrix.node-version }}
   uses: actions/setup-node@v1
   with:
    node-version: ${{ matrix.node-version }}

  # Install package dependencies
  - name: Install
   run: npm ci

  # Run tests
  - name: Test
   run: npm test

 release:
  # Only release on push to master
  if: github.event_name == 'push' && github.ref == 'refs/heads/master'
  runs-on: ubuntu-latest
  # Waits for test jobs for each Node.js version to complete
  needs: [test]
  steps:
  - name: Checkout
   uses: actions/checkout@v2

  - name: Setup Node.js
   uses: actions/setup-node@v1
   with:
    node-version: 12.x

  - name: Install
   run: npm ci

  - name: Release
   run: npx semantic-release
   env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```
That’s it! Your GitHub project is now set up to automatically run tests on every Pull Request and release changes pushed to the master branch.

#### 6.5.3 Let’s review
We installed Semantic Release and its plugins, updated our package.json, and added `release.config.js` to get our project ready for automated release versioning based on Conventional Commits. We then added automation by defining our GitHub Action in `.github/workflows/test-release.yaml`.

Now, all Pull Requests have tests run against them to ensure changes don’t break our package. When changes are pushed to our master branch or when Pull Requests are merged, we get versioned releases published to GitHub and NPM with release notes and a changelog. All Issues and PRs referenced in commit messages are automatically commented on to announce they’ve been addressed in a release. Not bad considering the minimal effort involved.

#### 6.5.4 Deploying services to the cloud
What we’ve walked through so far is great for releasing software packages such as libraries and frameworks to GitHub and NPM, but what about deploying services and applications to the cloud? In Part 2, we’ll build on the foundation we’ve established by creating a new GitHub Action workflow that triggers when a new GitHub release is published and deploys the build artifacts to AWS.










#### 5.2.2  angular-toolkit
https://github.com/ionic-team/angular-toolkit

Ionic’s angular-toolkit project, for instance, integrates Semantic Release to automate the release process (hereby follows the Angular commit conventions):





## 6. dev config
    




### 6.1 git hook



https://eidson.info/post/global-hooks-with-git

    git config --global core.hooksPath /path/to/my/centralized/hooks

    touch /path/to/my/centralized/hooks/pre-push
    chmod a+x /path/to/my/centralized/hooks/pre-push
    nano /path/to/my/centralized/hooks/pre-push

Content:
```
# /path/to/my/centralized/hooks/pre-push
#! /usr/bin/fish

if test -e ./.git/hooks/pre-push
    command sh ./.git/hooks/pre-push
end

if test -e ./sonar-project.properties
    command sonar-scanner
end
```
https://eidson.info/post/using-conventional-commit-messages-globally


commitlint in and of itself does not really do much until it is placed into a git hook. It is from inside this hook that we can fail the commit if the message does not follow the standard.

Like the earlier npm packages, I wanted this applied to all of my projects, without configuring a git hook for each individual project. If you are unfamiliar with using git hooks globally, you can check out my previous post on git global hooks.

If you've got global git hooks configured already, you can add a file as `/path/to/global/hooks/commit-msg`. 

I use the fish shell for my scripting, but the bash shouldn't look too much different. The line `commitlint < $argv[1]` does the work, I think bash would be `commitlint < $1`
```
#! /usr/bin/fish

# run any local commit-msg hook first
if test -e ./.git/hooks/commit-msg
        sh ./.git/hooks/commit-msg
end

commitlint < $argv[1]

exit $status
```







docker-helm/.githooks/pre-commit
```
#!/usr/bin/env bash

shopt -s globstar

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if shellcheck "$DIR"/../**/*.sh; then
  echo "code clean"
fi
```

Before any contribution, test your code :

using our testing script: 

    .githooks/pre-commit
by registering our githooks: 

    git config --local core.hooksPath .githooks/








https://github.com/aitemr/awesome-git-hooks








### 6.2 nodejs project git hook / CLI: Husky



    npm install husky --save-dev

This allows us to add git hooks directly into our package.json via the husky.hooks field.
```
// package.json
{
  "husky": {
    "hooks": {
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
}
```
or Alternatively, you can use a dedicated .huskyrc file, which contains only Husky configuration:
```
{
  "hooks": {
    "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
  }
}
```


npm uninstall @commitlint/prompt-cli



Test
```
touch abc
git add .
git commit -m "foo: this will fail"
```











### 6.3 other husky: python / go

Shell

https://github.com/nkantar/Autohook

https://github.com/rycus86/githooks

https://github.com/boddenberg-it/.githooker

gradle

https://github.com/gtramontina/ghooks.gradle

Go

https://github.com/git-hooks/git-hooks
https://github.com/Arkweid/lefthook

python

https://pre-commit.com/


Ruby

https://github.com/sds/overcommit

Perl 

https://github.com/gnustavo/Git-Hooks

https://github.com/guillaumeaubert/App-GitHooks


All

https://githooks.com/


## 7. CI/CD config





### 7.1 Github actions/workflows



https://github.com/features/actions
https://docs.github.com/en/actions/configuring-and-managing-workflows


https://developer.okta.com/blog/2020/05/18/travis-ci-to-github-actions

https://medium.com/@nwillc/travis-ci-to-github-actions-925d574f3f2b

https://tomasvotruba.com/blog/2020/01/27/switch-travis-to-github-actions-to-reduce-stress/


https://knapsackpro.com/ci_comparisons/github-actions/vs/travis-ci


https://bravelab.io/blog/migrating-from-travisci-to-github-actions-1/

https://www.eficode.com/blog/github-actions


https://markphelps.me/2019/09/migrating-from-travis-to-github-actions/



### 7.2 Travis-ci



https://docs.travis-ci.com/user/build-stages





## 8. Example project config


### 8.0 nodejs + bin

https://github.com/conventional-changelog/commitlint/blob/master/%40commitlint/prompt-cli/package.json


### 8.1 Nodejs + gitlab





https://dev.bleacherreport.com/how-we-use-commitizen-to-clean-up-commit-messages-a16790dcd2fd

I have added husky + commitizen + commitlint to our projects and it has been great.

Some benefits include an auto-generated change log. auto-incrementing semantic versioning. and increased visibility for breaking changes.

I would recommend it for every project.

Because we are using gitlab, we are using these packages semantic-release-gitlab and npm-publish-git-tag.



### 8.2 PHP projects +  Global for all local by BASH



https://eidson.info/post/using-conventional-commit-messages-globally



### 8.3 C# project + Visual Studio + github hooks + commitsar



https://github.com/unoplatform/uno/blob/master/.github/workflows/conventional-commits.yml





### 8.4 Python project gitlint



https://jorisroovers.com/gitlint/





## 9. shellcheck

https://www.shellcheck.net/

https://dev.to/david_j_eddy/using-shellcheck-to-lint-your-bashsh-scripts-3jaf

https://github.com/koalaman/shellcheck

https://www.linuxjournal.com/content/globstar-new-bash-globbing-option

https://github.com/renault-digital/docker-helm


https://github.com/marketplace/actions/shellcheck

https://github.com/ludeeus/action-shellcheck


https://github.com/marketplace/actions/run-shellcheck-with-reviewdog


## 10. node package.json

https://docs.npmjs.com/files/package.json


### 10.1 files
The optional files field is an array of file patterns that describes the entries to be included when your package is installed as a dependency. 

File patterns follow a similar syntax to .gitignore, but reversed: including a file, directory, or glob pattern (*, **/*, and such) will make it so that file is included in the tarball when it’s packed. 

Omitting the field will make it default to ["*"], which means it will include all files.

Some special files and directories are also included or excluded regardless of whether they exist in the files array (see below).

You can also provide a .npmignore file in the root of your package or in subdirectories, which will keep files from being included. At the root of your package it will not override the “files” field, but in subdirectories it will. The .npmignore file works just like a .gitignore. If there is a .gitignore file, and .npmignore is missing, .gitignore’s contents will be used instead.

Files included with the “package.json#files” field cannot be excluded through .npmignore or .gitignore.

Certain files are always included, regardless of settings:
```
package.json
README
CHANGES / CHANGELOG / HISTORY
LICENSE / LICENCE
NOTICE
The file in the “main” field
```
README, CHANGES, LICENSE & NOTICE can have any case and extension.

Conversely, some files are always ignored:
```
.git
CVS
.svn
.hg
.lock-wscript
.wafpickle-N
.*.swp
.DS_Store
._*
npm-debug.log
.npmrc
node_modules
config.gypi
*.orig
package-lock.json (use shrinkwrap instead)
```

### 10.2 main
The main field is a module ID that is the primary entry point to your program. That is, if your package is named foo, and a user installs it, and then does require("foo"), then your main module’s exports object will be returned.

This should be a module ID relative to the root of your package folder.

For most modules, it makes the most sense to have a main script and often not much else.


### 10.3 bin
A lot of packages have one or more executable files that they’d like to install into the PATH. npm makes this pretty easy (in fact, it uses this feature to install the “npm” executable.)

To use this, supply a bin field in your package.json which is a map of command name to local file name. On install, npm will symlink that file into `prefix/bin` for global installs, or `./node_modules/.bin/` for local installs.

For example, myapp could have this:
```
{ 
    "bin" : { 
        "myapp" : "./cli.js" 
     } 
}
```
So, when you install myapp, it’ll create a symlink from the **cli.js** script to **/usr/local/bin/myapp**.

If you have a single executable, and its name should be the name of the package, then you can just supply it as a string. For example:
```
{ 
    "name": "my-program",
    "version": "1.2.5",
    "bin": "./path/to/program" 
}
```
would be the same as this:
```
{ 
    "name": "my-program",
    "version": "1.2.5",
    "bin" : { 
        "my-program" : "./path/to/program" 
    } 
}
```
Please make sure that your file(s) referenced in bin starts with `#!/usr/bin/env node`, otherwise the scripts are started without the node executable!


### 10.4 scripts
The “scripts” property is a dictionary containing script commands that are run at various times in the lifecycle of your package. The key is the lifecycle event, and the value is the command to run at that point.

See **npm-scripts** to find out more about writing package scripts.

### 10.5 config
A “config” object can be used to set configuration parameters used in package scripts that persist across upgrades. For instance, if a package had the following:
```
{ 
    "name" : "foo",
    "config" : { 
        "port" : "8080" 
    } 
}
```
and then had a “start” command that then referenced the npm_package_config_port environment variable, then the user could override that by doing npm config set foo:port 8001.

See npm-config and npm-scripts for more on package configs.

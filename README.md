# bash-base

[toc]

## 1. Semantic Versioning

<details>


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
</details>




## 2. Conventional commits (semantic commit)
<details>


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


</details>




## 3. Tools generat commit




### 3.1 Commitizen

<details>

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
    
    
</details> 

### 3.2 Intellij

<details>
https://plugins.jetbrains.com/plugin/9861-git-commit-template

49.8k
4.84





https://plugins.jetbrains.com/plugin/13389-conventional-commit
https://github.com/lppedd/idea-conventional-commit

8.1k
4.7

</details>



## 4. Tools valid commit message



### 4.1 Commitlint

<details>
https://dev.bleacherreport.com/how-we-use-commitizen-to-clean-up-commit-messages-a16790dcd2fd



Create a package.json if needed

    npm init

Install and configure if needed

    npm install --save-dev @commitlint/{cli,config-conventional}
    echo "module.exports = {extends: ['@commitlint/config-conventional']};" > commitlint.config.js

Test

    echo "abc" | commitlint


</details>


### 4.2 commitsar

<details>

https://github.com/unoplatform/uno/blob/master/.github/workflows/conventional-commits.yml

https://commitsar.tech/docs/usage/github

https://github.com/aevea/commitsar


</details>

### 4.3 python Gitlint

<details>
Gitlint is a git commit message linter written in python: it checks your commit messages for style.
https://jorisroovers.com/gitlint/

</details>


## 5. Commit message to changelog/release number
    


### 5.1 commit message -> generate changelog

<details>

https://github.com/conventional-changelog/conventional-changelog

https://github.com/axetroy/vscode-changelog-generator

</details>

### 5.2 commit message -> release (change version automatically)

<details>

#### 5.2.1 semantic-release

https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/README.md#ci-configurations


https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/travis.md


#### 5.2.2  angular-toolkit
https://github.com/ionic-team/angular-toolkit

Ionic’s angular-toolkit project, for instance, integrates Semantic Release to automate the release process (hereby follows the Angular commit conventions):


</details>


## 6. dev config
    




### 6.1 git hook

<details>

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

</details>

### 6.2 nodejs project git hook / CLI: Husky

<details>

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


</details>




## 7. CI/CD config





### 7.1 Github actions/workflows

<details>

https://github.com/features/actions
https://docs.github.com/en/actions/configuring-and-managing-workflows

</details>

### 7.2 Travis-ci

<details>

https://docs.travis-ci.com/user/build-stages

</details>



## 8. Example project config




### 8.1 Nodejs + gitlab

<details>

https://dev.bleacherreport.com/how-we-use-commitizen-to-clean-up-commit-messages-a16790dcd2fd

I have added husky + commitizen + commitlint to our projects and it has been great.

Some benefits include an auto-generated change log. auto-incrementing semantic versioning. and increased visibility for breaking changes.

I would recommend it for every project.

Because we are using gitlab, we are using these packages semantic-release-gitlab and npm-publish-git-tag.

</details>

### 8.2 PHP projects +  Global for all local by BASH

<details>

https://eidson.info/post/using-conventional-commit-messages-globally

</details>

### 8.3 C# project + Visual Studio + github hooks + commitsar

<details>

https://github.com/unoplatform/uno/blob/master/.github/workflows/conventional-commits.yml


</details>


### 8.4 Python project gitlint

<details>

https://jorisroovers.com/gitlint/


</details>




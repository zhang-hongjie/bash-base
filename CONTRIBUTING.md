---
menu: Development
---

## Contributing

Please take a moment to review this document in order to make the contribution process easy and effective for everyone involved.

The issue tracker is the preferred channel for bug reports, features requests and submitting merge requests.

### bug reports

A bug is a demonstrable problem that is caused by the code in the repository. Good bug reports are extremely helpful.

Before create a bug report, search if it is not already created by others.<br>
Prepare a description containing the steps to reproduce the bug.

### feature requests

Feature requests are welcome.<br>
Before propose a feature, find out whether your idea fits with the scope of the project.<br>
If a proposal is pertinent, try to explain the main idea, it's requirements, it's users and it's context as much as possible.<br>
A good understanding of the requested feature may be crucial for the acceptance of the proposal by the community around this project.

### merge requests

Good merge requests are a fantastic help.<br>
It is the step where you submit patches to this repository.<br>
To prevent any frustration, you should make sure to open an issue to discuss any new features before working on it.<br>
This will prevent you from wasting time on a feature the maintainers doesn't see fit for the project scope.<br>
In any case, a merge request should remain focused in scope and avoid containing unrelated commits.

How to do it ?

1. Clone the repository

```
git clone https://gitlabee.dt.renault.com/shared/boilerplate/api-nodejs.git .
```

2. If you clone a while ago, get the latest changes from upstream.

```
git checkout develop
git pull origin develop
```

3. Create a fixture (fix), refactoring (refact) or feature (feat) :

```
git checkout -b fix|refact|feat-name
```

4. Commit your changes in logical chunks. Please see the (commit message guidelines). Don't forget to write/update tests concerning the evolution proposed.

```
git commit -m '✨ (module) message'
```

5. Push your changes

```
git push origin <your-branch-name>
```

6. Open a merge request with a clear title and description.

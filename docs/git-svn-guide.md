## "git svn" Guide

`git svn` is a git command that allows using git to interact with Subvesion (Svn) repsotories. It is part of git client bundle. In other words, we can work within a git space while synchronising with a Svn repository, emitting the `git svn` command to tell git to interact with a Svn.

## Prerequisites

- [git](https://git-scm.com/download)

## Create a new git repository pointing to an existing Svn repository

Here, we'll use PROJECT as an example for the Svn repository.

Notice the standard layout of a Svn repository :

> - Root : https://server/svn/PROJECT
> - Trunks : https://server/svn/PROJECT/trunk
> - Tags : https://server/svn/PROJECT/tags
> - Branches : https://server/svn/PROJECT/branches

__[Task 1] :__ Create a new git repository pointing to an existing Svn repository

```sh
git svn init https://server/svn/PROJECT svn2git -T trunk -t tags -b branches
```

By looking at __.git/config__ :

```s
[core]
        repositoryformatversion = 0
        filemode = false
        bare = false
        logallrefupdates = true
        symlinks = false
        ignorecase = true
[svn-remote "svn"]
        url = https://server/svn/PROJECT
        fetch = trunk:refs/remotes/origin/trunk
        branches = branches/*:refs/remotes/origin/*
        tags = tags/*:refs/remotes/origin/tags/*
```

__[Task 2] :__ Make change to the git config `.git/config` by replacing `origin` by `svn`

```s
[svn-remote "svn"]
        url = https://server/svn/PROJECT
        fetch = trunk:refs/remotes/svn/trunk
        branches = branches/*:refs/remotes/svn/branches/*
        tags = tags/*:refs/remotes/origin/svn/*
```

__[Task 3] :__ Fetch history of changes from Svn

```sh
git svn fetch
```

The above command allows to fetch changes from the remote Svn repository. The first fetch would take a while, likely a few hours depending on you machine and network, because it retrieve all changes from the server. The next time you trigger the fetch again, it should be quick as it will retrieve only the detla.

Now that the Svn commits are converted into git commits, we can start using git as usual.

> Notice : Continue developing by making local changes

- `git add FILE` to stage a file
- `git checkout FILE` to unstage a file
- `git commit` to save your changes. Those commits will be local and will not be _pushed_ to the Svn repository
- `git stash` and `git stash pop` save in the cache local changes, and put it back
- `git reset HEAD` Revert all your local change in the stage, using default `--soft`. `git reset HEAD --hard` Revert completely all your local changes and they will be lost
- `git log` Access all the history in the repository
- `git checkout BRANCH` change to BRANCH or create a new branch with `-b NEW_BRANCH`  
- `git branch` list all branches with `-a`, delete a branch with `-d`

## Convert SVN Trunk to Git develop branch

__[Task 4] :__ Merge Svn history to Git history

Now we need to associate the Svn Trunk to the develop branch of git;

Let's apply commits to `develop` branch

```sh
# create a new branch call develop, if not existed
git checkout -b develop

# Retrieve all the changes from the Svn remote repository and apply them on top of the current branch (equivalent to git pull)
git svn rebase
```

> Push local changes to Svn repository - NOT RECOMMENDED
> In case you need to push back changes to Svn, you may use `git svn dcommit`. It will create a Svn commit for each of your local git commits. As with Svn, ou local git history must be in sync with the latest changes in the Svn repository. So if the command fails, try performing a `git svn rebase` first.

```sh
git svn dcommit
```

> Notice : Your local git commits will be _rewritten_ when using the command `git svn dcommit`. This command will add a text to the git commit's message referencing the Svn revision created in the Svn server, which is very usefull. However, adding a new text requires modifying an existing commit's message which can't acctually be doe : git commits are immutable. The solution is to create a ew commit with the same content adn the new message, but it is technically a new commit ayway.

## Convert SVN tags to Git tags

__[Task 5] :__ Convert 'SVN tags' branches to simple git tags :

```sh
$ git for-each-ref --format="%(refname:short) %(objectname)" refs/remotes/origin/tags | cut -d / -f 3- | \
while read ref \
do \
  git tag -a $ref -m 'import tag from svn' \
done
```

__[Task 6] :__ Delete SVN tag branches

```sh
git for-each-ref --format="%(refname:short)" refs/remotes/origin/tags | cut -d / -f 1- | \
while read ref
do
  git branch -rd $ref \
done
```

__[Task 7] :__ Since tags marked in the previous step point to a commit "create tag", we need to derive "real" tags, i.e. parents of "create tag" commits.

```sh
git for-each-ref --format="%(refname:short)" refs/tags | \
while read ref \
do \
  tag=`echo $ref | sed 's/_/./g'` # give tags a new name \
  echo $ref -\> $tag \
  git tag -f -a $tag `git rev-list -2 $ref | tail -1` -m "proper svn tag" \
done
```

## Convert all Svn branches to Git Branches

__[Task 8] :__ Checkout all branches locally

```sh
git for-each-ref --format="%(refname)" refs/remotes | grep -v trunk | cut -d / -f 2- | \
while read ref \
do \
  branchName=`echo $ref | cut -f3 -d/` \
  git checkout -b $branchName $ref \
done
```

## Push all to Git remote

__[Task 9] :__ Push all tags and branches to Git remote

```sh
git remote add new-origin https://gitserver/group/project
git push new-origin --all --force
git push new-origin --tags
```

## References

- [git svn](https://git-scm.com/docs/git-svn)
- [Git Svn Guide](https://gist.github.com/rickyah/7bc2de953ce42ba07116)

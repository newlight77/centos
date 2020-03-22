---
layout: post
title:  "Svn to Git migration"
date:   2019-08-04 10:22:22 +0200
categories: 
    - git
    - migration
tags: 
    - devops
    - git
    - svn
    - migration
author: newlight77
---

In SVN, developers share contributions by committing changes from a working copy on their local computer to a central repository. Then, other developers pull these updates from the central repo into their own local working copies.

As opposed to SVN which is centralized, Git repository is distributed. Tthe collaboration workflow is much different. Instead of differentiating between working copies and the central repository, Git gives each developer their own copy of the entire repository. Changes are committed to this local repository instead of a central one. To share updates with other developers, you need to push these local changes to a public Git repository on a server. Then, the other developers can pull your new commits from the public repo into their own local repositories.

Now you've understood what is at stake, let's begin the migration.

## The migration

We’ve broken down the SVN-to-Git migration process into 5 simple steps:

1. Prepare your environment for the migration.
2. Convert the SVN repository to a local Git repository.
3. Synchronize the local Git repository when the SVN repository changes.
4. Share & use the Git repository
5. Remove SVN repository

The three first steps (1 to 3) take a SVN commit history and turn it into a Git repository. The best way to manage these steps is to designate one of your team members as the migration lead. They should be performed on a Linux machine. At the synchronize phase, the migration lead should keep the  Git repository up-to-date with an SVN counterpart, by pushing to the remote repository at daily basis. Until every developr is ready to switch to use a pure Git workflow, the team can keep working with this one-way synchronization from SVN to Git - the Git repository is treated as read-only. The final step in the migration process is to freeze your SVN repository and begin committing with Git instead.

### Prepare

The first step to migrating a project from SVN to Git-based is to prepare the Linux machine.

You'll require :

- Access to your current SVN repository as source
- Access to your new GIT repository as destination
- Access to a migration server
  - easily setup, requires basically a blank/sandbox redhat server
  - refer to [svn2git migration tool](https://github.com/newlight77/fedora-centos/tree/master/roles/svn2git)

### SVN to GIT

Please refer to [svn2git migration tool](https://github.com/newlight77/fedora-centos/tree/master/roles/svn2git)

### Synchronize

Once the SVN history is transfered to Git repository, you are entering into a transition phase and you need to keep both repositories in sync. It’s very easy to synchronize your new Git repository with new commits in the original SVN repository. The new Git repository serves as a read-only for your team during this phase. This means that you team is still working with the existing SVN workflow, while begining to experiment with Git on an extra git repository as a sandbox. This transition phase could take weeks and may be planed accordingly to your team's workload. During that time, you team may need training on git usage and you may also need to define a branching strategy. Once your team is comfortable wit git, you can move to the next step.

### Share and switch over to GIT

If you reach this step, it means that you are ready to completely switch to Git along the branching strategy. The migration lead will announce the switch over date and time.

In SVN, developers share contributions by committing changes from a working copy on their local computer to a central repository. Then, other developers pull these updates from the central repo into their own local working copies.

As opposed to SVN which is centralized, Git repository is distributed. Tthe collaboration workflow is much different. Instead of differentiating between working copies and the central repository, Git gives each developer their own copy of the entire repository. Changes are committed to this local repository instead of a central one. To share updates with other developers, you need to push these local changes to a public Git repository on a server. Then, the other developers can pull your new commits from the public repo into their own local repositories.

Giving each developer having their own complete repository, it opens up a wide array of potential workflows. That's why we talk about branching strategy.

### Remove SVN repository

Once everyone has switched to use git repository, we can delete the svn repository.

# svn2git

## Pre-requisites

- Git repository as source with standard structure
  - trunk
  - tags
  - branches
- Non standard repository structure:
  - the migrate.sh script must be adapted to point to correct folder mapping as where svn2git is called.

```sh
svn2git $svn_repo --trunk trunk --branches branches --tags tags
```

## Migration guide

1. clone the tool kit repositoy centos

```sh
git clone https://github.com/newlight77/centos /apps/centos
cd /apps/centos
```

2. install the svn2git package

```sh
sudo echo prompt password
ansible-playbook ansible/playooks/playbook-svn2git.yml
```

3. Run the migration script

```sh
cd /appli/svn2git

export SVN_URL=your_svn_url
export GIT_URL=your_git_url

docker-compose up

docker-compose down

# in case you want to run that inside the containwer, you override the env variables 
    # sh /appli/migrate.sh -s=your_svn_url -g=your_git_url
# you need to change the docker-compose.yml : command: bash

```

The log file resulting from the script execution will be available at [/apps/logs/svn2git-TIMESTAMP.log].

## Reference

[svn2git migration guide](https://github.com/newlight77/centos/tree/master/docs/svn2git-migration-guide.md)
[git svn guide](https://github.com/newlight77/centos/tree/master/docs/git-svn-guide.md)


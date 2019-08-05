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

1. clone the ci-kit

```sh
git clone https://github.com/newlight77/fedora-centos /apps/fedora-centos
cd /apps/fedora-centos
```

2. install the svn2git package

```sh
sudo echo prompt password
ansible-playbook ansible/playooks/playbook-svn2git.yml
```

3. Run the migration script

```sh
cd /appli/svn2git

docker-compose up –d

docker exec svn2git /appli/svn2git/migrate.sh
```

The log file resulting from the script execution will be available at [/apps/logs/svn2git-TIMESTAMP.log].


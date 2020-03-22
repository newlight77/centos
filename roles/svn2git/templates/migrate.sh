
#!/usr/bin/env bash


#############################################
## Global variables
#############################################
ROOT_DIR=$(dirname $0)
DIR="$(cd $ROOT_DIR/../.. && pwd -P)"
echo "${green} DIR: $DIR ${reset}"

#############################################
## Functions
#############################################
createProjectDir() {
  project=$1
  mkdir $project
  chmod 777 $project
  cd $project
}

convertBranches() {
  # Checkout all branches locally
  git for-each-ref --format="%(refname)" refs/remotes | grep -v trunk | cut -d / -f 2- | \
  while read ref 
  do 
    branchName=`echo $ref | cut -f3 -d/` 
    git checkout -b $branchName $ref 
  done
}

convertTags() {

  # Convert 'SVN tags' branches to simple git tags
  git for-each-ref --format="%(refname:short) %(objectname)" refs/remotes/origin/tags | cut -d / -f 3- | \
  while read ref 
  do 
    git tag -a $ref -m 'import tag from svn' 
  done

  # Delete SVN tag branches
  git for-each-ref --format="%(refname:short)" refs/remotes/origin/tags | cut -d / -f 1- | \
  while read ref
  do
    git branch -rd $ref 
  done

  # Since tags marked in the previous step point to a commit "create tag", we need to derive "real" tags, i.e. parents of "create tag" commits.
  git for-each-ref --format="%(refname:short)" refs/tags | \
  while read ref 
  do 
    tag=`echo $ref | sed 's/_/./g'` # give tags a new name 
    echo $ref -\> $tag 
    git tag -f -a $tag `git rev-list -2 $ref | tail -1` -m "proper svn tag" 
  done

}

#############################################
## Check arguments
#############################################
for i in "$@"
  do
    case $i in
      -s=*|--svnUrl=*)       SVN_URL="${i#*=}"  ;;
      -g=*|--gitUrl=*)       GIT_URL="${i#*=}"  ;;
      -a|--all)               ALL="true"         ;;
      -h|--help)                   usage               ;;
      *)                           usage               ;;
    esac
done


#############################################
## Run
#############################################
#createProjectDir $PROJECT
mkdir logs

echo 'Create a new git repository pointing to an existing Svn repository'
 
echo "SVN_URL=$SVN_URL"
echo "GIT_URL=$GIT_URL"

git svn init $SVN_URL . -T trunk -t tags -b branches | tee logs/svn2git-$(date +%F+%T).log 
git svn fetch | tee logs/svn2git-$(date +%F+%T).log 

echo 'Merging Svn history to Git history'
# Apply commits to develop branch
git checkout -b develop  | tee logs/svn2git-$(date +%F+%T).log 
# Retrieve all the changes from the Svn
git svn rebase | tee logs/svn2git-$(date +%F+%T).log 

echo 'Convert SVN tags to Git tags'
convertTags | tee logs/svn2git-$(date +%F+%T).log 

echo 'Convert all Svn branches to Git Branches'
convertBranches | tee logs/svn2git-$(date +%F+%T).log 

# In case there is any ssh certficate issue
git config --global http.sslVerify false

echo 'Push all tags and branches to Git remote'
git remote add new-origin $GIT_URL
git push new-origin --all --force | tee logs/svn2git-$(date +%F+%T).log 
git push new-origin --tags | tee logs/svn2git-$(date +%F+%T).log 

echo 'migration completed'

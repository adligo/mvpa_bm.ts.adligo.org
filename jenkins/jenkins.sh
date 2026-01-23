#
# This is the Jenkins Bash Build script for 
# https://github.com/adligo/mvpa_bm.ts.adligo.org/
#
# Note exit codes are (original) line numbers unless 0 which is a success,
# If your a maintainer feel free to update when they differ from the line numbers.
# 

VERSION="2025-12-28#7"
### Configuration Section ###
#
# ORIGIN one of {'github','localdisk'}
#
ORIGIN=github
#
# GIT_PROTOCOL one of {'https','ssh','local'}
#
GIT_PROTOCOL=https
#
# This is also the base directory for local builds
# i.e. 
# GIT_REPOSITORY_BASE='~/adligo-repos/'
#
GIT_REPOSITORY_BASE=$GIT_PROTOCOL'://github.com/adligo/'
#
# This is used for the directory path as well
#
GIT_REPOSITORY_PATH=mvpa_bm.ts.adligo.org
GIT_DEP_PROJECT=mvpa_group_deps.ts.adligo.org
GIT_GROUP_PROJECT=mvpa_group.ts.adligo.org

GIT_REPOSITORY=$GIT_REPOSITORY_BASE$GIT_REPOSITORY_PATH'.git'
ROOT_WORKSPACE=`pwd`

export PATH=$PATH:/usr/bin
#
# Note the concept of a work dir with a id number, exists because I have seen 
# Jenkins get stopped in the middle of builds creating inconsitent disk states
# This script trys to maximize the speed of git pulls with the flexibility of 
# git clones and clean from scratch builds.
#
WORK_DIR_ID=1

VERBOSE=true
START=$SECONDS
MAX_SECONDS=240

## Fast setup through env variables, this can be commented out to test discover or the common node_modules code 
export COMMON_NODE_MODULES=$ROOT_WORKSPACE/$WORK_DIR_ID/$GIT_REPOSITORY_PATH/mvpa-group/mvpa_group_deps.ts.adligo.org/node_modules
export TESTS4TS_NODE_MODULE_SLINK=$COMMON_NODE_MODULES
export JUNIT_XML_NODE_MODULE_SLINK=$COMMON_NODE_MODULES
export MVPA_NODE_MODULE_SLINK=$COMMON_NODE_MODULES
export OBJ_NODE_MODULE_SLINK=$COMMON_NODE_MODULES
export SLINK_NODE_MODULE_SLINK=$COMMON_NODE_MODULES

echo COMMON_NODE_MODULES is;
echo $COMMON_NODE_MODULES


### Execution Section ###
which git
EXIT_CODE=$?
if [[ "$EXIT_CODE" == "0" ]]; then
  if [[ $VERBOSE == "true" ]]; then
    echo "Git appears to be installed"
  fi
else
  echo "Please install git on this system and put it in the PATH variable!"
  echo "which git returned a EXIT_CODE '$EXIT_CODE'"
  exit 44
fi
echo "Running git version"
git -v

function doRm_fr () {
  rm -fr $1
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    echo "Sucessfully removed directory"
    echo $1
    echo "in"
    pwd
  else
    echo "Failed to remove directory"
    echo $1
    echo "in"
    pwd
    exit 72
  fi
}

function doCd () {
  cd $1
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    if [[ $VERBOSE == "true" ]]; then
      echo "Sucessfully moved(changed) into $1"
    fi
  else
    echo "Unable to move(change) into $1"
    exit 79
  fi
  
}

  
if [[ -d $WORK_DIR_ID ]]; then
  echo "The following directory exists;"
  echo $WORK_DIR_ID
else
  mkdir $WORK_DIR_ID
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    echo "Sucessfully created directory $WORK_DIR_ID"
  else
    echo "Failed to create directory $WORK_DIR_ID"
    exit 70
  fi
fi

doCd $WORK_DIR_ID

if [[ -d $GIT_REPOSITORY_PATH ]]; then
  doCd $GIT_REPOSITORY_PATH
  git pull
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    if [[ $VERBOSE == "true" ]]; then
      echo "Sucessfully performed a 'git pull' in"
      pwd
    fi
  else
    echo "Unable to run a 'git pull' in"
    pwd
    exit 108
  fi
else
  git clone $GIT_REPOSITORY
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    if [[ $VERBOSE == "true" ]]; then
      echo "Sucessfully cloned $GIT_REPOSITORY"
    fi
  else
    echo "Unable to clone $GIT_REPOSITORY"
    exit 119
  fi
  doCd $GIT_REPOSITORY_PATH
fi



function doAfterScript () {
  echo "doAfterScript $1"
  EXIT_CODE=$?
  if (( $EXIT_CODE == 0 )); then
    if [[ $VERBOSE == "true" ]]; then
      echo "Sucessfully ran script"
      echo $1
    fi
  else
    echo "There was a problem executing the following script"
    echo $1
    echo "in"
    pwd
    exit 150
  fi
}

./mvpa-group/buildSrc/checkVersions.sh
doAfterScript "./mvpa-group/buildSrc/checkVersions.sh"
function doHttps () {
  if [[ $VERBOSE == "true" ]]; then
    echo "jenkins.sh doHttps"
    ./buildSrc/cloneOrPull.sh --verbose --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --verbose --project $GIT_DEP_PROJECT --npm-install"
    ./buildSrc/cloneOrPull.sh --verbose --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --verbose --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --pull --verbose
    ../buildSrc/setupBuildTest.sh
    doAfterScript "../buildSrc/setupBuildTest.sh --verbose"
  else
    ./buildSrc/cloneOrPull.sh --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --project $GIT_DEP_PROJECT --npm-install"
    ./buildSrc/cloneOrPull.sh --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --pull
    ../buildSrc/setupBuildTest.sh
    doAfterScript "../buildSrc/setupBuildTest.sh"
  fi
}

function doSsl () {
  if [[ $VERBOSE == "true" ]]; then
    echo "jenkins.sh doSsl"
    ./buildSrc/cloneOrPull.sh --ssl --verbose --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --ssl --verbose --project $GIT_DEP_PROJECT --npm-install"
    ./buildSrc/cloneOrPull.sh --ssl --verbose --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --ssl --verbose --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --ssl --pull --verbose
    ../buildSrc/setupBuildTest.sh
    doAfterScript "../buildSrc/setupBuildTest.sh"
  else
    ./buildSrc/cloneOrPull.sh --ssl --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --ssl --project $GIT_DEP_PROJECT --npm-install"
    ./buildSrc/cloneOrPull.sh --ssl --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --ssl --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --ssl --pull
    ../buildSrc/setupBuildTest.sh
    doAfterScript "../buildSrc/setupBuildTest.sh"
  fi
}

#
# What procedural code looked like before oo yuk!
#
function doLocal () {
  if [[ $VERBOSE == "true" ]]; then
    echo "jenkins.sh doLocal"
    ./buildSrc/cloneOrPull.sh --local-build --verbose --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --local-build --verbose --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_DEP_PROJECT --npm-install"
    ./buildSrc/cloneOrPull.sh --local-build --verbose --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --local-build --verbose --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --local --pull --LOCAL_REPOSITORY_ROOT $GIT_REPOSITORY_BASE
    ../buildSrc/setupBuildTest.sh --verbose
    doAfterScript "../buildSrc/setupBuildTest.sh --verbose"
  else
    ./buildSrc/cloneOrPull.sh --local-build --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_DEP_PROJECT --npm-install
    doAfterScript "./buildSrc/cloneOrPull.sh --local-build --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_DEP_PROJECT --npm-install" 
    ./buildSrc/cloneOrPull.sh --local-build --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_GROUP_PROJECT
    doAfterScript "./buildSrc/cloneOrPull.sh --local-build --local-repository-root $GIT_REPOSITORY_BASE --project $GIT_GROUP_PROJECT"
    doCd mvpa_group.ts.adligo.org
    node --disable-warning=DEP0190 buildSrc/git-clone-or-pull.cjs --local --pull --LOCAL_REPOSITORY_ROOT $GIT_REPOSITORY_BASE
    ../buildSrc/setupBuildTest.sh
    doAfterScript "../buildSrc/setupBuildTest.sh"
  fi
}

echo "in jenkins_from_github.sh with GIT_PROTOCOL $GIT_PROTOCOL"
pwd
doCd mvpa-group

case "$GIT_PROTOCOL" in
  https) doHttps
      ;;
  ssl)
      doSsl
      ;;
  *)
      # Commands to execute if none of the above patterns match (default)
      doLocal
      ;;
esac

doCd $ROOT_WORKSPACE
if [[ -d "test-results" ]]; then
  doRm_fr test-results
fi

mkdir test-results
# gh_mvpa_bm.ts.adligo.org/1/mvpa_bm.ts.adligo.org/mvpa-group/mvpa_group.ts.adligo.org/
cp -r $ROOT_WORKSPACE/$WORK_DIR_ID/$GIT_REPOSITORY_PATH/mvpa-group/mvpa_group.ts.adligo.org/depot/test-results/**.*xml test-results
# rsync -avm --include='*.xml' -f 'hide,! */' $ROOT_WORKSPACE/$WORK_DIR_ID/$GIT_REPOSITORY_PATH/mvpa_group.ts.adligo.org/depot/test-results test-results/
echo "You can now publish using the JUnit Test Repoter with the following path;"
echo "test-results/*.xml"

duration=$(( SECONDS - START ))
if (( $duration > MAX_SECONDS )) ; then
  echo "Task completed in $duration seconds."
  echo "Sucessfully ran the jenkins.sh script version $VERSION!"
  echo "Build Failed, excessive time used!"
  exit 226
else
  echo "Task completed in $duration seconds."
  echo "Sucessfully ran the jenkins.sh script version $VERSION!"
fi

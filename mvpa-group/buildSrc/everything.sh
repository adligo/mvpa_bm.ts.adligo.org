#!/bin/bash
# Use GitBash to execute this script
# Not in use from Jenkins

echo "everything.sh starting"
VEBOSE=true
SSL=false
while (( "$#" )); do
  #echo "$1"
  case "$1" in
    -d | --deps) DEPS="$2"; shift 2 ;;
    -g | --group) GROUP="$2"; shift 2 ;;
    -r | --root-dir) ROOT_DIR="$2"; shift 2 ;;
    -s | --ssl) SSL=true; shift 1 ;;
    -v | --verbose) VERBOSE=true; shift 1 ;;
  esac
done

echo "everything.sh parsed CLI args"
if [[ $VERBOSE == "true" ]]; then
    echo "everything.sh verbose is $VERBOSE"
fi
  
#
# This is must be the mvpa_bm.ts.adligo.org/mvpa-group path
# 
if [[ -z $ROOT_DIR ]]; then
  echo "A root_dir is required."
  exit 17
fi

./buildSrc/checkVersions.sh
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "All required software is installed!"
  fi
else
  echo "There was a problem with the $PATH or required software."
  exit 37
fi

## Was cloneOrPullDeps
if [[ $VERBOSE == "true" ]]; then
  ./buildSrc/cloneOrPull.sh --verbose -p $DEPS -i
else
  ./buildSrc/cloneOrPull.sh -p $DEPS -i
fi
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "cloneOrPull.sh executed sucessfully"
  fi
else
  echo "There was a problem cloneOrPull.sh -p $DEPS -i"
  exit 21
fi

if [[ $VERBOSE == "true" ]]; then
  ./buildSrc/cloneOrPull.sh --verbose -p $GROUP
else
  ./buildSrc/cloneOrPull.sh -p $GROUP
fi
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "cloneOrPull.sh  -p $GROUP executed sucessfully"
  fi
else
  echo "There was a problem cloneOrPull.sh -p $GROUP"
  exit 32
fi

function doCd() {
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

echo "85 in everything.sh"
pwd
doCd $GROUP

if [[ $SSL == "true" ]]; then
  npm run git-clone-or-pull-ssh
else
  npm run git-clone-or-pull
fi

npm run setup
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "setup step executed sucessfully"
  fi
else
  echo "There was a problem with the setup step"
  exit 35
fi
npm run build
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "build step executed sucessfully"
  fi
else
  echo "There was a problem with the build step"
  exit 45
fi
npm run tests
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "test step executed sucessfully"
  fi
else
  echo "There was a problem with the test step"
  exit 55
fi
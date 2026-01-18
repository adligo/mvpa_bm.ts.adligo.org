#
# This script is expected to be executed by GitBash or Jenkins
#
# Note the #!/bin/bash directive has been removed as Jenkins on Windows will complain about it
#

VEBOSE=false
SSL=false
while (( "$#" )); do
  #echo "$1"
  case "$1" in
    -v | --verbose) VERBOSE=true; shift 1 ;;
  esac
done

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
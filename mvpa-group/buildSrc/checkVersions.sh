#
# This script is expected to be executed by GitBash or Jenkins
#
# Note the #!/bin/bash directive has been removed as Jenkins on Windows will complain about it
#
VERBOSE=false

which git
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "Git appears to be installed"
  fi
else
  echo "Please install git on this system and put it in the $PATH variable!"
  exit 11
fi
echo "Running git version"
git -v

which npm
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "Npm appears to be installed"
  fi
else
  echo "Please install Node.js on this system and put npm in the $PATH variable!"
  exit 24
fi
echo "Running npm version"
npm -v

which slink
EXIT_CODE=$?
if (( $EXIT_CODE == 0 )); then
  if [[ $VERBOSE == "true" ]]; then
    echo "Slink appears to be installed"
  fi
else
  echo "Please install Slink on this system and put npm in the $PATH variable!"
  exit 37
fi
echo "Running slink version"
slink -v
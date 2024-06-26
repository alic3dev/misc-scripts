#!/bin/zsh

. $(dirname "$0")/shared-variables.sh

printUpdatingMessageFor() {
  if $FIRST_PRINT
  then
    FIRST_PRINT=false
  else
    echo ""
  fi

  echo "${COLOR_BLUE}Updating ${COLOR_GREEN}${1}${COLOR_BLUE} packages${COLOR_RESET}"
}

printUpgradingMessageFor() {
  if $FIRST_PRINT
  then
    FIRST_PRINT=false
  else
    echo ""
  fi

  echo "${COLOR_BLUE}Upgrading ${COLOR_GREEN}${1}${COLOR_BLUE} packages${COLOR_RESET}"
}

if [ -f ./pnpm-lock.yaml ]
then
  printUpdatingMessageFor "PNPM"
  pnpm update
  printUpgradingMessageFor "PNPM"
  pnpm upgrade
  PNPM_EXIT_CODE=$?
elif [ -f ./package-lock.json ]
then
  printUpdatingMessageFor "NPM"
  npm update
  printUpgradingMessageFor "NPM"
  npm upgrade
  NPM_EXIT_CODE=$?
elif [ -f ./yarn.lock ]
then
  printUpgradingMessageFor "Yarn"
  yarn up
  YARN_EXIT_CODE=$?
elif [ -f ./package.json ]
then
  echo "No lock file found, install?"
  echo "(P) PNPM"
  echo "(N) NPM"
  echo "(Y) Yarn"
  echo "( ) Don't install"
  echo -n "> "
  read $REPLY
  echo ""

  if [[ $REPLY =~ ^[Pp]$ ]]
  then
    pnpm install
  elif [[ $REPLY =~ ^[Nn]$ ]]
  then
    npm install
  elif [[ $REPLY =~ ^[Yy]$ ]]
  then
    yarn install
  fi

  exit
fi



printStatusMessage() {
  if [ $1 -ne 0 ]
  then
    echo "❌ - ${COLOR_BOLD}${2}${COLOR_RESET} failed"
  else
    echo "✅ - ${COLOR_BOLD}${2}${COLOR_RESET} updated"
  fi
}

if [ -z ${NPM_EXIT_CODE+x} ] && [ -z ${PNPM_EXIT_CODE+x} ] && [ -z ${YARN_EXIT_CODE+x} ]
then
  echo "${COLOR_BOLD}${COLOR_RED}No packages found${COLOR_RESET}"
else
  echo ""

  if [ ! -z ${NPM_EXIT_CODE+x} ]
  then
    printStatusMessage $NPM_EXIT_CODE NPM
  fi

  if [ ! -z ${PNPM_EXIT_CODE+x} ]
  then
    printStatusMessage $PNPM_EXIT_CODE PNPM
  fi

  if [ ! -z ${YARN_EXIT_CODE+x} ]
  then
    printStatusMessage $YARN_EXIT_CODE Yarn
  fi
fi



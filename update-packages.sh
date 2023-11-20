#!/bin/zsh

# Color Variables
COLOR_RESET="\e[0m"
COLOR_BLUE="\e[34m"
COLOR_GREEN="\e[32m"
COLOR_BOLD="\e[1m"

# Misc Variables
FIRST_PRINT=true

printUpdatingMessageFor() {
  if $FIRST_PRINT
  then
    FIRST_PRINT=false
  else
    echo ""
  fi

  echo "${COLOR_BLUE}Updating/upgrading ${COLOR_GREEN}${1}${COLOR_BLUE} packages${COLOR_RESET}"
}

printUpdatingMessageFor "global NPM"
npm update -g && npm upgrade -g
NPM_EXIT_CODE=$?

printUpdatingMessageFor "global PNPM"
pnpm update -g && pnpm upgrade -g
PNPM_EXIT_CODE=$?

printUpdatingMessageFor brew
brew update && brew upgrade
BREW_EXIT_CODE=$?

echo ""

printStatusMessage() {
  if [ $1 -ne 0 ]
  then
    echo "❌ - ${COLOR_BOLD}${2}${COLOR_RESET} failed"
  else
    echo "✅ - ${COLOR_BOLD}${2}${COLOR_RESET} updated"
  fi
}

printStatusMessage $NPM_EXIT_CODE NPM
printStatusMessage $PNPM_EXIT_CODE PNPM
printStatusMessage $BREW_EXIT_CODE Brew

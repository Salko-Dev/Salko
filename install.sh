#!/bin/sh
set -e

# Salko CLI installer
# Installs Salko CLI if not present, authenticates with team key if provided,
# and delegates bundled skill installation to the CLI.

if [ -t 1 ]; then
  BOLD="\033[1m"
  GREEN="\033[32m"
  YELLOW="\033[33m"
  DARK="\033[90m"
  CYAN="\033[36m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  YELLOW=""
  DARK=""
  CYAN=""
  RESET=""
fi

print_ascii() {
  printf '%s\n' \
' ██╗  ██╗ ██████╗ ██████╗ ██╗   ██╗ ███████╗' \
' ██║ ██╔╝██╔═══██╗██╔══██╗██║   ██║ ██╔════╝' \
' █████╔╝ ██║   ██║██║  ██║██║   ██║ ███████╗' \
' ██╔═██╗ ██║   ██║██║  ██║██║   ██║ ╚════██║' \
' ██║  ██╗╚██████╔╝██████╔╝╚██████╔╝ ███████║' \
' ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝  ╚══════╝'

  printf "\n"
  printf "  ${DARK}AI-powered code review from your terminal${RESET}\n"
}

print_success() {
  printf "${GREEN}✓${RESET} %s\n" "$1"
}

print_info() {
  printf "${YELLOW}→${RESET} %s\n" "$1"
}

print_error() {
  printf "${BOLD}Error:${RESET} %s\n" "$1" >&2
}

print_dim() {
  printf "${DARK}%s${RESET}\n" "$1"
}

get_npm_bin() {
  if npm bin -g >/dev/null 2>&1; then
    npm bin -g
    return 0
  fi

  npm_prefix=$(npm prefix -g)
  printf '%s\n' "$npm_prefix/bin"
}

resolve_salko_command() {
  if command -v salko >/dev/null 2>&1; then
    command -v salko
    return 0
  fi

  npm_bin=$(get_npm_bin)
  candidate="$npm_bin/salko"
  if [ -x "$candidate" ]; then
    printf '%s\n' "$candidate"
    return 0
  fi

  return 1
}

TEAM_KEY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --team-key)
      TEAM_KEY="$2"
      shift 2
      ;;
    --team-key=*)
      TEAM_KEY="${1#*=}"
      shift
      ;;
    -h|--help)
      echo "Usage: curl -fsSL <url> | bash -s -- [options]"
      echo ""
      echo "Options:"
      echo "  --team-key <key>  Authenticate with team key after installation"
      echo "  -h, --help        Show this help message"
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

print_ascii
printf "\n"

print_info "Checking Salko CLI installation..."
SALKO_WAS_INSTALLED=0
if command -v salko >/dev/null 2>&1; then
  SALKO_VERSION=$(salko --version 2>/dev/null || echo "unknown")
  print_success "Salko CLI is already installed (${SALKO_VERSION})"
  SALKO_WAS_INSTALLED=1
fi

print_info "Updating Salko CLI..."
if ! command -v npm >/dev/null 2>&1; then
  print_error "npm is required but not installed"
  print_dim "Please install Node.js from https://nodejs.org"
  exit 1
fi

npm install -g @salko-dev/cli

SALKO_BIN=$(resolve_salko_command) || {
  print_error "Unable to find salko after installation. Open a new terminal and try again."
  exit 1
}
SALKO_VERSION=$($SALKO_BIN --version 2>/dev/null || echo "unknown")
if [ "$SALKO_WAS_INSTALLED" -eq 1 ]; then
  print_success "Salko CLI updated successfully (${SALKO_VERSION})"
else
  print_success "Salko CLI installed successfully (${SALKO_VERSION})"
fi

printf "\n"

if [ -n "$TEAM_KEY" ]; then
  print_info "Authenticating with team key..."
  if "$SALKO_BIN" auth team-key --key "$TEAM_KEY"; then
    print_success "Authenticated successfully"
  else
    print_error "Authentication failed"
    exit 1
  fi
  printf "\n"
else
  print_dim "No team key provided. Run later with: salko auth team-key --key <your-key>"
  printf "\n"
fi

print_info "Installing bundled Salko skills..."
"$SALKO_BIN" skills install
print_success "Bundled skills installed"

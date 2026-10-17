#!/usr/bin/env bash
# Install or update the revcenter CLI without prompting: the same installer as
# `curl -fsSL https://revcenter.ai/install.sh | sh`, told not to ask about signing in (the setup
# skill does that next, in a way an agent can relay). Never needs sudo.
set -euo pipefail
version="${1:-latest}"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL https://revcenter.ai/install.sh | REVCENTER_VERSION="$version" REVCENTER_NO_LOGIN=1 sh
else
  npm install --global --no-fund --no-audit "revcenter@$version"
fi

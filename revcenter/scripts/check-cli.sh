#!/usr/bin/env bash
# Session start: is a recent enough `revcenter` on PATH, and is it signed in? Local and quick:
# it reads the version and the saved login, and never signs in or downloads anything. Prints
# nothing when all is well; otherwise one line for the agent, in the shape its harness reads.

script_dir=$(cd -- "$(dirname -- "$0")" && pwd) || exit 0
minimum=$(tr -d '[:space:]' < "$script_dir/../cli-min-version" 2>/dev/null)

at_least() { # at_least <have> <need>: dotted versions, numerically
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -t. -k1,1n -k2,2n -k3,3n | head -1)" = "$2" ]
}

message=
executable=$(command -v revcenter || true)
if [ -z "$executable" ]; then
  message="Revcenter CLI setup required: revcenter is not installed. Use the Revcenter setup skill to install CLI $minimum or newer and sign in before any Revcenter task."
else
  version=$(revcenter --version 2>/dev/null | tr -d '[:space:]')
  if [ -z "$version" ] || ! at_least "$version" "$minimum"; then
    message="Revcenter CLI setup required: revcenter ${version:-?} is older than $minimum. Use the Revcenter setup skill to update it before any Revcenter task."
  elif ! revcenter auth status >/dev/null 2>&1; then
    message="Revcenter is installed but not signed in. Use the Revcenter setup skill to sign in (revcenter auth login --start, then --finish) before any Revcenter task."
  fi
fi
[ -n "$message" ] || exit 0
case "${1:-plain}" in
  claude|codex) printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$message" ;;
  cursor) printf '{"additional_context":"%s"}\n' "$message" ;;
  *) printf '%s\n' "$message" ;;
esac
exit 0

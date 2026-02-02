# logging and 'notify-send' functions
# SJP 2 Feb 2026
#
#
#!/usr/bin/env bash

APP_NAME="$(basename "${0%% *}")"
JOURNAL_TAG="${APP_NAME%%.*}"

notify() {
  local msg="$1"

  # Best-effort: never let notifications break the job.
  # Require a session bus; DISPLAY is optional for many setups.
  if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]] && command -v notify-send >/dev/null 2>&1; then
    notify-send -a "$APP_NAME" "$msg" 2>/dev/null || true
  fi
}

log() {
  local msg="$*"

  # Always log to the journal
  echo "$msg" | systemd-cat -t "$JOURNAL_TAG"

  # Also notify (best-effort)
  notify "$msg"
}

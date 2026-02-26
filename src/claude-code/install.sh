#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"

# Ensure curl is available
if ! command -v curl &>/dev/null; then
    echo "curl not found, installing..."
    if command -v apt-get &>/dev/null; then
        apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
    elif command -v apk &>/dev/null; then
        apk add --no-cache curl ca-certificates
    elif command -v dnf &>/dev/null; then
        dnf install -y curl ca-certificates
    elif command -v yum &>/dev/null; then
        yum install -y curl ca-certificates
    else
        echo "ERROR: Could not install curl – no supported package manager found."
        exit 1
    fi
fi

# Install Claude Code as the remote user (the native installer targets ~/.local/bin/)
REMOTE_USER="${_REMOTE_USER:-root}"
REMOTE_USER_HOME="${_REMOTE_USER_HOME:-$(eval echo "~${REMOTE_USER}")}"

echo "Installing Claude Code ${VERSION} for user ${REMOTE_USER} (home: ${REMOTE_USER_HOME})..."

# Ensure the directories the native installer needs exist and are owned by the target user
mkdir -p "${REMOTE_USER_HOME}/.local/bin" "${REMOTE_USER_HOME}/.local/share" "${REMOTE_USER_HOME}/.claude"
if [ "${REMOTE_USER}" != "root" ]; then
    chown -R "${REMOTE_USER}" "${REMOTE_USER_HOME}/.local" "${REMOTE_USER_HOME}/.claude"
fi

if [ "${REMOTE_USER}" = "root" ]; then
    curl -fsSL https://claude.ai/install.sh | bash -s -- "${VERSION}"
else
    su - "${REMOTE_USER}" -c "curl -fsSL https://claude.ai/install.sh | bash -s -- '${VERSION}'"
fi

# Symlink to /usr/local/bin so claude is on PATH for all users
CLAUDE_BIN="${REMOTE_USER_HOME}/.local/bin/claude"
if [ -f "${CLAUDE_BIN}" ]; then
    ln -sf "${CLAUDE_BIN}" /usr/local/bin/claude
    echo "Symlinked ${CLAUDE_BIN} -> /usr/local/bin/claude"
else
    echo "ERROR: Expected claude binary at ${CLAUDE_BIN} but it was not found."
    exit 1
fi

# Verify
claude --version
echo "Claude Code installed successfully."

#!/usr/bin/env bash

# Check if SSH key exists
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "❌ SSH key not found at $SSH_KEY_PATH"
    echo "🔑 Generate a new SSH key using:"
    echo "    ssh-keygen -t ed25519 -C \"danesh.manoharan@gmail.com\""
    exit 1
fi

# Verify SSH key is readable
if [ ! -r "$SSH_KEY_PATH" ]; then
    echo "❌ SSH key exists but is not readable"
    echo "🔧 Fix permissions using:"
    echo "    chmod 600 $SSH_KEY_PATH"
    exit 1
fi

# Create allowed_signers file if it doesn't exist
ALLOWED_SIGNERS="$HOME/.config/git/allowed_signers"
mkdir -p "$(dirname "$ALLOWED_SIGNERS")"
touch "$ALLOWED_SIGNERS"

# Add new key if it doesn't exist
EMAIL="danesh.manoharan@gmail.com"
NEW_KEY="$(cat ~/.ssh/id_ed25519.pub)"
if ! grep -q "$NEW_KEY" "$ALLOWED_SIGNERS"; then
    echo "$EMAIL namespaces=\"git\" $NEW_KEY" >> "$ALLOWED_SIGNERS"
    echo "✅ Added new key to allowed_signers"
else
    echo "ℹ️  Key already exists in allowed_signers"
fi

# Remove any existing signing configurations
git config --unset gpg.format
git config --unset user.signingkey
git config --unset commit.gpgsign
git config --unset tag.gpgsign

# Set user information
git config user.name "Danesh Manoharan"
git config user.email "$EMAIL"

# Configure SSH signing
git config gpg.format ssh
git config user.signingkey "$(cat ~/.ssh/id_ed25519.pub)"
git config commit.gpgsign true
git config tag.gpgsign true
git config gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS"

# Print configuration status
echo "😃: Username: $(git config --get user.name)"
echo "📧: Email: $(git config --get user.email)"
echo "🔑: Signing key: $(git config --get user.signingkey)"
echo "📝: Signing format: $(git config --get gpg.format)"
echo "✅: Git user configured!"
echo "✅: SSH signing enabled!"
echo "✅: Commit signing: $(git config --get commit.gpgsign)"
echo "✅: Tag signing: $(git config --get tag.gpgsign)"
echo "✅: Allowed signers file: $(git config --get gpg.ssh.allowedSignersFile)"

# Verify SSH agent has the key
if ! ssh-add -l | grep -q "$(ssh-keygen -lf $SSH_KEY_PATH | awk '{print $2}')" ; then
    echo "⚠️  Warning: SSH key not loaded in ssh-agent"
    echo "🔧 Add your key using:"
    echo "    ssh-add $SSH_KEY_PATH"
fi

# Print allowed signers content
echo -e "\n📋 Current allowed signers:"
cat "$ALLOWED_SIGNERS"


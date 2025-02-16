#!/usr/bin/env bash

git config --unset gpg.format # Remove gpg.format if it exists
git config --unset user.signingkey # Remove user.signingkey if it exists
git config --unset commit.gpgsign # Remove commit.gpgsign if it exists
git config --unset tag.gpgsign # Remove tag.gpgsign if it exists

git config user.name "Danesh Manoharan" # Set the username
git config user.email "danesh.manoharan@gmail.com" # Set the email
git config user.signingkey 584F75919B543983 # Set the signing key
git config commit.gpgsign true # Enable commit signing
git config tag.gpgsign true # Enable tag signing

echo "😃: Username: $(git config --get user.name)"
echo "📧: Email: $(git config --get user.email)"
echo "🔑: Signing key: $(git config --get user.signingkey)"
echo "✅: Git user configured!"
echo "✅: GPG signing enabled!"
echo "✅: Commit signing: $(git config --get commit.gpgsign)"
echo "✅: Tag signing: $(git config --get tag.gpgsign)"


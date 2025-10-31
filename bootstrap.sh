#!/bin/bash
#
# Ansible IaC Bootstrap Script
# 実行方法: curl -sL <このスクリプトのURL> | bash
#

set -e

# --- 設定 (ご自身の環境に合わせてください) ---
REPO_URL="https://github.com/neelbauman/workspace-setup.git" # ⬅️ あなたのIaCリポジトリURL
CLONE_DIR="$HOME/workspace-setup"
# ----------------------------------------

echo ">>> 1. (Bootstrap) Installing git and ansible..."

if ! command -v ansible &> /dev/null; then
    sudo apt update
    sudo apt install -y git ansible
else
    echo ">>> (Bootstrap) git and ansible are already installed. Skipping."
fi

echo ">>> 2. (Bootstrap) Cloning/Pulling IaC repository..."

if [ ! -d "$CLONE_DIR" ]; then
    git clone "$REPO_URL" "$CLONE_DIR"
else
    cd "$CLONE_DIR"
    git pull
fi

echo ">>> 3. (Bootstrap) Running Ansible Playbooks..."
cd "$CLONE_DIR"

# sudo (システム) Playbook の実行
# (sudoパスワードを尋ねる)
ansible-playbook -i inventory/hosts.ini playbook-system.yml --ask-become-pass

# ユーザー Playbook の実行
# (Vaultパスワードを尋ねる)
ansible-playbook -i inventory/hosts.ini playbook-user.yml --ask-vault-pass

echo ">>> (Bootstrap) Setup complete! Please reboot or re-login."
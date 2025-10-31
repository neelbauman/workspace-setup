#!/bin/bash
#
# Ansible IaC Bootstrap Script
#
# [重要] 対話的なパスワード入力を求めるため、curl | bash では実行できません。
#
# 実行方法:
# 1. curl -Lo bootstrap.sh <このスクリプトのURL>
# 2. chmod +x bootstrap.sh
# 3. ./bootstrap.sh <ターゲット環境名>
#    例: ./bootstrap.sh chromebook
#

set -e

# --- 設定 ---
REPO_URL="https://github.com/neelbauman/workspace-setup.git" # ⬅️ あなたのIaCリポジトリURL
CLONE_DIR="$HOME/workspace-setup"
# -------------

# --- 引数のチェック ---
if [ -z "$1" ]; then
    echo "!!! ERROR: ターゲット環境が指定されていません。"
    echo "!!! 使い方: $0 <ターゲット環境名>"
    echo "!!! 例: $0 chromebook"
    exit 1
fi
TARGET_ENV=$1
TARGET_DIR="$CLONE_DIR/$TARGET_ENV"
# ---------------------

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

echo ">>> 3. (Bootstrap) Validating target environment '$TARGET_ENV'..."

if [ ! -d "$TARGET_DIR" ]; then
    echo "!!! ERROR: 指定されたターゲットのディレクトリが見つかりません: $TARGET_DIR"
    exit 1
fi

echo ">>> 4. (Bootstrap) Running Ansible Playbooks for '$TARGET_ENV'..."
# ターゲット環境のディレクトリに移動して実行
cd "$TARGET_DIR"

# sudo (システム) Playbook の実行
# (sudoパスワードを尋ねる)
# (注: inventory/ や playbook-*.yml は $TARGET_DIR の相対パスになります)
ansible-playbook -i inventory/hosts.ini playbook-system.yml --ask-become-pass

# ユーザー Playbook の実行
# (Vaultパスワードを尋ねる)
ansible-playbook -i inventory/hosts.ini playbook-user.yml --ask-vault-pass

echo ">>> (Bootstrap) Setup complete for '$TARGET_ENV'!"
```

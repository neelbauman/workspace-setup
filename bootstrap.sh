#!/bin/bash
#
# Ansible IaC Playbook Runner
#
# このスクリプトは、git と ansible がインストールされ、
# リポジトリがクローンされた後に実行します。
#
# 使い方:
# ./bootstrap.sh <ターゲット環境名>
#    例: ./bootstrap.sh chromebook
#    例: ./bootstrap.sh server
#

set -e

# --- 引数のチェック ---
if [ -z "$1" ]; then
    echo "!!! ERROR: ターゲット環境が指定されていません。"
    echo "!!! 使い方: $0 <ターゲット環境名>"
    echo "!!! 例: $0 chromebook"
    exit 1
fi

TARGET_ENV=$1
# スクリプト自身の場所（リポジトリのルート）を基準にする
BASE_DIR=$(dirname "$0")
TARGET_DIR="$BASE_DIR/$TARGET_ENV"

# ---------------------

echo ">>> 1. (Bootstrap) Validating target environment '$TARGET_ENV'..."

if [ ! -d "$TARGET_DIR" ]; then
    echo "!!! ERROR: 指定されたターゲットのディレクトリが見つかりません: $TARGET_DIR"
    exit 1
fi

echo ">>> 2. (Bootstrap) Running Ansible Playbooks for '$TARGET_ENV'..."
# ターゲット環境のディレクトリに移動して実行
cd "$TARGET_DIR"

# sudo (システム) Playbook の実行
# (sudoパスワードを尋ねる)
ansible-playbook -i inventory/hosts.ini playbook-system.yml --ask-become-pass

# ユーザー Playbook の実行
# (Vaultパスワードを尋ねる)
ansible-playbook -i inventory/hosts.ini playbook-user.yml --ask-vault-pass

echo ">>> (Bootstrap) Setup complete for '$TARGET_ENV'!"
```

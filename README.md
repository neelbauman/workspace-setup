## 🚀 実行フロー

1.  **準備:**

    1.  上記ファイル群でセットアップ用ディレクトリ（例: `dev`）を作成し、GitHubにPushします。
    2.  `vars/main.yml` の `target_user` を編集します。
    3.  `vars/secrets.yml.template` を `vars/secrets.yml` にコピーして機密情報を書き、`ansible-vault encrypt vars/secrets.yml` で暗号化します。（Vaultパスワードを覚えます）
    4.  変更をコミット＆プッシュします。

2.  **新しいLinux環境での実行:**

    1.  まっさらなDebian/Ubuntuにログインします。
    2.  `bootstrap.sh` のURLを指定してファイルを取得します。
        ```bash
        curl -sL https://github.com/neelbauman/workspace-setup/main/bootstrap.sh
        ```
    2.  `vars/main.yml` の `target_user` を編集します。
    3.  `vars/secrets.yml.template` を `vars/secrets.yml` にコピーして機密情報を書き、`ansible-vault encrypt vars/secrets.yml` で暗号化します。（Vaultパスワードを覚えます）
    3.  以下の
        ```bash
        cd workspace-setup && ./bootstrap.sh chromebook
        ```
    4.  `sudo`のパスワードを1回、Vaultのパスワードを1回入力します。
    5.  Ansibleが実行され、すべての設定が自動的に行われます。

3.  **完了:**

    1.  `bootstrap.sh` が完了したら、システムを再起動します。
    2.  （初回のみ）`fcitx5-configtool` を起動し、Mozcが有効になっているか確認します。
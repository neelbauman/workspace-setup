# Workspace Setup (ワークスペース設定)

## 概要

このリポジトリは、Ansibleを使用して個人のLinux（Debian/Ubuntu/ChromeOS）ワークスペース環境を構築・管理するためのIaC（Infrastructure as Code）プロジェクトです。

パッケージのインストール、設定ファイル（Dotfiles）の配置、機密情報の管理までを自動化します。

## 重要な設計

このリポジトリは、`workspace-setup/` の下に `chromebook/` や `desktop/` のようなターゲット環境ごとのディレクトリを持つ構成を想定しています。

`bootstrap.sh` スクリプトは、リポジトリの**ルート**に配置され、指定されたターゲット環境（例: `chromebook`）のAnsible Playbookを実行するための**実行ランナー**として機能します。

**注意:** Ansibleが `sudo` や `vault` のパスワードを対話的に要求するため、`curl | bash` のような非対話的な実行はサポートしていません。

---

## 1. 必須の前提条件 (Prerequisites)

セットアップを開始する前に、ターゲットのマシンに **`git`** と **`ansible`** がインストールされている必要があります。

```bash
# パッケージリストを更新
sudo apt update

# git と ansible をインストール
sudo apt install git ansible
````

-----

## 2\. 🚀 セットアップ手順 (Getting Started)

前提条件が完了したら、以下の手順でセットアップを実行します。

### ステップ 1: リポジトリのクローン

このリポジトリをローカルにクローンし、ディレクトリに移動します。

```bash
git clone https://github.com/neelbauman/workspace-setup.git
cd workspace-setup
```

### ステップ 2: ターゲット環境の設定

実行したいターゲット環境（例: `chromebook`）のディレクトリ内で、変数と機密情報を設定します。

#### A. 一般変数の設定

1.  対象のディレクトリに移動します。
    ```bash
    cd chromebook
    ```
2.  `vars/main.yml` をエディタで開き、必要に応じて Ansible が理解するカスタム変数を設定します。
    ```yaml:vars/main.yml
    # ⬅️ 必要があれば、このように変数を定義します。
    ---
    target_user: "your_username"
    ```

#### B. 機密情報の設定 (Ansible Vault)

1.  機密情報のテンプレート（`.example`）をコピーして、実際のファイルを作成します。
    ```bash
    cp vars/secrets.yml.example vars/secrets.yml
    ```
2.  `vars/secrets.yml` をエディタで開き、実際の機密情報（APIキーなど）を書き込みます。
    ```bash
    nano vars/secrets.yml
    ```
3.  ファイルを `ansible-vault` で暗号化します。
    ```bash
    ansible-vault encrypt vars/secrets.yml
    ```
4.  Vaultの暗号化/復号に使う「**Vaultパスワード**」を設定し、これを覚えておきます。

### ステップ 3: セットアップの実行

機密情報の準備が完了したら、リポジトリの**ルートディレクトリ**に戻り、`bootstrap.sh` を実行します。

```bash
# ルートディレクトリに戻る
cd ..

# bootstrap.sh を実行（引数でターゲットを指定）
./bootstrap.sh chromebook
```

### ステップ 4: パスワードの入力

スクリプトを実行すると、Ansibleが対話的にパスワードを要求します。

1.  `BECOME password:` と聞かれたら、あなたの **`sudo` パスワード**を入力します。
2.  `Vault password:` と聞かれたら、ステップ2-Bで設定した「**Vaultパスワード**」を入力します。

入力後、Ansibleがすべての設定（パッケージのインストール、環境変数の設定など）を自動的に行います。

-----

## 3\. 完了 (Completion)

`bootstrap.sh` が `complete!` と表示して終了したら、以下の作業を行ってください。

1.  **システムを再起動します。**
    ```bash
    sudo reboot
    ```
2.  **（初回のみ）日本語入力の確認:**
    再ログイン後、`fcitx5-configtool` をターミナルで起動し、「入力メソッド」タブの右側リストに「Mozc」が追加されていることを確認してください。（通常は自動で設定されています）

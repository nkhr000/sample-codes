# GitHub ActionによるS3デプロイ

https://docs.github.com/en/actions

## 前提準備

- GithubのOrganizationを設定
  - [+]から[New Organization]を選んで作成
- Organizationを利用しない場合（個人リポジトリ）は、オーナーであれば実行可能
  - CloudformationのGithubOrgにはユーザ名を設定する

## Github Actionの有効化

[Repository] > [Settings] > [Actions]の設定

## thumbprintの確認

自分で確認する場合は以下の手順で確認できる

```
$ openssl s_client -servername token.actions.githubusercontent.com -showcerts -connect token.actions.githubusercontent.com:443

## 出力される文字列の一番下の証明書の[-----BEGIN CERTIFICATE-----]から[-----END CERTIFICATE-----]をcertificate.crtに保存
```

```
$ openssl x509 -in certificate.crt -fingerprint -noout | cut -f2 -d'=' | tr -d ':' | tr '[:upper:]' '[:lower:]'
6938fd4d98bab03faadb97b34396831e3780aea1

$ openssl x509 -noout -dates -in certificate.crt
notBefore=Sep 24 00:00:00 2020 GMT
notAfter=Sep 23 23:59:59 2030 GMT
```

## CloudformationでOIDCProviderとROLEを作成

cfn_iam_creation.yml 
  

# workflow作成

## フォルダを作成

対象のリポジトリ内に「`.github/workflows`」フォルダを作成し、その配下にワークフローファイルを格納する

## Environment設定

ワークフローのYamlファイル内に直接記載したくないシークレットやそれに付随する情報（ロール名や、バケット名）を環境変数としてGitHubのシステム側に設定する

[Settings] > [Environments] > [New environment]

Environmentでは以下の4つを指定可能

1. 保護ルール
   - プロセスを進めるための必須レビュー者
   - 待機タイマー（プロセス開始までの待ち時間）
2. 対象ブランチ制御
   - Workflowの対象とするブランチを制限可能
3. 環境シークレット
   - https://docs.github.com/ja/actions/security-guides/encrypted-secrets

## Workflowを作る

- actions/checkout@v3
  - checkoutという機能のv3タグのリリースを利用するということ
  - https://github.com/actions/checkout
- aws-actions/configure-aws-credentials
  - https://github.com/aws-actions/configure-aws-credentials
- actions/setup-python@v3
  - https://github.com/actions/setup-python

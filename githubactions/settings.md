## GitHub ActionによるS3デプロイ

https://docs.github.com/en/actions

### 前提準備

- GithubのOrganizationを設定（個人で実施している場合）
  - [+]から[New Organization]を選んで作成

### Github Actionの有効化

[Repository] > [Settings] > [Actions]の設定

### thumbprintの確認

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

### CloudformationでOIDCProviderとROLEを作成

cfn_iam_creation.yml


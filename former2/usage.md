### What is Former2

作成済みのAWSリソースからCloudformationコードを生成してくれるサービス  
ローカルのDockerでも実行可能
 
  
### 実行手順

1. ソースコードをCloneする

```
git clone https://github.com/iann0036/former2
```

2. コンテナを起動する

```
cd former2
docker-compose up -d
```

3. Switch Roleを利用している場合はAssume Roleコマンドで一時クレデンシャルを取得

```
aws sts assume-role --role-arn arn:aws:iam::${AccountId}:role/${rolename} --role-session-name "RoleSession1"
```

4. ブラウザでアクセス
http://127.0.0.1:80
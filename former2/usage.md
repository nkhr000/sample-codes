### What is Former2

作成済みのAWSリソースからCloudformationコードを生成してくれるサービス  
ローカルのDockerでも実行可能

### 事前準備

1. Dockerのインストール

```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce
sudo apt install docker-compose


sudo usermod -aG docker $USER
sudo visudo
<末尾に追加>
%docker ALL=(ALL)  NOPASSWD: /usr/sbin/service docker start

vim ~/.bashrc
<末尾に追加>
if [ $(service docker status | awk '{print $4}') = "not" ]; then
  sudo service docker start > /dev/null
fi

<powershell側で実行>
wsl --shutdown
<wsl:ubuntu側で実行>
sudo service docker status

sudo apt install awscli
```
  
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
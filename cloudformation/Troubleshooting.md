# Cloudformationリソースエラーの対処

## EC2
### cfn-signalが時間内に完了できずエラー

1. `DeletionPolicy: Retain`に変更する（作成失敗時に自動削除しない）
2. SSMまたはSSHで、インスタンスに接続する
3. Cloudformationの実行ログを確認し、エラー原因を調査する
   - `/var/log/cfn-init.log` : Cloudformation init実行ログ
   - `/var/log/cloud-init-output.log`　:UserDataの実行ログ（UserData部分の実行エラーはこちらを見た方がわかりやすい）

## Kinesis Data Firehouse設定

### 設定パラメータ（例）

- Source: DirectPut
- Destination: Amazon S3
- Delivery stream name: PUT-S3-Test
- S3 bucket prefix
  - Glue Crawlerでメタデータを取得するログはパーティションを設定しておくとよい
  - `<prefix>/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/`
  - `<errPrefix>/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/!{firehose:error-output-type}`
- S3 buffer hints
  - S3への出力について、どの程度バッファして（まとめて）書き出すかの設定
  - Buffer size: Minimum 1 MiB, maximum 128 MiB (2022/07時点)
  - Buffer interval: Minimum 60 seconds, maximum 900  (2022/07時点)
- S3 compression and encryption: GZIP

## 実行環境

### boto3 install

```
pipenv install boto3
```

### 実行方法

```
## python firehouse-put-data.py <Firehouseストリーム名> <レコード数>
## ※<レコード数>の指定がない場合は10レコードとする

python firehouse-put-data.py PUT-S3-Test 20
```


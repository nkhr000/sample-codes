## Official Site

https://www.mkdocs.org/

## install

```
pipenv install mkdocs
pipenv shell

mkdocs --version
```

### 新規プロジェクト作成

```
mkdocs new infra
```

- 自動作成されるフォルダ構成
  - infra/
    - docs/
      - index.md
    - mkdocs.yaml

### ドキュメントサーバの起動

```
mkdocs serve
```

### デプロイ用コンテンツ作成

`site`フォルダの作成

```
mkdocs build --clean
```


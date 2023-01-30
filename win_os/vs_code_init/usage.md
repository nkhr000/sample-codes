### VS Codeの拡張機能の移行方法

1. VS Codeのsetting.jsonをコピーし、移行先PCの指定フォルダに配置
   - Windows OS: `C:\Users\<username>\AppData\Roaming\Code\User\setting.json`
   - Mac OSX: `~/Library/Application Support/Code/User/setting.json`
2. VS Codeの拡張機能一覧をファイルにExportし、移行先PCの指定フォルダに配置
   - `code --list-extensions > vscode_extensions.txt`
3. `vs_code_copy.bat`を移行先PCの指定フォルダに配置し、実行


VS Codeの設定は以下のURLも参考
https://dev.classmethod.jp/articles/20211008-vscode-extention-settings/

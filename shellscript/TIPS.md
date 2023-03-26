ShellScript Tips
-------

## Set Options

### Debugging Mode

setで`-x`を設定することでデバックモードで実行できる 
実行したコマンドを全てターミナルに表示する

```
#!/bin/bash

set -x
```

### Exit Immediately

コマンドやスクリプトが失敗した際に、即座に処理を終了する

```
set -e
```
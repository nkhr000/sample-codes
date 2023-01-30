## Windows Settings


### install pyenv 

```
choco install gsudo
choco install jq
choco install terraform
choco install pyenv-win

pyenv install -l
pyenv install 3.9.6
pyenv local 3.9.6
pyenv global 3.9.6
```

- pyenvのインストールパスはPATHの上位に設定する
  - `C:\Users\<Username>\.pyenv\pyenv-win\bin`


### install pipenv

```
pip install pipenv
```

- PYTHONSCRIPT_HOME=`C:\Users\<Username>\.pyenv\pyenv-win\versions\<version>\Scripts`
- PIPENV_VENV_IN_PROJECT=true
  - カレントフォルダ配下に.venvフォルダを作る設定



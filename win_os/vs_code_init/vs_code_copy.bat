copy /Y .\settings.json %APPDATA%\Code\User\settings.json
for /f %%n in (vscode_extensions.txt) do (
    code --install-extension %%n
)

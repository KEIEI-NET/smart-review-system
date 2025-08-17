@echo off
REM Smart Review System v2 - Windows用自動セットアップスクリプト
REM バージョン: v1.0.0
REM 最終更新: 2025年08月17日

setlocal enabledelayedexpansion

REM カラーコード設定（Windows 10以降）
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM ロゴ表示
echo %BLUE%
echo ╔════════════════════════════════════════════════════╗
echo ║     Smart Review System v2 - Setup Script         ║
echo ║                  for Windows                      ║
echo ╚════════════════════════════════════════════════════╝
echo %NC%
echo.

echo 🚀 セットアップを開始します...
echo.

REM 環境チェック
echo 📋 環境チェックを開始...
echo.

REM Node.js チェック
where node >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo %GREEN%✅ Node.js !NODE_VERSION! ✓%NC%
) else (
    echo %RED%❌ Node.jsがインストールされていません%NC%
    echo   インストール: https://nodejs.org/
    goto :error
)

REM npm チェック
where npm >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo %GREEN%✅ npm v!NPM_VERSION! ✓%NC%
) else (
    echo %RED%❌ npmがインストールされていません%NC%
    goto :error
)

REM Git チェック
where git >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%i in ('git --version') do set GIT_VERSION=%%i
    echo %GREEN%✅ Git v!GIT_VERSION! ✓%NC%
) else (
    echo %RED%❌ Gitがインストールされていません%NC%
    echo   インストール: https://git-scm.com/
    goto :error
)

REM Claude CLI チェック
where claude >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Claude CLI インストール済み ✓%NC%
) else (
    echo %YELLOW%⚠️ Claude CLIがインストールされていません%NC%
    echo   インストール: npm install -g @anthropic/claude-code
    echo   または: https://claude.ai/code
)

echo.

REM ディレクトリ作成
echo ℹ️ ディレクトリ構造を作成中...

REM グローバルディレクトリ
if not exist "%USERPROFILE%\.claude\commands" mkdir "%USERPROFILE%\.claude\commands"
if not exist "%USERPROFILE%\.claude\agents" mkdir "%USERPROFILE%\.claude\agents"

REM ローカルディレクトリ
if not exist ".claudecode\commands" mkdir ".claudecode\commands"
if not exist ".claudecode\logs" mkdir ".claudecode\logs"

echo %GREEN%✅ ディレクトリ作成完了%NC%

REM 依存関係インストール
echo ℹ️ 依存関係をインストール中...

if exist "package.json" (
    call npm install --silent
    if !errorlevel! equ 0 (
        echo %GREEN%✅ npm パッケージインストール完了%NC%
    ) else (
        echo %RED%❌ npm インストールエラー%NC%
        goto :error
    )
) else (
    echo %RED%❌ package.json が見つかりません%NC%
    goto :error
)

REM スラッシュコマンド登録
echo ℹ️ スラッシュコマンドを登録中...

if exist "register-slash-command-v2.js" (
    node register-slash-command-v2.js >nul 2>&1
    echo %GREEN%✅ スラッシュコマンド登録完了%NC%
) else (
    echo %YELLOW%⚠️ register-slash-command-v2.js が見つかりません%NC%
)

REM エージェントインストール
echo ℹ️ Claude Code エージェントをインストール中...

if exist "install-agents.js" (
    node install-agents.js >nul 2>&1
    echo %GREEN%✅ エージェントインストール完了%NC%
) else (
    echo %YELLOW%⚠️ install-agents.js が見つかりません%NC%
)

REM 設定ファイル作成
echo ℹ️ 設定ファイルを作成中...

if not exist ".smart-review.json" (
    (
        echo {
        echo   "version": "2.1.0",
        echo   "scope": "changes",
        echo   "maxIterations": 3,
        echo   "autoFix": true,
        echo   "reviewAgents": [
        echo     "security-error-xss-analyzer",
        echo     "super-debugger-perfectionist",
        echo     "deep-code-reviewer"
        echo   ],
        echo   "security": {
        echo     "enablePathValidation": true,
        echo     "enableCommandSanitization": true,
        echo     "maxFileSize": 10485760,
        echo     "timeout": 120000
        echo   }
        echo }
    ) > .smart-review.json
    echo %GREEN%✅ プロジェクト設定ファイル作成完了%NC%
) else (
    echo ℹ️ プロジェクト設定ファイルは既に存在します
)

REM グローバル設定
if not exist "%USERPROFILE%\.claude\smart-review.json" (
    copy .smart-review.json "%USERPROFILE%\.claude\smart-review.json" >nul
    echo %GREEN%✅ グローバル設定ファイル作成完了%NC%
) else (
    echo ℹ️ グローバル設定ファイルは既に存在します
)

REM テスト実行
echo ℹ️ システムテストを実行中...

call npm test >nul 2>&1
if !errorlevel! equ 0 (
    echo %GREEN%✅ 全テスト合格%NC%
) else (
    echo %YELLOW%⚠️ 一部のテストが失敗しました（通常は問題ありません）%NC%
)

REM インストール検証
echo ℹ️ インストールを検証中...
echo.

if exist "%USERPROFILE%\.claude\commands\smart-review-v2.js" (
    echo %GREEN%✅ smart-review-v2.js インストール済み%NC%
) else (
    echo %RED%❌ smart-review-v2.js が見つかりません%NC%
)

if exist "%USERPROFILE%\.claude\commands\smart-review-config.js" (
    echo %GREEN%✅ smart-review-config.js インストール済み%NC%
) else (
    echo %RED%❌ smart-review-config.js が見つかりません%NC%
)

REM エージェント数確認
set AGENT_COUNT=0
for %%f in ("%USERPROFILE%\.claude\agents\*") do set /a AGENT_COUNT+=1
if !AGENT_COUNT! gtr 0 (
    echo %GREEN%✅ !AGENT_COUNT! 個のエージェントがインストール済み%NC%
) else (
    echo %YELLOW%⚠️ エージェントが見つかりません%NC%
)

echo.
echo %GREEN%════════════════════════════════════════════════════%NC%
echo %GREEN%🎉 セットアップが完了しました！%NC%
echo %GREEN%════════════════════════════════════════════════════%NC%
echo.
echo 📝 使用方法:
echo   1. Claude CLIを起動: claude
echo   2. スラッシュコマンドを実行: /smart-review
echo.
echo 📚 詳細は INSTALLATION_GUIDE.md を参照してください
echo.

pause
exit /b 0

:error
echo.
echo %RED%❌ セットアップに失敗しました%NC%
echo 上記のエラーを解決してから再度実行してください
echo.
pause
exit /b 1
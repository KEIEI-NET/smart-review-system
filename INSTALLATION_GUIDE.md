# インストールガイド

*バージョン: v1.0.0*
*最終更新: 2025年08月17日 16:30 JST*

このガイドでは、Smart Review System v2を新しいPCにインストールする手順を詳しく説明します。

## 📋 目次

1. [前提条件](#前提条件)
2. [クイックスタート](#クイックスタート)
3. [詳細インストール手順](#詳細インストール手順)
4. [トラブルシューティング](#トラブルシューティング)
5. [アンインストール](#アンインストール)

## 前提条件

### 必須要件
- **Node.js**: v18.0.0以上（推奨: v20.0.0以上）
- **npm**: v8.0.0以上
- **Git**: v2.30.0以上
- **Claude CLI**: v1.0.83以上

### OS別要件
- **Windows**: Windows 10/11、Git Bash推奨
- **macOS**: macOS 12.0以上
- **Linux**: Ubuntu 20.04以上、または同等のディストリビューション

## クイックスタート

30秒でインストールを完了させる最速手順：

```bash
# 1. リポジトリのクローン
git clone https://github.com/[your-username]/smart-review-system.git
cd smart-review-system

# 2. 依存関係のインストールと初期設定
npm install && npm run init

# 3. 動作確認
npm test
```

インストール完了！ `/smart-review` コマンドがClaude CLIで使用可能になります。

## 詳細インストール手順

### ステップ1: 環境確認

```bash
# Node.jsバージョン確認
node --version
# 出力例: v20.11.0

# npmバージョン確認
npm --version
# 出力例: v10.2.4

# Gitバージョン確認
git --version
# 出力例: git version 2.43.0

# Claude CLIインストール確認
claude --version
# 出力例: 1.0.83 (Claude Code)
```

⚠️ **Claude CLIがインストールされていない場合:**
```bash
# npmでインストール
npm install -g @anthropic/claude-code

# または公式サイトからダウンロード
# https://claude.ai/code
```

### ステップ2: リポジトリの取得

```bash
# HTTPSでクローン（推奨）
git clone https://github.com/[your-username]/smart-review-system.git

# またはSSHでクローン
git clone git@github.com:[your-username]/smart-review-system.git

# ディレクトリに移動
cd smart-review-system
```

### ステップ3: 依存関係のインストール

```bash
# package.jsonから依存関係をインストール
npm install

# インストールされるパッケージ:
# - eslint: コード品質チェック
# - eslint-plugin-security: セキュリティ脆弱性検出
# - その他の開発ツール
```

### ステップ4: 初期設定の実行

```bash
# 自動初期設定スクリプトの実行
npm run init

# このスクリプトは以下を実行します:
# 1. ディレクトリ構造の作成
# 2. スラッシュコマンドの登録
# 3. Claude Codeエージェントのインストール
# 4. 設定ファイルの生成
# 5. 初期テストの実行
```

**手動設定が必要な場合:**

```bash
# 1. ディレクトリ作成
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
mkdir -p .claudecode/commands

# 2. スラッシュコマンドの登録
node register-slash-command-v2.js

# 3. エージェントのインストール
node install-agents.js

# 4. 設定ファイルの確認
npm run validate-config
```

### ステップ5: インストールの検証

```bash
# システムテストの実行
npm test

# 期待される出力:
# ✅ SecurityUtils: 全テスト合格
# ✅ FileOperations: 全テスト合格
# ✅ 統合テスト: 全テスト合格
```

```bash
# スラッシュコマンドの確認
node test-slash-command.js

# 期待される出力:
# ✅ smart-review-v2.js (64.33 KB)
# ✅ smart-review-config.js (12.45 KB)
# ✅ 10個のエージェントがインストール済み
```

### ステップ6: Claude CLIでの使用

Claude CLIセッションを開始して、以下のコマンドを使用：

```bash
# Claude CLIを起動
claude

# スラッシュコマンドを実行
/smart-review          # 対話式メニュー
/smart-review --help   # ヘルプ表示
/smart-review --test   # システムテスト
```

## 設定のカスタマイズ

### グローバル設定
`~/.claude/smart-review.json`:
```json
{
  "version": "2.1.0",
  "agents": {
    "enabled": true,
    "timeout": 120000
  },
  "security": {
    "enablePathValidation": true,
    "enableCommandSanitization": true
  }
}
```

### プロジェクト設定
`.smart-review.json`:
```json
{
  "scope": "changes",
  "maxIterations": 3,
  "autoFix": true,
  "reviewAgents": [
    "security-error-xss-analyzer",
    "super-debugger-perfectionist",
    "deep-code-reviewer"
  ]
}
```

## トラブルシューティング

### 問題1: Claude CLIがコマンドを認識しない

**症状:** `/smart-review` コマンドが "Unknown command" エラーを返す

**解決方法:**
```bash
# コマンドの再登録
node register-slash-command-v2.js

# Claude CLIの再起動
# Ctrl+C で終了後、再度起動
claude
```

### 問題2: エージェントが見つからない

**症状:** "Agent not found" エラー

**解決方法:**
```bash
# エージェントの再インストール
npm run install-agents

# インストール確認
npm run list-agents
```

### 問題3: パーミッションエラー（Windows）

**症状:** "EPERM: operation not permitted" エラー

**解決方法:**
```bash
# 管理者権限でコマンドプロンプトを起動
# または PowerShell を管理者として実行

# Git Bashの使用を推奨
# MINGW64環境で実行
```

### 問題4: Node.jsバージョンの不一致

**症状:** "Unsupported Node.js version" エラー

**解決方法:**
```bash
# nvmを使用してNode.jsバージョンを管理
nvm install 20.11.0
nvm use 20.11.0

# または直接Node.jsをアップデート
# https://nodejs.org/
```

## アンインストール

システムを完全に削除する場合：

```bash
# 1. スラッシュコマンドの削除
npm run unregister

# 2. エージェントの削除
npm run uninstall-agents

# 3. グローバル設定の削除
rm -rf ~/.claude/commands/smart-review*
rm -rf ~/.claude/agents/*
rm -f ~/.claude/smart-review.json

# 4. プロジェクトディレクトリの削除
cd ..
rm -rf smart-review-system
```

## サポート

問題が解決しない場合は、以下の方法でサポートを受けられます：

1. **GitHub Issues**: [https://github.com/[your-username]/smart-review-system/issues](https://github.com/)
2. **ドキュメント**: `README.md` および `CLAUDE.md` を参照
3. **ログファイル**: `.claudecode/logs/` ディレクトリを確認

---

*最終更新: 2025年08月17日 16:30 JST*
*バージョン: v1.0.0*

**更新履歴:**
- v1.0.0 (2025年08月17日): 初版作成、詳細なインストール手順を文書化
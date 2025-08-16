# Changelog

すべての注目すべき変更は、このファイルに記録されます。

このプロジェクトは[Semantic Versioning](https://semver.org/spec/v2.0.0.html)に準拠しています。

## [2.1.1] - 2025-08-16

### セキュリティ
- **ReDoS脆弱性の修正**: `lib/common-utils.js`で正規表現パターンに長さ制限を追加
- **パストラバーサル攻撃対策**: 全ファイルでファイル名検証とパス検証を強化
  - `register-slash-command-v2.js`: エイリアス作成時の検証追加
  - `smart-updater.js`: ファイル名のサニタイズ処理追加
  - `install-agents.js`: ファイル名の安全性チェック追加
- **コマンドインジェクション対策**: `lib/common-utils.js`で危険パターンの検出を強化
- **エラーメッセージサニタイズ**: 全ファイルでエラー出力時にSecurityUtils.sanitizeError()を使用

### 修正
- **メモリリーク対策**: `smart-updater.js`でバッチ処理と定期的なGC実行を追加
- **ファイル競合問題**: `register-slash-command-v2.js`で並列処理を順次処理に変更
- **ファイルサイズ制限**: 10MB以上のファイル操作を制限

### 追加
- **LICENSEファイル**: MITライセンスファイルを追加（README.mdとpackage.jsonの矛盾解消）

### 変更
- エラーハンドリングの改善: 全体的にセキュアなエラーハンドリングを実装

## [2.1.0] - 2025-08-14

### 追加
- 共通ユーティリティモジュール (`lib/common-utils.js`)
  - SecurityUtils: パス検証、サニタイズ、ハッシュ計算
  - FileOperations: アトミック操作、バックアップ機能
  - VersionUtils: セマンティックバージョニング管理
  - SystemUtils: プラットフォーム情報、JST時刻
  - ErrorHandler: エラー処理とログ記録
  - ConfigUtils: 設定ファイル管理

### 変更
- 全モジュールで共通ユーティリティを使用するようリファクタリング
- DRY原則に従い重複コードを削減

### テスト
- 単体テスト追加 (`test/common-utils.test.js`)
- 統合テスト追加 (`test/integration.test.js`)

## [2.0.0] - 2025-08-13

### 追加
- Smart Review v2.0システムの初期リリース
- Claude Code CLIスラッシュコマンド登録機能
- 5つのClaude Codeエージェント統合
- インタラクティブメニューシステム
- 自動更新機能（SmartUpdater）

### セキュリティ
- コマンドインジェクション防止（execFile使用）
- パストラバーサル攻撃防止
- XSS防止（HTMLエスケープ）
- サンドボックス化されたエージェント実行

---

*最終更新: 2025年08月16日 17:30 JST*
*バージョン: v2.1.1*
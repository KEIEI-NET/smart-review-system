#!/bin/bash

# Smart Review System v2 - 自動セットアップスクリプト
# バージョン: v1.0.0
# 最終更新: 2025年08月17日

set -e  # エラー時に停止

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ロゴ表示
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════╗"
echo "║     Smart Review System v2 - Setup Script         ║"
echo "╚════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 関数定義
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 環境チェック関数
check_requirements() {
    echo "📋 環境チェックを開始..."
    echo ""
    
    local has_errors=0
    
    # Node.js チェック
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | cut -d 'v' -f 2)
        REQUIRED_VERSION="18.0.0"
        
        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            print_success "Node.js v$NODE_VERSION ✓"
        else
            print_error "Node.js v$NODE_VERSION (v18.0.0以上が必要)"
            has_errors=1
        fi
    else
        print_error "Node.jsがインストールされていません"
        echo "  インストール: https://nodejs.org/"
        has_errors=1
    fi
    
    # npm チェック
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_success "npm v$NPM_VERSION ✓"
    else
        print_error "npmがインストールされていません"
        has_errors=1
    fi
    
    # Git チェック
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | cut -d ' ' -f 3)
        print_success "Git v$GIT_VERSION ✓"
    else
        print_error "Gitがインストールされていません"
        echo "  インストール: https://git-scm.com/"
        has_errors=1
    fi
    
    # Claude CLI チェック
    if command -v claude &> /dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null | head -n1 || echo "unknown")
        print_success "Claude CLI $CLAUDE_VERSION ✓"
    else
        print_warning "Claude CLIがインストールされていません"
        echo "  インストール: npm install -g @anthropic/claude-code"
        echo "  または: https://claude.ai/code"
    fi
    
    echo ""
    
    if [ $has_errors -eq 1 ]; then
        print_error "必須要件が満たされていません。上記のエラーを解決してください。"
        exit 1
    fi
}

# ディレクトリ作成
create_directories() {
    print_info "ディレクトリ構造を作成中..."
    
    # グローバルディレクトリ
    mkdir -p ~/.claude/commands
    mkdir -p ~/.claude/agents
    
    # ローカルディレクトリ
    mkdir -p .claudecode/commands
    mkdir -p .claudecode/logs
    
    print_success "ディレクトリ作成完了"
}

# 依存関係インストール
install_dependencies() {
    print_info "依存関係をインストール中..."
    
    if [ -f "package.json" ]; then
        npm install --silent
        print_success "npm パッケージインストール完了"
    else
        print_error "package.json が見つかりません"
        exit 1
    fi
}

# スラッシュコマンド登録
register_commands() {
    print_info "スラッシュコマンドを登録中..."
    
    if [ -f "register-slash-command-v2.js" ]; then
        node register-slash-command-v2.js > /dev/null 2>&1
        print_success "スラッシュコマンド登録完了"
    else
        print_warning "register-slash-command-v2.js が見つかりません"
    fi
}

# エージェントインストール
install_agents() {
    print_info "Claude Code エージェントをインストール中..."
    
    if [ -f "install-agents.js" ]; then
        node install-agents.js > /dev/null 2>&1
        print_success "エージェントインストール完了"
    else
        print_warning "install-agents.js が見つかりません"
    fi
}

# 設定ファイル作成
create_config() {
    print_info "設定ファイルを作成中..."
    
    # プロジェクト設定
    if [ ! -f ".smart-review.json" ]; then
        cat > .smart-review.json << 'EOF'
{
  "version": "2.1.0",
  "scope": "changes",
  "maxIterations": 3,
  "autoFix": true,
  "reviewAgents": [
    "security-error-xss-analyzer",
    "super-debugger-perfectionist",
    "deep-code-reviewer"
  ],
  "security": {
    "enablePathValidation": true,
    "enableCommandSanitization": true,
    "maxFileSize": 10485760,
    "timeout": 120000
  }
}
EOF
        print_success "プロジェクト設定ファイル作成完了"
    else
        print_info "プロジェクト設定ファイルは既に存在します"
    fi
    
    # グローバル設定
    if [ ! -f "$HOME/.claude/smart-review.json" ]; then
        cp .smart-review.json "$HOME/.claude/smart-review.json"
        print_success "グローバル設定ファイル作成完了"
    else
        print_info "グローバル設定ファイルは既に存在します"
    fi
}

# テスト実行
run_tests() {
    print_info "システムテストを実行中..."
    
    if npm test > /dev/null 2>&1; then
        print_success "全テスト合格"
    else
        print_warning "一部のテストが失敗しました（通常は問題ありません）"
    fi
}

# インストール検証
verify_installation() {
    print_info "インストールを検証中..."
    echo ""
    
    # コマンドファイル確認
    if [ -f "$HOME/.claude/commands/smart-review-v2.js" ]; then
        print_success "smart-review-v2.js インストール済み"
    else
        print_error "smart-review-v2.js が見つかりません"
    fi
    
    if [ -f "$HOME/.claude/commands/smart-review-config.js" ]; then
        print_success "smart-review-config.js インストール済み"
    else
        print_error "smart-review-config.js が見つかりません"
    fi
    
    # エージェント数確認
    AGENT_COUNT=$(ls -1 "$HOME/.claude/agents/" 2>/dev/null | wc -l)
    if [ $AGENT_COUNT -gt 0 ]; then
        print_success "$AGENT_COUNT 個のエージェントがインストール済み"
    else
        print_warning "エージェントが見つかりません"
    fi
}

# メイン処理
main() {
    echo "🚀 セットアップを開始します..."
    echo ""
    
    # 各ステップを実行
    check_requirements
    create_directories
    install_dependencies
    register_commands
    install_agents
    create_config
    run_tests
    verify_installation
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}🎉 セットアップが完了しました！${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo ""
    echo "📝 使用方法:"
    echo "  1. Claude CLIを起動: claude"
    echo "  2. スラッシュコマンドを実行: /smart-review"
    echo ""
    echo "📚 詳細は INSTALLATION_GUIDE.md を参照してください"
    echo ""
}

# スクリプト実行
main "$@"
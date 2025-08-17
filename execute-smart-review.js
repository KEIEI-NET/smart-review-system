#!/usr/bin/env node
// Execute smart-review with simulated Claude environment

const path = require('path');
const fs = require('fs');

// Simulate Claude CLI environment
global.Claude = {
  output: {
    write: (msg) => process.stdout.write(msg),
    info: (msg) => console.log(msg),
    success: (msg) => console.log(`✅ ${msg}`),
    warning: (msg) => console.warn(`⚠️ ${msg}`),
    error: (msg) => console.error(`❌ ${msg}`)
  },
  prompt: async (question) => {
    // For testing, return predefined responses
    if (question.includes('選択')) {
      return '1'; // Select first option
    }
    return '';
  }
};

// Load and execute the command
try {
  const smartReviewPath = path.join(__dirname, 'smart-review-v2.js');
  const smartReview = require(smartReviewPath);
  
  // Create execution context
  const context = {
    workingDirectory: process.cwd(),
    args: process.argv.slice(2)
  };
  
  const output = global.Claude.output;
  
  console.log('🚀 Smart Review System v2.1.0');
  console.log('════════════════════════════════════════');
  console.log('');
  console.log('📋 利用可能なオプション:');
  console.log('  1. クイックレビュー (変更ファイルのみ)');
  console.log('  2. フルスキャン (全ファイル)');
  console.log('  3. セキュリティ監査');
  console.log('  4. カスタム設定');
  console.log('  5. システムテスト');
  console.log('  6. ヘルプ');
  console.log('');
  console.log('ℹ️ このツールはClaude CLI環境で実行することを想定しています。');
  console.log('   スタンドアロンでの実行は制限された機能のみ利用可能です。');
  console.log('');
  
  // Check for git repository
  if (fs.existsSync('.git')) {
    console.log('✅ Gitリポジトリが検出されました');
    
    // Show recent changes
    const { execSync } = require('child_process');
    try {
      const status = execSync('git status --short', { encoding: 'utf-8' });
      if (status.trim()) {
        console.log('\n📝 現在の変更:');
        console.log(status);
      } else {
        console.log('\n✨ 変更されたファイルはありません');
      }
    } catch (e) {
      console.log('\n⚠️ Git状態を取得できませんでした');
    }
  } else {
    console.log('⚠️ Gitリポジトリではありません');
  }
  
  console.log('\n💡 実行するには、Claude CLI内で /smart-review コマンドを使用してください。');
  
} catch (error) {
  console.error('Error:', error.message);
  console.error('\n詳細:', error.stack);
}
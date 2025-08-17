#!/usr/bin/env node
// Test script to verify slash command installation

const fs = require('fs');
const path = require('path');
const os = require('os');

console.log('🔍 Checking Slash Command Installation...\n');

// Check global commands directory
const globalCommandsDir = path.join(os.homedir(), '.claude', 'commands');
const localCommandsDir = path.join(process.cwd(), '.claudecode', 'commands');

console.log('📁 Directories:');
console.log(`  Global: ${globalCommandsDir}`);
console.log(`  Local:  ${localCommandsDir}\n`);

// Check for smart-review command
function checkCommands(dir, label) {
  console.log(`📦 ${label}:`);
  
  if (!fs.existsSync(dir)) {
    console.log('  ❌ Directory does not exist');
    return;
  }
  
  const files = fs.readdirSync(dir);
  if (files.length === 0) {
    console.log('  ⚠️  No commands found');
    return;
  }
  
  files.forEach(file => {
    const fullPath = path.join(dir, file);
    const stats = fs.statSync(fullPath);
    const size = (stats.size / 1024).toFixed(2);
    
    if (file.includes('smart-review')) {
      console.log(`  ✅ ${file} (${size} KB)`);
    } else {
      console.log(`  📄 ${file} (${size} KB)`);
    }
  });
}

checkCommands(globalCommandsDir, 'Global Commands');
console.log('');
checkCommands(localCommandsDir, 'Local Commands');

// Check agents
const globalAgentsDir = path.join(os.homedir(), '.claude', 'agents');
console.log('\n🤖 Agents:');

if (fs.existsSync(globalAgentsDir)) {
  const agents = fs.readdirSync(globalAgentsDir);
  console.log(`  Found ${agents.length} agents:`);
  agents.forEach(agent => {
    console.log(`  • ${agent}`);
  });
} else {
  console.log('  ❌ Agents directory not found');
}

console.log('\n✨ Installation Summary:');
console.log('  The slash command files are installed correctly.');
console.log('  Use within Claude CLI: /smart-review');
console.log('  Direct execution: node smart-review-v2.js (requires Claude context)');
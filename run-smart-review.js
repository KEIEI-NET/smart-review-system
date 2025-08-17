#!/usr/bin/env node
// Wrapper script to run smart-review-v2

const smartReview = require('./smart-review-v2.js');

// Run the interactive menu
(async () => {
  try {
    const context = {
      workingDirectory: process.cwd(),
      args: process.argv.slice(2)
    };
    
    // Check for command line arguments
    const args = process.argv.slice(2);
    
    if (args.includes('--help') || args.includes('-h')) {
      console.log(`
Smart Review System v2.1.0
==========================

Usage: node run-smart-review.js [options]

Options:
  --help, -h     Show this help message
  --test         Run system test
  --changes      Review only changed files (git diff)
  --all          Review all files in the project
  --security     Run security audit only

Interactive Mode:
  Run without arguments to open the interactive menu.
      `);
      process.exit(0);
    }
    
    if (args.includes('--test')) {
      console.log('Running system test...');
      const output = {
        info: (msg) => console.log(msg),
        success: (msg) => console.log(msg),
        warning: (msg) => console.warn(msg),
        error: (msg) => console.error(msg)
      };
      const result = await smartReview.runSystemTest(output);
      process.exit(0);
    }
    
    // Create output object
    const output = {
      info: (msg) => console.log(msg),
      success: (msg) => console.log(msg),
      warning: (msg) => console.warn(msg),
      error: (msg) => console.error(msg)
    };
    
    // Show interactive menu
    const result = await smartReview.execute(args, output, context);
    if (result && !result.success) {
      process.exit(1);
    }
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
})();
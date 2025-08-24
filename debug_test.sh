#!/bin/bash
cd /mnt/ide/app2/habit_breaker_app

echo "Running tests with detailed output..."
/mnt/ide/app2/flutter/bin/flutter test test/habit_list_screen_test.dart --verbose 2>&1 | tee test_debug.log

echo ""
echo "=== TEST DEBUG LOG ==="
cat test_debug.log | grep -A 20 -B 5 "failed\|Exception\|Error"

echo ""
echo "=== LAST 50 LINES ==="
tail -50 test_debug.log
#!/bin/bash
# ===========================================
# Code Style Check Script
# Usage: ./scripts/check_style.sh [files...]
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "============================================"
echo "  Code Style Check"
echo "============================================"
echo ""

# Check if Verible is installed
if ! command -v verible-format &> /dev/null; then
    echo -e "${YELLOW}Warning: Verible not installed${NC}"
    echo "Install with: pip install verible"
    echo ""
fi

# Check if SV-Lint is installed
if ! command -v svlint &> /dev/null; then
    echo -e "${YELLOW}Warning: SV-Lint not installed${NC}"
    echo "Install with: cargo install sv-lint"
    echo ""
fi

# Get files to check
if [ $# -eq 0 ]; then
    FILES=$(find "$ROOT_DIR" -name "*.sv" -o -name "*.svh" | grep -v ".git" | grep -v "uvm/")
else
    FILES="$@"
fi

TOTAL=0
FAILED=0

for file in $FILES; do
    TOTAL=$((TOTAL + 1))
    
    # Check file exists
    if [ ! -f "$file" ]; then
        continue
    fi
    
    echo "Checking: $file"
    
    # Verible check
    if command -v verible-format &> /dev/null; then
        if verible-format --check "$file" 2>/dev/null; then
            echo -e "  ${GREEN}✓ Verible OK${NC}"
        else
            echo -e "  ${RED}✗ Verible FAILED${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
    
    echo ""
done

echo "============================================"
echo "  Summary"
echo "============================================"
echo "Total files: $TOTAL"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some checks failed${NC}"
    exit 1
fi

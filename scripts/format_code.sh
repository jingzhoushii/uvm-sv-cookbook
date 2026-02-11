#!/bin/bash
# ===========================================
# Code Format Script
# Usage: ./scripts/format_code.sh [files...]
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "============================================"
echo "  Code Formatter"
echo "============================================"
echo ""

# Get files to format
if [ $# -eq 0 ]; then
    FILES=$(find "$ROOT_DIR" -name "*.sv" -o -name "*.svh" | grep -v ".git" | grep -v "uvm/")
else
    FILES="$@"
fi

TOTAL=0

for file in $FILES; do
    TOTAL=$((TOTAL + 1))
    
    # Check file exists
    if [ ! -f "$file" ]; then
        continue
    fi
    
    echo "Formatting: $file"
    
    # Verible format
    if command -v verible-format &> /dev/null; then
        verible-format -i "$file"
        echo "  ✓ Verible formatted"
    else
        echo -e "  ${YELLOW}Warning: Verible not installed${NC}"
    fi
done

echo ""
echo "============================================"
echo "  Summary"
echo "============================================"
echo "Total files: $TOTAL"
echo ""
echo -e "${GREEN}✅ Formatting complete!${NC}"

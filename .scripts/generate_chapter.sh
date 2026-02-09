#!/bin/bash
# 快速生成章节模板

CHAPTER=$1
SECTION=$2

if [ -z "$CHAPTER" ] || [ -z "$SECTION" ]; then
    echo "用法: ./generate_chapter.sh <CHAPTER> <SECTION>"
    echo "示例: ./generate_chapter.sh 01-sv-fundamentals 01-data-types"
    exit 1
fi

DIR="$CHAPTER/$SECTION"
mkdir -p "$DIR"/{dut,tb,test,examples}

cat > "$DIR/README.md" << EOF
# $SECTION

## 知识点

## 运行

\`\`\`bash
cd $DIR && make
\`\`\`
EOF

cat > "$DIR/Makefile" << 'EOF'
SIM ?= vcs

all: compile run

compile:
	vcs -sverilog +v2k -ntb_opts uvm -l comp.log

run:
	./simv -l run.log

clean:
	rm -f *.log *.vcd simv*
EOF

echo "Created $DIR structure"

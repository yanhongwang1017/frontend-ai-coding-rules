#!/bin/bash
# 把本目录下的 .agents/ 和 AGENTS.md 覆盖复制到多个目标项目
# 用法：双击运行，或在终端执行 ./sync-rules.command
# 首次执行时输入目标路径（多个用 ; 分隔），会自动保存到同目录 targets.txt
# 之后直接回车即用已保存的路径；也可以手动编辑 targets.txt（每行一个，# 开头为注释）

set -e

# 源目录 = 脚本所在目录
SRC="$(cd "$(dirname "$0")" && pwd)"
LIST="$SRC/targets.txt"

# 读取已保存的路径，拼成 A;B;C 形式
SAVED=""
if [ -f "$LIST" ]; then
  while IFS= read -r line; do
    line="${line%%#*}"             # 去注释
    line="${line#"${line%%[![:space:]]*}"}" # 去首空格
    line="${line%"${line##*[![:space:]]}"}" # 去尾空格
    if [ -n "$line" ]; then
      SAVED="${SAVED:+$SAVED;}$line"
    fi
  done < "$LIST"
fi

if [ -n "$SAVED" ]; then
  echo "已保存的目标路径："
  echo "$SAVED" | tr ';' '\n' | sed 's/^/  - /'
  echo "直接回车使用；或输入新路径覆盖（多个用 ; 分隔）："
else
  echo "请输入目标项目路径，多个用 ; 分隔（例：/a/b;/c/d），回车确认："
fi
read -r INPUT

# 输入了就用新的并覆盖保存，没输入就沿用已保存的
if [ -n "$INPUT" ]; then
  USED="$INPUT"
  NEW=1
else
  USED="$SAVED"
  NEW=0
fi

if [ -z "$USED" ]; then
  echo "未输入路径，已退出。"
  exit 1
fi

IFS=';' read -r -a RAW_LIST <<< "$USED"

CLEAN=()
for RAW in "${RAW_LIST[@]}"; do
  T="${RAW//\\/}"                # 兼容拖拽进终端产生的 \ 转义
  T="${T#"${T%%[![:space:]]*}"}" # 去首空格
  T="${T%"${T##*[![:space:]]}"}" # 去尾空格
  T="${T/#\~/$HOME}"             # 支持 ~ 开头的路径

  if [ -z "$T" ]; then
    continue
  fi
  CLEAN+=("$T")

  echo "==> [$T]"             # 加方括号，便于看出多余空格或漏字符
  if [ ! -d "$T" ]; then
    echo "    跳过：目标目录不存在"
    continue
  fi

  rm -rf "$T/.agents"                   # 先删掉旧目录，保证不留残留文件
  cp -R "$SRC/.agents" "$T/.agents"     # 复制 .agents
  cp -f "$SRC/AGENTS.md" "$T/AGENTS.md" # 覆盖 AGENTS.md

  echo "    已替换 .agents/ 与 AGENTS.md"
done

if [ ${#CLEAN[@]} -eq 0 ]; then
  echo "没有可用路径，已退出。"
  exit 1
fi

if [ "$NEW" = 1 ]; then
  printf '%s\n' "${CLEAN[@]}" > "$LIST"
  echo "已保存到 targets.txt，下次直接回车即可。"
fi

echo "全部完成。"
read -n 1 -s -r -p "按任意键关闭窗口..." || true
echo

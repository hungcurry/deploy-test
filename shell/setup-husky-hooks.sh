#!/bin/bash

# 確保 husky 已安裝及初始化
if ! command -v npx >/dev/null 2>&1; then
  echo "❌ 找不到 npx，請先安裝 Node.js"
  exit 1
fi

echo "✅ 開始安裝 Husky hooks"

npx husky install

# 加上執行權限用的函數
make_executable() {
  chmod +x "$1"
  echo "✅ 設定 $1 可執行"
}

# 符合 Husky v10 的 hook 內容（不含 deprecated 部分）
hook_pre_commit='#!/bin/sh

branch=$(git symbolic-ref --short HEAD)

if [ "$branch" = "main" ]; then
  echo "🚫 你現在在 main 分支，請不要直接 commit！"
  exit 1
fi
'

hook_pre_push='#!/bin/sh

branch=$(git symbolic-ref --short HEAD)

if [ "$branch" = "main" ]; then
  echo "🚫 你現在在 main 分支，禁止 push！"
  exit 1
fi
'

hook_pre_merge_commit='#!/bin/sh

branch=$(git symbolic-ref --short HEAD)

if [ "$branch" = "main" ]; then
  echo "🚫 禁止直接在 main 分支進行 merge！請使用 Pull Request 流程"
  exit 1
fi
'

# 寫入三個 hook
echo "$hook_pre_commit" > .husky/pre-commit
echo "$hook_pre_push" > .husky/pre-push
echo "$hook_pre_merge_commit" > .husky/pre-merge-commit

# 設定執行權限
make_executable ".husky/pre-commit"
make_executable ".husky/pre-push"
make_executable ".husky/pre-merge-commit"

echo "🎉 Husky hook 安裝完成（已符合 v10）！"



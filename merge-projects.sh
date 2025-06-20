#!/bin/bash

# all-in-one-portfolio 클론
git clone https://github.com/seonginsong/all-in-one-portfolio.git
cd all-in-one-portfolio || exit

repos=(
  "mbboard"
  "cashbook"
  "ajax"
  "cashbook2"
  "java-oop"
  "poll"
  "jpaboard"
  "sakila"
  "oop2"
  "schedule"
  "chartjs"
  "snapi"
  "mfu"
  "js0507"
  "fileupload"
  "mvc"
)

for repo in "${repos[@]}"; do
  echo "🔄 Merging $repo..."

  # 이미 폴더가 존재하면 삭제
  if [ -d "$repo" ]; then
    echo "⚠️ Folder $repo already exists. Removing..."
    rm -rf "$repo"
  fi

  git remote add "$repo" "https://github.com/seonginsong/$repo.git"
  git fetch "$repo"

  git checkout -b "merge-$repo" "$repo/main" 2>/dev/null || \
  git checkout -b "merge-$repo" "$repo/master" 2>/dev/null || \
  git checkout -b "merge-$repo" "$repo/origin"

  mkdir "$repo"

  # 모든 파일을 폴더로 이동하되 .git, .gitignore, 스크립트는 제외
  shopt -s dotglob nullglob
  for f in *; do
    if [[ "$f" != "$repo" && "$f" != ".git" && "$f" != ".gitignore" && "$f" != "merge-projects.sh" ]]; then
      mv "$f" "$repo/"
    fi
  done
  shopt -u dotglob nullglob

  git commit -am "Move $repo project into $repo/ folder"

  git checkout main
  git merge --allow-unrelated-histories "merge-$repo" -m "Merge $repo into main as $repo/"

  git remote remove "$repo"
done

echo "✅ All projects merged!"

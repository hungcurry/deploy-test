✅ 步驟 1：產生你的 GHCR_PAT <br>
1. 到 GitHub → 點右上角大頭貼 → Settings<br>
2. 左側選單點 Developer settings<br>
3. 選 Personal access tokens → 選 Tokens (classic)<br>
4. 點 Generate new token（建議選 90 天有效，或無限期）<br>

5. ✅ 權限要勾這些：<br>
    * write:packages
    * read:packages
    * repo（建議一起勾）
6. 產生完會看到一串長長的 token（只會顯示一次）
---
✅ 步驟 2：把 GHCR_PAT 存到 GitHub Secrets <br>
1. 到你的 repo → 點 Settings
2. 左邊選 Secrets and variables → Actions
3. 點 New repository secret
4. 名稱填 GHCR_PAT（你可以自訂，但要跟 .yml 配合）
5. 值貼上剛剛產生的 PAT

✅ 步驟 3：<br>
docker-publish.yml
```jsx=
- name: Log in to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    // 這樣就不需要手動開權限、也不會遇到 push denied 問題
    username: ${{ github.actor }}
    password: ${{ secrets.GHCR_PAT }}
```
Dockerfile
```jsx=
// 加上標籤 LABEL 到 Dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install

# 要讓 GHCR 的 image「綁定某個 GitHub repo」
LABEL org.opencontainers.image.source="https://github.com/hungcurry/ghcr-demo"

COPY . .
EXPOSE 3000
CMD ["node", "index.js"]
```

✅ 步驟 4：開分支觸發推送<br>
```jsx=
// http://localhost:3000/
dev
* docker build -f docker/Dockerfile.dev -t ghcr-demo-dev .
* docker tag ghcr-demo-dev ghcr.io/hungcurry/ghcr-demo-dev:latest
* docker push ghcr.io/hungcurry/ghcr-demo-dev:latest

prod
* docker build -f docker/Dockerfile.prod -t ghcr-demo-prod .
* docker tag ghcr-demo-prod ghcr.io/hungcurry/ghcr-demo-prod:latest
* docker push ghcr.io/hungcurry/ghcr-demo-prod:latest

test
* docker build -f docker/Dockerfile.test -t ghcr-demo-test .
* docker tag ghcr-demo-test ghcr.io/hungcurry/ghcr-demo-test:latest
* docker push ghcr.io/hungcurry/ghcr-demo-test:latest

啟動dev
docker build -f docker/Dockerfile.dev -t ghcr-demo-dev .
docker run --env-file env/.env.dev -p 3001:3001 ghcr-demo-dev
```

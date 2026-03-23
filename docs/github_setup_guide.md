# GitHub Setup Guide
## How to Push This Project to Your GitHub

---

## Step 1 — Create the Repo on GitHub

1. Go to github.com → click "+" → "New repository"
2. Name it: `supply-chain-intelligence-system`
3. Set to **Public**
4. Do NOT initialize with README (we already have one)
5. Click "Create repository"

---

## Step 2 — Push From Your Local Machine

Open terminal in your project folder and run these commands one by one:

```bash
# Navigate to project folder (adjust path to wherever you saved it)
cd supply-chain-intelligence-system

# Initialize git
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: project structure, notebooks, SQL queries, docs"

# Connect to your GitHub repo (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/supply-chain-intelligence-system.git

# Push
git branch -M main
git push -u origin main
```

---

## Step 3 — Download Dataset + Add to Repo

1. Go to: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Click "Download" (requires free Kaggle account)
3. Unzip and place all CSVs into: `data/raw/`
4. Do NOT commit the raw CSVs — they're in `.gitignore` (too large)
5. Your README already has download instructions for anyone cloning

---

## Step 4 — Pin the Repo on Your Profile

1. Go to your GitHub profile page
2. Click "Customize your profile"
3. Pin `supply-chain-intelligence-system`
4. It will appear at the top of your profile immediately

---

## Step 5 — Add Topics/Tags to the Repo

On your repo page → click the gear icon next to "About" → add these topics:
```
supply-chain  python  tableau  sql  data-analytics
demand-forecasting  operations-analytics  pandas  prophet  xgboost
```

These tags help the repo show up in GitHub searches.

---

## Commit Message Guide (as you build)

Use these commit messages as you complete each phase:

```bash
git commit -m "Add: EDA and cleaning notebook (01)"
git commit -m "Add: KPI calculations notebook (02)"
git commit -m "Add: Demand forecasting with Prophet + XGBoost (03)"
git commit -m "Add: Inventory optimization and reorder alerts (04)"
git commit -m "Add: SQL analytics queries (5 queries)"
git commit -m "Add: Tableau dashboard screenshots"
git commit -m "Update: README with Tableau Public link and findings"
git commit -m "Add: Business findings executive summary"
```

Each commit shows recruiters that the project was built progressively — not dumped all at once.

---

## What Your Repo URL Will Look Like

```
https://github.com/YOUR_USERNAME/supply-chain-intelligence-system
```

Put this link on:
- Your resume (under the project)
- Your LinkedIn (Featured section + About section)
- Any job application that asks for portfolio/GitHub

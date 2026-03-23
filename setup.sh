#!/bin/bash
# ============================================================
# GUIDO SDD Engineering Stack — GitHub Setup Script
# Run this from the folder where you want to create the repo
# ============================================================

set -e

REPO_NAME="guido-sdd-engineering-stack"
GITHUB_USER="GuiMiran"
DESCRIPTION="GUIDO SDD Engineering Stack — Governed, Unified, Intent-Driven, Definition-first, Outcomes. A software quality engineering framework for the AI-agentic era."

echo "🚀 Setting up $REPO_NAME..."

# Step 1: Create the repo on GitHub (requires GitHub CLI)
echo "📦 Creating GitHub repo..."
gh repo create "$GITHUB_USER/$REPO_NAME" \
  --public \
  --description "$DESCRIPTION" \
  --confirm 2>/dev/null || echo "Repo may already exist, continuing..."

# Step 2: Init git if not already
if [ ! -d ".git" ]; then
  git init
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

# Step 3: Stage and commit all files
git add .
git commit -m "feat: initial GUIDO SDD Engineering Stack

- README with full framework definition and GUIDO acronym
- Architecture overview with system diagram
- Layer 1: Intent (specs, context files, data files, tag taxonomy)
- Layer 2: Execution (Selenium, SpecFlow, K6, OWASP ZAP)
- Layer 3: Governance (GUIDO Scale gates, coverage thresholds)
- Layer 4: Platform (GitHub Actions + Azure DevOps pipelines)
- Layer 5: Knowledge (Allure, living docs, context maintenance)
- Test type catalog (functional, non-functional, specialized, AI-agentic)
- Spec quality guide (levels 0-3, checklist, naming conventions)
- Example global context file

Framework: GUIDO — Governed Unified Intent-Driven Definition-first Outcomes
Author: Guido Miranda Mercado"

# Step 4: Push
git branch -M main
git push -u origin main

# Step 5: Add topics
echo "🏷️  Adding topics..."
gh repo edit "$GITHUB_USER/$REPO_NAME" \
  --add-topic "spec-driven-development" \
  --add-topic "test-automation" \
  --add-topic "quality-engineering" \
  --add-topic "guido-stack" \
  --add-topic "bdd" \
  --add-topic "gherkin" \
  --add-topic "specflow" \
  --add-topic "selenium" \
  --add-topic "csharp" \
  --add-topic "ai-agents" \
  --add-topic "software-quality" \
  --add-topic "sdd"

echo ""
echo "✅ Done! Repo available at:"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "Next step: pin this repo in your GitHub profile."

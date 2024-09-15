#!/bin/sh
set -e

# Configuration
INPUT_BRANCH=${INPUT_BRANCH:-gh-pages}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'website/build/tech-portfolio'}
TEMP_DIR=$(mktemp -d)  # Create a temporary directory

# Check for GITHUB_TOKEN
[ -z "${GITHUB_TOKEN}" ] && {
    echo 'Missing input "GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

# Copy build files to the temporary directory
cp -r ${INPUT_DIRECTORY}/* ${TEMP_DIR}

# Navigate to the temporary directory
cd ${TEMP_DIR}
git init
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add .
git commit -m "Push to GitHub Pages"

# Push to the gh-pages branch
remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags --force

# Clean up
rm -rf ${TEMP_DIR}

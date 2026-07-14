#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="artic-rampart"

echo "Cleaning old install..."
rm -rf node_modules build

eval "$(conda shell.bash hook)"

if conda env list | awk '{print $1}' | grep -qx "${ENV_NAME}"; then
  conda deactivate || true
  conda env remove -n "${ENV_NAME}" -y
fi

echo "Creating conda environment..."
conda env create -f environment.yml

echo "Activating conda environment..."
conda activate "${ENV_NAME}"

echo "Using:"
which node
node --version
which npm
npm --version
node -p "process.versions.openssl"

echo "Installing npm dependencies and building..."
npm install

echo "Installing rampart globally into conda environment..."
npm install --global .

echo "Checking rampart..."
rampart --help

echo "Done."
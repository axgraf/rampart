#!/bin/bash
set -e

conda activate artic-rampart

git pull
conda env update -f environment.yml --prune
NODE_OPTIONS=--openssl-legacy-provider npm install
npm install --global .
#!/bin/sh
# Ignored all .tmproj files that are being updated in this GIT repository.
# Run from repository root.
git update-index --assume-unchanged `find . -name '*.tmproj'`
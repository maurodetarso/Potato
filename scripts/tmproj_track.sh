#!/bin/sh
# Resume tracking changes of all .tmproj files that have been added to the repository.
# Run from repository root.
git update-index --no-assume-unchanged `find . -name '*.tmproj'`
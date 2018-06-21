#!/usr/bin/env bash

set -e

rm -rf public/

hugo -v

if [ "${CIRCLE_BRANCH}" != "master" ]; then
    exit 0
fi


DEPLOY_DIR=deploy

git config --global push.default simple
git config --global user.email $(git --no-pager show -s --format='%ae' HEAD)
git config --global user.name ${CIRCLE_USERNAME}

git clone -q --branch=gh-pages ${CIRCLE_REPOSITORY_URL} $DEPLOY_DIR

rsync -arv --delete public/* ${DEPLOY_DIR}/

cd ${DEPLOY_DIR}

git add -f .
git commit -m "Deploy build ${CIRCLE_BUILD_NUM}"
git push -f

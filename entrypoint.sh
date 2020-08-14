#!/bin/bash -l
set -e

cd /opt/app
mix local.hex --force
OUTPUT=`MIX_ENV=gha mix lei.scan ${GITHUB_WORKSPACE})`
cd $GITHUB_WORKSPACE

INPUT_BRANCH=${INPUT_BRANCH}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
_FORCE_OPTION=''
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
cd ${INPUT_DIRECTORY}
echo Printing Report:
echo $OUTPUT

git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
filename="lei--$(date +'%Y-%m-%d--%H-%M-%S').json"
touch $filename
echo "${OUTPUT}" > $filename
git add $filename
git commit -m "Add changes" -a

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

if ${INPUT_TAGS}; then
    _TAGS='--tags'
fi

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS;
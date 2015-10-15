#!/bin/bash -e

REPO_OWNER="holidayextras"
APP_NAME="`cat package.json | grep -m 1 name | cut -d '"' -f 4`"
# Get the last version from Git
git fetch
RELEASED_VERSION_STRING=`git describe --tags \`git rev-list --tags --max-count=1\` | tr -d "v"`
# Get the version from the local package.json
CANDIDATE_VERSION_STRING="`cat package.json | grep version | cut -d '"' -f 4`"
GIT_CHANGED="false"
BUMP_MESSAGE="Version bump required"

if ! git diff-index --quiet HEAD --; then
    GIT_CHANGED="true"
fi

echo "App Name: $APP_NAME"
echo "Repo Changes: $GIT_CHANGED"
echo "Current Release: $RELEASED_VERSION_STRING"
echo "Local Version: $CANDIDATE_VERSION_STRING"
# Split the string up into an array
RELEASED_VERSION=(${RELEASED_VERSION_STRING//./ })
CANDIDATE_VERSION=(${CANDIDATE_VERSION_STRING//./ })

if [ $GIT_CHANGED = "true" ]; then
	echo "Checking Release"
	if [ -z $RELEASED_VERSION ]; then
		echo "No release to date"
	else
		# Check if the major is less than
		if [ ${CANDIDATE_VERSION[0]} -lt ${RELEASED_VERSION[0]} ]; then
			# e.g. 1.0.0 < 2.0.0
			echo $BUMP_MESSAGE
			exit 1
		fi
		# Check if the major is less than or equal and if the minor is less than
		if [ ${CANDIDATE_VERSION[0]} -le ${RELEASED_VERSION[0]} ] && [ ${CANDIDATE_VERSION[1]} -lt ${RELEASED_VERSION[1]} ]; then
			# e.g. 1.0.0 < 1.1.0
			echo $BUMP_MESSAGE
			exit 1
		fi
		# Check if the major is less than or equal and if the minor is less than or equal and if the patch is less than or equal
		if [ ${CANDIDATE_VERSION[0]} -le ${RELEASED_VERSION[0]} ] && [ ${CANDIDATE_VERSION[1]} -le ${RELEASED_VERSION[1]} ] && [ ${CANDIDATE_VERSION[2]} -le ${RELEASED_VERSION[2]} ]; then
			# e.g. 1.0.0 < 1.0.1
			echo $BUMP_MESSAGE
			exit 1
		fi
	fi
	echo "Version already bumped"
else
	echo "No changes detected, NOT checking release"
fi
exit 0

#!/usr/bin/env bash
###
### SCRIPT-TO-UPDATE TERRAFORM!
###

# Lists terraform releasesusing GitHub API.

DOWNLOADED="False"


[[ -n "${DEBUG}" ]] && { set -x; }

# Usage: assert_environment
assert_environment() {
	for dependency in curl jq sed unzip ; do
		command -v "${dependency}" 2>&1 > /dev/null \
			|| { echo "Error! Install missing dependency ${dependency}." >&2; exit 42; }
	done
}


# Usage: list_latest_releases | filter_numbers_only
filter_numbers_only() {
    [ -n $OPTION_NUMBER_ONLY ] && sed 's/^v//'
}


# Usage: latest_release_only
latest_release_only() {

	assert_environment

	curl --silent \
		-H "Accept: application/vnd.github.v3+json" \
		https://api.github.com/repos/hashicorp/terraform/releases/latest \
		| jq -r ".tag_name" \
		| sed 's/"//g' \
        | filter_numbers_only
}


# Usage: download_latest_release
download_latest_release() {
    if [ ! -f terraform-v${LATEST}.zip ] ; then
        curl \
            --silent \
            --output terraform-v${LATEST}.zip \
            https://releases.hashicorp.com/terraform/${LATEST}/terraform_${LATEST}_linux_amd64.zip
        DOWNLOADED="True"
    fi
}


# Usage: extract_terraform
extract_download_zipfile() {

    { if [ -n ${LATEST} ] ; then exit 42; fi } 

    download_latest_release

    [ "$DOWNLOADED" == "False" ] && return 44
    [ -d $HOME/.local/bin ] && TARGETDIR=$HOME/.local/bin/
    [ -z $TARGETDIR ] && TARGETDIR=/usr/local/bin/
    sudo unzip -qq -o terraform-v${LATEST}.zip terraform -d $TARGETDIR
}


LATEST=$(latest_release_only)
extract_download_zipfile

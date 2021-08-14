#!/bin/bash

############
# SETTINGS #
############

TMP_PATH="$HOME/tmp/ephemeralFirefox"
SKEL_PATH="$HOME/.mozilla/firefox/ephemeralFirefoxSkel"

###############################
# CLEANUP OLD ORPHAN TMP DATA #
###############################

# loop through all the Ephemeral Firefox temp dirs
for tmpDir in $(find "${TMP_PATH}" -mindepth 1 -maxdepth 1 -type d); do
	# is this temp dir for an Ephemeral Firefox that's still running? Or is it no longer needed?
	if [[ -z `firejail --list | grep "${tmpDir}"` ]]; then
		# this temp dir is no longer needed; delete it
		echo "INFO: shredding data from old Ephemeral Firefox temp dir = ${tmpDir}"
		srm -rfll "${tmpDir}"
	fi
done

###################
# CREATE TEMP DIR #
###################

# first create a temp dir in our (hopefully encrypted) $HOME dir, if first run
[ ! -d "${TMP_PATH}" ] && mkdir -p "${TMP_PATH}"

# create temp dir for ephemeral session
tmpDir=`/bin/mktemp -p "$TMP_PATH" -d`
tmpProfileDir="${tmpDir}/firefoxProfile"
mkdir -p "${tmpProfileDir}"

echo "INFO: created Ephemeral Firefox temp profile dir = ${tmpProfileDir}"

###########################
# START EPHEMERAL FIREFOX #
###########################



# prepare Borwser Data

cp -r "${SKEL_PATH}/datareporting" "${tmpProfileDir}/datareporting"
cp -r "${SKEL_PATH}/storage" "${tmpProfileDir}/storage"
cp -r "${SKEL_PATH}/weave" "${tmpProfileDir}/weave"
cp "${SKEL_PATH}/addons.json" "${tmpProfileDir}/"
cp "${SKEL_PATH}/addonStartup.json.lz4" "${tmpProfileDir}/"
cp "${SKEL_PATH}/shield-preference-experiments.json" "${tmpProfileDir}/"
cp "${SKEL_PATH}/storage.sqlite" "${tmpProfileDir}/"
cp "${SKEL_PATH}/protections.sqlite" "${tmpProfileDir}/"
cp "${SKEL_PATH}/SiteSecurityServiceState.txt" "${tmpProfileDir}/"

# chrome
cp -r "${SKEL_PATH}/chrome" "${tmpProfileDir}/chrome"

#DOM storage
cp "${SKEL_PATH}/webappsstore.sqlite" "${tmpProfileDir}/"
cp "${SKEL_PATH}/chromeappsstore.sqlite" "${tmpProfileDir}/"

# User preferences
cp "${SKEL_PATH}/user.js" "${tmpProfileDir}/"
cp "${SKEL_PATH}/prefs.js" "${tmpProfileDir}/"

# Stored session
cp "${SKEL_PATH}/sessionstore.jsonlz4" "${tmpProfileDir}/"
cp "${SKEL_PATH}/sessionCheckpoints.json" "${tmpProfileDir}/"

# Search engines
cp "${SKEL_PATH}/search.json.mozlz4" "${tmpProfileDir}/"

# Cookies
cp "${SKEL_PATH}/cookies.sqlite" "${tmpProfileDir}/"

# Extensions
cp -r "${SKEL_PATH}/extensions" "${tmpProfileDir}/extensions"
cp -r "${SKEL_PATH}/browser-extension-data" "${tmpProfileDir}/browser-extension-data"
cp "${SKEL_PATH}/extensions.json" "${tmpProfileDir}/"
cp "${SKEL_PATH}/extension-preferences.json" "${tmpProfileDir}/"
cp "${SKEL_PATH}/extension-settings.json" "${tmpProfileDir}/"

# Bookmarks, Downloads and Browsing History:
cp -r "${SKEL_PATH}/bookmarkbackups" "${tmpProfileDir}/bookmarkbackups"
cp "${SKEL_PATH}/places.sqlite" "${tmpProfileDir}/"
cp "${SKEL_PATH}/favicons.sqlite" "${tmpProfileDir}/"

# Site-specific preferences:
cp "${SKEL_PATH}/permissions.sqlite" "${tmpProfileDir}/"
cp "${SKEL_PATH}/content-prefs.sqlite" "${tmpProfileDir}/"

# Toolbar customization:
cp "${SKEL_PATH}/xulstore.json" "${tmpProfileDir}/"

# try disabling 'seccomp' if you encounter issues
#firejail --ignore=seccomp --whitelist="${tmpProfileDir}" firefox -no-remote -new-instance -profile "${tmpProfileDir}" "${url}"

firejail --whitelist="${tmpProfileDir}" firefox -no-remote -new-instance -profile "${tmpProfileDir}"

###########
# CLEANUP #
###########

# fast (secure enough) wipe of tmp dir 
srm -vrfll "${tmpDir}"

# clean exit
exit 0
EOF

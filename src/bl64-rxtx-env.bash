#######################################
# BashLib64 / Module / Globals / Transfer and Receive data over the network
#######################################

export BL64_RXTX_VERSION='1.20.2'

declare BL64_RXTX_MODULE='0'

export BL64_RXTX_CMD_CURL=''
export BL64_RXTX_CMD_WGET=''

export BL64_RXTX_ALIAS_CURL=''
export BL64_RXTX_ALIAS_WGET=''

export BL64_RXTX_SET_CURL_FAIL=''
export BL64_RXTX_SET_CURL_HEADER=''
export BL64_RXTX_SET_CURL_INCLUDE=''
export BL64_RXTX_SET_CURL_OUTPUT=''
export BL64_RXTX_SET_CURL_REDIRECT=''
export BL64_RXTX_SET_CURL_REQUEST=''
export BL64_RXTX_SET_CURL_SECURE=''
export BL64_RXTX_SET_CURL_SILENT=''
export BL64_RXTX_SET_CURL_VERBOSE=''
export BL64_RXTX_SET_WGET_OUTPUT=''
export BL64_RXTX_SET_WGET_SECURE=''
export BL64_RXTX_SET_WGET_VERBOSE=''

#
# GitHub specific parameters
#

# Public server
export BL64_RXTX_GITHUB_URL='https://github.com'

export _BL64_RXTX_TXT_MISSING_COMMAND='no web transfer command was found on the system'
export _BL64_RXTX_TXT_EXISTING_DESTINATION='destination path is not empty. No action taken.'
export _BL64_RXTX_TXT_CREATION_PROBLEM='unable to create temporary git repo'
export _BL64_RXTX_TXT_DOWNLOAD_FILE='download file'
export _BL64_RXTX_TXT_ERROR_DOWNLOAD_FILE='file download failed'
export _BL64_RXTX_TXT_ERROR_DOWNLOAD_DIR='directory download failed'

#######################################
# BashLib64 / Module / Globals / Manipulate CSV like text files
#######################################

declare BL64_XSV_VERSION='1.7.1'

declare BL64_XSV_MODULE='0'

declare BL64_XSV_CMD_YQ="$BL64_VAR_UNAVAILABLE"
declare BL64_XSV_CMD_JQ="$BL64_VAR_UNAVAILABLE"

# Field separators
declare BL64_XSV_FS='_@64@_' # Custom
declare BL64_XSV_FS_SPACE=' '
declare BL64_XSV_FS_NEWLINE=$'\n'
declare BL64_XSV_FS_TAB=$'\t'
declare BL64_XSV_FS_COLON=':'
declare BL64_XSV_FS_SEMICOLON=';'
declare BL64_XSV_FS_COMMA=','
declare BL64_XSV_FS_PIPE='|'
declare BL64_XSV_FS_AT='@'
declare BL64_XSV_FS_DOLLAR='$'
declare BL64_XSV_FS_SLASH='/'

# Common search paths for commands
declare -a _BL64_XSV_SEARCH_PATHS=('/home/linuxbrew/.linuxbrew/bin' '/opt/homebrew/bin' '/usr/local/bin' '/usr/bin')

declare _BL64_XSV_TXT_SOURCE_NOT_FOUND='source file not found'

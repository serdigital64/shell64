#######################################
# BashLib64 / Module / Globals / Setup script run-time environment
#
# Version: 1.8.0
#######################################

# Declare imported variables
export LANG
export LC_ALL
export LANGUAGE
export TERM

#
# Global flags
#

# Set Command flag (On/Off)
export BL64_LIB_CMD="${BL64_LIB_CMD:-0}"

# Set Verbosity flag (BL64_MSG_VERBOSE_APP)
export BL64_LIB_VERBOSE="${BL64_LIB_VERBOSE:-1}"

# Set Debug flag (On/Off)
export BL64_LIB_DEBUG="${BL64_LIB_DEBUG:-0}"

# Set Strict flag (On/Off)
export BL64_LIB_STRICT="${BL64_LIB_STRICT:-1}"

# Set Traps flag (On/Off)
export BL64_LIB_TRAPS="${BL64_LIB_TRAPS:-1}"

# Set Normalize locale flag
export BL64_LIB_LANG="${BL64_LIB_LANG:-1}"

#
# Common values
#

# Default value for parameters
export BL64_LIB_DEFAULT='_'

# Flag for incompatible command o task
export BL64_LIB_INCOMPATIBLE='_INC_'

# Flag for unavailable command o task
export BL64_LIB_UNAVAILABLE='_UNV_'

# Pseudo null value
export BL64_LIB_VAR_NULL='__'

# Logical values
export BL64_LIB_VAR_TRUE='0'
export BL64_LIB_VAR_FALSE='1'
export BL64_LIB_VAR_ON='1'
export BL64_LIB_VAR_OFF='0'
export BL64_LIB_VAR_OK='0'

#
# Common error codes
#

# Parameters
declare -ig BL64_LIB_ERROR_PARAMETER_INVALID=3
declare -ig BL64_LIB_ERROR_PARAMETER_MISSING=4
declare -ig BL64_LIB_ERROR_PARAMETER_RANGE=5
declare -ig BL64_LIB_ERROR_PARAMETER_EMPTY=6

# Function operation
declare -ig BL64_LIB_ERROR_TASK_FAILED=10
declare -ig BL64_LIB_ERROR_TASK_BACKUP=11
declare -ig BL64_LIB_ERROR_TASK_RESTORE=12
declare -ig BL64_LIB_ERROR_TASK_TEMP=13
declare -ig BL64_LIB_ERROR_TASK_UNDEFINED=14

# Module operation
declare -ig BL64_LIB_ERROR_MODULE_SETUP_INVALID=20
declare -ig BL64_LIB_ERROR_MODULE_SETUP_MISSING=21

# OS
declare -ig BL64_LIB_ERROR_OS_NOT_MATCH=30
declare -ig BL64_LIB_ERROR_OS_TAG_INVALID=31
declare -ig BL64_LIB_ERROR_OS_INCOMPATIBLE=32

# External commands
declare -ig BL64_LIB_ERROR_APP_INCOMPATIBLE=40
declare -ig BL64_LIB_ERROR_APP_MISSING=41

# Filesystem
declare -ig BL64_LIB_ERROR_FILE_NOT_FOUND=50
declare -ig BL64_LIB_ERROR_FILE_NOT_READ=51
declare -ig BL64_LIB_ERROR_FILE_NOT_EXECUTE=52
declare -ig BL64_LIB_ERROR_DIRECTORY_NOT_FOUND=53
declare -ig BL64_LIB_ERROR_DIRECTORY_NOT_READ=54
declare -ig BL64_LIB_ERROR_PATH_NOT_RELATIVE=55
declare -ig BL64_LIB_ERROR_PATH_NOT_ABSOLUTE=56
declare -ig BL64_LIB_ERROR_PATH_NOT_FOUND=57

# General
declare -ig BL64_LIB_ERROR_EXPORT_EMPTY=60
declare -ig BL64_LIB_ERROR_EXPORT_SET=61
declare -ig BL64_LIB_ERROR_PRIVILEGE_IS_ROOT=62
declare -ig BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT=63
declare -ig BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED=64

#
# Local values (not exported)
#

# Set Signal traps
declare BL64_LIB_SIGNAL_HUP="${BL64_LIB_SIGNAL_HUP:--}"
declare BL64_LIB_SIGNAL_STOP="${BL64_LIB_SIGNAL_STOP:--}"
declare BL64_LIB_SIGNAL_QUIT="${BL64_LIB_SIGNAL_QUIT:--}"
declare BL64_LIB_SIGNAL_DEBUG="${BL64_LIB_SIGNAL_DEBUG:--}"
declare BL64_LIB_SIGNAL_ERR="${BL64_LIB_SIGNAL_ERR:--}"
declare BL64_LIB_SIGNAL_EXIT="${BL64_LIB_SIGNAL_EXIT:-bl64_dbg_runtime_show}"

# Capture script name
declare BL64_SCRIPT_NAME="${BL64_SCRIPT_NAME:-${0##*/}}"

# Capture script path
declare BL64_SCRIPT_PATH=''

# Define session ID for the current script
declare BL64_SCRIPT_SID="${BASHPID}"

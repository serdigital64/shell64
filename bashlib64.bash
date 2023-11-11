#!/usr/bin/env bash
#######################################
# BashLib64 / Bash automation library
#
# Author: serdigital64 (https://github.com/serdigital64)
# Repository: https://github.com/automation64/bashlib64
#
# Copyright 2022 SerDigital64@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#######################################

#
# Library Bootstrap
#

# Do not inherit aliases and commands
builtin unset -f unalias
builtin unalias -a
builtin unset -f command
builtin hash -r

# Normalize shtop defaults
builtin shopt -qu \
  'dotglob' \
  'extdebug' \
  'failglob' \
  'globstar' \
  'gnu_errfmt' \
  'huponexit' \
  'lastpipe' \
  'login_shell' \
  'nocaseglob' \
  'nocasematch' \
  'nullglob' \
  'xpg_echo'
builtin shopt -qs \
  'extquote'

# Ensure pipeline exit status is failed when any cmd fails
builtin set -o 'pipefail'

# Enable error processing
builtin set -o 'errtrace'
builtin set -o 'functrace'

# Disable fast-fail. Developer must implement error handling (check for exit status)
builtin set +o 'errexit'

# Reset bash set options to defaults
builtin set -o 'braceexpand'
builtin set -o 'hashall'
builtin set +o 'allexport'
builtin set +o 'histexpand'
builtin set +o 'history'
builtin set +o 'ignoreeof'
builtin set +o 'monitor'
builtin set +o 'noclobber'
builtin set +o 'noglob'
builtin set +o 'nolog'
builtin set +o 'notify'
builtin set +o 'onecmd'
builtin set +o 'posix'

# Do not set/unset - Breaks bats-core
# set -o 'keyword'
# set -o 'noexec'

# Do not inherit sensitive environment variables
builtin unset MAIL
builtin unset ENV
builtin unset IFS
builtin unset TMPDIR

# Normalize terminal settings
TERM="${TERM:-vt100}"

#######################################
# BashLib64 / Module / Globals / Setup script run-time environment
#######################################

export BL64_VERSION='17.2.0'

#
# Imported shell standard variables
#

export LANG
export LC_ALL
export LANGUAGE
export TERM

#
# Common constants
#

# Default value for parameters
export BL64_VAR_DEFAULT='_'

# Flag for incompatible command or task
export BL64_VAR_INCOMPATIBLE='_INC_'

# Flag for unavailable command or task
export BL64_VAR_UNAVAILABLE='_UNV_'

# Pseudo null value
export BL64_VAR_NULL='_NULL_'

# Logical values
export BL64_VAR_TRUE='0'
export BL64_VAR_FALSE='1'
export BL64_VAR_ON='1'
export BL64_VAR_OFF='0'
export BL64_VAR_OK='0'
export BL64_VAR_NONE='_NONE_'
export BL64_VAR_ALL='_ALL_'

#
# Global settings
#
# * Allows the caller to customize bashlib64 behaviour
# * Set the variable to the intented value before sourcing bashlib64
#

# Run lib as command? (On/Off)
export BL64_LIB_CMD="${BL64_LIB_CMD:-$BL64_VAR_OFF}"

# Enable generic compatibility mode? (On/Off)
export BL64_LIB_COMPATIBILITY="${BL64_LIB_COMPATIBILITY:-$BL64_VAR_ON}"

# Normalize locale? (On/Off)
export BL64_LIB_LANG="${BL64_LIB_LANG:-$BL64_VAR_ON}"

# Enable strict security? (On/Off)
export BL64_LIB_STRICT="${BL64_LIB_STRICT:-$BL64_VAR_ON}"

# Enable lib shell traps? (On/Off)
export BL64_LIB_TRAPS="${BL64_LIB_TRAPS:-$BL64_VAR_ON}"

#
# Shared error codes
#
# * Warning: bashlib64 error codes must be declared in this section only to avoid module level duplicates
# * Error code 1 and 2 are reserved for the caller script
# * Codes must be between 3 and 127
#

# Application reserved. Not used by bashlib64
# declare -ig BL64_LIB_ERROR_APP_1=1
# declare -ig BL64_LIB_ERROR_APP_2=2

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
declare -ig BL64_LIB_ERROR_MODULE_NOT_IMPORTED=22

# OS
declare -ig BL64_LIB_ERROR_OS_NOT_MATCH=30
declare -ig BL64_LIB_ERROR_OS_TAG_INVALID=31
declare -ig BL64_LIB_ERROR_OS_INCOMPATIBLE=32
declare -ig BL64_LIB_ERROR_OS_BASH_VERSION=33

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
declare -ig BL64_LIB_ERROR_PATH_PRESENT=58

# IAM
declare -ig BL64_LIB_ERROR_PRIVILEGE_IS_ROOT=60
declare -ig BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT=61
declare -ig BL64_LIB_ERROR_USER_NOT_FOUND=62
#declare -ig BL64_LIB_ERROR_GROUP_NOT_FOUND=63

# General
declare -ig BL64_LIB_ERROR_EXPORT_EMPTY=70
declare -ig BL64_LIB_ERROR_EXPORT_SET=71
declare -ig BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED=72
declare -ig BL64_LIB_ERROR_CHECK_FAILED=80

#
# Script Identify
#

export BL64_SCRIPT_PATH=''
export BL64_SCRIPT_NAME=''
export BL64_SCRIPT_SID=''
export BL64_SCRIPT_ID=''

#
# Set Signal traps
#

export BL64_LIB_SIGNAL_HUP='-'
export BL64_LIB_SIGNAL_STOP='-'
export BL64_LIB_SIGNAL_QUIT='-'
export BL64_LIB_SIGNAL_DEBUG='-'
export BL64_LIB_SIGNAL_ERR='-'
export BL64_LIB_SIGNAL_EXIT='bl64_dbg_runtime_show'

#
# Module IDs
#

export BL64_ANS_MODULE=''
export BL64_API_MODULE=''
export BL64_ARC_MODULE=''
export BL64_AWS_MODULE=''
export BL64_BSH_MODULE=''
export BL64_CHECK_MODULE=''
export BL64_CNT_MODULE=''
export BL64_DBG_MODULE=''
export BL64_FMT_MODULE=''
export BL64_FS_MODULE=''
export BL64_GCP_MODULE=''
export BL64_HLM_MODULE=''
export BL64_IAM_MODULE=''
export BL64_K8S_MODULE=''
export BL64_LOG_MODULE=''
export BL64_MDB_MODULE=''
export BL64_MSG_MODULE=''
export BL64_OS_MODULE=''
export BL64_PKG_MODULE=''
export BL64_PY_MODULE=''
export BL64_RBAC_MODULE=''
export BL64_RND_MODULE=''
export BL64_RXTX_MODULE=''
export BL64_TF_MODULE=''
export BL64_TM_MODULE=''
export BL64_TXT_MODULE=''
export BL64_UI_MODULE=''
export BL64_VCS_MODULE=''
export BL64_XSV_MODULE=''
#######################################
# BashLib64 / Module / Functions / Setup script run-time environment
#######################################

function bl64_lib_mode_command_is_enabled { bl64_lib_flag_is_enabled "$BL64_LIB_CMD"; }
function bl64_lib_mode_compability_is_enabled { bl64_lib_flag_is_enabled "$BL64_LIB_COMPATIBILITY"; }
function bl64_lib_mode_strict_is_enabled { bl64_lib_flag_is_enabled "$BL64_LIB_STRICT"; }

function bl64_lib_lang_is_enabled { bl64_lib_flag_is_enabled "$BL64_LIB_LANG"; }
function bl64_lib_trap_is_enabled { bl64_lib_flag_is_enabled "$BL64_LIB_TRAPS"; }

#######################################
# Determines if the flag variable is enabled or not
#
# * Use to query flag type parameters that are called directly from the shell where bl64 vars are not yet defined
# * Primitive function: should not depend on any other function or external command
# * Flag is considered enabled when value is:
#   * $BL64_VAR_ON
#   * 'ON' | 'on' | 'On'
#   * 'YES' | 'no' | 'No'
#   * 1
#
# Arguments:
#   $1: flag value. Strings are automatically converted to uppercase
# Outputs:
#   STDOUT: None
#   STDERR: command stderr
# Returns:
#   0: flag enabled
#   1: flag disabled
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#######################################
function bl64_lib_flag_is_enabled {
  local -u flag="${1:-}"

  [[ -z "$flag" ]] && return $BL64_LIB_ERROR_PARAMETER_MISSING

  [[ "$flag" == "$BL64_VAR_ON" ||
    "$flag" == 'ON' ||
    "$flag" == 'YES' ]]
}
#######################################
# BashLib64 / Module / Globals / Interact with RESTful APIs
#######################################

export BL64_API_VERSION='1.0.1'

export BL64_API_MODULE="$BL64_VAR_OFF"

#
# Common constants
#

export BL64_API_METHOD_DELETE='DELETE'
export BL64_API_METHOD_GET='GET'
export BL64_API_METHOD_POST='POST'
export BL64_API_METHOD_PUT='PUT'

export _BL64_API_TXT_ERROR_API_FAILED='API call failed'

#######################################
# BashLib64 / Module / Globals / Interact with Bash shell
#######################################

export BL64_BSH_VERSION='1.2.0'

export BL64_BSH_MODULE="$BL64_VAR_OFF"

export BL64_BSH_VERSION_BASH=''

export _BL64_BSH_TXT_UNSUPPORTED='BashLib64 is not supported in the current Bash version'

#######################################
# BashLib64 / Module / Globals / Check for conditions and report status
#######################################

export BL64_CHECK_VERSION='4.2.0'

export BL64_CHECK_MODULE="$BL64_VAR_OFF"

export _BL64_CHECK_TXT_PARAMETER_MISSING='required parameter is missing'
export _BL64_CHECK_TXT_PARAMETER_NOT_SET='required shell variable is not set'
export _BL64_CHECK_TXT_PARAMETER_DEFAULT='required parameter value must be other than default'
export _BL64_CHECK_TXT_PARAMETER_INVALID='the requested operation was provided with an invalid parameter value'

export _BL64_CHECK_TXT_COMMAND_NOT_FOUND='required command is not present'
export _BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE='required command is present but has no execution permission'
export _BL64_CHECK_TXT_COMMAND_NOT_INSTALLED='required command is not installed'
export _BL64_CHECK_TXT_COMMAND_NOT_IN_PATH='required command is not found in any of the search paths'

export _BL64_CHECK_TXT_FILE_NOT_FOUND='required file is not present'
export _BL64_CHECK_TXT_FILE_NOT_FILE='path is present but is not a regular file'
export _BL64_CHECK_TXT_FILE_NOT_READABLE='required file is present but has no read permission'

export _BL64_CHECK_TXT_DIRECTORY_NOT_FOUND='required directory is not present'
export _BL64_CHECK_TXT_DIRECTORY_NOT_DIR='path is present but is not a directory'
export _BL64_CHECK_TXT_DIRECTORY_NOT_READABLE='required directory is present but has no read permission'

export _BL64_CHECK_TXT_EXPORT_EMPTY='required shell exported variable is empty'
export _BL64_CHECK_TXT_EXPORT_SET='required shell exported variable is not set'

export _BL64_CHECK_TXT_PATH_NOT_FOUND='required path is not present'
export _BL64_CHECK_TXT_PATH_NOT_RELATIVE='required path must be relative'
export _BL64_CHECK_TXT_PATH_NOT_ABSOLUTE='required path must be absolute'
export _BL64_CHECK_TXT_PATH_PRESENT='requested path is already present'

export _BL64_CHECK_TXT_PRIVILEGE_IS_NOT_ROOT='the task requires root privilege. Please run the script as root or with SUDO'
export _BL64_CHECK_TXT_PRIVILEGE_IS_ROOT='the task should not be run with root privilege. Please run the script as a regular user and not using SUDO'

export _BL64_CHECK_TXT_OVERWRITE_NOT_PERMITED='target is already present and overwrite is not permitted. Unable to continue'
export _BL64_CHECK_TXT_OVERWRITE_SKIP_EXISTING='target is already present and overwrite is not requested. Target is left as is'

export _BL64_CHECK_TXT_INCOMPATIBLE='the requested operation is not supported on the current OS'
export _BL64_CHECK_TXT_UNDEFINED='requested command is not defined or implemented'
export _BL64_CHECK_TXT_NOARGS='the requested operation requires at least one parameter and none was provided'
export _BL64_CHECK_TXT_FAILED='task execution failed'

export _BL64_CHECK_TXT_MODULE_SET='required BashLib64 module not found. Please source the module before using it'
export _BL64_CHECK_TXT_MODULE_SETUP_FAILED='failed to setup the requested BashLib64 module'
export _BL64_CHECK_TXT_MODULE_NOT_SETUP='required BashLib64 module is not setup. Call the bl64_<MODULE>_setup function before using the module'

export _BL64_CHECK_TXT_HOME_MISSING='standard shell variable HOME is not defined'
export _BL64_CHECK_TXT_HOME_DIR_MISSING="unable to find user's HOME directory"

export _BL64_CHECK_TXT_RESOURCE_NOT_FOUND='required resource was not found on the system'
export _BL64_CHECK_TXT_STATUS_ERROR='task execution failed'
export _BL64_CHECK_TXT_COMPATIBILITY_MODE='using generic compatibility mode for untested command version'

export _BL64_CHECK_TXT_COMMAND='command'
export _BL64_CHECK_TXT_FILE='file'
export _BL64_CHECK_TXT_PATH='path'
export _BL64_CHECK_TXT_FUNCTION='caller'
export _BL64_CHECK_TXT_MODULE='module'
export _BL64_CHECK_TXT_PARAMETER='parameter'

#######################################
# BashLib64 / Module / Globals / Show shell debugging information
#######################################

export BL64_DBG_VERSION='2.3.0'

export BL64_DBG_MODULE="$BL64_VAR_OFF"

# Debug target
export BL64_DBG_TARGET=''

#
# Debug targets. Use to select what to debug and how
#
# * ALL_TRACE: Shell tracing for the application and bashlib64
# * APP_TRACE: Shell tracing for selected application functions
# * APP_TASK: Debugging messages from selected application functions
# * APP_CMD: External commands: enable command specific debugging options used in the app
# * APP_CUSTOM_X: Do nothing. Reserved to allow the application define custom debug
# * APP_ALL: Enable full app debugging (task,trace,cmd)
# * LIB_TRACE: Shell tracing for selected bashlib64 functions
# * LIB_TASK: Debugging messages from selected bashlib64 functions
# * LIB_CMD: External commands: enable command specific debugging options used in bashlib64
# * LIB_ALL: Enable full bashlib64 debugging (task,trace,cmd)
#

export BL64_DBG_TARGET_NONE='NONE'
export BL64_DBG_TARGET_APP_TRACE='APP_TRACE'
export BL64_DBG_TARGET_APP_TASK='APP_TASK'
export BL64_DBG_TARGET_APP_CMD='APP_CMD'
export BL64_DBG_TARGET_APP_ALL='APP'
export BL64_DBG_TARGET_APP_CUSTOM_1='CUSTOM_1'
export BL64_DBG_TARGET_APP_CUSTOM_2='CUSTOM_2'
export BL64_DBG_TARGET_APP_CUSTOM_3='CUSTOM_3'
export BL64_DBG_TARGET_LIB_TRACE='LIB_TRACE'
export BL64_DBG_TARGET_LIB_TASK='LIB_TASK'
export BL64_DBG_TARGET_LIB_CMD='LIB_CMD'
export BL64_DBG_TARGET_LIB_ALL='LIB'
export BL64_DBG_TARGET_ALL='ALL'

export _BL64_DBG_TXT_FUNCTION_START='function tracing started'
export _BL64_DBG_TXT_FUNCTION_STOP='function tracing stopped'
export _BL64_DBG_TXT_SHELL_VAR='shell variable'
export _BL64_DBG_TXT_COMMENTS='dev-comments'

export _BL64_DBG_TXT_LABEL_BASH_RUNTIME='[bash-runtime]'
export _BL64_DBG_TXT_LABEL_BASH_VARIABLE='[bash-variable]'

export _BL64_DBG_TXT_BASH='Bash / Interpreter path'
export _BL64_DBG_TXT_BASHOPTS='Bash / ShOpt Options'
export _BL64_DBG_TXT_SHELLOPTS='Bash / Set -o Options'
export _BL64_DBG_TXT_BASH_VERSION='Bash / Version'
export _BL64_DBG_TXT_OSTYPE='Bash / Detected OS'
export _BL64_DBG_TXT_LC_ALL='Shell / Locale setting'
export _BL64_DBG_TXT_HOSTNAME='Shell / Hostname'
export _BL64_DBG_TXT_EUID='Script / User ID'
export _BL64_DBG_TXT_UID='Script / Effective User ID'
export _BL64_DBG_TXT_BASH_ARGV='Script / Arguments'
export _BL64_DBG_TXT_COMMAND='Script / Last executed command'
export _BL64_DBG_TXT_STATUS='Script / Last exit status'

export _BL64_DBG_TXT_FUNCTION_APP_RUN='run app function with parameters'
export _BL64_DBG_TXT_FUNCTION_LIB_RUN='run bashlib64 function with parameters'

export _BL64_DBG_TXT_CALLSTACK='Last executed function'

export _BL64_DBG_TXT_HOME='Home directory (HOME)'
export _BL64_DBG_TXT_PATH='Search path (PATH)'
export _BL64_DBG_TXT_CD_PWD='Current cd working directory (PWD)'
export _BL64_DBG_TXT_CD_OLDPWD='Previous cd working directory (OLDPWD)'
export _BL64_DBG_TXT_SCRIPT_PATH='Initial script path (BL64_SCRIPT_PATH)'
export _BL64_DBG_TXT_TMPDIR='Temporary path (TMPDIR)'
export _BL64_DBG_TXT_PWD='Current working directory (pwd command)'
export _BL64_DBG_TXT_DEBUG='Debug'

export _BL64_DBG_TXT_WRONG_LEVEL='invalid debugging level. Must be one of: '

#######################################
# BashLib64 / Module / Globals / Manage local filesystem
#######################################

export BL64_FS_VERSION='4.6.1'

export BL64_FS_MODULE="$BL64_VAR_OFF"

export BL64_FS_PATH_TEMPORAL=''
export BL64_FS_PATH_CACHE=''
# Location for temporary files generated by bashlib64 functions
export BL64_FS_PATH_TMP='/tmp'

export BL64_FS_CMD_CHMOD=''
export BL64_FS_CMD_CHOWN=''
export BL64_FS_CMD_CP=''
export BL64_FS_CMD_FIND=''
export BL64_FS_CMD_LN=''
export BL64_FS_CMD_LS=''
export BL64_FS_CMD_MKDIR=''
export BL64_FS_CMD_MKTEMP=''
export BL64_FS_CMD_MV=''
export BL64_FS_CMD_RM=''
export BL64_FS_CMD_TOUCH=''

export BL64_FS_ALIAS_CHOWN_DIR=''
export BL64_FS_ALIAS_CP_FILE=''
export BL64_FS_ALIAS_LN_SYMBOLIC=''
export BL64_FS_ALIAS_LS_FILES=''
export BL64_FS_ALIAS_MKDIR_FULL=''
export BL64_FS_ALIAS_MV=''
export BL64_FS_ALIAS_RM_FILE=''
export BL64_FS_ALIAS_RM_FULL=''

export BL64_FS_SET_CHMOD_RECURSIVE=''
export BL64_FS_SET_CHMOD_VERBOSE=''
export BL64_FS_SET_CHOWN_RECURSIVE=''
export BL64_FS_SET_CHOWN_VERBOSE=''
export BL64_FS_SET_CP_FORCE=''
export BL64_FS_SET_CP_RECURSIVE=''
export BL64_FS_SET_CP_VERBOSE=''
export BL64_FS_SET_FIND_NAME=''
export BL64_FS_SET_FIND_PRINT=''
export BL64_FS_SET_FIND_RUN=''
export BL64_FS_SET_FIND_STAY=''
export BL64_FS_SET_FIND_TYPE_DIR=''
export BL64_FS_SET_FIND_TYPE_FILE=''
export BL64_FS_SET_LN_FORCE=''
export BL64_FS_SET_LN_SYMBOLIC=''
export BL64_FS_SET_LN_VERBOSE=''
export BL64_FS_SET_LS_NOCOLOR=''
export BL64_FS_SET_MKDIR_PARENTS=''
export BL64_FS_SET_MKDIR_VERBOSE=''
export BL64_FS_SET_MKTEMP_DIRECTORY=''
export BL64_FS_SET_MKTEMP_QUIET=''
export BL64_FS_SET_MKTEMP_TMPDIR=''
export BL64_FS_SET_MV_FORCE=''
export BL64_FS_SET_MV_VERBOSE=''
export BL64_FS_SET_RM_FORCE=''
export BL64_FS_SET_RM_RECURSIVE=''
export BL64_FS_SET_RM_VERBOSE=''

export BL64_FS_UMASK_RW_USER='u=rwx,g=,o='
export BL64_FS_UMASK_RW_GROUP='u=rwx,g=rwx,o='
export BL64_FS_UMASK_RW_ALL='u=rwx,g=rwx,o=rwx'
export BL64_FS_UMASK_RW_USER_RO_ALL='u=rwx,g=rx,o=rx'
export BL64_FS_UMASK_RW_GROUP_RO_ALL='u=rwx,g=rwx,o=rx'

export BL64_FS_SAFEGUARD_POSTFIX='.bl64_fs_safeguard'

export BL64_FS_TMP_PREFIX='bl64tmp'

export _BL64_FS_TXT_CLEANUP_CACHES='clean up OS cache contents'
export _BL64_FS_TXT_CLEANUP_LOGS='clean up OS logs'
export _BL64_FS_TXT_CLEANUP_TEMP='clean up OS temporary files'
export _BL64_FS_TXT_COPY_FILE_PATH='copy file'
export _BL64_FS_TXT_CREATE_DIR_PATH='create directory'
export _BL64_FS_TXT_MERGE_ADD_SOURCE='merge content from source'
export _BL64_FS_TXT_MERGE_DIRS='merge directories content'
export _BL64_FS_TXT_RESTORE_OBJECT='restore original file from backup'
export _BL64_FS_TXT_SAFEGUARD_FAILED='unable to safeguard requested path'
export _BL64_FS_TXT_SAFEGUARD_OBJECT='backup original file'
export _BL64_FS_TXT_SYMLINK_CREATE='create symbolick link'
export _BL64_FS_TXT_SYMLINK_EXISTING='target symbolick link is already present. No further action taken'

export _BL64_FS_TXT_ERROR_NOT_TMPDIR='provided directory was not created by bl64_fs_create_tmpdir'
export _BL64_FS_TXT_ERROR_NOT_TMPFILE='provided directory was not created by bl64_fs_create_tmpfile'
export _BL64_FS_TXT_ERROR_INVALID_FILE_TARGET='invalid file destination. Provided path exists and is a directory'
export _BL64_FS_TXT_ERROR_INVALID_DIR_TARGET='invalid directory destination. Provided path exists and is a file'

#######################################
# BashLib64 / Module / Globals / Format text data
#######################################

export BL64_FMT_VERSION='2.2.1'

export BL64_FMT_MODULE="$BL64_VAR_OFF"

export _BL64_FMT_TXT_ERROR_VALUE_LIST_EMPTY='please provide at least one value to check against'
export _BL64_FMT_TXT_ERROR_VALUE_LIST_WRONG='invalid value'
export _BL64_FMT_TXT_VALUE_LIST_VALID='Value must be one of'

#######################################
# BashLib64 / Module / Globals / Display messages
#######################################

export BL64_MSG_VERSION='4.2.0'

export BL64_MSG_MODULE="$BL64_VAR_OFF"

# Target verbosity)
export BL64_MSG_VERBOSE=''

#
# Verbosity levels
#
# * 0: nothing is showed
# * 1: application messages only
# * 2: bashlib64 and application messages
#

export BL64_MSG_VERBOSE_NONE='NONE'
export BL64_MSG_VERBOSE_APP='APP'
export BL64_MSG_VERBOSE_LIB='LIB'
export BL64_MSG_VERBOSE_ALL='ALL'

#
# Message type tag
#

export BL64_MSG_TYPE_BATCH='BATCH'
export BL64_MSG_TYPE_BATCHERR='BATCHERR'
export BL64_MSG_TYPE_BATCHOK='BATCHOK'
export BL64_MSG_TYPE_ERROR='ERROR'
export BL64_MSG_TYPE_INFO='INFO'
export BL64_MSG_TYPE_INPUT='INPUT'
export BL64_MSG_TYPE_LIBINFO='LIBINFO'
export BL64_MSG_TYPE_LIBSUBTASK='LIBSUBTASK'
export BL64_MSG_TYPE_LIBTASK='LIBTASK'
export BL64_MSG_TYPE_PHASE='PHASE'
export BL64_MSG_TYPE_SEPARATOR='SEPARATOR'
export BL64_MSG_TYPE_SUBTASK='SUBTASK'
export BL64_MSG_TYPE_TASK='TASK'
export BL64_MSG_TYPE_WARNING='WARNING'

#
# Message output type
#

export BL64_MSG_OUTPUT_ASCII='A'
export BL64_MSG_OUTPUT_ANSI='N'

# default message output type
export BL64_MSG_OUTPUT=''

#
# Message formats
#

export BL64_MSG_FORMAT_PLAIN='R'
export BL64_MSG_FORMAT_HOST='H'
export BL64_MSG_FORMAT_TIME='T'
export BL64_MSG_FORMAT_CALLER='C'
export BL64_MSG_FORMAT_FULL='F'

# Selected message format
export BL64_MSG_FORMAT="${BL64_MSG_FORMAT:-$BL64_MSG_FORMAT_FULL}"

#
# Message Themes
#

export BL64_MSG_THEME_ID_ASCII_STD='ascii-std'
export BL64_MSG_THEME_ASCII_STD_BATCH='(@)'
export BL64_MSG_THEME_ASCII_STD_BATCHERR='(@)'
export BL64_MSG_THEME_ASCII_STD_BATCHOK='(@)'
export BL64_MSG_THEME_ASCII_STD_ERROR='(!)'
export BL64_MSG_THEME_ASCII_STD_FMTCALLER=''
export BL64_MSG_THEME_ASCII_STD_FMTHOST=''
export BL64_MSG_THEME_ASCII_STD_FMTTIME=''
export BL64_MSG_THEME_ASCII_STD_INFO='(I)'
export BL64_MSG_THEME_ASCII_STD_INPUT='(?)'
export BL64_MSG_THEME_ASCII_STD_LIBINFO='(II)'
export BL64_MSG_THEME_ASCII_STD_LIBSUBTASK='(>>)'
export BL64_MSG_THEME_ASCII_STD_LIBTASK='(--)'
export BL64_MSG_THEME_ASCII_STD_PHASE='(=)'
export BL64_MSG_THEME_ASCII_STD_SEPARATOR=''
export BL64_MSG_THEME_ASCII_STD_SUBTASK='(>)'
export BL64_MSG_THEME_ASCII_STD_TASK='(-)'
export BL64_MSG_THEME_ASCII_STD_WARNING='(*)'

export BL64_MSG_THEME_ID_ANSI_STD='ansi-std'
export BL64_MSG_THEME_ANSI_STD_BATCH='30;1;47'
export BL64_MSG_THEME_ANSI_STD_BATCHERR='5;30;41'
export BL64_MSG_THEME_ANSI_STD_BATCHOK='30;42'
export BL64_MSG_THEME_ANSI_STD_ERROR='5;37;41'
export BL64_MSG_THEME_ANSI_STD_FMTCALLER='33'
export BL64_MSG_THEME_ANSI_STD_FMTHOST='34'
export BL64_MSG_THEME_ANSI_STD_FMTTIME='36'
export BL64_MSG_THEME_ANSI_STD_INFO='36'
export BL64_MSG_THEME_ANSI_STD_INPUT='5;30;47'
export BL64_MSG_THEME_ANSI_STD_LIBINFO='1;32'
export BL64_MSG_THEME_ANSI_STD_LIBSUBTASK='1;36'
export BL64_MSG_THEME_ANSI_STD_LIBTASK='1;35'
export BL64_MSG_THEME_ANSI_STD_PHASE='7;1;36'
export BL64_MSG_THEME_ANSI_STD_SEPARATOR='30;44'
export BL64_MSG_THEME_ANSI_STD_SUBTASK='37'
export BL64_MSG_THEME_ANSI_STD_TASK='1;37'
export BL64_MSG_THEME_ANSI_STD_WARNING='5;37;43'

# Selected message theme
export BL64_MSG_THEME='BL64_MSG_THEME_ANSI_STD'

#
# ANSI codes
#

export BL64_MSG_ANSI_FG_BLACK='30'
export BL64_MSG_ANSI_FG_RED='31'
export BL64_MSG_ANSI_FG_GREEN='32'
export BL64_MSG_ANSI_FG_BROWN='33'
export BL64_MSG_ANSI_FG_BLUE='34'
export BL64_MSG_ANSI_FG_PURPLE='35'
export BL64_MSG_ANSI_FG_CYAN='36'
export BL64_MSG_ANSI_FG_LIGHT_GRAY='37'
export BL64_MSG_ANSI_FG_DARK_GRAY='1;30'
export BL64_MSG_ANSI_FG_LIGHT_RED='1;31'
export BL64_MSG_ANSI_FG_LIGHT_GREEN='1;32'
export BL64_MSG_ANSI_FG_YELLOW='1;33'
export BL64_MSG_ANSI_FG_LIGHT_BLUE='1;34'
export BL64_MSG_ANSI_FG_LIGHT_PURPLE='1;35'
export BL64_MSG_ANSI_FG_LIGHT_CYAN='1;36'
export BL64_MSG_ANSI_FG_WHITE='1;37'

export BL64_MSG_ANSI_BG_BLACK='40'
export BL64_MSG_ANSI_BG_RED='41'
export BL64_MSG_ANSI_BG_GREEN='42'
export BL64_MSG_ANSI_BG_BROWN='43'
export BL64_MSG_ANSI_BG_BLUE='44'
export BL64_MSG_ANSI_BG_PURPLE='45'
export BL64_MSG_ANSI_BG_CYAN='46'
export BL64_MSG_ANSI_BG_LIGHT_GRAY='47'
export BL64_MSG_ANSI_BG_DARK_GRAY='1;40'
export BL64_MSG_ANSI_BG_LIGHT_RED='1;41'
export BL64_MSG_ANSI_BG_LIGHT_GREEN='1;42'
export BL64_MSG_ANSI_BG_YELLOW='1;43'
export BL64_MSG_ANSI_BG_LIGHT_BLUE='1;44'
export BL64_MSG_ANSI_BG_LIGHT_PURPLE='1;45'
export BL64_MSG_ANSI_BG_LIGHT_CYAN='1;46'
export BL64_MSG_ANSI_BG_WHITE='1;47'

export BL64_MSG_ANSI_CHAR_NORMAL='0'
export BL64_MSG_ANSI_CHAR_BOLD='1'
export BL64_MSG_ANSI_CHAR_UNDERLINE='4'
export BL64_MSG_ANSI_CHAR_BLINK='5'
export BL64_MSG_ANSI_CHAR_REVERSE='7'

#
# Cosmetic
#

export BL64_MSG_COSMETIC_ARROW='-->'
export BL64_MSG_COSMETIC_ARROW2='==>'
export BL64_MSG_COSMETIC_LEFT_ARROW='<--'
export BL64_MSG_COSMETIC_LEFT_ARROW2='<=='
export BL64_MSG_COSMETIC_PHASE_PREFIX='===['
export BL64_MSG_COSMETIC_PHASE_SUFIX=']==='
export BL64_MSG_COSMETIC_PIPE='|'

#
# Display messages
#

export _BL64_MSG_TXT_BATCH_FINISH_ERROR='finished with errors'
export _BL64_MSG_TXT_BATCH_FINISH_OK='finished successfully'
export _BL64_MSG_TXT_BATCH_START='started'
export _BL64_MSG_TXT_BATCH='Process'
export _BL64_MSG_TXT_COMMANDS='Commands'
export _BL64_MSG_TXT_ERROR='Error'
export _BL64_MSG_TXT_FLAGS='Flags'
export _BL64_MSG_TXT_INFO='Info'
export _BL64_MSG_TXT_INPUT='Input'
export _BL64_MSG_TXT_INVALID_VALUE='invalid value. Not one of'
export _BL64_MSG_TXT_PARAMETERS='Parameters'
export _BL64_MSG_TXT_PHASE='Phase'
export _BL64_MSG_TXT_SEPARATOR='>>>>>'
export _BL64_MSG_TXT_SUBTASK='Subtask'
export _BL64_MSG_TXT_TASK='Task'
export _BL64_MSG_TXT_USAGE='Usage'
export _BL64_MSG_TXT_WARNING='Warning'

#######################################
# BashLib64 / Module / Globals / OS / Identify OS attributes and provide command aliases
#######################################

export BL64_OS_VERSION='4.1.0'

export BL64_OS_MODULE="$BL64_VAR_OFF"

export BL64_OS_DISTRO=''

export BL64_OS_CMD_BASH=''
export BL64_OS_CMD_CAT=''
export BL64_OS_CMD_DATE=''
export BL64_OS_CMD_FALSE=''
export BL64_OS_CMD_HOSTNAME=''
export BL64_OS_CMD_LOCALE=''
export BL64_OS_CMD_TEE=''
export BL64_OS_CMD_TRUE=''
export BL64_OS_CMD_UNAME=''

export BL64_OS_ALIAS_ID_USER=''

export BL64_OS_SET_LOCALE_ALL=''

export _BL64_OS_TXT_CHECK_OS_MATRIX='Please check the OS compatibility matrix for BashLib64'
export _BL64_OS_TXT_ERROR_OS_RELEASE='failed to load OS information from /etc/os-release file'
export _BL64_OS_TXT_INVALID_OS_PATTERN='invalid OS pattern'
export _BL64_OS_TXT_OS_MATRIX='Compatible-versions'
export _BL64_OS_TXT_OS_NOT_KNOWN='current OS is not supported'
export _BL64_OS_TXT_OS_NOT_SUPPORTED='BashLib64 not supported on the current OS'
export _BL64_OS_TXT_OS_VERSION_NOT_SUPPORTED='current OS version is not supported'
export _BL64_OS_TXT_TASK_NOT_SUPPORTED='task not supported on the current OS version'

#
# OS standard name tags
#
# * Used to normalize OS names
# * Format: BL64_OS_TAG
#

# ALM -> AlmaLinux
export BL64_OS_ALM='ALMALINUX'
# ALP -> Alpine Linux
export BL64_OS_ALP='ALPINE'
# AMZ -> Amazon Linux
export BL64_OS_AMZ='AMZN'
# CNT -> CentOS
export BL64_OS_CNT='CENTOS'
# DEB -> Debian
export BL64_OS_DEB='DEBIAN'
# FD  -> Fedora
export BL64_OS_FD='FEDORA'
# MCOS-> MacOS (Darwin)
export BL64_OS_MCOS='DARWIN'
# OL  -> OracleLinux
export BL64_OS_OL='OL'
# RCK -> Rocky Linux
export BL64_OS_RCK='ROCKY'
# RHEL-> RedHat Enterprise Linux
export BL64_OS_RHEL='RHEL'
# SLES-> SUSE Linux Enterprise Server
export BL64_OS_SLES='SLES'
# UB  -> Ubuntu
export BL64_OS_UB='UBUNTU'
# UNK -> Unknown OS
export BL64_OS_UNK='UNKNOWN'

#######################################
# BashLib64 / Module / Globals / Manage role based access service
#######################################

export BL64_RBAC_VERSION='1.12.1'

export BL64_RBAC_MODULE="$BL64_VAR_OFF"

export BL64_RBAC_CMD_SUDO=''
export BL64_RBAC_CMD_VISUDO=''
export BL64_RBAC_FILE_SUDOERS=''

export BL64_RBAC_ALIAS_SUDO_ENV=''

export BL64_RBAC_SET_SUDO_CHECK=''
export BL64_RBAC_SET_SUDO_FILE=''
export BL64_RBAC_SET_SUDO_QUIET=''

export _BL64_RBAC_TXT_INVALID_SUDOERS='the sudoers file is corrupt or invalid'
export _BL64_RBAC_TXT_ADD_ROOT='add password-less root privilege to user'

#######################################
# BashLib64 / Module / Globals / Generate random data
#######################################

export BL64_RND_VERSION='1.1.2'

export BL64_RND_MODULE="$BL64_VAR_OFF"

declare -ig BL64_RND_LENGTH_1=1
declare -ig BL64_RND_LENGTH_20=20
declare -ig BL64_RND_LENGTH_100=100
declare -ig BL64_RND_RANDOM_MIN=0
declare -ig BL64_RND_RANDOM_MAX=32767

# shellcheck disable=SC2155
export BL64_RND_POOL_UPPERCASE="$(printf '%b' "$(printf '\\%o' {65..90})")"
export BL64_RND_POOL_UPPERCASE_MAX_IDX="$(( ${#BL64_RND_POOL_UPPERCASE} - 1 ))"
# shellcheck disable=SC2155
export BL64_RND_POOL_LOWERCASE="$(printf '%b' "$(printf '\\%o' {97..122})")"
export BL64_RND_POOL_LOWERCASE_MAX_IDX="$(( ${#BL64_RND_POOL_LOWERCASE} - 1 ))"
# shellcheck disable=SC2155
export BL64_RND_POOL_DIGITS="$(printf '%b' "$(printf '\\%o' {48..57})")"
export BL64_RND_POOL_DIGITS_MAX_IDX="$(( ${#BL64_RND_POOL_DIGITS} - 1 ))"
export BL64_RND_POOL_ALPHANUMERIC="${BL64_RND_POOL_UPPERCASE}${BL64_RND_POOL_LOWERCASE}${BL64_RND_POOL_DIGITS}"
export BL64_RND_POOL_ALPHANUMERIC_MAX_IDX="$(( ${#BL64_RND_POOL_ALPHANUMERIC} - 1 ))"

export _BL64_RND_TXT_LENGHT_MIN='length can not be less than'
export _BL64_RND_TXT_LENGHT_MAX='length can not be greater than'

#######################################
# BashLib64 / Module / Globals / Transfer and Receive data over the network
#######################################

export BL64_RXTX_VERSION='1.20.0'

export BL64_RXTX_MODULE="$BL64_VAR_OFF"

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

#######################################
# BashLib64 / Module / Globals / Manage date-time data
#######################################

export BL64_TM_VERSION='1.0.0'

export BL64_TM_MODULE="$BL64_VAR_OFF"

#######################################
# BashLib64 / Module / Globals / Manipulate text files content
#######################################

export BL64_TXT_VERSION='1.12.0'

export BL64_TXT_MODULE="$BL64_VAR_OFF"

export BL64_TXT_CMD_AWK_POSIX=''
export BL64_TXT_CMD_AWK=''
export BL64_TXT_CMD_BASE64=''
export BL64_TXT_CMD_CUT=''
export BL64_TXT_CMD_ENVSUBST=''
export BL64_TXT_CMD_GAWK=''
export BL64_TXT_CMD_GREP=''
export BL64_TXT_CMD_SED=''
export BL64_TXT_CMD_SORT=''
export BL64_TXT_CMD_TR=''
export BL64_TXT_CMD_UNIQ=''

export BL64_TXT_SET_AWK_POSIX=''
export BL64_TXT_SET_GREP_ERE="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_GREP_INVERT="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_GREP_NO_CASE="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_GREP_QUIET="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_GREP_SHOW_FILE_ONLY="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_GREP_STDIN="$BL64_VAR_UNAVAILABLE"
export BL64_TXT_SET_SED_EXPRESSION="$BL64_VAR_UNAVAILABLE"

export BL64_TXT_SET_AWS_FS="$BL64_VAR_UNAVAILABLE"

export BL64_TXT_FLAG_STDIN='STDIN'

#######################################
# BashLib64 / Module / Globals / User Interface
#######################################

export BL64_UI_VERSION='1.0.1'

export BL64_UI_MODULE="$BL64_VAR_OFF"

export BL64_UI_READ_TIMEOUT='60'

export _BL64_UI_TXT_CONFIRMATION_QUESTION='Please confirm the operation by writting the message'
export _BL64_UI_TXT_CONFIRMATION_MESSAGE='confirm-operation'
export _BL64_UI_TXT_CONFIRMATION_ERROR='provided confirmation message is not what is expected'

#######################################
# BashLib64 / Module / Globals / Manage Version Control System
#######################################

export BL64_VCS_VERSION='1.14.1'

export BL64_VCS_MODULE="$BL64_VAR_OFF"

export BL64_VCS_CMD_GIT=''

export BL64_VCS_SET_GIT_NO_PAGER=''
export BL64_VCS_SET_GIT_QUIET=''

#
# GitHub related parameters
#

# GitHub API FQDN
export BL64_VCS_GITHUB_API_URL='https://api.github.com'
# Target GitHub public API version
export BL64_VCS_GITHUB_API_VERSION='2022-11-28'
# Special tag for latest release
export BL64_VCS_GITHUB_LATEST='latest'

export _BL64_VCS_TXT_CLONE_REPO='clone single branch from GIT repository'
export _BL64_VCS_TXT_GET_LATEST_RELEASE='get release tag from latest release'
export _BL64_VCS_TXT_GET_LATEST_RELEASE_FAILED='unable to determine latest release'

#######################################
# BashLib64 / Module / Globals / Manipulate CSV like text files
#
# Version: 1.5.0
#######################################

export BL64_XSV_VERSION='1.5.0'

export BL64_XSV_MODULE="$BL64_VAR_OFF"

# Field separators
export BL64_XSV_FS='_@64@_' # Custom
export BL64_XSV_FS_SPACE=' '
export BL64_XSV_FS_NEWLINE=$'\n'
export BL64_XSV_FS_TAB=$'\t'
export BL64_XSV_FS_COLON=':'
export BL64_XSV_FS_SEMICOLON=';'
export BL64_XSV_FS_COMMA=','
export BL64_XSV_FS_PIPE='|'
export BL64_XSV_FS_AT='@'
export BL64_XSV_FS_DOLLAR='$'
export BL64_XSV_FS_SLASH='/'

export _BL64_XSV_TXT_SOURCE_NOT_FOUND='source file not found'

#######################################
# BashLib64 / Module / Globals / Write messages to logs
#######################################

export BL64_LOG_VERSION='2.0.0'

# Optional module. Not enabled by default
export BL64_LOG_MODULE="$BL64_VAR_OFF"

# Log file types
export BL64_LOG_FORMAT_CSV='C'

# Logging categories
export BL64_LOG_CATEGORY_NONE='NONE'
export BL64_LOG_CATEGORY_INFO='INFO'
export BL64_LOG_CATEGORY_DEBUG='DEBUG'
export BL64_LOG_CATEGORY_WARNING='WARNING'
export BL64_LOG_CATEGORY_ERROR='ERROR'

# Parameters
export BL64_LOG_REPOSITORY_MODE='0755'
export BL64_LOG_TARGET_MODE='0644'

# Module variables
export BL64_LOG_FS=''
export BL64_LOG_FORMAT=''
export BL64_LOG_LEVEL=''
export BL64_LOG_REPOSITORY=''
export BL64_LOG_DESTINATION=''
export BL64_LOG_RUNTIME=''

export _BL64_LOG_TXT_INVALID_TYPE='invalid log type. Please use any of BL64_LOG_TYPE_*'
export _BL64_LOG_TXT_SET_TARGET_FAILED='failed to set log target'
export _BL64_LOG_TXT_CREATE_REPOSITORY='create log repository'
#######################################
# BashLib64 / Module / Globals / Manage OS identity and access service
#######################################

export BL64_IAM_VERSION='3.0.1'

export BL64_IAM_MODULE="$BL64_VAR_OFF"

export BL64_IAM_CMD_USERADD=''
export BL64_IAM_CMD_ID=''

export BL64_IAM_SET_USERADD_CREATE_HOME=''
export BL64_IAM_SET_USERADD_GROUP=''
export BL64_IAM_SET_USERADD_HOME_PATH=''
export BL64_IAM_SET_USERADD_SHELL=''

export BL64_IAM_ALIAS_USERADD=''

export _BL64_IAM_TXT_ADD_USER='create user account'
export _BL64_IAM_TXT_EXISTING_USER='user already created, re-using existing one'
export _BL64_IAM_TXT_USER_NOT_FOUND='required user is not present in the operating system'

#######################################
# BashLib64 / Module / Globals / Manage native OS packages
#######################################

export BL64_PKG_VERSION='4.3.0'

export BL64_PKG_MODULE="$BL64_VAR_OFF"

export BL64_PKG_CMD_APK=''
export BL64_PKG_CMD_APT=''
export BL64_PKG_CMD_BRW=''
export BL64_PKG_CMD_DNF=''
export BL64_PKG_CMD_YUM=''
export BL64_PKG_CMD_ZYPPER=''

export BL64_PKG_ALIAS_APK_CLEAN=''
export BL64_PKG_ALIAS_APK_INSTALL=''
export BL64_PKG_ALIAS_APK_CACHE=''
export BL64_PKG_ALIAS_APT_CLEAN=''
export BL64_PKG_ALIAS_APT_INSTALL=''
export BL64_PKG_ALIAS_APT_CACHE=''
export BL64_PKG_ALIAS_BRW_CLEAN=''
export BL64_PKG_ALIAS_BRW_INSTALL=''
export BL64_PKG_ALIAS_BRW_CACHE=''
export BL64_PKG_ALIAS_DNF_CACHE=''
export BL64_PKG_ALIAS_DNF_CLEAN=''
export BL64_PKG_ALIAS_DNF_INSTALL=''
export BL64_PKG_ALIAS_YUM_CACHE=''
export BL64_PKG_ALIAS_YUM_CLEAN=''
export BL64_PKG_ALIAS_YUM_INSTALL=''

export BL64_PKG_SET_ASSUME_YES=''
export BL64_PKG_SET_QUIET=''
export BL64_PKG_SET_SLIM=''
export BL64_PKG_SET_VERBOSE=''

#
# Common paths
#

export BL64_PKG_PATH_APT_SOURCES_LIST_D=''
export BL64_PKG_PATH_GPG_KEYRINGS=''
export BL64_PKG_PATH_YUM_REPOS_D=''

export BL64_PKG_DEF_SUFIX_APT_REPOSITORY='list'
export BL64_PKG_DEF_SUFIX_GPG_FILE='gpg'
export BL64_PKG_DEF_SUFIX_YUM_REPOSITORY='repo'

export _BL64_PKG_TXT_CLEAN='clean up package manager run-time environment'
export _BL64_PKG_TXT_INSTALL='install packages'
export _BL64_PKG_TXT_UPGRADE='upgrade packages'
export _BL64_PKG_TXT_PREPARE='initialize package manager'
export _BL64_PKG_TXT_REPOSITORY_REFRESH='refresh package repository content'
export _BL64_PKG_TXT_REPOSITORY_ADD='add remote package repository'
export _BL64_PKG_TXT_REPOSITORY_EXISTING='requested repository is already present. Continue using existing one.'
export _BL64_PKG_TXT_REPOSITORY_ADD_YUM='create YUM repository definition'
export _BL64_PKG_TXT_REPOSITORY_ADD_APT='create APT repository definition'
export _BL64_PKG_TXT_REPOSITORY_ADD_KEY='install GPG key'

#######################################
# BashLib64 / Module / Globals / Interact with system-wide Python
#######################################

export BL64_PY_VERSION='1.15.0'

# Optional module. Not enabled by default
export BL64_PY_MODULE="$BL64_VAR_OFF"

# Define placeholders for optional distro native python versions
export BL64_PY_CMD_PYTHON3="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON35="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON36="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON37="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON38="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON39="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON310="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON311="$BL64_VAR_UNAVAILABLE"
export BL64_PY_CMD_PYTHON312="$BL64_VAR_UNAVAILABLE"

# Full path to the python venv activated by bl64_py_setup
export BL64_PY_VENV_PATH=''

# Version info
export BL64_PY_VERSION_PYTHON3=''
export BL64_PY_VERSION_PIP3=''

export BL64_PY_SET_PIP_VERBOSE=''
export BL64_PY_SET_PIP_VERSION=''
export BL64_PY_SET_PIP_UPGRADE=''
export BL64_PY_SET_PIP_USER=''
export BL64_PY_SET_PIP_DEBUG=''
export BL64_PY_SET_PIP_QUIET=''
export BL64_PY_SET_PIP_SITE=''
export BL64_PY_SET_PIP_NO_WARN_SCRIPT=''

export BL64_PY_DEF_VENV_CFG=''
export BL64_PY_DEF_MODULE_VENV=''
export BL64_PY_DEF_MODULE_PIP=''

export _BL64_PY_TXT_PIP_PREPARE_PIP='upgrade pip module'
export _BL64_PY_TXT_PIP_PREPARE_SETUP='install and upgrade setuptools modules'
export _BL64_PY_TXT_PIP_CLEANUP_PIP='cleanup pip cache'
export _BL64_PY_TXT_PIP_INSTALL='install modules'
export _BL64_PY_TXT_VENV_MISSING='requested python virtual environment is missing'
export _BL64_PY_TXT_VENV_INVALID='requested python virtual environment is invalid (no pyvenv.cfg found)'
export _BL64_PY_TXT_VENV_CREATE='create python virtual environment'

#######################################
# BashLib64 / Module / Globals / Manage archive files
#######################################

export BL64_ARC_VERSION='2.1.0'

export BL64_ARC_MODULE="$BL64_VAR_OFF"

export BL64_ARC_CMD_TAR=''
export BL64_ARC_CMD_UNZIP=''

export BL64_ARC_SET_TAR_VERBOSE=''

export BL64_ARC_SET_UNZIP_OVERWRITE=''

export _BL64_ARC_TXT_OPEN_ZIP='open zip archive'
export _BL64_ARC_TXT_OPEN_TAR='open tar archive'

#######################################
# BashLib64 / Module / Globals / Interact with Ansible CLI
#######################################

export BL64_ANS_VERSION='1.6.0'

# Optional module. Not enabled by default
export BL64_ANS_MODULE="$BL64_VAR_OFF"

export BL64_ANS_ENV_IGNORE=''

export BL64_ANS_VERSION_CORE=''

export BL64_ANS_CMD_ANSIBLE="$BL64_VAR_UNAVAILABLE"
export BL64_ANS_CMD_ANSIBLE_PLAYBOOK="$BL64_VAR_UNAVAILABLE"
export BL64_ANS_CMD_ANSIBLE_GALAXY="$BL64_VAR_UNAVAILABLE"

export BL64_ANS_PATH_USR_ANSIBLE=''
export BL64_ANS_PATH_USR_COLLECTIONS=''
export BL64_ANS_PATH_USR_CONFIG=''

export BL64_ANS_SET_VERBOSE=''
export BL64_ANS_SET_DIFF=''
export BL64_ANS_SET_DEBUG=''

export _BL64_ANS_TXT_ERROR_GET_VERSION='failed to get CLI version'

#######################################
# BashLib64 / Module / Globals / Interact with AWS
#######################################

export BL64_AWS_VERSION='1.4.1'

# Optional module. Not enabled by default
export BL64_AWS_MODULE="$BL64_VAR_OFF"

export BL64_AWS_CMD_AWS="$BL64_VAR_UNAVAILABLE"

export BL64_AWS_DEF_SUFFIX_TOKEN=''
export BL64_AWS_DEF_SUFFIX_HOME=''
export BL64_AWS_DEF_SUFFIX_CACHE=''
export BL64_AWS_DEF_SUFFIX_CONFIG=''
export BL64_AWS_DEF_SUFFIX_CREDENTIALS=''

export BL64_AWS_CLI_MODE='0700'
export BL64_AWS_CLI_HOME=''
export BL64_AWS_CLI_CONFIG=''
export BL64_AWS_CLI_CREDENTIALS=''
export BL64_AWS_CLI_TOKEN=''
export BL64_AWS_CLI_REGION=''

export BL64_AWS_SET_FORMAT_JSON=''
export BL64_AWS_SET_FORMAT_TEXT=''
export BL64_AWS_SET_FORMAT_TABLE=''
export BL64_AWS_SET_FORMAT_YAML=''
export BL64_AWS_SET_FORMAT_STREAM=''
export BL64_AWS_SET_DEBUG=''
export BL64_AWS_SET_OUPUT_NO_PAGER=''

export _BL64_AWS_TXT_TOKEN_NOT_FOUND='unable to locate temporary access token file'

#######################################
# BashLib64 / Module / Globals / Interact with container engines
#######################################

export BL64_CNT_VERSION='2.0.0'

# Optional module. Not enabled by default
export BL64_CNT_MODULE="$BL64_VAR_OFF"

export BL64_CNT_DRIVER_DOCKER='docker'
export BL64_CNT_DRIVER_PODMAN='podman'
export BL64_CNT_DRIVER=''

export BL64_CNT_FLAG_STDIN='-'

export BL64_CNT_CMD_PODMAN=''
export BL64_CNT_CMD_DOCKER=''

export BL64_CNT_SET_DEBUG=''
export BL64_CNT_SET_ENTRYPOINT=''
export BL64_CNT_SET_FILE=''
export BL64_CNT_SET_FILTER=''
export BL64_CNT_SET_INTERACTIVE=''
export BL64_CNT_SET_LOG_LEVEL=''
export BL64_CNT_SET_NO_CACHE=''
export BL64_CNT_SET_PASSWORD_STDIN=''
export BL64_CNT_SET_PASSWORD=''
export BL64_CNT_SET_QUIET=''
export BL64_CNT_SET_RM=''
export BL64_CNT_SET_TAG=''
export BL64_CNT_SET_TTY=''
export BL64_CNT_SET_USERNAME=''
export BL64_CNT_SET_VERSION=''

export BL64_CNT_SET_FILTER_ID=''
export BL64_CNT_SET_FILTER_NAME=''
export BL64_CNT_SET_LOG_LEVEL_DEBUG=''
export BL64_CNT_SET_LOG_LEVEL_ERROR=''
export BL64_CNT_SET_LOG_LEVEL_INFO=''
export BL64_CNT_SET_STATUS_RUNNING=''


export BL64_CNT_PATH_DOCKER_SOCKET=''

export _BL64_CNT_TXT_NO_CLI='unable to detect supported container engine'
export _BL64_CNT_TXT_EXISTING_NETWORK='container network already created. No further action needed'
export _BL64_CNT_TXT_CREATE_NETWORK='creating container network'
export _BL64_CNT_TXT_LOGIN_REGISTRY='loging to container registry'
export _BL64_CNT_TXT_BUILD='build container image'
export _BL64_CNT_TXT_PUSH='push container image to registry'
export _BL64_CNT_TXT_PULL='pull container image from registry'
export _BL64_CNT_TXT_TAG='add tag to container image'
export _BL64_CNT_TXT_MISSING_FILTER='no filter was selected. Task requires one of them'

#######################################
# BashLib64 / Module / Globals / Interact with GCP
#######################################

export BL64_GCP_VERSION='1.5.1'

# Optional module. Not enabled by default
export BL64_GCP_MODULE="$BL64_VAR_OFF"

export BL64_GCP_CMD_GCLOUD="$BL64_VAR_UNAVAILABLE"

export BL64_GCP_CONFIGURATION_NAME='bl64_gcp_configuration_private'
export BL64_GCP_CONFIGURATION_CREATED="$BL64_VAR_FALSE"

export BL64_GCP_SET_FORMAT_YAML=''
export BL64_GCP_SET_FORMAT_TEXT=''
export BL64_GCP_SET_FORMAT_JSON=''

export BL64_GCP_CLI_PROJECT=''
export BL64_GCP_CLI_IMPERSONATE_SA=''

#######################################
# BashLib64 / Module / Globals / Interact with HLM
#######################################

export BL64_HLM_VERSION='1.3.0'

# Optional module. Not enabled by default
export BL64_HLM_MODULE="$BL64_VAR_OFF"

export BL64_HLM_CMD_HELM="$BL64_VAR_UNAVAILABLE"

export BL64_HLM_SET_DEBUG=''
export BL64_HLM_SET_OUTPUT_TABLE=''
export BL64_HLM_SET_OUTPUT_JSON=''
export BL64_HLM_SET_OUTPUT_YAML=''

export BL64_HLM_RUN_TIMEOUT=''

export BL64_HLM_TXT_ADD_REPO='add Helm repository'
export BL64_HLM_TXT_UPDATE_REPO='update Helm repository catalog'
export BL64_HLM_TXT_DEPLOY_CHART='deploy helm chart'

#######################################
# BashLib64 / Module / Globals / Interact with Kubernetes
#######################################

export BL64_K8S_VERSION='2.1.0'

# Optional module. Not enabled by default
export BL64_K8S_MODULE="$BL64_VAR_OFF"

export BL64_K8S_CMD_KUBECTL="$BL64_VAR_UNAVAILABLE"

export BL64_K8S_CFG_KUBECTL_OUTPUT=''
export BL64_K8S_CFG_KUBECTL_OUTPUT_JSON='j'
export BL64_K8S_CFG_KUBECTL_OUTPUT_YAML='y'

export BL64_K8S_SET_VERBOSE_NONE="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_VERBOSE_NORMAL="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_VERBOSE_DEBUG="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_OUTPUT_JSON="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_OUTPUT_YAML="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_OUTPUT_TXT="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_OUTPUT_NAME="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_DRY_RUN_SERVER="$BL64_VAR_UNAVAILABLE"
export BL64_K8S_SET_DRY_RUN_CLIENT="$BL64_VAR_UNAVAILABLE"

export BL64_K8S_VERSION_KUBECTL=''

export BL64_K8S_RESOURCE_NS='namespace'
export BL64_K8S_RESOURCE_SA='serviceaccount'
export BL64_K8S_RESOURCE_SECRET='secret'

export _BL64_K8S_TXT_CREATE_NS='create namespace'
export _BL64_K8S_TXT_CREATE_SA='create service account'
export _BL64_K8S_TXT_CREATE_SECRET='create generic secret'
export _BL64_K8S_TXT_SET_LABEL='set or update label'
export _BL64_K8S_TXT_SET_ANNOTATION='set or update annotation'
export _BL64_K8S_TXT_GET_SECRET='get secret definition from source'
export _BL64_K8S_TXT_CREATE_SECRET='copy secret to destination'
export _BL64_K8S_TXT_RESOURCE_UPDATE='create or update resource definition'
export _BL64_K8S_TXT_RESOURCE_EXISTING='the resource is already created. No further actions are needed'
export _BL64_K8S_TXT_ERROR_KUBECTL_VERSION='unable to determine kubectl version'
export _BL64_K8S_TXT_ERROR_INVALID_KUBECONF='kubectl config file not found'
export _BL64_K8S_TXT_ERROR_MISSING_COMMAND='kubectl command not provided'

#######################################
# BashLib64 / Module / Setup / Interact with MongoDB
#######################################

export BL64_MDB_VERSION='1.1.0'

# Optional module. Not enabled by default
export BL64_MDB_MODULE="$BL64_VAR_OFF"

export BL64_MDB_CMD_MONGOSH="$BL64_VAR_UNAVAILABLE"
export BL64_MDB_CMD_MONGORESTORE="$BL64_VAR_UNAVAILABLE"
export BL64_MDB_CMD_MONGOEXPORT="$BL64_VAR_UNAVAILABLE"

export BL64_MDB_SET_VERBOSE=''
export BL64_MDB_SET_QUIET=''
export BL64_MDB_SET_NORC=''

export BL64_MDB_REPLICA_WRITE=''
export BL64_MDB_REPLICA_TIMEOUT=''

#######################################
# BashLib64 / Module / Globals / Interact with Terraform
#######################################

export BL64_TF_VERSION='1.3.0'

# Optional module. Not enabled by default
export BL64_TF_MODULE="$BL64_VAR_OFF"

export BL64_TF_LOG_PATH=''
export BL64_TF_LOG_LEVEL=''

export BL64_TF_CMD_TERRAFORM="$BL64_VAR_UNAVAILABLE"

export BL64_TF_VERSION_CLI=''

# Output export formats
export BL64_TF_OUTPUT_RAW='0'
export BL64_TF_OUTPUT_JSON='1'
export BL64_TF_OUTPUT_TEXT='2'

export BL64_TF_SET_LOG_TRACE=''
export BL64_TF_SET_LOG_DEBUG=''
export BL64_TF_SET_LOG_INFO=''
export BL64_TF_SET_LOG_WARN=''
export BL64_TF_SET_LOG_ERROR=''
export BL64_TF_SET_LOG_OFF=''

export BL64_TF_DEF_PATH_LOCK=''
export BL64_TF_DEF_PATH_RUNTIME=''

export _BL64_TF_TXT_ERROR_GET_VERSION='failed to get terraform CLI version'

#######################################
# BashLib64 / Module / Setup / Interact with RESTful APIs
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_api_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  BL64_API_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'api'
}

#######################################
# BashLib64 / Module / Functions / Interact with RESTful APIs
#######################################

#######################################
# Call RESTful API using Curl
#
# * API calls are executed using Curl
# * Curl is used directly instead of the wrapper to minimize shell expansion unintented modifications
# * The caller is responsible for properly url-encoding the query when needed
# * Using curl --fail option to capture HTTP errors
#
# Arguments:
#   $1: API server FQDN. Format: PROTOCOL://FQDN
#   $2: API path. Format: Full path (/X/Y/Z)
#   $3: RESTful method. Format: $BL64_API_METHOD_*. Default: $BL64_API_METHOD_GET
#   $4: API query to be appended to the API path. Format: url encoded string. Default: none
#   $@: additional arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: API call executed. Warning: curl exit status only, not the HTTP status code
#   >: API call failed or unable to call API
#######################################
function bl64_api_call() {
  bl64_dbg_lib_show_function "$@"
  local api_url="$1"
  local api_path="$2"
  local api_method="${3:-${BL64_API_METHOD_GET}}"
  local api_query="${4:-${BL64_VAR_NULL}}"
  local debug="$BL64_RXTX_SET_CURL_SILENT"
  local -i status=0

  bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_command "$BL64_RXTX_CMD_CURL" &&
    bl64_check_parameter 'api_url' &&
    bl64_check_parameter 'api_path' || return $?

  [[ "$api_query" == "${BL64_VAR_NULL}" ]] && api_query=''
  shift
  shift
  shift
  shift

  bl64_dbg_lib_command_enabled && debug="${BL64_RXTX_SET_CURL_VERBOSE} ${BL64_RXTX_SET_CURL_INCLUDE}"
  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_RXTX_CMD_CURL" \
    $BL64_RXTX_SET_CURL_FAIL \
    $BL64_RXTX_SET_CURL_REDIRECT \
    $BL64_RXTX_SET_CURL_SECURE \
    $BL64_RXTX_SET_CURL_REQUEST ${api_method} \
    $debug \
    "${api_url}${api_path}${api_query}" \
    "$@"
  bl64_dbg_lib_trace_stop
  status=$?
  (( status != 0 )) && bl64_msg_show_error "${_BL64_API_TXT_ERROR_API_FAILED} (${api_url}${api_path})"
  return $status
}

#######################################
# Converts ASCII-127 string to URL compatible format
#
# * Target is the QUERY segment of the URL:
# *   PROTOCOL://FQDN/QUERY
# * Conversion is done using sed
# * Input is assumed to be encoded in ASCII-127
# * Conversion is done as per RFC3986
# *  unreserved: left as is
# *  reserved: converted
# *  remaining ascii-127 non-control chars: converted
# * Warning: sed regexp is not consistent across versions and vendors. Using [] when \ is not possible to scape special chars
#
# Arguments:
#   $1: String to convert. Must be terminated by \n
# Outputs:
#   STDOUT: encoded string
#   STDERR: execution errors
# Returns:
#   0: successfull execution
#   >0: failed to convert
#######################################
function bl64_api_url_encode() {
  bl64_dbg_lib_show_function "$@"
  local raw_string="$1"

  bl64_check_parameter 'raw_string' || return $?

  echo "$raw_string" |
    bl64_txt_run_sed \
      -e 's/%/%25/g' \
      -e 's/ /%20/g' \
      -e 's/:/%3A/g' \
      -e 's/\//%2F/g' \
      -e 's/[?]/%3F/g' \
      -e 's/#/%23/g' \
      -e 's/@/%40/g' \
      -e 's/\[/%5B/g' \
      -e 's/\]/%5D/g' \
      -e 's/\!/%21/g' \
      -e 's/\$/%24/g' \
      -e 's/&/%26/g' \
      -e "s/'/%27/g" \
      -e 's/[(]/%28/g' \
      -e 's/[)]/%29/g' \
      -e 's/\*/%2A/g' \
      -e 's/[+]/%2B/g' \
      -e 's/,/%2C/g' \
      -e 's/;/%3B/g' \
      -e 's/=/%3D/g' \
      -e 's/"/%22/g' \
      -e 's/</%3C/g' \
      -e 's/>/%3E/g' \
      -e 's/\^/%5E/g' \
      -e 's/`/%60/g' \
      -e 's/{/%7B/g' \
      -e 's/}/%7D/g' \
      -e 's/[|]/%7C/g' \
      -e 's/[\]/%5C/g'
}

#######################################
# BashLib64 / Module / Setup / Interact with Bash shell
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_bsh_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_FMT_MODULE' &&
    _bl64_bsh_set_version &&
    BL64_BSH_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'bsh'
}

#######################################
# Identify and set module components versions
#
# * Version information is stored in module global variables
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: command errors
# Returns:
#   0: version set ok
#   $BL64_LIB_ERROR_OS_BASH_VERSION
#######################################
function _bl64_bsh_set_version() {
  bl64_dbg_lib_show_function

  case "${BASH_VERSINFO[0]}" in
  4*) BL64_BSH_VERSION_BASH='4.0' ;;
  5*) BL64_BSH_VERSION_BASH='5.0' ;;
  *)
    bl64_check_alert_unsupported "Bash: ${BASH_VERSINFO[0]}"
    return $BL64_LIB_ERROR_OS_BASH_VERSION
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_BSH_VERSION_BASH'

  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with Bash shell
#######################################

#######################################
# Get current script location
#
# Arguments:
#   None
# Outputs:
#   STDOUT: full path
#   STDERR: Error messages
# Returns:
#   0: full path
#   >0: command error
#######################################
function bl64_bsh_script_get_path() {
  bl64_dbg_lib_show_function
  local -i main=${#BASH_SOURCE[*]}
  local caller=''

  ((main > 0)) && main=$((main - 1))
  caller="${BASH_SOURCE[${main}]}"

  unset CDPATH &&
    [[ -n "$caller" ]] &&
    cd -- "${caller%/*}" >/dev/null &&
    pwd -P ||
    return $?
}

#######################################
# Get current script name
#
# Arguments:
#   None
# Outputs:
#   STDOUT: script name
#   STDERR: Error messages
# Returns:
#   0: name
#   >0: command error
#######################################
function bl64_bsh_script_get_name() {
  bl64_dbg_lib_show_function
  local -i main=${#BASH_SOURCE[*]}

  ((main > 0)) && main=$((main - 1))

  bl64_fmt_basename "${BASH_SOURCE[${main}]}"
}

#######################################
# Set script ID
#
# * Use to change the default BL64_SCRIPT_ID which is BL64_SCRIPT_NAME
#
# Arguments:
#   $1: id value
# Outputs:
#   STDOUT: script name
#   STDERR: Error messages
# Returns:
#   0: id
#   >0: command error
#######################################
# shellcheck disable=SC2120
function bl64_bsh_script_set_id() {
  bl64_dbg_lib_show_function "$@"
  local script_id="${1:-}"

  bl64_check_parameter 'script_id' || return $?

  BL64_SCRIPT_ID="$script_id"
}

#######################################
# Define current script identity
#
# * BL64_SCRIPT_SID: session ID for the running script. Changes on each run
# * BL64_SCRIPT_PATH: full path to the base directory script
# * BL64_SCRIPT_NAME: file name of the current script
# * BL64_SCRIPT_ID: script id (tag)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: Error messages
# Returns:
#   0: identity set
#   >0: failed to set
#######################################
function bl64_bsh_script_set_identity() {
  bl64_dbg_lib_show_function

  BL64_SCRIPT_SID="${BASHPID}${RANDOM}" &&
    BL64_SCRIPT_PATH="$(bl64_bsh_script_get_path)" &&
    BL64_SCRIPT_NAME="$(bl64_bsh_script_get_name)" &&
    bl64_bsh_script_set_id "$BL64_SCRIPT_NAME"
}

#######################################
# Generate a string that can be used to populate shell.env files
#
# * Export format is bash compatible
#
# Arguments:
#   $1: variable name
#   $2: value
# Outputs:
#   STDOUT: export string
#   STDERR: Error messages
# Returns:
#   0: string created
#   >0: creation error
#######################################
function bl64_bsh_env_export_variable() {
  bl64_dbg_lib_show_function "$@"
  local variable="${1:-${BL64_VAR_NULL}}"
  local value="${2:-}"

  bl64_check_parameter 'variable' ||
    return $?

  printf "export %s='%s'\n" "$variable" "$value"
}

#######################################
# BashLib64 / Module / Setup / Check for conditions and report status
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_check_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    BL64_CHECK_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'check'
}

#######################################
# BashLib64 / Module / Functions / Check for conditions and report status
#######################################

#######################################
# Check and report if the command is present and has execute permissions for the current user.
#
# Arguments:
#   $1: Full path to the command to check
#   $2: Not found error message. Default: _BL64_CHECK_TXT_COMMAND_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Command found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_APP_INCOMPATIBLE
#   $BL64_LIB_ERROR_APP_MISSING
#   $BL64_LIB_ERROR_FILE_NOT_FOUND
#   $BL64_LIB_ERROR_FILE_NOT_EXECUTE
#######################################
function bl64_check_command() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_COMMAND_NOT_FOUND}}"

  bl64_check_parameter 'path' || return $?

  if [[ "$path" == "$BL64_VAR_INCOMPATIBLE" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_INCOMPATIBLE} (OS: ${BL64_OS_DISTRO} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  if [[ "$path" == "$BL64_VAR_UNAVAILABLE" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_COMMAND_NOT_INSTALLED} (${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi

  if [[ ! -e "$path" ]]; then
    bl64_msg_show_error "${message} (${_BL64_CHECK_TXT_COMMAND}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi

  if [[ ! -x "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE} (${_BL64_CHECK_TXT_COMMAND}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_EXECUTE
  fi

  return 0
}

#######################################
# Check that the file is present and has read permissions for the current user.
#
# Arguments:
#   $1: Full path to the file
#   $2: Not found error message. Default: _BL64_CHECK_TXT_FILE_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_FILE_NOT_FOUND
#   $BL64_LIB_ERROR_FILE_NOT_READ
#######################################
function bl64_check_file() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_FILE_NOT_FOUND}}"

  bl64_check_parameter 'path' || return $?
  if [[ ! -e "$path" ]]; then
    bl64_msg_show_error "${message} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -f "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_FILE_NOT_FILE} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -r "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_FILE_NOT_READABLE} (${_BL64_CHECK_TXT_FILE}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_READ
  fi
  return 0
}

#######################################
# Check that the directory is present and has read and execute permissions for the current user.
#
# Arguments:
#   $1: Full path to the directory
#   $2: Not found error message. Default: _BL64_CHECK_TXT_DIRECTORY_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_DIRECTORY_NOT_FOUND
#   $BL64_LIB_ERROR_DIRECTORY_NOT_READ
#######################################
function bl64_check_directory() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_DIRECTORY_NOT_FOUND}}"

  bl64_check_parameter 'path' || return $?
  if [[ ! -e "$path" ]]; then
    bl64_msg_show_error "${message} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_DIRECTORY_NOT_FOUND
  fi
  if [[ ! -d "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_DIRECTORY_NOT_DIR} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_DIRECTORY_NOT_FOUND
  fi
  if [[ ! -r "$path" || ! -x "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_DIRECTORY_NOT_READABLE} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_DIRECTORY_NOT_READ
  fi
  return 0
}

#######################################
# Check that the path is present
#
# * The target must can be of any type
#
# Arguments:
#   $1: Full path
#   $2: Not found error message. Default: _BL64_CHECK_TXT_PATH_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_NOT_FOUND
#######################################
function bl64_check_path() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_PATH_NOT_FOUND}}"

  bl64_check_parameter 'path' || return $?
  if [[ ! -e "$path" ]]; then
    bl64_msg_show_error "${message} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_NOT_FOUND
  fi
  return 0
}

#######################################
# Check for mandatory shell function parameters
#
# * Check that:
#   * variable is defined
#   * parameter is not empty
#   * parameter is not using null value
#   * parameter is not using default value: this is to allow the calling function to have several mandatory parameters before optionals
#
# Arguments:
#   $1: parameter name
#   $2: (optional) parameter description. Shown on error messages
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PARAMETER_EMPTY
#######################################
function bl64_check_parameter() {
  bl64_dbg_lib_show_function "$@"
  local parameter_name="${1:-}"
  local description="${2:-parameter: ${parameter_name}}"

  if [[ -z "$parameter_name" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PARAMETER_MISSING} (${_BL64_CHECK_TXT_PARAMETER}: ${parameter_name} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_PARAMETER_EMPTY
  fi

  if [[ ! -v "$parameter_name" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PARAMETER_NOT_SET} (${description} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_PARAMETER_MISSING
  fi

  if eval "[[ -z \"\${${parameter_name}}\" || \"\${${parameter_name}}\" == '${BL64_VAR_NULL}' ]]"; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PARAMETER_MISSING} (${description} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_PARAMETER_EMPTY
  fi

  if eval "[[ \"\${${parameter_name}}\" == '${BL64_VAR_DEFAULT}' ]]"; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PARAMETER_DEFAULT} (${description} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  fi
  return 0
}

#######################################
# Check shell exported environment variable:
#   - exported variable is not empty
#   - exported variable is set
#
# Arguments:
#   $1: parameter name
#   $2: parameter description. Shown on error messages
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_EXPORT_EMPTY
#   $BL64_LIB_ERROR_EXPORT_SET
#######################################
function bl64_check_export() {
  bl64_dbg_lib_show_function "$@"
  local export_name="${1:-}"
  local description="${2:-export: $export_name}"

  bl64_check_parameter 'export_name' || return $?

  if [[ ! -v "$export_name" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_EXPORT_SET} (${description} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_EXPORT_SET
  fi

  if eval "[[ -z \$${export_name} ]]"; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_EXPORT_EMPTY} (${description} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_EXPORT_EMPTY
  fi
  return 0
}

#######################################
# Check that the given path is relative
#
# * String check only
# * Path is not tested for existance
#
# Arguments:
#   $1: Path string
#   $2: Failed check error message. Default: _BL64_CHECK_TXT_PATH_NOT_RELATIVE
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_NOT_RELATIVE
#######################################
function bl64_check_path_relative() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_PATH_NOT_RELATIVE}}"

  bl64_check_parameter 'path' || return $?
  if [[ "$path" == '/' || "$path" == /* ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PATH_NOT_RELATIVE} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_NOT_RELATIVE
  fi
  return 0
}

#######################################
# Check that the given path is not present
#
# * The target must can be of any type
#
# Arguments:
#   $1: Full path
#   $2: Failed check error message. Default: _BL64_CHECK_TXT_PATH_PRESENT
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_PRESENT
#######################################
function bl64_check_path_not_present() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_PATH_PRESENT}}"

  bl64_check_parameter 'path' || return $?
  if [[ -e "$path" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PATH_PRESENT} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_PRESENT
  fi
  return 0
}

#######################################
# Check that the given path is absolute
#
# * String check only
# * Path is not tested for existance
#
# Arguments:
#   $1: Path string
#   $2: Failed check error message. Default: _BL64_CHECK_TXT_PATH_NOT_ABSOLUTE
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_NOT_ABSOLUTE
#######################################
function bl64_check_path_absolute() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_PATH_NOT_ABSOLUTE}}"

  bl64_check_parameter 'path' || return $?
  if [[ "$path" != '/' && "$path" != /* ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PATH_NOT_ABSOLUTE} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_NOT_ABSOLUTE
  fi
  return 0
}

#######################################
# Check that the effective user running the current process is root
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_PRIVILEGE_IS_ROOT
#######################################
function bl64_check_privilege_root() {
  bl64_dbg_lib_show_function
  if [[ "$EUID" != '0' ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PRIVILEGE_IS_NOT_ROOT} (current id: $EUID ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT
  fi
  return 0
}

#######################################
# Check that the effective user running the current process is not root
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT
#######################################
function bl64_check_privilege_not_root() {
  bl64_dbg_lib_show_function

  if [[ "$EUID" == '0' ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_PRIVILEGE_IS_ROOT} (${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PRIVILEGE_IS_ROOT
  fi
  return 0
}

#######################################
# Check file/dir overwrite condition and fail if not meet
#
# * Use for tasks that needs to ensure that previous content will not overwriten unless requested
# * Target path can be of any type
#
# Arguments:
#   $1: Full path to the object
#   $2: Overwrite flag. Must be ON(1) or OFF(0). Default: OFF
#   $3: Error message
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: no previous file/dir or overwrite is requested
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED
#######################################
function bl64_check_overwrite() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local overwrite="${2:-$BL64_VAR_OFF}"
  local message="${3:-$_BL64_CHECK_TXT_OVERWRITE_NOT_PERMITED}"

  bl64_check_parameter 'path' || return $?

  if [[ "$overwrite" == "$BL64_VAR_OFF" || "$overwrite" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -e "$path" ]]; then
      bl64_msg_show_error "${message:-$_BL64_CHECK_TXT_OVERWRITE_NOT_PERMITED} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
      return $BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED
    fi
  fi

  return 0
}

#######################################
# Check file/dir overwrite condition and warn if not meet
#
# * Use for tasks that will do nothing if the target is already present
# * Warning: Caller is responsible for checking that path parameter is valid
# * Target path can be of any type
#
# Arguments:
#   $1: Full path to the object
#   $2: Overwrite flag. Must be ON(1) or OFF(0). Default: OFF
#   $3: Warning message
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: skip since previous file/dir is present
#   1: no previous file/dir present or overwrite is requested
#######################################
function bl64_check_overwrite_skip() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-}"
  local overwrite="${2:-$BL64_VAR_OFF}"
  local message="${3:-}"

  bl64_check_parameter 'path'

  if [[ "$overwrite" == "$BL64_VAR_OFF" || "$overwrite" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -e "$path" ]]; then
      bl64_msg_show_warning "${message:-$_BL64_CHECK_TXT_OVERWRITE_SKIP_EXISTING} (${_BL64_CHECK_TXT_PATH}: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
      return 0
    fi
  fi

  return 1
}

#######################################
# Raise error: invalid parameter
#
# * Use to raise an error when the calling function has verified that the parameter is not valid
# * This is a generic enough message to capture most validation use cases when there is no specific bl64_check_*
# * Can be used as the default value (*) for the bash command "case" to capture invalid options
#
# Arguments:
#   $1: parameter name
#   $2: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
# shellcheck disable=SC2120
function bl64_check_alert_parameter_invalid() {
  bl64_dbg_lib_show_function "$@"
  local parameter="${1:-${BL64_VAR_DEFAULT}}"
  local message="${2:-${_BL64_CHECK_TXT_PARAMETER_INVALID}}"

  [[ "$parameter" == "$BL64_VAR_DEFAULT" ]] && parameter=''
  bl64_msg_show_error "${message} (${parameter:+${_BL64_CHECK_TXT_PARAMETER}: ${parameter} ${BL64_MSG_COSMETIC_PIPE} }${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
  return $BL64_LIB_ERROR_PARAMETER_INVALID
}

#######################################
# Raise unsupported platform error
#
# Arguments:
#   $1: extra error message. Added to the error detail between (). Default: none
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_OS_INCOMPATIBLE
#######################################
function bl64_check_alert_unsupported() {
  bl64_dbg_lib_show_function "$@"
  local extra="${1:-}"

  bl64_msg_show_error "${_BL64_CHECK_TXT_INCOMPATIBLE} (${extra:+${extra} ${BL64_MSG_COSMETIC_PIPE} }OS: ${BL64_OS_DISTRO} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
  return $BL64_LIB_ERROR_OS_INCOMPATIBLE
}

#######################################
# Check that the compatibility mode is enabled to support untested command
#
# * If enabled, show a warning and continue OK
# * If not enabled, fail
#
# Arguments:
#   $1: extra error message. Added to the error detail between (). Default: none
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: using compatibility mode
#   >0: command is incompatible and compatibility mode is disabled
#######################################
function bl64_check_compatibility_mode() {
  bl64_dbg_lib_show_function "$@"
  local extra="${1:-}"

  if bl64_lib_mode_compability_is_enabled; then
    bl64_msg_show_warning "${_BL64_CHECK_TXT_COMPATIBILITY_MODE} (${extra:+${extra} ${BL64_MSG_COSMETIC_PIPE} }os: ${BL64_OS_DISTRO} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
  else
    bl64_check_alert_unsupported "$extra"
    return $?
  fi
}

#######################################
# Raise resource not detected error
#
# * Generic error used when a required external resource is not found on the system
# * Common use case: module setup looking for command in known locations
#
# Arguments:
#   $1: resource name. Default: none
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_APP_MISSING
#######################################
function bl64_check_alert_resource_not_found() {
  bl64_dbg_lib_show_function "$@"
  local resource="${1:-}"

  bl64_msg_show_error "${_BL64_CHECK_TXT_RESOURCE_NOT_FOUND} (${resource:+resource: ${resource} ${BL64_MSG_COSMETIC_PIPE} }os: ${BL64_OS_DISTRO} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
  return $BL64_LIB_ERROR_APP_MISSING
}

#######################################
# Raise undefined command error
#
# * Commonly used in the default branch of case statements to catch undefined options
#
# Arguments:
#   $1: command
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_TASK_UNDEFINED
#######################################
# shellcheck disable=SC2119,SC2120
function bl64_check_alert_undefined() {
  bl64_dbg_lib_show_function "$@"
  local target="${1:-}"

  bl64_msg_show_error "${_BL64_CHECK_TXT_UNDEFINED} (${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE}${target:+ ${BL64_MSG_COSMETIC_PIPE} command: ${target}})"
  return $BL64_LIB_ERROR_TASK_UNDEFINED
}

#######################################
# Raise module setup error
#
# * Helper to check if the module was correctly setup and raise error if not
# * Use as last function of bl64_*_setup
# * Will take the last exit status
#
# Arguments:
#   $1: bashlib64 module alias
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   $status
#######################################
function bl64_check_alert_module_setup() {
  local -i last_status=$? # must be first line to catch $?
  bl64_dbg_lib_show_function "$@"
  local module="${1:-}"

  bl64_check_parameter 'module' || return $?

  if [[ "$last_status" != '0' ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_MODULE_SETUP_FAILED} (${_BL64_CHECK_TXT_MODULE}: ${module} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $last_status
  else
    return 0
  fi
}

#######################################
# Check that at least 1 parameter is passed when using dynamic arguments
#
# Arguments:
#   $1: must be $# to capture number of parameters from the calling function
#   $2: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_TASK_UNDEFINED
#######################################
function bl64_check_parameters_none() {
  bl64_dbg_lib_show_function "$@"
  local count="$1"
  local message="${2:-${_BL64_CHECK_TXT_NOARGS}}"

  bl64_check_parameter 'count' || return $?

  if [[ "$count" == '0' ]]; then
    bl64_msg_show_error "${message} (${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_PARAMETER_MISSING
  else
    return 0
  fi
}

#######################################
# Check that the module is loaded and has been setup
#
# Arguments:
#   $1: module id (eg: BL64_XXXX_MODULE)
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_MODULE_SETUP_MISSING
#######################################
function bl64_check_module() {
  bl64_dbg_lib_show_function "$@"
  local module="${1:-}"
  local setup_status=''

  bl64_check_parameter 'module' &&
    bl64_check_module_imported "$module" ||
    return $?

  eval setup_status="\$$module"
  if [[ "$setup_status" == "$BL64_VAR_OFF" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_MODULE_NOT_SETUP} (${_BL64_CHECK_TXT_MODULE}: ${module} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_MODULE_SETUP_MISSING
  fi

  return 0
}

#######################################
# Check that the module is imported
#
# Arguments:
#   $1: module id (eg: BL64_XXXX_MODULE)
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_MODULE_NOT_IMPORTED
#######################################
function bl64_check_module_imported() {
  bl64_dbg_lib_show_function "$@"
  local module="${1:-}"
  bl64_check_parameter 'module' || return $?

  if [[ ! -v "$module" ]]; then
    bl64_msg_show_error "${_BL64_CHECK_TXT_MODULE_SET} (${_BL64_CHECK_TXT_MODULE}: ${module} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_MODULE_NOT_IMPORTED
  fi
  return 0
}

#######################################
# Check exit status
#
# * Helper to check for exit status of the last executed command and show error if failed
# * Return the same status as the latest command. This is to facilitate chaining with && return $? or be the last command of the function
#
# Arguments:
#   $1: exit status
#   $2: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   $status
#######################################
function bl64_check_status() {
  bl64_dbg_lib_show_function "$@"
  local status="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_STATUS_ERROR}}"

  bl64_check_parameter 'status' || return $?

  if [[ "$status" != '0' ]]; then
    bl64_msg_show_error "${message} (status: ${status} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return "$status"
  else
    return 0
  fi
}

#######################################
# Check that the HOME variable is present and the path is valid
#
# * HOME is the standard shell variable for current user's home
#
# Arguments:
#   None
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: home is valid
#   >0: home is not valid
#######################################
function bl64_check_home() {
  bl64_dbg_lib_show_function

  bl64_check_export 'HOME' "$_BL64_CHECK_TXT_HOME_MISSING" &&
    bl64_check_directory "$HOME" "$_BL64_CHECK_TXT_HOME_DIR_MISSING"
}

#######################################
# Check and report if the command is available using the current search path
#
# * standar PATH variable is used for the search
# * aliases and built-in commands will always return true
# * if the command is in the search path, then bl64_check_command is used to ensure it can be used
#
# Arguments:
#   $1: command file name
#   $2: Not found error message. Default: _BL64_CHECK_TXT_COMMAND_NOT_IN_PATH
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Command found
#   BL64_LIB_ERROR_FILE_NOT_FOUND
#######################################
function bl64_check_command_search_path() {
  bl64_dbg_lib_show_function "$@"
  local file="${1:-}"
  local message="${2:-${_BL64_CHECK_TXT_COMMAND_NOT_IN_PATH}}"
  local full_path=''

  bl64_check_parameter 'file' || return $?

  full_path="$(type -p "${file}")"
  # shellcheck disable=SC2181
  if (($? != 0)); then
    bl64_msg_show_error "${message} (command: ${file} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi

  bl64_check_command "$full_path"
}

#######################################
# BashLib64 / Module / Setup / Show shell debugging inlevelion
#######################################

#
# Individual debugging level status
#
function bl64_dbg_app_task_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_TASK" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_ALL" ]]; }
function bl64_dbg_lib_task_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_TASK" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_ALL" ]]; }
function bl64_dbg_app_command_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_CMD" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_ALL" ]]; }
function bl64_dbg_lib_command_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_CMD" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_ALL" ]]; }
function bl64_dbg_app_trace_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_TRACE" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_ALL" ]]; }
function bl64_dbg_lib_trace_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_ALL" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_TRACE" || "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_LIB_ALL" ]]; }
function bl64_dbg_app_custom_1_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_CUSTOM_1" ]]; }
function bl64_dbg_app_custom_2_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_CUSTOM_2" ]]; }
function bl64_dbg_app_custom_3_enabled { [[ "$BL64_DBG_TARGET" == "$BL64_DBG_TARGET_APP_CUSTOM_3" ]]; }

#
# Individual debugging level control
#
function bl64_dbg_all_disable { BL64_DBG_TARGET="$BL64_DBG_TARGET_NONE"; }
function bl64_dbg_all_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_ALL"; }
function bl64_dbg_app_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_ALL"; }
function bl64_dbg_lib_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_LIB_ALL"; }
function bl64_dbg_app_task_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_TASK"; }
function bl64_dbg_lib_task_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_LIB_TASK"; }
function bl64_dbg_app_command_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_CMD"; }
function bl64_dbg_lib_command_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_LIB_CMD"; }
function bl64_dbg_app_trace_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_TRACE"; }
function bl64_dbg_lib_trace_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_LIB_TRACE"; }
function bl64_dbg_app_custom_1_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_CUSTOM_1"; }
function bl64_dbg_app_custom_2_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_CUSTOM_2"; }
function bl64_dbg_app_custom_3_enable { BL64_DBG_TARGET="$BL64_DBG_TARGET_APP_CUSTOM_3"; }

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
# * Warning: keep this module independant (do not depend on other bl64 modules)
# * Debugging messages are disabled by default
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_dbg_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_dbg_all_disable &&
    BL64_DBG_MODULE="$BL64_VAR_ON"
}

#######################################
# Set debugging level
#
# Arguments:
#   $1: target level. One of BL64_DBG_TARGET_*
# Outputs:
#   STDOUT: None
#   STDERR: check error
# Returns:
#   0: set ok
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_dbg_set_level() {
  local level="$1"
  case "$level" in
  "$BL64_DBG_TARGET_NONE") bl64_dbg_all_disable ;;
  "$BL64_DBG_TARGET_APP_TRACE") bl64_dbg_app_trace_enable ;;
  "$BL64_DBG_TARGET_APP_TASK") bl64_dbg_app_task_enable ;;
  "$BL64_DBG_TARGET_APP_CMD") bl64_dbg_app_command_enable ;;
  "$BL64_DBG_TARGET_APP_CUSTOM_1") bl64_dbg_app_custom_1_enable ;;
  "$BL64_DBG_TARGET_APP_CUSTOM_2") bl64_dbg_app_custom_2_enable ;;
  "$BL64_DBG_TARGET_APP_CUSTOM_3") bl64_dbg_app_custom_3_enable ;;
  "$BL64_DBG_TARGET_APP_ALL") bl64_dbg_app_enable ;;
  "$BL64_DBG_TARGET_LIB_TRACE") bl64_dbg_lib_trace_enable ;;
  "$BL64_DBG_TARGET_LIB_TASK") bl64_dbg_lib_task_enable ;;
  "$BL64_DBG_TARGET_LIB_CMD") bl64_dbg_lib_command_enable ;;
  "$BL64_DBG_TARGET_LIB_ALL") bl64_dbg_lib_enable ;;
  "$BL64_DBG_TARGET_ALL") bl64_dbg_all_enable ;;
  *)
    _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_WRONG_LEVEL} ${BL64_DBG_TARGET_ALL}|${BL64_DBG_TARGET_APP_ALL}|${BL64_DBG_TARGET_LIB_ALL}"
    return $BL64_LIB_ERROR_PARAMETER_INVALID
    ;;
  esac
}

#######################################
# BashLib64 / Module / Functions / Show shell debugging information
#######################################

function _bl64_dbg_show() {
  local message="$1"
  printf '%s: %s\n' "$_BL64_DBG_TXT_DEBUG" "$message" >&2
}

#######################################
# Show runtime info
#
# * Saves the last exit status so the function will not disrupt the error flow
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: runtime info
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show() {
  local -i last_status=$?
  bl64_dbg_app_command_enabled || return $last_status

  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_BASH}: [${BASH}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_BASHOPTS}: [${BASHOPTS:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_SHELLOPTS}: [${SHELLOPTS:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_BASH_VERSION}: [${BASH_VERSION}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_OSTYPE}: [${OSTYPE:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_LC_ALL}: [${LC_ALL:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_HOSTNAME}: [${HOSTNAME:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_EUID}: [${EUID}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_UID}: [${UID}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_BASH_ARGV}: [${BASH_ARGV[*]:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_COMMAND}: [${BASH_COMMAND:-NONE}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_STATUS}: [${last_status}]"

  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_SCRIPT_PATH}: [${BL64_SCRIPT_PATH:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_HOME}: [${HOME:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_PATH}: [${PATH:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_CD_PWD}: [${PWD:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_CD_OLDPWD}: [${OLDPWD:-EMPTY}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_PWD}: [$(pwd)]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_TMPDIR}: [${TMPDIR:-NONE}]"

  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_CALLSTACK}(1): [${BASH_SOURCE[1]:-NONE}:${FUNCNAME[1]:-NONE}:${BASH_LINENO[1]:-0}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_CALLSTACK}(2): [${BASH_SOURCE[2]:-NONE}:${FUNCNAME[2]:-NONE}:${BASH_LINENO[2]:-0}]"
  _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_RUNTIME} ${_BL64_DBG_TXT_CALLSTACK}(3): [${BASH_SOURCE[3]:-NONE}:${FUNCNAME[3]:-NONE}:${BASH_LINENO[3]:-0}]"

  # shellcheck disable=SC2248
  return $last_status
}

#######################################
# Show runtime call stack
#
# * Show previous 3 functions from the current caller
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: callstack
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show_callstack() {
  bl64_dbg_app_task_enabled || bl64_dbg_lib_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_CALLSTACK}(2): [${BASH_SOURCE[1]:-NONE}:${FUNCNAME[2]:-NONE}:${BASH_LINENO[2]:-0}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_CALLSTACK}(3): [${BASH_SOURCE[2]:-NONE}:${FUNCNAME[3]:-NONE}:${BASH_LINENO[3]:-0}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_CALLSTACK}(4): [${BASH_SOURCE[3]:-NONE}:${FUNCNAME[4]:-NONE}:${BASH_LINENO[4]:-0}]"
}

#######################################
# Show runtime paths
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: callstack
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show_paths() {
  bl64_dbg_app_task_enabled || bl64_dbg_lib_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_SCRIPT_PATH}: [${BL64_SCRIPT_PATH:-EMPTY}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_HOME}: [${HOME:-EMPTY}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_PATH}: [${PATH:-EMPTY}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_CD_PWD}: [${PWD:-EMPTY}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_CD_OLDPWD}: [${OLDPWD:-EMPTY}]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_PWD}: [$(pwd)]"
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_TMPDIR}: [${TMPDIR:-NONE}]"
}

#######################################
# Stop app  shell tracing
#
# * Saves the last exit status so the function will not disrupt the error flow
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_trace_stop() {
  local -i state=$?
  bl64_dbg_app_trace_enabled || return $state

  set +x
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_STOP}"

  return $state
}

#######################################
# Start app  shell tracing if target is in scope
#
# Arguments:
#   None
# Outputs:
#   STDOUT: Tracing
#   STDERR: Debug messages
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_trace_start() {
  bl64_dbg_app_trace_enabled || return 0

  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_START}"
  set -x

  return 0
}

#######################################
# Stop bashlib64 shell tracing
#
# * Saves the last exit status so the function will not disrupt the error flow
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   Saved exit status
#######################################
function bl64_dbg_lib_trace_stop() {
  local -i state=$?
  bl64_dbg_lib_trace_enabled || return $state

  set +x
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_STOP}"

  return $state
}

#######################################
# Start bashlib64 shell tracing if target is in scope
#
# Arguments:
#   None
# Outputs:
#   STDOUT: Tracing
#   STDERR: Debug messages
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_trace_start() {
  bl64_dbg_lib_trace_enabled || return 0

  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_START}"
  set -x

  return 0
}

#######################################
# Show bashlib64 task level debugging information
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_info() {
  bl64_dbg_lib_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${*}"
  return 0
}

#######################################
# Show app task level debugging information
#
# Arguments:
#   $@: messages
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_info() {
  bl64_dbg_app_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${*}"
  return 0
}

#######################################
# Show bashlib64 task level variable values
#
# Arguments:
#   $@: variable names
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_vars() {
  local variable=''
  bl64_dbg_lib_task_enabled || return 0

  for variable in "$@"; do
    eval "_bl64_dbg_show \"[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_SHELL_VAR}: [${variable}=\$${variable}]\""
  done

  return 0
}

#######################################
# Show app task level variable values
#
# Arguments:
#   $@: variable names
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_vars() {
  local variable=''
  bl64_dbg_app_task_enabled || return 0

  for variable in "$@"; do
    eval "_bl64_dbg_show \"[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_SHELL_VAR}: [${variable}=\$${variable}]\""
  done

  return 0
}

#######################################
# Show bashlib64 function name and parameters
#
# Arguments:
#   $@: parameters
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
# shellcheck disable=SC2120
function bl64_dbg_lib_show_function() {
  bl64_dbg_lib_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_LIB_RUN}: [${*}]"
  return 0
}

#######################################
# Show app function name and parameters
#
# Arguments:
#   $@: parameters
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
# shellcheck disable=SC2120
function bl64_dbg_app_show_function() {
  bl64_dbg_app_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_APP_RUN}: [${*}]"
  return 0
}

#######################################
# Stop bashlib64 external command tracing
#
# * Saves the last exit status so the function will not disrupt the error flow
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   Saved exit status
#######################################
function bl64_dbg_lib_command_trace_stop() {
  local -i state=$?
  bl64_dbg_lib_task_enabled || return $state

  set +x
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_STOP}"

  return $state
}

#######################################
# Start bashlib64 external command tracing if target is in scope
#
# * Use in functions: bl64_*_run_*
#
# Arguments:
#   None
# Outputs:
#   STDOUT: Tracing
#   STDERR: Debug messages
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_command_trace_start() {
  bl64_dbg_lib_task_enabled || return 0

  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_FUNCTION_START}"
  set -x

  return 0
}

#######################################
# Show developer comments in bashlib64 functions
#
# Arguments:
#   $1: comments
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_comments() {
  bl64_dbg_lib_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_COMMENTS}: ${*}"
  return 0
}

#######################################
# Show developer comments in app functions
#
# Arguments:
#   $@: comments
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_comments() {
  bl64_dbg_app_task_enabled || return 0
  _bl64_dbg_show "[${FUNCNAME[1]:-NONE}] ${_BL64_DBG_TXT_COMMENTS}: ${*}"
  return 0
}

#######################################
# Show non BL64 variables and attributes
#
# Arguments:
#   None
# Outputs:
#   STDOUT: declare -p output
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_variables() {
  bl64_dbg_app_task_enabled || return 0
  local filter='^declare .*BL64_.*=.*'

  IFS=$'\n'
  for variable in $(declare -p); do
    unset IFS
    [[ "$variable" =~ $filter || "$variable" =~ "declare -- filter=" ]] && continue
    _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_VARIABLE} ${variable}"
  done
  return 0
}

#######################################
# Show BL64 variables and attributes
#
# Arguments:
#   None
# Outputs:
#   STDOUT: declare -p output
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_variables() {
  bl64_dbg_lib_task_enabled || return 0
  local filter='^declare .*BL64_.*=.*'

  IFS=$'\n'
  for variable in $(declare -p); do
    unset IFS
    [[ ! "$variable" =~ $filter || "$variable" =~ "declare -- filter=" ]] && continue
    _bl64_dbg_show "${_BL64_DBG_TXT_LABEL_BASH_VARIABLE} ${variable}"
  done
  return 0
}

#######################################
# BashLib64 / Module / Setup / Manage local filesystem
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_fs_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  _bl64_fs_set_command &&
    _bl64_fs_set_alias &&
    _bl64_fs_set_options &&
    BL64_FS_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'fs'
}

#######################################
# Identify and normalize common *nix OS commands
#
# * Commands are exported as variables with full path
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function
function _bl64_fs_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/bin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    BL64_FS_CMD_TOUCH='/usr/bin/touch'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_FS_CMD_CHMOD='/usr/bin/chmod'
    BL64_FS_CMD_CHOWN='/usr/bin/chown'
    BL64_FS_CMD_CP='/usr/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/usr/bin/ls'
    BL64_FS_CMD_MKDIR='/usr/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_FS_CMD_MV='/usr/bin/mv'
    BL64_FS_CMD_RM='/usr/bin/rm'
    BL64_FS_CMD_TOUCH='/usr/bin/touch'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_FS_CMD_CHMOD='/usr/bin/chmod'
    BL64_FS_CMD_CHOWN='/usr/bin/chown'
    BL64_FS_CMD_CP='/usr/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/usr/bin/ln'
    BL64_FS_CMD_LS='/usr/bin/ls'
    BL64_FS_CMD_MKDIR='/usr/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_FS_CMD_MV='/usr/bin/mv'
    BL64_FS_CMD_RM='/usr/bin/rm'
    BL64_FS_CMD_TOUCH='/usr/bin/touch'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/bin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    BL64_FS_CMD_TOUCH='/bin/touch'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/usr/sbin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    BL64_FS_CMD_TOUCH='/usr/bin/touch'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
# * BL64_FS_SET_MKTEMP_TMPDIR: not using long form (--) as it requires =
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_fs_set_options() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_FS_SET_CHMOD_RECURSIVE='--recursive'
    BL64_FS_SET_CHMOD_VERBOSE='--verbose'
    BL64_FS_SET_CHOWN_RECURSIVE='--recursive'
    BL64_FS_SET_CHOWN_VERBOSE='--verbose'
    BL64_FS_SET_CP_FORCE='--force'
    BL64_FS_SET_CP_RECURSIVE='--recursive'
    BL64_FS_SET_CP_VERBOSE='--verbose'
    BL64_FS_SET_FIND_NAME='-name'
    BL64_FS_SET_FIND_PRINT='-print'
    BL64_FS_SET_FIND_RUN='-exec'
    BL64_FS_SET_FIND_STAY='-xdev'
    BL64_FS_SET_FIND_TYPE_DIR='-type d'
    BL64_FS_SET_FIND_TYPE_FILE='-type f'
    BL64_FS_SET_LN_FORCE='--force'
    BL64_FS_SET_LN_SYMBOLIC='--symbolic'
    BL64_FS_SET_LN_VERBOSE='--verbose'
    BL64_FS_SET_LS_NOCOLOR='--color=never'
    BL64_FS_SET_MKDIR_PARENTS='--parents'
    BL64_FS_SET_MKDIR_VERBOSE='--verbose'
    BL64_FS_SET_MKTEMP_DIRECTORY='--directory'
    BL64_FS_SET_MKTEMP_QUIET='--quiet'
    BL64_FS_SET_MKTEMP_TMPDIR='-p'
    BL64_FS_SET_MV_FORCE='--force'
    BL64_FS_SET_MV_VERBOSE='--verbose'
    BL64_FS_SET_RM_FORCE='--force'
    BL64_FS_SET_RM_RECURSIVE='--recursive'
    BL64_FS_SET_RM_VERBOSE='--verbose'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_FS_SET_CHMOD_RECURSIVE='--recursive'
    BL64_FS_SET_CHMOD_VERBOSE='--verbose'
    BL64_FS_SET_CHOWN_RECURSIVE='--recursive'
    BL64_FS_SET_CHOWN_VERBOSE='--verbose'
    BL64_FS_SET_CP_FORCE='--force'
    BL64_FS_SET_CP_RECURSIVE='--recursive'
    BL64_FS_SET_CP_VERBOSE='--verbose'
    BL64_FS_SET_FIND_NAME='-name'
    BL64_FS_SET_FIND_PRINT='-print'
    BL64_FS_SET_FIND_RUN='-exec'
    BL64_FS_SET_FIND_STAY='-xdev'
    BL64_FS_SET_FIND_TYPE_DIR='-type d'
    BL64_FS_SET_FIND_TYPE_FILE='-type f'
    BL64_FS_SET_LN_FORCE='--force'
    BL64_FS_SET_LN_SYMBOLIC='--symbolic'
    BL64_FS_SET_LN_VERBOSE='--verbose'
    BL64_FS_SET_LS_NOCOLOR='--color=never'
    BL64_FS_SET_MKDIR_PARENTS='--parents'
    BL64_FS_SET_MKDIR_VERBOSE='--verbose'
    BL64_FS_SET_MKTEMP_DIRECTORY='--directory'
    BL64_FS_SET_MKTEMP_QUIET='--quiet'
    BL64_FS_SET_MKTEMP_TMPDIR='-p'
    BL64_FS_SET_MV_FORCE='--force'
    BL64_FS_SET_MV_VERBOSE='--verbose'
    BL64_FS_SET_RM_FORCE='--force'
    BL64_FS_SET_RM_RECURSIVE='--recursive'
    BL64_FS_SET_RM_VERBOSE='--verbose'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_FS_SET_CHMOD_RECURSIVE='--recursive'
    BL64_FS_SET_CHMOD_VERBOSE='--verbose'
    BL64_FS_SET_CHOWN_RECURSIVE='--recursive'
    BL64_FS_SET_CHOWN_VERBOSE='--verbose'
    BL64_FS_SET_CP_FORCE='--force'
    BL64_FS_SET_CP_RECURSIVE='--recursive'
    BL64_FS_SET_CP_VERBOSE='--verbose'
    BL64_FS_SET_FIND_NAME='-name'
    BL64_FS_SET_FIND_PRINT='-print'
    BL64_FS_SET_FIND_RUN='-exec'
    BL64_FS_SET_FIND_STAY='-xdev'
    BL64_FS_SET_FIND_TYPE_DIR='-type d'
    BL64_FS_SET_FIND_TYPE_FILE='-type f'
    BL64_FS_SET_LN_FORCE='--force'
    BL64_FS_SET_LN_SYMBOLIC='--symbolic'
    BL64_FS_SET_LN_VERBOSE='--verbose'
    BL64_FS_SET_LS_NOCOLOR='--color=never'
    BL64_FS_SET_MKDIR_PARENTS='--parents'
    BL64_FS_SET_MKDIR_VERBOSE='--verbose'
    BL64_FS_SET_MKTEMP_DIRECTORY='--directory'
    BL64_FS_SET_MKTEMP_QUIET='--quiet'
    BL64_FS_SET_MKTEMP_TMPDIR='-p'
    BL64_FS_SET_MV_FORCE='--force'
    BL64_FS_SET_MV_VERBOSE='--verbose'
    BL64_FS_SET_RM_FORCE='--force'
    BL64_FS_SET_RM_RECURSIVE='--recursive'
    BL64_FS_SET_RM_VERBOSE='--verbose'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_FS_SET_CHMOD_RECURSIVE='-R'
    BL64_FS_SET_CHMOD_VERBOSE='-v'
    BL64_FS_SET_CHOWN_RECURSIVE='-R'
    BL64_FS_SET_CHOWN_VERBOSE='-v'
    BL64_FS_SET_CP_FORCE='-f'
    BL64_FS_SET_CP_RECURSIVE='-R'
    BL64_FS_SET_CP_VERBOSE='-v'
    BL64_FS_SET_FIND_NAME='-name'
    BL64_FS_SET_FIND_PRINT='-print'
    BL64_FS_SET_FIND_RUN='-exec'
    BL64_FS_SET_FIND_STAY='-xdev'
    BL64_FS_SET_FIND_TYPE_DIR='-type d'
    BL64_FS_SET_FIND_TYPE_FILE='-type f'
    BL64_FS_SET_LN_FORCE='-f'
    BL64_FS_SET_LN_SYMBOLIC='-s'
    BL64_FS_SET_LN_VERBOSE='-v'
    BL64_FS_SET_LS_NOCOLOR='--color=never'
    BL64_FS_SET_MKDIR_PARENTS='-p'
    BL64_FS_SET_MKDIR_VERBOSE=' '
    BL64_FS_SET_MKTEMP_DIRECTORY='-d'
    BL64_FS_SET_MKTEMP_QUIET='-q'
    BL64_FS_SET_MKTEMP_TMPDIR='-p'
    BL64_FS_SET_MV_FORCE='-f'
    BL64_FS_SET_MV_VERBOSE=' '
    BL64_FS_SET_RM_FORCE='-f'
    BL64_FS_SET_RM_RECURSIVE='-R'
    BL64_FS_SET_RM_VERBOSE=' '
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_FS_SET_CHMOD_RECURSIVE='-R'
    BL64_FS_SET_CHMOD_VERBOSE='-v'
    BL64_FS_SET_CHOWN_RECURSIVE='-R'
    BL64_FS_SET_CHOWN_VERBOSE='-v'
    BL64_FS_SET_CP_FORCE='-f'
    BL64_FS_SET_CP_RECURSIVE='-R'
    BL64_FS_SET_CP_VERBOSE='-v'
    BL64_FS_SET_FIND_NAME='-name'
    BL64_FS_SET_FIND_PRINT='-print'
    BL64_FS_SET_FIND_RUN='-exec'
    BL64_FS_SET_FIND_STAY='-xdev'
    BL64_FS_SET_FIND_TYPE_DIR='-type d'
    BL64_FS_SET_FIND_TYPE_FILE='-type f'
    BL64_FS_SET_LN_FORCE='-f'
    BL64_FS_SET_LN_SYMBOLIC='-s'
    BL64_FS_SET_LN_VERBOSE='-v'
    BL64_FS_SET_LS_NOCOLOR='--color=never'
    BL64_FS_SET_MKDIR_PARENTS='-p'
    BL64_FS_SET_MKDIR_VERBOSE='-v'
    BL64_FS_SET_MKTEMP_DIRECTORY='-d'
    BL64_FS_SET_MKTEMP_QUIET='-q'
    BL64_FS_SET_MKTEMP_TMPDIR='-p'
    BL64_FS_SET_MV_FORCE='-f'
    BL64_FS_SET_MV_VERBOSE='-v'
    BL64_FS_SET_RM_FORCE='-f'
    BL64_FS_SET_RM_RECURSIVE='-R'
    BL64_FS_SET_RM_VERBOSE='-v'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# shellcheck disable=SC2034
function _bl64_fs_set_alias() {
  local cmd_mawk='/usr/bin/mawk'

  BL64_FS_ALIAS_CHOWN_DIR="${BL64_FS_CMD_CHOWN} ${BL64_FS_SET_CHOWN_VERBOSE} ${BL64_FS_SET_CHOWN_RECURSIVE}"
  BL64_FS_ALIAS_CP_DFIND="/usr/bin/find"
  BL64_FS_ALIAS_CP_DIR="${BL64_FS_CMD_CP} ${BL64_FS_SET_CP_VERBOSE} ${BL64_FS_SET_CP_FORCE} ${BL64_FS_SET_CP_RECURSIVE}"
  BL64_FS_ALIAS_CP_FIFIND="/usr/bin/find"
  BL64_FS_ALIAS_CP_FILE="${BL64_FS_CMD_CP} ${BL64_FS_SET_CP_VERBOSE} ${BL64_FS_SET_CP_FORCE}"
  BL64_FS_ALIAS_LN_FORCE="--force"
  BL64_FS_ALIAS_LN_SYMBOLIC="${BL64_FS_CMD_LN} ${BL64_FS_SET_LN_SYMBOLIC} ${BL64_FS_SET_LN_VERBOSE}"
  BL64_FS_ALIAS_LS_FILES="${BL64_FS_CMD_LS} ${BL64_FS_SET_LS_NOCOLOR}"
  BL64_FS_ALIAS_MKDIR_FULL="${BL64_FS_CMD_MKDIR} ${BL64_FS_SET_MKDIR_VERBOSE} ${BL64_FS_SET_MKDIR_PARENTS}"
  BL64_FS_ALIAS_MKTEMP_DIR="${BL64_FS_CMD_MKTEMP} -d"
  BL64_FS_ALIAS_MKTEMP_FILE="${BL64_FS_CMD_MKTEMP}"
  BL64_FS_ALIAS_MV="${BL64_FS_CMD_MV} ${BL64_FS_SET_MV_VERBOSE} ${BL64_FS_SET_MV_FORCE}"
  BL64_FS_ALIAS_MV="${BL64_FS_CMD_MV} ${BL64_FS_SET_MV_VERBOSE} ${BL64_FS_SET_MV_FORCE}"
  BL64_FS_ALIAS_RM_FILE="${BL64_FS_CMD_RM} ${BL64_FS_SET_RM_VERBOSE} ${BL64_FS_SET_RM_FORCE}"
  BL64_FS_ALIAS_RM_FULL="${BL64_FS_CMD_RM} ${BL64_FS_SET_RM_VERBOSE} ${BL64_FS_SET_RM_FORCE} ${BL64_FS_SET_RM_RECURSIVE}"
}

#######################################
# BashLib64 / Module / Functions / Manage local filesystem
#######################################

#######################################
# Create one ore more directories, then set owner and permissions
#
#  Features:
#   * If the new path is already present nothing is done. No error or warning is presented
# Limitations:
#   * Parent directories are not created
#   * No rollback in case of errors. The process will not remove already created paths
# Arguments:
#   $1: permissions. Format: chown format. Default: use current umask
#   $2: user name. Default: current
#   $3: group name. Default: current
#   $@: full directory paths
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_create_dir() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_VAR_DEFAULT}}"
  local user="${2:-${BL64_VAR_DEFAULT}}"
  local group="${3:-${BL64_VAR_DEFAULT}}"
  local path=''

  # Remove consumed parameters
  shift
  shift
  shift

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_show_info "path list:[${*}]"

  for path in "$@"; do

    bl64_check_path_absolute "$path" || return $?
    [[ -d "$path" ]] && continue

    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_CREATE_DIR_PATH} (${path})"
    bl64_fs_run_mkdir "$path" &&
      bl64_fs_set_permissions "$mode" "$user" "$group" "$path" ||
      return $?

  done

  return 0
}

#######################################
# Copy one ore more files to a single destination, then set owner and permissions
#
# Requirements:
#   * Destination path should be present
#   * root privilege (sudo) if paths are restricted or change owner is requested
# Limitations:
#   * No rollback in case of errors. The process will not remove already copied files
# Arguments:
#   $1: permissions. Format: chown format. Default: use current umask
#   $2: user name. Default: current
#   $3: group name. Default: current
#   $4: destination path
#   $@: full file paths
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_copy_files() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_VAR_DEFAULT}}"
  local user="${2:-${BL64_VAR_DEFAULT}}"
  local group="${3:-${BL64_VAR_DEFAULT}}"
  local destination="${4:-${BL64_VAR_DEFAULT}}"
  local path=''
  local target=''

  bl64_check_directory "$destination" || return $?

  # Remove consumed parameters
  shift
  shift
  shift
  shift

  # shellcheck disable=SC2086
  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_show_info "paths:[${*}]"
  for path in "$@"; do
    target=''
    bl64_check_path_absolute "$path" &&
      target="${destination}/$(bl64_fmt_basename "$path")" || return $?

    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_COPY_FILE_PATH} (${path} ${BL64_MSG_COSMETIC_ARROW2} ${target})"
    bl64_fs_cp_file "$path" "$target" &&
      bl64_fs_set_permissions "$mode" "$user" "$group" "$target" ||
      return $?
  done

  return 0
}

#######################################
# Merge 2 or more files into a new one, then set owner and permissions
#
# * If the destination is already present no update is done unless requested
# * If asked to replace destination, no backup is done. Caller must take one if needed
# * If merge fails, the incomplete file will be removed
#
# Arguments:
#   $1: permissions. Format: chown format. Default: use current umask
#   $2: user name. Default: current
#   $3: group name. Default: current
#   $4: replace existing content. Values: $BL64_VAR_ON | $BL64_VAR_OFF (default)
#   $5: destination file. Full path
#   $@: source files. Full path
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#   $BL64_FS_ERROR_EXISTING_FILE
#   $BL64_LIB_ERROR_TASK_FAILED
#######################################
function bl64_fs_merge_files() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_VAR_DEFAULT}}"
  local user="${2:-${BL64_VAR_DEFAULT}}"
  local group="${3:-${BL64_VAR_DEFAULT}}"
  local replace="${4:-${BL64_VAR_DEFAULT}}"
  local destination="${5:-${BL64_VAR_DEFAULT}}"
  local path=''
  local -i status=0
  local -i first=1

  bl64_check_parameter 'destination' &&
    bl64_fs_check_new_file "$destination" &&
    bl64_check_overwrite "$destination" "$replace" ||
    return $?

  # Remove consumed parameters
  shift
  shift
  shift
  shift
  shift
  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_show_info "source files:[${*}]"

  for path in "$@"; do
    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_MERGE_ADD_SOURCE} (${path} ${BL64_MSG_COSMETIC_ARROW2} ${destination})"
    if ((first == 1)); then
      first=0
      bl64_check_path_absolute "$path" &&
        "$BL64_OS_CMD_CAT" "$path" >"$destination"
    else
      bl64_check_path_absolute "$path" &&
        "$BL64_OS_CMD_CAT" "$path" >>"$destination"
    fi
    status=$?
    ((status != 0)) && break
    :
  done

  if ((status == 0)); then
    bl64_dbg_lib_show_comments "merge commplete, update permissions if needed (${destination})"
    bl64_fs_set_permissions "$mode" "$user" "$group" "$destination"
    status=$?
  else
    bl64_dbg_lib_show_comments "merge failed, removing incomplete file (${destination})"
    [[ -f "$destination" ]] && bl64_fs_rm_file "$destination"
  fi

  return $status
}

#######################################
# Merge contents from source directory to target
#
# Requirements:
#   * root privilege (sudo) if the files are restricted
# Arguments:
#   $1: source path
#   $2: target path
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   bl64_check_parameter
#   bl64_check_directory
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_merge_dir() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-${BL64_VAR_DEFAULT}}"
  local target="${2:-${BL64_VAR_DEFAULT}}"

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'target' &&
    bl64_check_directory "$source" &&
    bl64_check_directory "$target" ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_FS_TXT_MERGE_DIRS} (${source} ${BL64_MSG_COSMETIC_ARROW2} ${target})"
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_fs_cp_dir --no-target-directory "$source" "$target"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    bl64_fs_cp_dir --no-target-directory "$source" "$target"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_fs_cp_dir --no-target-directory "$source" "$target"
    ;;
  ${BL64_OS_ALP}-*)
    # shellcheck disable=SC2086
    shopt -sq dotglob &&
      bl64_fs_cp_dir ${source}/* -t "$target" &&
      shopt -uq dotglob
    ;;
  ${BL64_OS_MCOS}-*)
    # shellcheck disable=SC2086
    bl64_fs_cp_dir ${source}/ "$target"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_chown() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CHOWN_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CHOWN" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Warning: mktemp with no arguments creates a temp file by default
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_mktemp() {
  bl64_dbg_lib_show_function "$@"
  local verbose="$BL64_FS_SET_MKTEMP_QUIET"

  bl64_dbg_lib_command_enabled && verbose=''

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MKTEMP" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_chmod() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CHMOD_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CHMOD" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Change directory ownership recursively
#
# * Simple command wrapper
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_chown_dir() {
  bl64_dbg_lib_show_function "$@"

  # shellcheck disable=SC2086
  bl64_fs_run_chown "$BL64_FS_SET_CHOWN_RECURSIVE" "$@"
}

#######################################
# Change directory permissions recursively
#
# * Simple command wrapper
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_chmod_dir() {
  bl64_dbg_lib_show_function "$@"

  # shellcheck disable=SC2086
  bl64_fs_run_chmod "$BL64_FS_SET_CHMOD_RECURSIVE" "$@"
}

#######################################
# Copy files with force flag
#
# * Simple command wrapper
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_cp_file() {
  bl64_dbg_lib_show_function "$@"

  # shellcheck disable=SC2086
  bl64_fs_run_cp "$BL64_FS_SET_CP_FORCE" "$@"
}

#######################################
# Copy directory with recursive and force flags
#
# * Simple command wrapper
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_cp_dir() {
  bl64_dbg_lib_show_function "$@"

  # shellcheck disable=SC2086
  bl64_fs_run_cp "$BL64_FS_SET_CP_FORCE" "$BL64_FS_SET_CP_RECURSIVE" "$@"
}

#######################################
# Create a symbolic link
#
# * Simple command wrapper
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_ln_symbolic() {
  bl64_dbg_lib_show_function "$@"

  bl64_fs_run_ln "$BL64_FS_SET_LN_SYMBOLIC" "$@"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_mkdir() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_MKDIR_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MKDIR" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Create full path including parents
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_mkdir_full() {
  bl64_dbg_lib_show_function "$@"

  bl64_fs_run_mkdir "$BL64_FS_SET_MKDIR_PARENTS" "$@"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_mv() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_MV_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MV" $verbose "$BL64_FS_SET_MV_FORCE" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove files using the verbose and force flags. Limited to current filesystem
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_rm_file() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" || return $?

  bl64_fs_run_rm "$BL64_FS_SET_RM_FORCE" "$@"
}

#######################################
# Remove directories using the verbose and force flags. Limited to current filesystem
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_rm_full() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" || return $?

  bl64_fs_run_rm "$BL64_FS_SET_RM_FORCE" "$BL64_FS_SET_RM_RECURSIVE" "$@"
}

#######################################
# Remove content from OS temporary repositories
#
# * Warning: intented for container build only, not to run on regular OS
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_tmps() {
  bl64_dbg_lib_show_function
  local target=''

  target='/tmp'
  bl64_msg_show_lib_subtask "${_BL64_FS_TXT_CLEANUP_TEMP} (${target})"
  bl64_fs_rm_full -- ${target}/[[:alnum:]]*

  target='/var/tmp'
  bl64_msg_show_lib_subtask "${_BL64_FS_TXT_CLEANUP_TEMP} (${target})"
  bl64_fs_rm_full -- ${target}/[[:alnum:]]*
  return 0
}

#######################################
# Remove or reset logs from standard locations
#
# * Warning: intented for container build only, not to run on regular OS
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_logs() {
  bl64_dbg_lib_show_function
  local target='/var/log'

  if [[ -d "$target" ]]; then
    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_CLEANUP_LOGS} (${target})"
    bl64_fs_rm_full ${target}/[[:alnum:]]*
  fi
  return 0
}

#######################################
# Remove or reset OS caches from standard locations
#
# * Warning: intented for container build only, not to run on regular OS
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_caches() {
  bl64_dbg_lib_show_function
  local target='/var/cache/man'

  if [[ -d "$target" ]]; then
    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_CLEANUP_CACHES} (${target})"
    bl64_fs_rm_full ${target}/[[:alnum:]]*
  fi
  return 0
}

#######################################
# Performs a complete cleanup of OS ephemeral content
#
# * Warning: intented for container build only, not to run on regular OS
# * Removes temporary files
# * Cleans caches
# * Removes logs
#
# Arguments:
#   None
# Outputs:
#   STDOUT: output from clean functions
#   STDERR: output from clean functions
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_full() {
  bl64_dbg_lib_show_function

  bl64_fs_cleanup_tmps
  bl64_fs_cleanup_logs
  bl64_fs_cleanup_caches

  return 0
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_find() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_command "$BL64_FS_CMD_FIND" || return $?

  bl64_dbg_lib_trace_start
  "$BL64_FS_CMD_FIND" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Find files and report as list
#
# * Not using bl64_fs_find to avoid file expansion for -name
#
# Arguments:
#   $1: search path
#   $2: search pattern. Format: find -name options
#   $3: search content in text files
# Outputs:
#   STDOUT: file list. One path per line
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_find_files() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-.}"
  local pattern="${2:-${BL64_VAR_DEFAULT}}"
  local content="${3:-${BL64_VAR_DEFAULT}}"

  bl64_check_command "$BL64_FS_CMD_FIND" &&
    bl64_check_directory "$path" || return $?

  [[ "$pattern" == "$BL64_VAR_DEFAULT" ]] && pattern=''

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  if [[ "$content" == "$BL64_VAR_DEFAULT" ]]; then
    "$BL64_FS_CMD_FIND" \
      "$path" \
      -type 'f' \
      ${pattern:+-name "${pattern}"} \
      -print
  else
    "$BL64_FS_CMD_FIND" \
      "$path" \
      -type 'f' \
      ${pattern:+-name "${pattern}"} \
      -exec \
      "$BL64_TXT_CMD_GREP" \
      "$BL64_TXT_SET_GREP_SHOW_FILE_ONLY" \
      "$BL64_TXT_SET_GREP_ERE" "$content" \
      "{}" \;
  fi
  bl64_dbg_lib_trace_stop

}

#######################################
# Safeguard path to a temporary location
#
# * Use for file/dir operations that will alter or replace the content and requires a quick rollback mechanism
# * The original path is renamed until bl64_fs_restore is called to either remove or restore it
# * If the destination is not present nothing is done. Return with no error. This is to cover for first time path creation
#
# Arguments:
#   $1: safeguard path (produced by bl64_fs_safeguard)
#   $2: task status (exit status from last operation)
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_safeguard() {
  bl64_dbg_lib_show_function "$@"
  local destination="${1:-}"
  local backup="${destination}${BL64_FS_SAFEGUARD_POSTFIX}"

  bl64_check_parameter 'destination' ||
    return $?

  # Return if not present
  if [[ ! -e "$destination" ]]; then
    bl64_dbg_lib_show_comments "path is not yet created, nothing to do (${destination})"
    return 0
  fi

  bl64_msg_show_lib_subtask "${_BL64_FS_TXT_SAFEGUARD_OBJECT} ([${destination}]->[${backup}])"
  if ! bl64_fs_run_mv "$destination" "$backup"; then
    bl64_msg_show_error "$_BL64_FS_TXT_SAFEGUARD_FAILED ($destination)"
    return $BL64_LIB_ERROR_TASK_BACKUP
  fi

  return 0
}

#######################################
# Restore path from safeguard if operation failed or remove if operation was ok
#
# * Use as a quick rollback for file/dir operations
# * Called after bl64_fs_safeguard creates the backup
# * If the backup is not there nothing is done, no error returned. This is to cover for first time path creation
#
# Arguments:
#   $1: safeguard path (produced by bl64_fs_safeguard)
#   $2: task status (exit status from last operation)
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_restore() {
  bl64_dbg_lib_show_function "$@"
  local destination="${1:-}"
  local -i result=$2
  local backup="${destination}${BL64_FS_SAFEGUARD_POSTFIX}"

  bl64_check_parameter 'destination' &&
    bl64_check_parameter 'result' ||
    return $?

  # Return if not present
  if [[ ! -e "$backup" ]]; then
    bl64_dbg_lib_show_comments "backup was not created, nothing to do (${backup})"
    return 0
  fi

  # Check if restore is needed based on the operation result
  if ((result == 0)); then
    bl64_dbg_lib_show_comments 'operation was ok, backup no longer needed, remove it'
    [[ -e "$backup" ]] && bl64_fs_rm_full "$backup"

    # shellcheck disable=SC2086
    return 0
  else
    bl64_dbg_lib_show_comments 'operation was NOT ok, remove invalid content'
    [[ -e "$destination" ]] && bl64_fs_rm_full "$destination"

    bl64_msg_show_lib_subtask "${_BL64_FS_TXT_RESTORE_OBJECT} ([${backup}]->[${destination}])"
    # shellcheck disable=SC2086
    bl64_fs_run_mv "$backup" "$destination" ||
      return $BL64_LIB_ERROR_TASK_RESTORE
  fi
}

#######################################
# Set object permissions and ownership
#
# * work on individual files
# * no recurse option
# * all files get the same permissions, user, group
#
# Arguments:
#   $1: permissions. Format: chown format. Default: use current umask
#   $2: user name. Default: nonde
#   $3: group name. Default: current
#   $@: list of objects. Must use full path for each
# Outputs:
#   STDOUT: command stdin
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_set_permissions() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_VAR_DEFAULT}}"
  local user="${2:-${BL64_VAR_DEFAULT}}"
  local group="${3:-${BL64_VAR_DEFAULT}}"
  local path=''

  # Remove consumed parameters
  shift
  shift
  shift

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_show_info "path list:[${*}]"

  if [[ "$mode" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_comments "set new permissions (${mode})"
    bl64_fs_run_chmod "$mode" "$@" || return $?
  fi

  if [[ "$user" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_comments "set new user (${user})"
    bl64_fs_run_chown "${user}" "$@" || return $?
  fi

  if [[ "$group" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_comments "set new group (${group})"
    bl64_fs_run_chown ":${group}" "$@" || return $?
  fi

  return 0
}

#######################################
# Fix path permissions
#
# * allow different permissions for files and directories
# * recursive
#
# Arguments:
#   $1: file permissions. Format: chown format. Default: no action
#   $2: directory permissions. Format: chown format. Default: no action
#   $@: list of paths. Must use full path for each
# Outputs:
#   STDOUT: command stdin
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_fix_permissions() {
  bl64_dbg_lib_show_function "$@"
  local file_mode="${1:-${BL64_VAR_DEFAULT}}"
  local dir_mode="${2:-${BL64_VAR_DEFAULT}}"
  local path=''

  # Remove consumed parameters
  shift
  shift

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_show_info "path list:[${*}]"

  if [[ "$file_mode" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_comments "fix file permissions (${file_mode})"
    # shellcheck disable=SC2086
    bl64_fs_run_find \
      "$@" \
      ${BL64_FS_SET_FIND_STAY} \
      ${BL64_FS_SET_FIND_TYPE_FILE} \
      ${BL64_FS_SET_FIND_RUN} "$BL64_FS_CMD_CHMOD" "$file_mode" "{}" \; ||
      return $?
  fi

  if [[ "$dir_mode" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_comments "fix directory permissions (${dir_mode})"
    # shellcheck disable=SC2086
    bl64_fs_run_find \
      "$@" \
      ${BL64_FS_SET_FIND_STAY} \
      ${BL64_FS_SET_FIND_TYPE_DIR} \
      ${BL64_FS_SET_FIND_RUN} "$BL64_FS_CMD_CHMOD" "$dir_mode" "{}" \; ||
      return $?
  fi

  return 0
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_cp() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CP_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CP" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_rm() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CP_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_RM" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_ls() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" || return $?

  bl64_dbg_lib_trace_start
  "$BL64_FS_CMD_LS" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_run_ln() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" || return $?
  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_LN_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_FS_CMD_LN" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Set default path creation permission with umask
#
# * Uses symbolic permission form
# * Supports predefined sets: BL64_FS_UMASK_*
#
# Arguments:
#   $1: permission. Format: BL64_FS_UMASK_RW_USER
# Outputs:
#   STDOUT: None
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
# shellcheck disable=SC2120
function bl64_fs_set_umask() {
  bl64_dbg_lib_show_function "$@"
  local permissions="${1:-${BL64_FS_UMASK_RW_USER}}"

  umask -S "$permissions" >/dev/null
}

#######################################
# Set global ephemeral paths for bashlib64 functions
#
# * When set, bashlib64 can use these locations as alternative paths to standard ephemeral locations (tmp, cache, etc)
# * Path is created if not already present
#
# Arguments:
#   $1: Temporal files. Short lived, data should be removed after usage. Format: full path
#   $2: cache files. Lifecycle managed by the consumer. Data can persist between runs. If data is removed, consumer should be able to regenerate it. Format: full path
#   $3: permissions. Format: chown format. Default: use current umask
#   $4: user name. Default: current
#   $5: group name. Default: current
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_set_ephemeral() {
  bl64_dbg_lib_show_function "$@"
  local temporal="${1:-${BL64_VAR_DEFAULT}}"
  local cache="${2:-${BL64_VAR_DEFAULT}}"
  local mode="${3:-${BL64_VAR_DEFAULT}}"
  local user="${4:-${BL64_VAR_DEFAULT}}"
  local group="${5:-${BL64_VAR_DEFAULT}}"

  if [[ "$temporal" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_fs_create_dir "$mode" "$user" "$group" "$temporal" &&
      BL64_FS_PATH_TEMPORAL="$temporal" ||
      return $?
  fi

  if [[ "$cache" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_fs_create_dir "$mode" "$user" "$group" "$cache" &&
      BL64_FS_PATH_CACHE="$cache" ||
      return $?
  fi

  return 0
}

#######################################
# Create temporal directory
#
# * Wrapper to the mktemp tool
#
# Arguments:
#   None
# Outputs:
#   STDOUT: full path to temp dir
#   STDERR: error messages
# Returns:
#   0: temp created ok
#  >0: failed to create temp
#######################################
function bl64_fs_create_tmpdir() {
  bl64_dbg_lib_show_function
  local template="${BL64_FS_TMP_PREFIX}-${BL64_SCRIPT_NAME}.XXXXXXXXXX"

  bl64_fs_run_mktemp \
    "$BL64_FS_SET_MKTEMP_DIRECTORY" \
    "$BL64_FS_SET_MKTEMP_TMPDIR" "$BL64_FS_PATH_TMP" \
    "$template"
}

#######################################
# Create temporal file
#
# * Wrapper to the mktemp tool
#
# Arguments:
#   None
# Outputs:
#   STDOUT: full path to temp file
#   STDERR: error messages
# Returns:
#   0: temp created ok
#  >0: failed to create temp
#######################################
function bl64_fs_create_tmpfile() {
  bl64_dbg_lib_show_function
  local template="${BL64_FS_TMP_PREFIX}-${BL64_SCRIPT_NAME}.XXXXXXXXXX"

  bl64_fs_run_mktemp \
    "$BL64_FS_SET_MKTEMP_TMPDIR" "$BL64_FS_PATH_TMP" \
    "$template"
}

#######################################
# Remove temporal directory created by bl64_fs_create_tmpdir
#
# Arguments:
#   $1: full path to the tmpdir
# Outputs:
#   STDOUT: None
#   STDERR: error messages
# Returns:
#   0: temp removed ok
#  >0: failed to remove temp
#######################################
function bl64_fs_rm_tmpdir() {
  bl64_dbg_lib_show_function "$@"
  local tmpdir="$1"

  bl64_check_parameter 'tmpdir' &&
    bl64_check_directory "$tmpdir" ||
    return $?

  if [[ "$tmpdir" != ${BL64_FS_PATH_TMP}/${BL64_FS_TMP_PREFIX}-*.* ]]; then
    bl64_msg_show_error "${_BL64_FS_TXT_ERROR_NOT_TMPDIR} (${tmpdir})"
    return $BL64_LIB_ERROR_TASK_FAILED
  fi

  bl64_fs_rm_full "$tmpdir"
}

#######################################
# Remove temporal file create by bl64_fs_create_tmpfile
#
# Arguments:
#   $1: full path to the tmpfile
# Outputs:
#   STDOUT: None
#   STDERR: error messages
# Returns:
#   0: temp removed ok
#  >0: failed to remove temp
#######################################
function bl64_fs_rm_tmpfile() {
  bl64_dbg_lib_show_function "$@"
  local tmpfile="$1"

  bl64_check_parameter 'tmpfile' &&
    bl64_check_file "$tmpfile" ||
    return $?

  if [[ "$tmpfile" != ${BL64_FS_PATH_TMP}/${BL64_FS_TMP_PREFIX}-*.* ]]; then
    bl64_msg_show_error "${_BL64_FS_TXT_ERROR_NOT_TMPFILE} (${tmpfile})"
    return $BL64_LIB_ERROR_TASK_FAILED
  fi

  bl64_fs_rm_file "$tmpfile"
}

#######################################
# Check that the new file path is valid
#
# * If path exists, check that is not a directory
# * Check is ok when path does not exist or exists but it's a file
#
# Arguments:
#   $1: new file path
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_fs_check_new_file() {
  bl64_dbg_lib_show_function "$@"
  local file="${1:-}"

  bl64_check_parameter 'file' ||
    return $?

  if [[ -d "$file" ]]; then
    bl64_msg_show_error "${_BL64_FS_TXT_ERROR_INVALID_FILE_TARGET} (${file})"
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  fi

  return 0
}

#######################################
# Check that the new directory path is valid
#
# * If path exists, check that is not a file
# * Check is ok when path does not exist or exists but it's a directory
#
# Arguments:
#   $1: new directory path
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_fs_check_new_dir() {
  bl64_dbg_lib_show_function "$@"
  local directory="${1:-}"

  bl64_check_parameter 'directory' ||
    return $?

  if [[ -f "$directory" ]]; then
    bl64_msg_show_error "${_BL64_FS_TXT_ERROR_INVALID_DIR_TARGET} (${directory})"
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  fi

  return 0
}

#######################################
# Create symbolic link
#
# * Wrapper to the ln -s command
# * Provide extra checks and verbosity
#
# Arguments:
#   $1: source path
#   $2: destination path
#   $3: overwrite if already present?
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_fs_create_symlink() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-}"
  local destination="${2:-}"
  local overwrite="${3:-$BL64_VAR_OFF}"

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_path "$source" ||
    return $?

  if [[ -e "$destination" ]]; then
    if [[ "$overwrite" == "$BL64_VAR_ON" ]]; then
      bl64_fs_rm_file "$destination" ||
        return $?
    else
      bl64_msg_show_warning "${_BL64_FS_TXT_SYMLINK_EXISTING} (${destination})"
      return 0
    fi
  fi
  bl64_msg_show_lib_subtask "${_BL64_FS_TXT_SYMLINK_CREATE} (${source} ${BL64_MSG_COSMETIC_ARROW2} ${destination})"
  bl64_fs_run_ln "$BL64_FS_SET_LN_SYMBOLIC" "$source" "$destination"
}

#######################################
# BashLib64 / Module / Setup / Format text data
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_fmt_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    bl64_check_module_imported 'BL64_TXT_MODULE' &&
    BL64_FMT_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'fmt'
}

#######################################
# BashLib64 / Module / Functions / Format text data
#######################################

#######################################
# Removes starting slash from path
#
# * If path is a single slash or relative path no change is done
#
# Arguments:
#   $1: Target path
# Outputs:
#   STDOUT: Updated path
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_strip_starting_slash() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return 0
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == /* ]]; then
    printf '%s' "${path:1}"
  else
    printf '%s' "${path}"
  fi
}

#######################################
# Removes ending slash from path
#
# * If path is a single slash or no ending slash is present no change is done
#
# Arguments:
#   $1: Target path
# Outputs:
#   STDOUT: Updated path
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_strip_ending_slash() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return 0
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == */ ]]; then
    printf '%s' "${path:0:-1}"
  else
    printf '%s' "${path}"
  fi
}

#######################################
# Show the last part (basename) of a path
#
# * The function operates on text data, it doesn't verify path existance
# * The last part can be either a directory or a file
# * Parts are separated by the / character
# * The basename is defined by taking the text to the right of the last separator
# * Function mimics the linux basename command
#
# Examples:
#
#   bl64_fmt_basename '/full/path/to/file' -> 'file'
#   bl64_fmt_basename '/full/path/to/file/' -> ''
#   bl64_fmt_basename 'path/to/file' -> 'file'
#   bl64_fmt_basename 'path/to/file/' -> ''
#   bl64_fmt_basename '/file' -> 'file'
#   bl64_fmt_basename '/' -> ''
#   bl64_fmt_basename 'file' -> 'file'
#
# Arguments:
#   $1: Path
# Outputs:
#   STDOUT: Basename
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_basename() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local base=''

  if [[ -n "$path" && "$path" != '/' ]]; then
    base="${path##*/}"
  fi

  if [[ -z "$base" || "$base" == */* ]]; then
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  else
    printf '%s' "$base"
  fi
  return 0
}

#######################################
# Show the directory part of a path
#
# * The function operates on text data, it doesn't verify path existance
# * Parts are separated by the slash (/) character
# * The directory is defined by taking the input string up to the last separator
#
# Examples:
#
#   bl64_fmt_dirname '/full/path/to/file' -> '/full/path/to'
#   bl64_fmt_dirname '/full/path/to/file/' -> '/full/path/to/file'
#   bl64_fmt_dirname '/file' -> '/'
#   bl64_fmt_dirname '/' -> '/'
#   bl64_fmt_dirname 'dir' -> 'dir'
#
# Arguments:
#   $1: Path
# Outputs:
#   STDOUT: Dirname
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_dirname() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return 0
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" != */* ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == /*/* ]]; then
    printf '%s' "${path%/*}"
  elif [[ "$path" == */*/* ]]; then
    printf '%s' "${path%/*}"
  elif [[ "$path" == /* && "${path:1}" != */* ]]; then
    printf '%s' '/'
  fi
}

#######################################
# Convert list to string. Optionally add prefix, postfix to each field
#
# * list: lines separated by \n
# * string: same as original list but with \n replaced with space
#
# Arguments:
#   $1: output field separator. Default: space
#   $2: prefix. Format: string
#   $3: postfix. Format: string
# Inputs:
#   STDIN: list
# Outputs:
#   STDOUT: string
#   STDERR: None
# Returns:
#   always ok
#######################################
function bl64_fmt_list_to_string() {
  bl64_dbg_lib_show_function
  local field_separator="${1:-${BL64_VAR_DEFAULT}}"
  local prefix="${2:-${BL64_VAR_DEFAULT}}"
  local postfix="${3:-${BL64_VAR_DEFAULT}}"

  [[ "$field_separator" == "$BL64_VAR_DEFAULT" ]] && field_separator=' '
  [[ "$prefix" == "$BL64_VAR_DEFAULT" ]] && prefix=''
  [[ "$postfix" == "$BL64_VAR_DEFAULT" ]] && postfix=''

  bl64_txt_run_awk \
    -v field_separator="$field_separator" \
    -v prefix="$prefix" \
    -v postfix="$postfix" \
    '
    BEGIN {
      joined_string = ""
      RS="\n"
    }
    {
      joined_string = ( joined_string == "" ? "" : joined_string field_separator ) prefix $0 postfix
    }
    END { print joined_string }
  '
}

#######################################
# Build a separator line with optional payload
#
# * Separator format: payload + \n
#
# Arguments:
#   $1: Separator payload. Format: string
# Outputs:
#   STDOUT: separator line
#   STDERR: grep Error message
# Returns:
#   printf exit status
#######################################
function bl64_fmt_separator_line() {
  bl64_dbg_lib_show_function "$@"
  local payload="${1:-}"

  printf '%s\n' "$payload"
}

#######################################
# Check that the value is part of a list
#
# Arguments:
#   $1: (optional) error message
#   $2: value that will be verified
#   $@: list of one or more values to check against
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: check ok
#   BL64_LIB_ERROR_CHECK_FAILED
#######################################
function bl64_fmt_check_value_in_list() {
  bl64_dbg_lib_show_function "$@"
  local error_message="${1:-$BL64_VAR_DEFAULT}"
  local target_value="${2:-}"
  local valid_value=''
  local -i is_valid=$BL64_LIB_ERROR_CHECK_FAILED

  shift
  shift
  bl64_check_parameter 'target_value' &&
    bl64_check_parameters_none $# "$_BL64_FMT_TXT_ERROR_VALUE_LIST_EMPTY" ||
    return $?
  [[ "$error_message" == "$BL64_VAR_DEFAULT" ]] && error_message="$_BL64_FMT_TXT_ERROR_VALUE_LIST_WRONG"

  for valid_value in "$@"; do
    [[ "$target_value" == "$valid_value" ]] &&
      is_valid=0 &&
      break
  done
  ((is_valid != 0)) &&
    bl64_msg_show_error "${error_message}. ${_BL64_FMT_TXT_VALUE_LIST_VALID}: [${*}] (${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"

  return $is_valid
}

#######################################
# BashLib64 / Module / Setup / Display messages
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_msg_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_msg_set_output "$BL64_MSG_OUTPUT_ANSI" &&
    bl64_msg_app_enable_verbose &&
    BL64_MSG_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'msg'
}

#######################################
# Set verbosity level
#
# Arguments:
#   $1: target level. One of BL64_MSG_VERBOSE_*
# Outputs:
#   STDOUT: None
#   STDERR: check error
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_msg_set_level() {
  bl64_dbg_lib_show_function "$@"
  local level="$1"

  bl64_check_parameter 'level' || return $?

  case "$level" in
  "$BL64_MSG_VERBOSE_NONE")
    bl64_msg_all_disable_verbose
    ;;
  "$BL64_MSG_VERBOSE_APP")
    bl64_msg_app_enable_verbose
    ;;
  "$BL64_MSG_VERBOSE_LIB")
    bl64_msg_lib_enable_verbose
    ;;
  "$BL64_MSG_VERBOSE_ALL")
    bl64_msg_all_enable_verbose
    ;;
  *)
    bl64_check_alert_parameter_invalid 'BL64_MSG_VERBOSE' \
      "${_BL64_MSG_TXT_INVALID_VALUE}: ${BL64_MSG_VERBOSE_NONE}|${BL64_MSG_VERBOSE_ALL}|${BL64_MSG_VERBOSE_APP}|${BL64_MSG_VERBOSE_LIB}"
    return $?
    ;;
  esac
}

#######################################
# Set message format
#
# Arguments:
#   $1: format. One of BL64_MSG_FORMAT_*
# Outputs:
#   STDOUT: None
#   STDERR: parameter error
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_msg_set_format() {
  bl64_dbg_lib_show_function "$@"
  local format="$1"

  bl64_check_parameter 'format' || return $?

  case "$format" in
  "$BL64_MSG_FORMAT_PLAIN")
    BL64_MSG_FORMAT="$BL64_MSG_FORMAT_PLAIN"
    ;;
  "$BL64_MSG_FORMAT_HOST")
    BL64_MSG_FORMAT="$BL64_MSG_FORMAT_HOST"
    ;;
  "$BL64_MSG_FORMAT_TIME")
    BL64_MSG_FORMAT="$BL64_MSG_FORMAT_TIME"
    ;;
  "$BL64_MSG_FORMAT_CALLER")
    BL64_MSG_FORMAT="$BL64_MSG_FORMAT_CALLER"
    ;;
  "$BL64_MSG_FORMAT_FULL")
    BL64_MSG_FORMAT="$BL64_MSG_FORMAT_FULL"
    ;;
  *)
    bl64_check_alert_parameter_invalid 'BL64_MSG_FORMAT' \
      "${_BL64_MSG_TXT_INVALID_VALUE}: ${BL64_MSG_FORMAT_PLAIN}|${BL64_MSG_FORMAT_HOST}|${BL64_MSG_FORMAT_TIME}|${BL64_MSG_FORMAT_CALLER}|${BL64_MSG_FORMAT_FULL}"
    return $?
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_MSG_FORMAT'
}

#######################################
# Set message display theme
#
# Arguments:
#   $1: theme name. One of BL64_MSG_THEME_ID_*
# Outputs:
#   STDOUT: None
#   STDERR: parameter error
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_msg_set_theme() {
  bl64_dbg_lib_show_function "$@"
  local theme="$1"

  bl64_check_parameter 'theme' || return $?

  case "$theme" in
  "$BL64_MSG_THEME_ID_ASCII_STD")
    BL64_MSG_THEME='BL64_MSG_THEME_ASCII_STD'
    ;;
  "$BL64_MSG_THEME_ID_ANSI_STD")
    BL64_MSG_THEME='BL64_MSG_THEME_ANSI_STD'
    ;;
  *)
    bl64_check_alert_parameter_invalid 'BL64_MSG_THEME' \
      "${_BL64_MSG_TXT_INVALID_VALUE}: ${BL64_MSG_THEME_ID_ASCII_STD}|${BL64_MSG_THEME_ID_ANSI_STD}"
    return $?
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_MSG_THEME'
}

#######################################
# Set message output type
#
# * Will also setup the theme
# * If no theme is provided then the STD is used (ansi or ascii)
#
# Arguments:
#   $1: output type. One of BL64_MSG_OUTPUT_*
#   $2: (optional) theme. Default: STD
# Outputs:
#   STDOUT: None
#   STDERR: parameter error
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
function bl64_msg_set_output() {
  bl64_dbg_lib_show_function "$@"
  local output="${1:-}"
  local theme="${2:-${BL64_VAR_DEFAULT}}"

  bl64_check_parameter 'output' || return $?

  case "$output" in
  "$BL64_MSG_OUTPUT_ASCII")
    [[ "$theme" == "$BL64_VAR_DEFAULT" ]] && theme="$BL64_MSG_THEME_ID_ASCII_STD"
    BL64_MSG_OUTPUT="$output"
    ;;
  "$BL64_MSG_OUTPUT_ANSI")
    [[ "$theme" == "$BL64_VAR_DEFAULT" ]] && theme="$BL64_MSG_THEME_ID_ANSI_STD"
    BL64_MSG_OUTPUT="$output"
    ;;
  *)
    bl64_check_alert_parameter_invalid 'BL64_MSG_OUTPUT' \
      "${_BL64_MSG_TXT_INVALID_VALUE}: ${BL64_MSG_OUTPUT_ASCII}|${BL64_MSG_OUTPUT_ANSI}"
    return $?
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_MSG_OUTPUT'
  bl64_msg_set_theme "$theme"
}

#
# Verbosity control
#

function bl64_msg_app_verbose_enabled {
  bl64_dbg_lib_show_function
  [[ "$BL64_MSG_VERBOSE" == "$BL64_MSG_VERBOSE_APP" || "$BL64_MSG_VERBOSE" == "$BL64_MSG_VERBOSE_ALL" ]]
}
function bl64_msg_lib_verbose_enabled {
  bl64_dbg_lib_show_function
  [[ "$BL64_MSG_VERBOSE" == "$BL64_MSG_VERBOSE_LIB" || "$BL64_MSG_VERBOSE" == "$BL64_MSG_VERBOSE_ALL" ]]
}

function bl64_msg_all_disable_verbose {
  bl64_dbg_lib_show_function
  BL64_MSG_VERBOSE="$BL64_MSG_VERBOSE_NONE"
}
function bl64_msg_all_enable_verbose {
  bl64_dbg_lib_show_function
  BL64_MSG_VERBOSE="$BL64_MSG_VERBOSE_ALL"
}
function bl64_msg_lib_enable_verbose {
  bl64_dbg_lib_show_function
  BL64_MSG_VERBOSE="$BL64_MSG_VERBOSE_LIB"
}
function bl64_msg_app_enable_verbose {
  bl64_dbg_lib_show_function
  BL64_MSG_VERBOSE="$BL64_MSG_VERBOSE_APP"
}

#######################################
# BashLib64 / Module / Functions / Display messages
#######################################

#######################################
# Display message helper
#
# Arguments:
#   $1: stetic attribute
#   $2: type of message
#   $2: message to show
# Outputs:
#   STDOUT: message
#   STDERR: message when type is error or warning
# Returns:
#   printf exit status
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function _bl64_msg_print() {
  bl64_dbg_lib_show_function "$@"
  local attribute="${1:-}"
  local type="${2:-}"
  local message="${3:-}"

  [[ -n "$attribute" && -n "$type" && -n "$message" ]] || return $BL64_LIB_ERROR_PARAMETER_MISSING

  case "$BL64_MSG_OUTPUT" in
  "$BL64_MSG_OUTPUT_ASCII") _bl64_msg_format_ascii "$attribute" "$type" "$message" ;;
  "$BL64_MSG_OUTPUT_ANSI") _bl64_msg_format_ansi "$attribute" "$type" "$message" ;;
  *) bl64_check_alert_parameter_invalid ;;
  esac
}

function _bl64_msg_format_ansi() {
  bl64_dbg_lib_show_function "$@"
  local attribute="${1:-}"
  local type="${2:-}"
  local message="${3:-}"
  local style=''
  local style_fmttime="${BL64_MSG_THEME}_FMTTIME"
  local style_fmthost="${BL64_MSG_THEME}_FMTHOST"
  local style_fmtcaller="${BL64_MSG_THEME}_FMTCALLER"
  local linefeed='\n'

  [[ -n "$attribute" && -n "$type" && -n "$message" ]] || return $BL64_LIB_ERROR_PARAMETER_MISSING
  style="${BL64_MSG_THEME}_${attribute}"
  [[ "$attribute" == "$BL64_MSG_TYPE_INPUT" ]] && linefeed=''

  case "$BL64_MSG_FORMAT" in
  "$BL64_MSG_FORMAT_PLAIN")
    printf "%b: %s${linefeed}" \
      "\e[${!style}m${type}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_HOST")
    printf "[%b] %b: %s${linefeed}" \
      "\e[${!style_fmthost}m${HOSTNAME}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style}m${type}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_TIME")
    printf "[%b] %b: %s${linefeed}" \
      "\e[${!style_fmttime}m$(printf '%(%d/%b/%Y-%H:%M:%S-UTC%z)T' '-1')\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style}m${type}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_CALLER")
    printf "[%b] %b: %s${linefeed}" \
      "\e[${!style_fmtcaller}m${BL64_SCRIPT_ID}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style}m${type}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_FULL")
    printf "[%b] %b:%b | %b: %s${linefeed}" \
      "\e[${!style_fmttime}m$(printf '%(%d/%b/%Y-%H:%M:%S-UTC%z)T' '-1')\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style_fmthost}m${HOSTNAME}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style_fmtcaller}m${BL64_SCRIPT_ID}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "\e[${!style}m${type}\e[${BL64_MSG_ANSI_CHAR_NORMAL}m" \
      "$message"
    ;;
  *) bl64_check_alert_parameter_invalid ;;
  esac
}

function _bl64_msg_format_ascii() {
  bl64_dbg_lib_show_function "$@"
  local attribute="${1:-}"
  local type="${2:-}"
  local message="${3:-}"
  local style=''
  local style_fmttime="${BL64_MSG_THEME}_FMTTIME"
  local style_fmthost="${BL64_MSG_THEME}_FMTHOST"
  local style_fmtcaller="${BL64_MSG_THEME}_FMTCALLER"
  local linefeed='\n'

  [[ -n "$attribute" && -n "$type" && -n "$message" ]] || return $BL64_LIB_ERROR_PARAMETER_MISSING
  style="${BL64_MSG_THEME}_${attribute}"
  [[ "$attribute" == "$BL64_MSG_TYPE_INPUT" ]] && linefeed=''

  case "$BL64_MSG_FORMAT" in
  "$BL64_MSG_FORMAT_PLAIN")
    printf "%s: %s${linefeed}" \
      "${!style} $type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_HOST")
    printf "[%s] %s: %s${linefeed}" \
      "${HOSTNAME}" \
      "${!style} $type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_TIME")
    printf "[%(%d/%b/%Y-%H:%M:%S-UTC%z)T] %s: %s${linefeed}" \
      '-1' \
      "${!style} $type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_CALLER")
    printf "[%s] %s: %s${linefeed}" \
      "$BL64_SCRIPT_ID" \
      "${!style} $type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_FULL")
    printf "[%(%d/%b/%Y-%H:%M:%S-UTC%z)T] %s:%s | %s: %s${linefeed}" \
      '-1' \
      "$HOSTNAME" \
      "$BL64_SCRIPT_ID" \
      "${!style} $type" \
      "$message"
    ;;
  *) bl64_check_alert_parameter_invalid ;;
  esac
}

#######################################
# Show script usage information
#
# Arguments:
#   $1: script command line. Include all required and optional components
#   $2: full script usage description
#   $3: list of script commands
#   $4: list of script flags
#   $5: list of script parameters
# Outputs:
#   STDOUT: usage info
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_usage() {
  bl64_dbg_lib_show_function "$@"
  local usage="${1:-${BL64_VAR_NULL}}"
  local description="${2:-${BL64_VAR_DEFAULT}}"
  local commands="${3:-${BL64_VAR_DEFAULT}}"
  local flags="${4:-${BL64_VAR_DEFAULT}}"
  local parameters="${5:-${BL64_VAR_DEFAULT}}"

  bl64_check_parameter 'usage' || return $?

  printf '\n%s: %s %s\n\n' "$_BL64_MSG_TXT_USAGE" "$BL64_SCRIPT_ID" "$usage"

  if [[ "$description" != "$BL64_VAR_DEFAULT" ]]; then
    printf '%s\n\n' "$description"
  fi

  if [[ "$commands" != "$BL64_VAR_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_COMMANDS" "$commands"
  fi

  if [[ "$flags" != "$BL64_VAR_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_FLAGS" "$flags"
  fi

  if [[ "$parameters" != "$BL64_VAR_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_PARAMETERS" "$parameters"
  fi

  return 0
}

#######################################
# Display error message
#
# Arguments:
#   $1: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_error() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_error "${FUNCNAME[1]:-MAIN}" "$message" &&
    _bl64_msg_print "$BL64_MSG_TYPE_ERROR" "$_BL64_MSG_TXT_ERROR" "$message" >&2
}

#######################################
# Display warning message
#
# Arguments:
#   $1: warning message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_warning() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_warning "${FUNCNAME[1]:-MAIN}" "$message" &&
    _bl64_msg_print "$BL64_MSG_TYPE_WARNING" "$_BL64_MSG_TXT_WARNING" "$message" >&2
}

#######################################
# Display info message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_info() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "$message" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_INFO" "$_BL64_MSG_TXT_INFO" "$message"
}

#######################################
# Display phase message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_phase() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_PHASE}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_PHASE" "$_BL64_MSG_TXT_PHASE" "${BL64_MSG_COSMETIC_PHASE_PREFIX} ${message} ${BL64_MSG_COSMETIC_PHASE_SUFIX}"
}

#######################################
# Display task message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_task() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_TASK}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_TASK" "$_BL64_MSG_TXT_TASK" "$message"
}

#######################################
# Display subtask message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_subtask() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_SUBTASK}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_SUBTASK" "$_BL64_MSG_TXT_SUBTASK" "${BL64_MSG_COSMETIC_ARROW2} ${message}"
}

#######################################
# Display task message for bash64lib functions
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_lib_task() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_LIBTASK}:${message}" &&
    bl64_msg_lib_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_LIBTASK" "$_BL64_MSG_TXT_TASK" "$message"
}

#######################################
# Display subtask message for bash64lib functions
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_lib_subtask() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_LIBSUBTASK}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_LIBSUBTASK" "$_BL64_MSG_TXT_SUBTASK" "${BL64_MSG_COSMETIC_ARROW2} ${message}"
}

#######################################
# Display info message for bash64lib functions
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_lib_info() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_LIBINFO}:${message}" &&
    bl64_msg_lib_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_LIBINFO" "$_BL64_MSG_TXT_INFO" "$message"
}

#######################################
# Display message. Plain output, no extra info.
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_text() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "$message" &&
    bl64_msg_app_verbose_enabled || return 0

  printf '%s\n' "$message"
}

#######################################
# Display batch process start message
#
# * Use in the main section of task oriented scripts to show start/end of batch process
#
# Arguments:
#   $2: batch short description
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_batch_start() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_BATCH}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  _bl64_msg_print "$BL64_MSG_TYPE_BATCH" "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_START}"
}

#######################################
# Display batch process complete message
#
# * Use in the main section of task oriented scripts to show start/end of batch process
# * Can be used as last command in shell script to both show status and return exit status
#
# Arguments:
#   $1: process exit status
#   $2: batch short description
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_batch_finish() {
  bl64_dbg_lib_show_function "$@"
  local -i status=$1
  local message="${2-}"

  bl64_log_info "${FUNCNAME[1]:-MAIN}" "${BL64_MSG_TYPE_BATCH}:${status}:${message}" &&
    bl64_msg_app_verbose_enabled || return 0

  if ((status == 0)); then
    _bl64_msg_print "$BL64_MSG_TYPE_BATCHOK" "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_FINISH_OK}"
  else
    _bl64_msg_print "$BL64_MSG_TYPE_BATCHERR" "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_FINISH_ERROR}: exit-status-${status}"
  fi
  # shellcheck disable=SC2086
  return $status
}

#######################################
# Display user input message
#
# * Used exclusively by the io module to show messages for user input from stdin
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_input() {
  bl64_dbg_lib_show_function "$@"
  local message="$1"

  _bl64_msg_print "$BL64_MSG_TYPE_INPUT" "$_BL64_MSG_TXT_INPUT" "$message"
}

#######################################
# Show separator line
#
# Arguments:
#   $1: Prefix string. Default: none
#   $2: character used to build the line. Default: =
#   $3: separator length (without prefix). Default: 60
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_separator() {
  bl64_dbg_lib_show_function "$@"
  local message="${1:-$BL64_VAR_DEFAULT}"
  local separator="${2:-$BL64_VAR_DEFAULT}"
  local length="${3:-$BL64_VAR_DEFAULT}"
  local -i counter=0
  local output=''

  [[ "$message" == "$BL64_VAR_DEFAULT" ]] && message=''
  [[ "$separator" == "$BL64_VAR_DEFAULT" ]] && separator='='
  [[ "$length" == "$BL64_VAR_DEFAULT" ]] && length=60

  output="$(
    while true; do
      counter=$((counter + 1))
      printf '%c' "$separator"
      ((counter == length)) && break
    done
  )"

  _bl64_msg_print "$BL64_MSG_TYPE_SEPARATOR" "$_BL64_MSG_TXT_SEPARATOR" "${message}${output}"
}

#######################################
# BashLib64 / Module / Setup / OS / Identify OS attributes and provide command aliases
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_os_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  [[ "${BASH_VERSINFO[0]}" != '4' && "${BASH_VERSINFO[0]}" != '5' ]] &&
    bl64_msg_show_error "BashLib64 is not supported in the current Bash version (${BASH_VERSINFO[0]})" &&
    return $BL64_LIB_ERROR_OS_BASH_VERSION

  _bl64_os_set_distro &&
    _bl64_os_set_runtime &&
    _bl64_os_set_command &&
    _bl64_os_set_options &&
    BL64_OS_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'os'
}

#######################################
# Identify and normalize common *nix OS commands
#
# * Commands are exported as variables with full path
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function
function _bl64_os_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_OS_CMD_BASH='/bin/bash'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE='/bin/date'
    BL64_OS_CMD_FALSE='/bin/false'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_LOCALE='/usr/bin/locale'
    BL64_OS_CMD_TEE='/usr/bin/tee'
    BL64_OS_CMD_TRUE='/bin/true'
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_OS_CMD_BASH='/bin/bash'
    BL64_OS_CMD_CAT='/usr/bin/cat'
    BL64_OS_CMD_DATE='/bin/date'
    BL64_OS_CMD_FALSE='/usr/bin/false'
    BL64_OS_CMD_HOSTNAME='/usr/bin/hostname'
    BL64_OS_CMD_LOCALE='/usr/bin/locale'
    BL64_OS_CMD_TEE='/usr/bin/tee'
    BL64_OS_CMD_TRUE='/usr/bin/true'
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_OS_CMD_BASH='/usr/bin/bash'
    BL64_OS_CMD_CAT='/usr/bin/cat'
    BL64_OS_CMD_DATE='/usr/bin/date'
    BL64_OS_CMD_FALSE='/usr/bin/false'
    BL64_OS_CMD_HOSTNAME='/usr/bin/hostname'
    BL64_OS_CMD_LOCALE='/usr/bin/locale'
    BL64_OS_CMD_TEE='/usr/bin/tee'
    BL64_OS_CMD_TRUE='/usr/bin/true'
    BL64_OS_CMD_UNAME='/usr/bin/uname'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_OS_CMD_BASH='/bin/bash'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE='/bin/date'
    BL64_OS_CMD_FALSE='/bin/false'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_LOCALE='/usr/bin/locale'
    BL64_OS_CMD_TEE='/usr/bin/tee'
    BL64_OS_CMD_TRUE='/bin/true'
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_MCOS}-*)
    # Homebrew used when no native option available
    BL64_OS_CMD_BASH='/opt/homebre/bin/bash'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE='/bin/date'
    BL64_OS_CMD_FALSE='/usr/bin/false'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_LOCALE='/usr/bin/locale'
    BL64_OS_CMD_TEE='/usr/bin/tee'
    BL64_OS_CMD_TRUE='/usr/bin/true'
    BL64_OS_CMD_UNAME='/usr/bin/uname'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_os_set_options() {
  bl64_dbg_lib_show_function

  BL64_OS_SET_LOCALE_ALL='--all-locales'
}

#######################################
# Set runtime defaults
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_os_set_runtime() {
  bl64_dbg_lib_show_function

  # Reset language to modern specification of C locale
  if bl64_lib_lang_is_enabled; then
    # shellcheck disable=SC2034
    case "$BL64_OS_DISTRO" in
    ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
      bl64_os_set_lang 'C.UTF-8'
      ;;
    ${BL64_OS_FD}-*)
      bl64_os_set_lang 'C.UTF-8'
      ;;
    ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
      bl64_dbg_lib_show_comments 'UTF locale not installed by default, skipping'
      ;;
    ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-8.* | ${BL64_OS_OL}-9.* | ${BL64_OS_RCK}-*)
      bl64_os_set_lang 'C.UTF-8'
      ;;
    ${BL64_OS_SLES}-*)
      bl64_os_set_lang 'C.UTF-8'
      ;;
    ${BL64_OS_ALP}-*)
      bl64_dbg_lib_show_comments 'UTF locale not installed by default, skipping'
      ;;
    ${BL64_OS_MCOS}-*)
      bl64_dbg_lib_show_comments 'UTF locale not installed by default, skipping'
      ;;
    *)
      bl64_check_alert_unsupported
      return $?
      ;;
    esac
  fi

  return 0
}

#######################################
# Set locale related shell variables
#
# * Locale variables are set as is, no extra validation on the locale availability
#
# Arguments:
#   $1: locale name
# Outputs:
#   STDOUT: None
#   STDERR: Validation errors
# Returns:
#   0: set ok
#   >0: set error
#######################################
function bl64_os_set_lang() {
  bl64_dbg_lib_show_function "$@"
  local locale="$1"

  bl64_check_parameter 'locale' || return $?

  LANG="$locale"
  LC_ALL="$locale"
  LANGUAGE="$locale"
  bl64_dbg_lib_show_vars 'LANG' 'LC_ALL' 'LANGUAGE'

  return 0
}

#######################################
# BashLib64 / Module / Functions / OS / Identify OS attributes and provide command aliases
#######################################

function _bl64_os_match() {
  bl64_dbg_lib_show_function "$@"
  local target="$1"
  local target_os=''
  local target_major=''
  local target_minor=''
  local current_os=''
  local current_major=''
  local current_minor=''

  if [[ "$target" == +([[:alpha:]])-+([[:digit:]]).+([[:digit:]]) ]]; then
    target_os="${target%%-*}"
    target_major="${target##*-}"
    target_minor="${target_major##*\.}"
    target_major="${target_major%%\.*}"
    current_major="${BL64_OS_DISTRO##*-}"
    current_minor="${current_major##*\.}"
    current_major="${current_major%%\.*}"

    bl64_dbg_lib_show_info "Pattern: match OS, Major and Minor [${BL64_OS_DISTRO}] == [${target_os}-${target_major}.${target_minor}]"
    [[ "$BL64_OS_DISTRO" == ${target_os}-+([[:digit:]]).+([[:digit:]]) ]] &&
      ((current_major == target_major && current_minor == target_minor)) ||
      return $BL64_LIB_ERROR_OS_NOT_MATCH

  elif [[ "$target" == +([[:alpha:]])-+([[:digit:]]) ]]; then
    target_os="${target%%-*}"
    target_major="${target##*-}"
    target_major="${target_major%%\.*}"
    current_os="${BL64_OS_DISTRO%%-*}"
    current_major="${BL64_OS_DISTRO##*-}"
    current_major="${current_major%%\.*}"

    bl64_dbg_lib_show_info "Pattern: match OS and Major [${current_os}-${current_major}] == [${target_os}-${target_major}]"
    [[ "$BL64_OS_DISTRO" == ${target_os}-+([[:digit:]]).+([[:digit:]]) ]] &&
      ((current_major == target_major)) ||
      return $BL64_LIB_ERROR_OS_NOT_MATCH

  elif [[ "$target" == +([[:alpha:]]) ]]; then
    target_os="$target"

    bl64_dbg_lib_show_info "Pattern: match OS ID only [${BL64_OS_DISTRO}] == [${target_os}]"
    [[ "$BL64_OS_DISTRO" == ${target_os}-+([[:digit:]]).+([[:digit:]]) ]] || return $BL64_LIB_ERROR_OS_NOT_MATCH

  else
    bl64_msg_show_error "${_BL64_OS_TXT_INVALID_OS_PATTERN} (${target})"
    return $BL64_LIB_ERROR_OS_TAG_INVALID
  fi

  return 0
}

#######################################
# Get normalized OS distro and version from uname
#
# * Warning: bootstrap function
# * Use only for OS that do not have /etc/os-release
# * Normalized data is stored in the global variable BL64_OS_DISTRO
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: os match
#   >0: error or os not recognized
#######################################
function _bl64_os_get_distro_from_uname() {
  bl64_dbg_lib_show_function
  local os_type=''
  local os_version=''
  local cmd_sw_vers='/usr/bin/sw_vers'

  os_type="$(uname)"
  case "$os_type" in
  'Darwin')
    os_version="$("$cmd_sw_vers" -productVersion)"
    BL64_OS_DISTRO="DARWIN-${os_version}"
    ;;
  *)
    BL64_OS_DISTRO="$BL64_OS_UNK"
    bl64_msg_show_error "${_BL64_OS_TXT_OS_NOT_SUPPORTED}. ${_BL64_OS_TXT_CHECK_OS_MATRIX} ($(uname -a))"
    return $BL64_LIB_ERROR_OS_INCOMPATIBLE
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_OS_DISTRO'

  return 0
}

#######################################
# Get normalized OS distro and version from os-release
#
# * Warning: bootstrap function
# * Normalized data is stored in the global variable BL64_OS_DISTRO
# * Version is normalized to the format: OS_ID-V.S
#   * OS_ID: one of the OS standard tags
#   * V: Major version, number
#   * S: Minor version, number
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: os match
#   >0: error or os not recognized
#######################################
function _bl64_os_get_distro_from_os_release() {
  bl64_dbg_lib_show_function

  # shellcheck disable=SC1091
  source '/etc/os-release'
  if [[ -n "${ID:-}" && -n "${VERSION_ID:-}" ]]; then
    BL64_OS_DISTRO="${ID^^}-${VERSION_ID}"
  else
    bl64_msg_show_error "$_BL64_OS_TXT_ERROR_OS_RELEASE"
    return $BL64_LIB_ERROR_TASK_FAILED
  fi

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_ALM}-8.* | ${BL64_OS_ALM}-9.*) : ;;
  ${BL64_OS_ALP}-3.*) BL64_OS_DISTRO="${BL64_OS_ALP}-${VERSION_ID%.*}" ;;
  "${BL64_OS_CNT}-7" | ${BL64_OS_CNT}-7.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-7" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-7.0" ;;
  "${BL64_OS_CNT}-8" | ${BL64_OS_CNT}-8.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-8" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-8.0" ;;
  "${BL64_OS_CNT}-9" | ${BL64_OS_CNT}-9.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-9" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-9.0" ;;
  "${BL64_OS_DEB}-9" | ${BL64_OS_DEB}-9.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-9" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-9.0" ;;
  "${BL64_OS_DEB}-10" | ${BL64_OS_DEB}-10.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-10" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-10.0" ;;
  "${BL64_OS_DEB}-11" | ${BL64_OS_DEB}-11.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-11" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-11.0" ;;
  "${BL64_OS_FD}-33" | ${BL64_OS_FD}-33.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-33" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-33.0" ;;
  "${BL64_OS_FD}-34" | ${BL64_OS_FD}-34.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-34" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-34.0" ;;
  "${BL64_OS_FD}-35" | ${BL64_OS_FD}-35.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-35" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-35.0" ;;
  "${BL64_OS_FD}-36" | ${BL64_OS_FD}-36.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-36" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-36.0" ;;
  "${BL64_OS_FD}-37" | ${BL64_OS_FD}-37.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-37" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-37.0" ;;
  "${BL64_OS_FD}-38" | ${BL64_OS_FD}-38.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-38" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-38.0" ;;
  "${BL64_OS_FD}-39" | ${BL64_OS_FD}-39.*) [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-39" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-39.0" ;;
  ${BL64_OS_OL}-7.* | ${BL64_OS_OL}-8.* | ${BL64_OS_OL}-9.*) : ;;
  ${BL64_OS_RCK}-8.* | ${BL64_OS_RCK}-9.*) : ;;
  ${BL64_OS_RHEL}-8.* | ${BL64_OS_RHEL}-9.*) : ;;
  ${BL64_OS_SLES}-15.*) : ;;
  ${BL64_OS_UB}-18.* | ${BL64_OS_UB}-20.* | ${BL64_OS_UB}-21.* | ${BL64_OS_UB}-22.* | ${BL64_OS_UB}-23.*) : ;;
  ${BL64_OS_ALM}-* | ${BL64_OS_ALP}-* | ${BL64_OS_CNT}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_SLES}-* | ${BL64_OS_UB}-*)
    if ! bl64_lib_mode_compability_is_enabled; then
      bl64_msg_show_error "${_BL64_OS_TXT_OS_VERSION_NOT_SUPPORTED}. ${_BL64_OS_TXT_CHECK_OS_MATRIX} (ID=${ID:-NONE} | VERSION_ID=${VERSION_ID:-NONE})"
      return $BL64_LIB_ERROR_OS_INCOMPATIBLE
    fi
    ;;
  *)
    BL64_OS_DISTRO="$BL64_OS_UNK"
    bl64_msg_show_error "${_BL64_OS_TXT_OS_NOT_KNOWN}. ${_BL64_OS_TXT_CHECK_OS_MATRIX} (ID=${ID:-NONE} | VERSION_ID=${VERSION_ID:-NONE})"
    return $BL64_LIB_ERROR_OS_INCOMPATIBLE
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_OS_DISTRO'

  return 0
}

#######################################
# Compare the current OS version against a list of OS versions
#
# Arguments:
#   $@: each argument is an OS target. The list is any combintation of the formats: "$BL64_OS_<ALIAS>" "${BL64_OS_<ALIAS>}-V" "${BL64_OS_<ALIAS>}-V.S"
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: os match
#   BL64_LIB_ERROR_OS_NOT_MATCH
#   BL64_LIB_ERROR_OS_TAG_INVALID
#######################################
function bl64_os_match() {
  bl64_dbg_lib_show_function "$@"
  local item=''
  local -i status=$BL64_LIB_ERROR_OS_NOT_MATCH

  bl64_check_module 'BL64_OS_MODULE' || return $?

  bl64_dbg_lib_show_info "Look for [BL64_OS_DISTRO=${BL64_OS_DISTRO}] in [OSList=${*}}]"
  # shellcheck disable=SC2086
  for item in "$@"; do
    _bl64_os_match "$item"
    status=$?
    ((status == 0)) && break
  done

  # shellcheck disable=SC2086
  return $status
}

#######################################
# Identify and normalize Linux OS distribution name and version
#
# * Warning: bootstrap function
# * OS name format: OOO-V.V
#   * OOO: OS short name (tag)
#   * V.V: Version (Major, Minor)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function
function _bl64_os_set_distro() {
  bl64_dbg_lib_show_function
  if [[ -r '/etc/os-release' ]]; then
    _bl64_os_get_distro_from_os_release
  else
    _bl64_os_get_distro_from_uname
  fi
}

#######################################
# Determine if locale resources for language are installed in the OS
#
# Arguments:
#   $1: locale name
# Outputs:
#   STDOUT: None
#   STDERR: Validation errors
# Returns:
#   0: resources are installed
#   >0: no resources
#######################################
function bl64_os_lang_is_available() {
  bl64_dbg_lib_show_function "$@"
  local locale="$1"
  local line=''

  bl64_check_module 'BL64_OS_MODULE' &&
    bl64_check_parameter 'locale' &&
    bl64_check_command "$BL64_OS_CMD_LOCALE" ||
    return $?

  bl64_dbg_lib_show_info 'look for the requested locale using the locale command'
  IFS=$'\n'
  for line in $("$BL64_OS_CMD_LOCALE" "$BL64_OS_SET_LOCALE_ALL"); do
    unset IFS
    bl64_dbg_lib_show_info "checking [${line}] == [${locale}]"
    [[ "$line" == "$locale" ]] && return 0
  done

  return 1
}

#######################################
# Check the current OS version is in the supported list
#
# * Target use case is script compatibility. Use in the init part to halt execution if OS is not supported
# * Not recommended for checking individual functions. Instead, use if or case structures to support multiple values based on the OS version
# * The check is done against the provided list
# * This is a wrapper to the bl64_os_match so it can be used as a check function
#
# Arguments:
#   $@: list of OS versions to check against. Format: same as bl64_os_match
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_APP_INCOMPATIBLE
#######################################
function bl64_os_check_version() {
  bl64_dbg_lib_show_function "$@"

  bl64_os_match "$@" && return 0

  bl64_msg_show_error "${_BL64_OS_TXT_TASK_NOT_SUPPORTED} (OS: ${BL64_OS_DISTRO} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_OS_TXT_OS_MATRIX}: ${*}) ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
  return $BL64_LIB_ERROR_APP_INCOMPATIBLE
}

#######################################
# BashLib64 / Module / Setup / Manage role based access service
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_rbac_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  _bl64_rbac_set_command &&
    _bl64_rbac_set_options &&
    _bl64_rbac_set_alias &&
    BL64_RBAC_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'rbac'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rbac_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rbac_set_alias() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  ${BL64_OS_SLES}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rbac_set_options() {
  bl64_dbg_lib_show_function

  BL64_RBAC_SET_SUDO_CHECK='--check'
  BL64_RBAC_SET_SUDO_FILE='--file'
  BL64_RBAC_SET_SUDO_QUIET='--quiet'
}

#######################################
# BashLib64 / Module / Functions / Manage role based access service
#######################################

#######################################
# Add password-less root privilege
#
# Arguments:
#   $1: user name. User must already be present.
# Outputs:
#   STDOUT: None
#   STDERR: execution errors
# Returns:
#   0: rule added
#   >0: failed command exit status
#######################################
function bl64_rbac_add_root() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local new_sudoers="${BL64_RBAC_FILE_SUDOERS}.bl64_new"
  local old_sudoers="${BL64_RBAC_FILE_SUDOERS}.bl64_old"
  local -i status=0

  bl64_check_privilege_root &&
    bl64_check_parameter 'user' &&
    bl64_check_file "$BL64_RBAC_FILE_SUDOERS" &&
    bl64_rbac_check_sudoers "$BL64_RBAC_FILE_SUDOERS" ||
    return $?

  bl64_msg_show_lib_subtask "$_BL64_RBAC_TXT_ADD_ROOT ($user)"
  umask 0266

  if [[ -s "$BL64_RBAC_FILE_SUDOERS" ]]; then
    bl64_dbg_lib_show_info "backup original sudoers (${BL64_RBAC_FILE_SUDOERS} -> ${old_sudoers})"
    bl64_fs_cp_file "${BL64_RBAC_FILE_SUDOERS}" "$old_sudoers"
    status=$?
    ((status != 0)) && bl64_msg_show_error "unable to backup sudoers file (${BL64_RBAC_FILE_SUDOERS})" && return $status

    bl64_dbg_lib_show_info "create new sudoers (${new_sudoers})"
    # shellcheck disable=SC2016
    bl64_txt_run_awk \
      -v ControlUsr="$user" \
      '
        BEGIN { Found = 0 }
        ControlUsr " ALL=(ALL) NOPASSWD: ALL" == $0 { Found = 1 }
        { print $0 }
        END {
          if( Found == 0) {
            print( ControlUsr " ALL=(ALL) NOPASSWD: ALL" )
          }
        }
      ' \
      "$BL64_RBAC_FILE_SUDOERS" >"$new_sudoers"
    status=$?
    ((status != 0)) && bl64_msg_show_error "unable to create new sudoers file (${new_sudoers})" && return $status

    bl64_dbg_lib_show_info "replace original sudoers with new version (${new_sudoers} ->${BL64_RBAC_FILE_SUDOERS})"
    "$BL64_OS_CMD_CAT" "$new_sudoers" >"${BL64_RBAC_FILE_SUDOERS}"
    status=$?
    ((status != 0)) && bl64_msg_show_error "unable to promote new sudoers file (${new_sudoers}->${BL64_RBAC_FILE_SUDOERS})" && return $status
  else
    printf '%s ALL=(ALL) NOPASSWD: ALL\n' "$user" > "$BL64_RBAC_FILE_SUDOERS"
    status=$?
    ((status != 0)) && bl64_msg_show_error "unable to create new sudoers file (${BL64_RBAC_FILE_SUDOERS})" && return $status
  fi

  bl64_rbac_check_sudoers "$BL64_RBAC_FILE_SUDOERS"
  status=$?

  return $status
}

#######################################
# Use visudo --check to validate sudoers file
#
# Arguments:
#   $1: full path to the sudoers file
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: sudoers sintax ok
#   visudo exit status
#######################################
function bl64_rbac_check_sudoers() {
  bl64_dbg_lib_show_function "$@"
  local sudoers="$1"
  local -i status=0
  local debug="$BL64_RBAC_SET_SUDO_QUIET"

  bl64_check_parameter 'sudoers' &&
    bl64_check_command "$BL64_RBAC_CMD_VISUDO" ||
    return $?

  bl64_dbg_lib_command_enabled && debug=' '

  # shellcheck disable=SC2086
  "$BL64_RBAC_CMD_VISUDO" \
    $debug \
    $BL64_RBAC_SET_SUDO_CHECK \
    ${BL64_RBAC_SET_SUDO_FILE}="$sudoers"
  status=$?

  if ((status != 0)); then
    bl64_msg_show_error "$_BL64_RBAC_TXT_INVALID_SUDOERS ($sudoers)"
  fi

  return $status
}

#######################################
# Run privileged OS command using Sudo if needed
#
# Arguments:
#   $1: user to run as. Default: root
#   $@: command and arguments to run
# Outputs:
#   STDOUT: command or sudo output
#   STDERR: command or sudo error
# Returns:
#   command or sudo exit status
#######################################
function bl64_rbac_run_command() {
  bl64_dbg_lib_show_function "$@"
  local user="${1:-${BL64_VAR_NULL}}"
  local target=''

  bl64_check_parameter 'user' &&
    bl64_check_command "$BL64_RBAC_CMD_SUDO" ||
    return $?

  shift
  bl64_check_parameters_none "$#" ||
    return $?
  target="$(bl64_iam_user_get_id "${user}")" || return $?

  if [[ "$UID" == "$target" ]]; then
    bl64_dbg_lib_show_info "run command directly (user: $user)"
    bl64_dbg_lib_trace_start
    "$@"
    bl64_dbg_lib_trace_stop
  else
    bl64_dbg_lib_show_info "run command with sudo (user: $user)"
    bl64_dbg_lib_trace_start
    $BL64_RBAC_ALIAS_SUDO_ENV -u "$user" "$@"
    bl64_dbg_lib_trace_stop
  fi
}

#######################################
# Run privileged Bash function using Sudo if needed
#
# Arguments:
#   $1: library that contains the target function.
#   $2: user to run as. Default: root
#   $@: command and arguments to run
# Outputs:
#   STDOUT: command or sudo output
#   STDERR: command or sudo error
# Returns:
#   command or sudo exit status
#######################################
function bl64_rbac_run_bash_function() {
  bl64_dbg_lib_show_function "$@"
  local library="${1:-${BL64_VAR_NULL}}"
  local user="${2:-${BL64_VAR_NULL}}"
  local target=''

  bl64_check_parameter 'library' &&
    bl64_check_parameter 'user' &&
    bl64_check_file "$library" &&
    bl64_check_command "$BL64_RBAC_CMD_SUDO" ||
    return $?

  shift
  shift
  bl64_check_parameters_none "$#" ||
    return $?

  target="$(bl64_iam_user_get_id "${user}")" || return $?

  if [[ "$UID" == "$target" ]]; then
    # shellcheck disable=SC1090
    . "$library" &&
      "$@"
  else
    bl64_dbg_lib_trace_start
    $BL64_RBAC_ALIAS_SUDO_ENV -u "$user" "$BL64_OS_CMD_BASH" -c ". ${library}; ${*}"
    bl64_dbg_lib_trace_stop
  fi
}

#######################################
# BashLib64 / Module / Setup / Generate random data
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_rnd_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  BL64_RND_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'rnd'
}

#######################################
# BashLib64 / Module / Functions / Generate random data
#######################################

#######################################
# Generate random integer number between min and max
#
# Arguments:
#   $1: Minimum. Default: BL64_RND_RANDOM_MIN
#   $2: Maximum. Default: BL64_RND_RANDOM_MAX
# Outputs:
#   STDOUT: random number
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
function bl64_rnd_get_range() {
  bl64_dbg_lib_show_function "$@"
  local min="${1:-${BL64_RND_RANDOM_MIN}}"
  local max="${2:-${BL64_RND_RANDOM_MAX}}"
  local modulo=0

  # shellcheck disable=SC2086
  ((min < BL64_RND_RANDOM_MIN)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_RANDOM_MIN" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  # shellcheck disable=SC2086
  ((max > BL64_RND_RANDOM_MAX)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_RANDOM_MAX" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  modulo=$((max - min + 1))

  printf '%s' "$((min + (RANDOM % modulo)))"
}

#######################################
# Generate numeric string
#
# Arguments:
#   $1: Length. Default: BL64_RND_LENGTH_1
# Outputs:
#   STDOUT: random string
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
# shellcheck disable=SC2120
function bl64_rnd_get_numeric() {
  bl64_dbg_lib_show_function "$@"
  local -i length=${1:-${BL64_RND_LENGTH_1}}
  local seed=''

  # shellcheck disable=SC2086
  ((length < BL64_RND_LENGTH_1)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_LENGTH_1" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  # shellcheck disable=SC2086
  ((length > BL64_RND_LENGTH_20)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_LENGTH_20" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  seed="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
  printf '%s' "${seed:0:$length}"
}

#######################################
# Generate alphanumeric string
#
# Arguments:
#   $1: Minimum. Default: BL64_RND_RANDOM_MIN
#   $2: Maximum. Default: BL64_RND_RANDOM_MAX
# Outputs:
#   STDOUT: random string
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
function bl64_rnd_get_alphanumeric() {
  bl64_dbg_lib_show_function "$@"
  local -i length=${1:-${BL64_RND_LENGTH_1}}
  local output=''
  local item=''
  local index=0
  local count=0

  ((length < BL64_RND_LENGTH_1)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_LENGTH_1" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  ((length > BL64_RND_LENGTH_100)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_LENGTH_100" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  while ((count < length)); do
    index=$(bl64_rnd_get_range '0' "$BL64_RND_POOL_ALPHANUMERIC_MAX_IDX")
    item="$(printf '%s' "${BL64_RND_POOL_ALPHANUMERIC:$index:1}")"
    output="${output}${item}"
    ((count++))
  done

  printf '%s' "$output"
}

#######################################
# BashLib64 / Module / Setup / Transfer and Receive data over the network
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_rxtx_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_FS_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    bl64_check_module_imported 'BL64_VCS_MODULE' &&
    _bl64_rxtx_set_command &&
    _bl64_rxtx_set_options &&
    _bl64_rxtx_set_alias &&
    BL64_RXTX_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'rxtx'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rxtx_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET='/usr/bin/wget'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET='/usr/bin/wget'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET='/usr/bin/wget'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET='/usr/bin/wget'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET="$BL64_VAR_INCOMPATIBLE"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rxtx_set_options() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_DEB}-9.* | ${BL64_OS_UB}-18.* | ${BL64_OS_DEB}-10.* | ${BL64_OS_DEB}-11.*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS=' '
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_UB}-* | ${BL64_OS_UB}-* | ${BL64_OS_UB}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS='--no-progress-meter'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_FD}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS='--no-progress-meter'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS=' '
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS=' '
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS=' '
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='-O'
    BL64_RXTX_SET_WGET_SECURE=' '
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RXTX_SET_CURL_FAIL='--fail'
    BL64_RXTX_SET_CURL_HEADER='-H'
    BL64_RXTX_SET_CURL_INCLUDE='--include'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_NO_PROGRESS='--no-progress-meter'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_CURL_REQUEST='-X'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT=' '
    BL64_RXTX_SET_WGET_SECURE=' '
    BL64_RXTX_SET_WGET_VERBOSE=' '
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_rxtx_set_alias() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
    BL64_RXTX_ALIAS_WGET="$BL64_RXTX_CMD_WGET ${BL64_RXTX_SET_WGET_SECURE}"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
    BL64_RXTX_ALIAS_WGET="$BL64_RXTX_CMD_WGET ${BL64_RXTX_SET_WGET_SECURE}"
    ;;
  ${BL64_OS_SLES}-*)
    BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
    BL64_RXTX_ALIAS_WGET="$BL64_RXTX_CMD_WGET ${BL64_RXTX_SET_WGET_SECURE}"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
    BL64_RXTX_ALIAS_WGET="$BL64_RXTX_CMD_WGET ${BL64_RXTX_SET_WGET_SECURE}"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
    BL64_RXTX_ALIAS_WGET=''
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# BashLib64 / Module / Functions / Transfer and Receive data over the network
#######################################

#######################################
# Pull data from web server
#
# * If the destination is already present no update is done unless $3=$BL64_VAR_ON
#
# Arguments:
#   $1: Source URL
#   $2: Full path to the destination file
#   $3: replace existing content Values: $BL64_VAR_ON | $BL64_VAR_OFF (default)
#   $4: permissions. Regular chown format accepted. Default: umask defined
# Outputs:
#   STDOUT: None unless BL64_DBG_TARGET_LIB_CMD
#   STDERR: command error
# Returns:
#   BL64_LIB_ERROR_APP_MISSING
#   command error status
#######################################
function bl64_rxtx_web_get_file() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"
  local replace="${3:-${BL64_VAR_DEFAULT}}"
  local mode="${4:-${BL64_VAR_DEFAULT}}"
  local -i status=0

  bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_fs_check_new_file "$destination" ||
    return $?

  bl64_check_overwrite_skip "$destination" "$replace" && return

  bl64_fs_safeguard "$destination" >/dev/null || return $?

  bl64_msg_show_lib_subtask "$_BL64_RXTX_TXT_DOWNLOAD_FILE ($source)"
  # shellcheck disable=SC2086
  if [[ -x "$BL64_RXTX_CMD_CURL" ]]; then
    bl64_rxtx_run_curl \
      $BL64_RXTX_SET_CURL_FAIL \
      $BL64_RXTX_SET_CURL_REDIRECT \
      $BL64_RXTX_SET_CURL_OUTPUT "$destination" \
      "$source"
    status=$?
  elif [[ -x "$BL64_RXTX_CMD_WGET" ]]; then
    bl64_rxtx_run_wget \
      $BL64_RXTX_SET_WGET_OUTPUT "$destination" \
      "$source"
    status=$?
  else
    bl64_msg_show_error "$_BL64_RXTX_TXT_MISSING_COMMAND (wget or curl)" &&
      return $BL64_LIB_ERROR_APP_MISSING
  fi
  (( status != 0 )) && bl64_msg_show_error "$_BL64_RXTX_TXT_ERROR_DOWNLOAD_FILE"

  bl64_dbg_lib_show_comments 'Determine if asked to set mode'
  if [[ "$status" == '0' && "$mode" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_fs_run_chmod "$mode" "$destination"
    status=$?
  fi

  bl64_fs_restore "$destination" "$status" || return $?

  return $status
}

#######################################
# Pull directory contents from git repo
#
# * Content of source path is downloaded into destination (source_path/* --> destionation/). Source path itself is not created
# * If the destination is already present no update is done unless $4=$BL64_VAR_ON
# * If asked to replace destination, temporary backup is done in case git fails by moving the destination to a temp name
# * Warning: git repo info is removed after pull (.git)
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: source path. Format: relative to the repo URL. Use '.' to download the full repo
#   $3: destination path. Format: full path
#   $4: replace existing content. Values: $BL64_VAR_ON | $BL64_VAR_OFF (default)
#   $5: branch name. Default: main
# Outputs:
#   STDOUT: command stdout
#   STDERR: command error
# Returns:
#   0: operation OK
#   BL64_LIB_ERROR_TASK_TEMP
#   command error status
#######################################
function bl64_rxtx_git_get_dir() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local source_path="${2}"
  local destination="${3}"
  local replace="${4:-${BL64_VAR_DEFAULT}}"
  local branch="${5:-main}"
  local -i status=0

  bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_parameter 'source_url' &&
    bl64_check_parameter 'source_path' &&
    bl64_check_parameter 'destination' &&
    bl64_check_path_relative "$source_path" &&
    bl64_fs_check_new_dir "$destination" ||
    return $?

  # shellcheck disable=SC2086
  bl64_check_overwrite_skip "$destination" "$replace" && return $?
  bl64_fs_safeguard "$destination" || return $?

  if [[ "$source_path" == '.' || "$source_path" == './' ]]; then
    _bl64_rxtx_git_get_dir_root "$source_url" "$destination" "$branch"
  else
    _bl64_rxtx_git_get_dir_sub "$source_url" "$source_path" "$destination" "$branch"
  fi
  status=$?
  (( status != 0 )) && bl64_msg_show_error "$_BL64_RXTX_TXT_ERROR_DOWNLOAD_DIR"

  if [[ "$status" == '0' && -d "${destination}/.git" ]]; then
    bl64_dbg_lib_show_info "remove git metadata (${destination}/.git)"
    # shellcheck disable=SC2164
    cd "$destination"
    bl64_fs_rm_full '.git' >/dev/null
  fi

  bl64_fs_restore "$destination" "$status" || return $?
  return $status
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * verbose is not implemented to avoid unintentional alteration of output when using for APIs
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_rxtx_run_curl() {
  bl64_dbg_lib_show_function "$@"
  local debug="$BL64_RXTX_SET_CURL_SILENT"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_command "$BL64_RXTX_CMD_CURL" || return $?

  bl64_msg_lib_verbose_enabled && debug=''
  bl64_dbg_lib_command_enabled && debug="$BL64_RXTX_SET_CURL_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_RXTX_CMD_CURL" \
    $BL64_RXTX_SET_CURL_SECURE \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_rxtx_run_wget() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_command "$BL64_RXTX_CMD_WGET" || return $?

  bl64_dbg_lib_command_enabled && verbose="$BL64_RXTX_SET_WGET_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_RXTX_CMD_WGET" \
    $verbose \
    "$@"
  bl64_dbg_lib_trace_stop
}

function _bl64_rxtx_git_get_dir_root() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local destination="${2}"
  local branch="${3:-main}"
  local -i status=0
  local repo=''
  local git_name=''
  local transition=''

  bl64_check_module 'BL64_RXTX_MODULE' || return $?

  repo="$($BL64_FS_ALIAS_MKTEMP_DIR)"
  bl64_check_directory "$repo" "$_BL64_RXTX_TXT_CREATION_PROBLEM" || return $BL64_LIB_ERROR_TASK_TEMP

  git_name="$(bl64_fmt_basename "$source_url")"
  git_name="${git_name/.git/}"
  transition="${repo}/${git_name}"
  bl64_dbg_lib_show_vars 'git_name' 'transition'

  bl64_dbg_lib_show_comments 'Clone the repo'
  bl64_vcs_git_clone "$source_url" "$repo" "$branch" &&
    bl64_dbg_lib_show_info 'promote to destination' &&
    bl64_fs_run_mv "$transition" "$destination"
  status=$?

  [[ -d "$repo" ]] && bl64_fs_rm_full "$repo" >/dev/null
  return $status
}

function _bl64_rxtx_git_get_dir_sub() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local source_path="${2}"
  local destination="${3}"
  local branch="${4:-main}"
  local -i status=0
  local repo=''
  local target=''
  local source=''
  local transition=''

  bl64_check_module 'BL64_RXTX_MODULE' || return $?

  repo="$($BL64_FS_ALIAS_MKTEMP_DIR)"
  # shellcheck disable=SC2086
  bl64_check_directory "$repo" "$_BL64_RXTX_TXT_CREATION_PROBLEM" || return $BL64_LIB_ERROR_TASK_TEMP

  bl64_dbg_lib_show_comments 'Use transition path to get to the final target path'
  source="${repo}/${source_path}"
  target="$(bl64_fmt_basename "$destination")"
  transition="${repo}/transition/${target}"
  bl64_dbg_lib_show_vars 'source' 'target' 'transition'

  bl64_vcs_git_sparse "$source_url" "$repo" "$branch" "$source_path" &&
    [[ -d "$source" ]] &&
    bl64_fs_mkdir_full "${repo}/transition" &&
    bl64_fs_run_mv "$source" "$transition" >/dev/null &&
    bl64_fs_run_mv "${transition}" "$destination" >/dev/null
  status=$?

  [[ -d "$repo" ]] && bl64_fs_rm_full "$repo" >/dev/null
  return $status
}

#######################################
# Download file asset from release in github repository
#
# Arguments:
#   $1: repo owner
#   $2: repo name
#   $3: release tag. Use $BL64_VCS_GITHUB_LATEST (latest) to obtain latest version
#   $4: asset name: file name available in the target release
#   $5: destination
#   $6: replace existing content Values: $BL64_VAR_ON | $BL64_VAR_OFF (default)
#   $7: permissions. Regular chown format accepted. Default: umask defined
# Outputs:
#   STDOUT: none
#   STDERR: task error
# Returns:
#   0: success
#   >0: error
#######################################
function bl64_rxtx_github_get_asset() {
  bl64_dbg_lib_show_function "$@"
  local repo_owner="$1"
  local repo_name="$2"
  local release_tag="$3"
  local asset_name="$4"
  local destination="$5"
  local replace="${6:-${BL64_VAR_OFF}}"
  local mode="${7:-${BL64_VAR_DEFAULT}}"

  bl64_check_module 'BL64_RXTX_MODULE' &&
    bl64_check_parameter 'repo_owner' &&
    bl64_check_parameter 'repo_name' &&
    bl64_check_parameter 'release_tag' &&
    bl64_check_parameter 'asset_name' &&
    bl64_check_parameter 'destination' ||
    return $?

  if [[ "$release_tag" == "$BL64_VCS_GITHUB_LATEST" ]]; then
    release_tag="$(bl64_vcs_github_release_get_latest "$repo_owner" "$repo_name")" ||
      return $?
  fi

  bl64_rxtx_web_get_file \
    "${BL64_RXTX_GITHUB_URL}/${repo_owner}/${repo_name}/releases/download/${release_tag}/${asset_name}" \
    "$destination" "$replace" "$mode"
}

#######################################
# BashLib64 / Module / Setup / Manage date-time data
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_tm_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  BL64_TM_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'tm'
}

#######################################
# BashLib64 / Module / Functions / Manage date-time data
#######################################

#######################################
# Get current date-time in timestamp format
#
# * Format: DDMMYYHHMMSS
#
# Arguments:
#   None
# Outputs:
#   STDOUT: formated string
#   STDERR: command Error message
# Returns:
#   date exit status
#######################################
function bl64_tm_create_timestamp() {
  "$BL64_OS_CMD_DATE" '+%d%m%Y%H%M%S'
}

#######################################
# Get current date-time in file timestamp format
#
# * Format: DD:MM:YYYY-HH:MM:SS-TZ
#
# Arguments:
#   None
# Outputs:
#   STDOUT: formated string
#   STDERR: command Error message
# Returns:
#   date exit status
#######################################
function bl64_tm_create_timestamp_file() {
  "$BL64_OS_CMD_DATE" '+%d:%m:%Y-%H:%M:%S-UTC%z'
}

#######################################
# BashLib64 / Module / Setup / Manipulate text files content
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_txt_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    _bl64_txt_set_command &&
    _bl64_txt_set_options &&
    BL64_TXT_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'txt'
}

#######################################
# Identify and normalize common *nix OS commands
#
# * Commands are exported as variables with full path
# * For AWK the function will determine the best option to match posix awk
# * Warning: bootstrap function
# * AWS: provide legacy AWS, posix AWS and modern AWS when available
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function
function _bl64_txt_set_command() {
  bl64_dbg_lib_show_function

  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_TXT_CMD_AWK='/usr/bin/awk'
    BL64_TXT_CMD_BASE64='/usr/bin/base64'
    BL64_TXT_CMD_CUT='/usr/bin/cut'
    BL64_TXT_CMD_ENVSUBST='/usr/bin/envsubst'
    BL64_TXT_CMD_GAWK='/usr/bin/gawk'
    BL64_TXT_CMD_GREP='/bin/grep'
    BL64_TXT_CMD_SED='/bin/sed'
    BL64_TXT_CMD_SORT='/usr/bin/sort'
    BL64_TXT_CMD_TR='/usr/bin/tr'
    BL64_TXT_CMD_UNIQ='/usr/bin/uniq'

    if [[ -x '/usr/bin/gawk' ]]; then
      BL64_TXT_CMD_AWK_POSIX='/usr/bin/gawk'
    elif [[ -x '/usr/bin/mawk' ]]; then
      BL64_TXT_CMD_AWK_POSIX='/usr/bin/mawk'
    fi
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_TXT_CMD_AWK='/usr/bin/awk'
    BL64_TXT_CMD_AWK_POSIX='/usr/bin/gawk'
    BL64_TXT_CMD_BASE64='/usr/bin/base64'
    BL64_TXT_CMD_CUT='/usr/bin/cut'
    BL64_TXT_CMD_ENVSUBST='/usr/bin/envsubst'
    BL64_TXT_CMD_GAWK='/usr/bin/gawk'
    BL64_TXT_CMD_GREP='/usr/bin/grep'
    BL64_TXT_CMD_SED='/usr/bin/sed'
    BL64_TXT_CMD_SORT='/usr/bin/sort'
    BL64_TXT_CMD_TR='/usr/bin/tr'
    BL64_TXT_CMD_UNIQ='/usr/bin/uniq'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_TXT_CMD_AWK='/usr/bin/gawk'
    BL64_TXT_CMD_AWK_POSIX='/usr/bin/gawk'
    BL64_TXT_CMD_BASE64='/usr/bin/base64'
    BL64_TXT_CMD_CUT='/usr/bin/cut'
    BL64_TXT_CMD_ENVSUBST='/usr/bin/envsubst'
    BL64_TXT_CMD_GAWK='/usr/bin/gawk'
    BL64_TXT_CMD_GREP='/usr/bin/grep'
    BL64_TXT_CMD_SED='/usr/bin/sed'
    BL64_TXT_CMD_SORT='/usr/bin/sort'
    BL64_TXT_CMD_TR='/usr/bin/tr'
    BL64_TXT_CMD_UNIQ='/usr/bin/uniq'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_TXT_CMD_AWK='/usr/bin/awk'
    BL64_TXT_CMD_BASE64='/bin/base64'
    BL64_TXT_CMD_CUT='/usr/bin/cut'
    BL64_TXT_CMD_ENVSUBST='/usr/bin/envsubst'
    BL64_TXT_CMD_GAWK='/usr/bin/gawk'
    BL64_TXT_CMD_GREP='/bin/grep'
    BL64_TXT_CMD_SED='/bin/sed'
    BL64_TXT_CMD_SORT='/usr/bin/sort'
    BL64_TXT_CMD_TR='/usr/bin/tr'
    BL64_TXT_CMD_UNIQ='/usr/bin/uniq'

    if [[ -x '/usr/bin/gawk' ]]; then
      BL64_TXT_CMD_AWK_POSIX='/usr/bin/gawk'
    fi
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_TXT_CMD_AWK='/usr/bin/awk'
    BL64_TXT_CMD_AWK_POSIX='/usr/bin/awk'
    BL64_TXT_CMD_BASE64='/usr/bin/base64'
    BL64_TXT_CMD_CUT='/usr/bin/cut'
    BL64_TXT_CMD_ENVSUBST='/opt/homebrew/bin/envsubst'
    BL64_TXT_CMD_GAWK="$BL64_VAR_INCOMPATIBLE"
    BL64_TXT_CMD_GREP='/usr/bin/grep'
    BL64_TXT_CMD_SED='/usr/bin/sed'
    BL64_TXT_CMD_SORT='/usr/bin/sort'
    BL64_TXT_CMD_TR='/usr/bin/tr'
    BL64_TXT_CMD_UNIQ='/usr/bin/uniq'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_txt_set_options() {
  bl64_dbg_lib_show_function

  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_TXT_SET_AWS_FS='-F'
    BL64_TXT_SET_GREP_ERE='-E'
    BL64_TXT_SET_GREP_INVERT='-v'
    BL64_TXT_SET_GREP_NO_CASE='-i'
    BL64_TXT_SET_GREP_QUIET='--quiet'
    BL64_TXT_SET_GREP_SHOW_FILE_ONLY='-l'
    BL64_TXT_SET_GREP_STDIN='-'
    BL64_TXT_SET_SED_EXPRESSION='-e'

    if [[ -x '/usr/bin/gawk' ]]; then
      BL64_TXT_SET_AWK_POSIX='--posix'
    fi
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_TXT_SET_AWK_POSIX='--posix'
    BL64_TXT_SET_AWS_FS='-F'
    BL64_TXT_SET_GREP_ERE='-E'
    BL64_TXT_SET_GREP_INVERT='-v'
    BL64_TXT_SET_GREP_NO_CASE='-i'
    BL64_TXT_SET_GREP_QUIET='--quiet'
    BL64_TXT_SET_GREP_SHOW_FILE_ONLY='-l'
    BL64_TXT_SET_GREP_STDIN='-'
    BL64_TXT_SET_SED_EXPRESSION='-e'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_TXT_SET_AWK_POSIX='--posix'
    BL64_TXT_SET_AWS_FS='-F'
    BL64_TXT_SET_GREP_ERE='-E'
    BL64_TXT_SET_GREP_INVERT='-v'
    BL64_TXT_SET_GREP_NO_CASE='-i'
    BL64_TXT_SET_GREP_QUIET='-q'
    BL64_TXT_SET_GREP_SHOW_FILE_ONLY='-l'
    BL64_TXT_SET_GREP_STDIN='-'
    BL64_TXT_SET_SED_EXPRESSION='-e'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_TXT_SET_AWK_POSIX=''
    BL64_TXT_SET_AWS_FS='-F'
    BL64_TXT_SET_GREP_ERE='-E'
    BL64_TXT_SET_GREP_INVERT='-v'
    BL64_TXT_SET_GREP_NO_CASE='-i'
    BL64_TXT_SET_GREP_QUIET='-q'
    BL64_TXT_SET_GREP_SHOW_FILE_ONLY='-l'
    BL64_TXT_SET_GREP_STDIN='-'
    BL64_TXT_SET_SED_EXPRESSION='-e'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_TXT_SET_AWK_POSIX=''
    BL64_TXT_SET_AWS_FS='-F'
    BL64_TXT_SET_GREP_ERE='-E'
    BL64_TXT_SET_GREP_INVERT='-v'
    BL64_TXT_SET_GREP_NO_CASE='-i'
    BL64_TXT_SET_GREP_QUIET='-q'
    BL64_TXT_SET_GREP_SHOW_FILE_ONLY='-l'
    BL64_TXT_SET_GREP_STDIN='-'
    BL64_TXT_SET_SED_EXPRESSION='-e'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac

}

#######################################
# BashLib64 / Module / Functions / Manipulate text files content
#######################################

#######################################
# Removes comments from text input using the external tool Grep
#
# * Comment delimiter: #
# * All text to the right of the delimiter is removed
#
# Arguments:
#   $1: Full path to the text file. Use $BL64_TXT_FLAG_STDIN for stdin. Default: STDIN
# Outputs:
#   STDOUT: Original text with comments removed
#   STDERR: grep Error message
# Returns:
#   0: successfull execution
#   >0: grep command exit status
#######################################
function bl64_txt_strip_comments() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-${BL64_TXT_FLAG_STDIN}}"

  [[ "$source" == "$BL64_TXT_FLAG_STDIN" ]] && source="$BL64_TXT_SET_GREP_STDIN"

  bl64_txt_run_egrep "$BL64_TXT_SET_GREP_INVERT" '^#.*$|^ *#.*$' "$source"
}

#######################################
# Read a text file, replace shell variable names with its value and show the result on stdout
#
# * Uses envsubst
# * Variables in the source file must follow the syntax: $VARIABLE or ${VARIABLE}
#
# Arguments:
#   $1: source file path
# Outputs:
#   STDOUT: source modified with replaced variables
#   STDERR: command stderr
# Returns:
#   0: replacement ok
#   >0: status from last failed command
#######################################
function bl64_txt_replace_env() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-}"

  bl64_check_parameter 'source' &&
    bl64_check_file "$source" ||
    return $?

  bl64_txt_run_envsubst <"$source"
}

#######################################
# Search for a whole line in a given text file or stdin
#
# Arguments:
#   $1: source file path. Use $BL64_TXT_FLAG_STDIN for stdin. Default: STDIN
#   $2: text to look for. Default: empty line
# Outputs:
#   STDOUT: none
#   STDERR: Error messages
# Returns:
#   0: line was found
#   >0: grep command exit status
#######################################
function bl64_txt_search_line() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-${BL64_TXT_FLAG_STDIN}}"
  local line="${2:-}"

  [[ "$source" == "$BL64_TXT_FLAG_STDIN" ]] && source="$BL64_TXT_SET_GREP_STDIN"
  bl64_txt_run_egrep "$BL64_TXT_SET_GREP_QUIET" "^${line}$" "$source"
}

#######################################
# OS command wrapper: awk
#
# * Detects OS provided awk and selects the best match
# * The selected awk app is configured for POSIX compatibility and traditional regexp
# * If gawk is required use the BL64_TXT_CMD_GAWK variable instead of this function
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_awk() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" ||
    return $?

  bl64_check_command "$BL64_TXT_CMD_AWK_POSIX" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_TXT_CMD_AWK_POSIX" $BL64_TXT_SET_AWK_POSIX "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
# shellcheck disable=SC2120
function bl64_txt_run_envsubst() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_ENVSUBST" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_ENVSUBST" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_grep() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_GREP" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_GREP" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Run grep with regular expression matching
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_egrep() {
  bl64_dbg_lib_show_function "$@"

  bl64_txt_run_grep "$BL64_TXT_SET_GREP_ERE" "$@"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
# * Warning: sed regexp is not consistent across versions and vendors. Caller is responsible for testing to ensure compatibility
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_sed() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_SED" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_SED" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_base64() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_BASE64" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_BASE64" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_tr() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_TR" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_TR" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_cut() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_CUT" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_CUT" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_uniq() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_UNIQ" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_UNIQ" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_txt_run_sort() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TXT_MODULE' &&
    bl64_check_command "$BL64_TXT_CMD_SORT" ||
    return $?

  bl64_dbg_lib_trace_start
  "$BL64_TXT_CMD_SORT" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# BashLib64 / Module / Setup / User Interface
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_ui_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  BL64_UI_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'ui'
}

#######################################
# BashLib64 / Module / Functions / User Interface
#######################################

#######################################
# Ask for confirmation
#
# * Use to confirm dangerous operations
#
# Arguments:
#   $1: confirmation question
#   $2: confirmation value that needs to be match
# Outputs:
#   STDOUT: user interaction
#   STDERR: command stderr
# Returns:
#   0: confirmed
#   >0: not confirmed
#######################################
function bl64_ui_ask_confirmation() {
  bl64_dbg_lib_show_function "$@"
  local question="${1:-${_BL64_UI_TXT_CONFIRMATION_QUESTION}}"
  local confirmation="${2:-${_BL64_UI_TXT_CONFIRMATION_MESSAGE}}"
  local input=''

  bl64_msg_show_input "${question} [${confirmation}]: "
  read -r -t "$BL64_UI_READ_TIMEOUT" input

  if [[ "$input" != "$confirmation" ]]; then
    bl64_msg_show_error "$_BL64_UI_TXT_CONFIRMATION_ERROR"
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  fi

  return 0
}

#######################################
# BashLib64 / Module / Setup / Manage Version Control System
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_vcs_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  _bl64_vcs_set_command &&
    _bl64_vcs_set_options &&
    BL64_VCS_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'vcs'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_vcs_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_vcs_set_options() {
  bl64_dbg_lib_show_function
  # Common sets - unversioned
  BL64_VCS_SET_GIT_NO_PAGER='--no-pager'
  BL64_VCS_SET_GIT_QUIET=' '
}

#######################################
# BashLib64 / Module / Functions / Manage Version Control System
#######################################

#######################################
# GIT CLI wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_vcs_run_git() {
  bl64_dbg_lib_show_function "$@"
  local debug="$BL64_VCS_SET_GIT_QUIET"

  bl64_check_module 'BL64_VCS_MODULE' &&
    bl64_check_parameters_none "$#" &&
    bl64_check_command "$BL64_VCS_CMD_GIT" || return $?

  bl64_vcs_blank_git

  bl64_dbg_lib_show_info "current path: $(pwd)"
  if bl64_dbg_lib_command_enabled; then
    debug=''
    export GIT_TRACE='2'
  else
    export GIT_TRACE='0'
  fi

  export GIT_CONFIG_NOSYSTEM='0'
  export GIT_AUTHOR_EMAIL='nouser@nodomain'
  export GIT_AUTHOR_NAME='bl64_vcs_run_git'

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_VCS_CMD_GIT" \
    $debug \
    $BL64_VCS_SET_GIT_NO_PAGER \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_vcs_blank_git() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited GIT_* shell variables'
  bl64_dbg_lib_trace_start
  unset GIT_TRACE
  unset GIT_CONFIG_NOSYSTEM
  unset GIT_AUTHOR_EMAIL
  unset GIT_AUTHOR_NAME
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# Clone GIT branch
#
# * File ownership is set to the current user
# * Destination is created if not existing
# * Single branch
# * Depth = 1
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: destination path where the repository will be created
#   $3: branch name. Default: main
# Outputs:
#   STDOUT: git output
#   STDERR: git stderr
# Returns:
#   n: git exit status
#######################################
function bl64_vcs_git_clone() {
  bl64_dbg_lib_show_function "$@"
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_command "$BL64_VCS_CMD_GIT" ||
    return $?

  bl64_fs_create_dir "${BL64_VAR_DEFAULT}" "${BL64_VAR_DEFAULT}" "${BL64_VAR_DEFAULT}" "$destination" || return $?

  bl64_msg_show_lib_subtask "$_BL64_VCS_TXT_CLONE_REPO ($source)"

  # shellcheck disable=SC2164
  cd "$destination"

  # shellcheck disable=SC2086
  bl64_vcs_run_git \
    clone \
    --depth 1 \
    --single-branch \
    --branch "$branch" \
    "$source"
}

#######################################
# Clone partial GIT repository (sparse checkout)
#
# * File ownership is set to the current user
# * Destination is created if not existing
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: destination path where the repository will be created
#   $3: branch name. Default: main
#   $4: include pattern list. Field separator: space
# Outputs:
#   STDOUT: git output
#   STDERR: git stderr
# Returns:
#   n: git exit status
#######################################
function bl64_vcs_git_sparse() {
  bl64_dbg_lib_show_function "$@"
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"
  local pattern="${4}"
  local item=''
  local -i status=0

  bl64_check_command "$BL64_VCS_CMD_GIT" &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_parameter 'pattern' || return $?

  bl64_fs_create_dir "${BL64_VAR_DEFAULT}" "${BL64_VAR_DEFAULT}" "${BL64_VAR_DEFAULT}" "$destination" || returnn $?

  # shellcheck disable=SC2164
  cd "$destination"

  bl64_dbg_lib_show_info 'detect if current git supports sparse-checkout option'
  if bl64_os_match "${BL64_OS_DEB}-9" "${BL64_OS_DEB}-10" "${BL64_OS_UB}-18" "${BL64_OS_UB}-20" "${BL64_OS_OL}-7" "${BL64_OS_CNT}-7"; then
    bl64_dbg_lib_show_info 'git sparse-checkout not supported. Using alternative method'
    # shellcheck disable=SC2086
    bl64_vcs_run_git init &&
      bl64_vcs_run_git remote add origin "$source" &&
      bl64_vcs_run_git config core.sparseCheckout true &&
      {
        IFS=' '
        for item in $pattern; do echo "$item" >>'.git/info/sparse-checkout'; done
        unset IFS
      } &&
      bl64_vcs_run_git pull --depth 1 origin "$branch"
  else
    bl64_dbg_lib_show_info 'git sparse-checkout is supported'
    # shellcheck disable=SC2086
    bl64_vcs_run_git init &&
      bl64_vcs_run_git sparse-checkout set &&
      {
        IFS=' '
        for item in $pattern; do echo "$item"; done | bl64_vcs_run_git sparse-checkout add --stdin
      } &&
      bl64_vcs_run_git remote add origin "$source" &&
      bl64_vcs_run_git pull --depth 1 origin "$branch"
  fi
  status=$?

  return $status
}

#######################################
# GitHub / Call API
#
# * Call GitHub APIs
# * API calls are executed using Curl wrapper
#
# Arguments:
#   $1: API path. Format: Full path (/X/Y/Z)
#   $2: RESTful method. Format: $BL64_API_METHOD_*. Default: $BL64_API_METHOD_GET
#   $3: API query to be appended to the API path. Format: url encoded string. Default: none
#   $4: API Token. Default: none
#   $5: API Version. Default: $BL64_VCS_GITHUB_API_VERSION
#   $@: additional arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: API call executed. Warning: curl exit status only, not the HTTP status code
#   >: unable to execute API call
#######################################
function bl64_vcs_github_run_api() {
  bl64_dbg_lib_show_function "$@"
  local api_path="$1"
  local api_method="${2:-${BL64_API_METHOD_GET}}"
  local api_query="${3:-${BL64_VAR_NULL}}"
  local api_token="${4:-${BL64_VAR_NULL}}"
  local api_version="${5:-${BL64_VCS_GITHUB_API_VERSION}}"

  bl64_check_parameter 'api_path' ||
    return $?

  [[ "$api_token" == "$BL64_VAR_NULL" ]] && api_token=''
  shift
  shift
  shift
  shift
  shift

  # shellcheck disable=SC2086
  bl64_api_call \
    "$BL64_VCS_GITHUB_API_URL" \
    "$api_path" \
    "$api_method" \
    "$api_query" \
    $BL64_RXTX_SET_CURL_HEADER 'Accept: application/vnd.github+json' \
    $BL64_RXTX_SET_CURL_HEADER "X-GitHub-Api-Version: ${api_version}" \
    ${api_token:+${BL64_RXTX_SET_CURL_HEADER} "Authorization: Bearer ${api_token}"} \
    "$@"
}

#######################################
# GitHub / Get release number from latest release
#
# * Uses GitHub API
# * Assumes repo uses standard github release process which binds the latest release to a tag name representing the last version
# * Looks for pattern in json output: "tag_name": "xxxxx"
#
# Arguments:
#   $1: repo owner
#   $2: repo name
# Outputs:
#   STDOUT: release tag
#   STDERR: api error
# Returns:
#   0: api call success
#   >0: api call error
#######################################
function bl64_vcs_github_release_get_latest() {
  bl64_dbg_lib_show_function "$@"
  local repo_owner="$1"
  local repo_name="$2"
  local repo_tag=''

  bl64_check_module 'BL64_VCS_MODULE' &&
    bl64_check_parameter 'repo_owner' &&
    bl64_check_parameter 'repo_name' ||
    return $?

  repo_tag="$(_bl64_vcs_github_release_get_latest "$repo_owner" "$repo_name")"

  if [[ -n "$repo_tag" ]]; then
    echo "$repo_tag"
  else
    bl64_msg_show_error "$_BL64_VCS_TXT_GET_LATEST_RELEASE_FAILED (${repo_owner}/${repo_name})"
    return $BL64_LIB_ERROR_TASK_FAILED
  fi
}

function _bl64_vcs_github_release_get_latest() {
  bl64_dbg_lib_show_function "$@"
  local repo_owner="$1"
  local repo_name="$2"
  local repo_api_query="/repos/${repo_owner}/${repo_name}/releases/latest"

  # shellcheck disable=SC2086
  bl64_vcs_github_run_api "$repo_api_query" |
    bl64_txt_run_awk \
      ${BL64_TXT_SET_AWS_FS} ':' \
      '/"tag_name": "/ {
        gsub(/[ ",]/,"", $2); print $2
      }'
}

#######################################
# BashLib64 / Module / Setup / Manipulate CSV like text files
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_xsv_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  BL64_XSV_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'xsv'
}

#######################################
# BashLib64 / Module / Functions / Manipulate CSV like text files
#######################################

#######################################
# Dump file to STDOUT without comments and spaces
#
# Arguments:
#   $1: Full path to the file
# Outputs:
#   STDOUT: file content
#   STDERR: Error messages
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_FILE_*
#######################################
function bl64_xsv_dump() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_check_parameter 'source' &&
    bl64_check_file "$source" "$_BL64_XSV_TXT_SOURCE_NOT_FOUND" || return $?

  bl64_txt_run_egrep "$BL64_TXT_SET_GREP_INVERT" '^#.*$|^$' "$source"

}

#######################################
# Search for records based on key filters and return matching rows
#
# * Column numbers are AWK fields. First column: 1
#
# Arguments:
#   $1: Single string with one ore more search values separated by $BL64_XSV_FS
#   $2: source file path. Default: STDIN
#   $3: one ore more column numbers (keys) where values will be searched. Format: single string using $BL64_XSV_COLON as field separator
#   $4: one or more fields to show on record match. Format: single string using $BL64_XSV_COLON as field separator
#   $5: field separator for the source file. Default: $BL64_XSV_COLON
#   $6: field separator for the output record. Default: $BL64_XSV_COLON
# Outputs:
#   STDOUT: matching records
#   STDERR: Error messages
# Returns:
#   0: successfull execution
#   >0: awk command exit status
#######################################
function bl64_xsv_search_records() {
  bl64_dbg_lib_show_function "$@"
  local values="$1"
  local source="${2:--}"
  local keys="${3:-1}"
  local fields="${4:-0}"
  local fs_src="${5:-$BL64_XSV_FS_COLON}"
  local fs_out="${6:-$BL64_XSV_FS_COLON}"

  # shellcheck disable=SC2086
  bl64_check_parameter 'values' 'search value' || return $?

  # shellcheck disable=SC2016
  bl64_txt_run_awk \
    -F "$fs_src" \
    -v VALUES="${values}" \
    -v KEYS="$keys" \
    -v FIELDS="$fields" \
    -v FS_OUT="$fs_out" \
    '
      BEGIN {
        show_total = split( FIELDS, show_fields, ENVIRON["BL64_XSV_FS_COLON"] )
        keys_total = split( KEYS, keys_fields, ENVIRON["BL64_XSV_FS_COLON"] )
        values_total = split( VALUES, values_fields, ENVIRON["BL64_XSV_FS"] )
        if( keys_total != values_total ) {
          exit ENVIRON["BL64_LIB_ERROR_PARAMETER_INVALID"]
        }
        row_match = ""
        count = 0
        found = 0
      }
      /^#/ || /^$/ { next }
      {
        found = 0
        for( count = 1; count <= keys_total; count++ ) {
          if ( $keys_fields[count] == values_fields[count] ) {
            found = 1
          } else {
            found = 0
            break
          }
        }

        if( found == 1 ) {
          row_match = $show_fields[1]
          for( count = 2; count <= show_total; count++ ) {
            row_match = row_match FS_OUT $show_fields[count]
          }
          print row_match
        }
      }
      END {}
    ' \
    "$source"

}

#######################################
# BashLib64 / Module / Setup / Write messages to logs
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: log repository. Full path
#   $2: log target. Default: BL64_SCRIPT_ID
#   $2: level. One of BL64_LOG_CATEGORY_*
#   $3: format. One of BL64_LOG_FORMAT_*
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function bl64_log_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local repository="${1:-}"
  local target="${2:-${BL64_SCRIPT_ID}}"
  local level="${3:-${BL64_LOG_CATEGORY_NONE}}"
  local format="${4:-${BL64_LOG_FORMAT_CSV}}"

  [[ -z "$repository" ]] && return $BL64_LIB_ERROR_PARAMETER_MISSING

  bl64_log_set_repository "$repository" &&
    bl64_log_set_target "$target" &&
    bl64_log_set_level "$level" &&
    bl64_log_set_format "$format" &&
    BL64_LOG_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'log'
}

#######################################
# Set log repository
#
# * Create the repository directory
#
# Arguments:
#   $1: repository path
# Outputs:
#   STDOUT: None
#   STDERR: command stderr
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_log_set_repository() {
  bl64_dbg_lib_show_function "$@"
  local repository="$1"

  if [[ ! -d "$repository" ]]; then
    "$BL64_FS_CMD_MKDIR" "$repository" &&
      "$BL64_FS_CMD_CHMOD" "$BL64_LOG_REPOSITORY_MODE" "$repository" ||
      return $BL64_LIB_ERROR_TASK_FAILED
  else
    [[ -w "$repository" ]] || return $BL64_LIB_ERROR_TASK_FAILED
  fi

  BL64_LOG_REPOSITORY="$repository"
  return 0
}

#######################################
# Set logging level
#
# Arguments:
#   $1: target level. One of BL64_LOG_CATEGORY_*
# Outputs:
#   STDOUT: None
#   STDERR: check error
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_log_set_level() {
  bl64_dbg_lib_show_function "$@"
  local level="$1"

  case "$level" in
  "$BL64_LOG_CATEGORY_NONE") BL64_LOG_LEVEL="$BL64_LOG_CATEGORY_NONE" ;;
  "$BL64_LOG_CATEGORY_INFO") BL64_LOG_LEVEL="$BL64_LOG_CATEGORY_INFO" ;;
  "$BL64_LOG_CATEGORY_DEBUG") BL64_LOG_LEVEL="$BL64_LOG_CATEGORY_DEBUG" ;;
  "$BL64_LOG_CATEGORY_WARNING") BL64_LOG_LEVEL="$BL64_LOG_CATEGORY_WARNING" ;;
  "$BL64_LOG_CATEGORY_ERROR") BL64_LOG_LEVEL="$BL64_LOG_CATEGORY_ERROR" ;;
  *) return $BL64_LIB_ERROR_PARAMETER_INVALID ;;
  esac
}

#######################################
# Set log format
#
# Arguments:
#   $1: log format. One of BL64_LOG_FORMAT_*
# Outputs:
#   STDOUT: None
#   STDERR: commands stderr
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_log_set_format() {
  bl64_dbg_lib_show_function "$@"
  local format="$1"

  case "$format" in
  "$BL64_LOG_FORMAT_CSV")
    BL64_LOG_FORMAT="$BL64_LOG_FORMAT_CSV"
    BL64_LOG_FS=':'
    ;;
  *) return $BL64_LIB_ERROR_PARAMETER_INVALID ;;
  esac
}

#######################################
# Set log target
#
# * Log target is the file where logs will be written to
# * File is created or appended in the log repository
#
# Arguments:
#   $1: log target. Format: file name
# Outputs:
#   STDOUT: None
#   STDERR: commands stderr
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_log_set_target() {
  bl64_dbg_lib_show_function "$@"
  local target="$1"
  local destination="${BL64_LOG_REPOSITORY}/${target}"

  # Check if there is a new target to set
  [[ "$BL64_LOG_DESTINATION" == "$destination" ]] && return 0

  if [[ ! -w "$destination" ]]; then
    "$BL64_FS_CMD_TOUCH" "$destination" &&
      "$BL64_FS_CMD_CHMOD" "$BL64_LOG_TARGET_MODE" "$destination" ||
      return $BL64_LIB_ERROR_TASK_FAILED
  fi

  BL64_LOG_DESTINATION="$destination"
  return 0
}

#######################################
# Set runtime log target
#
# * Use to save output from commands using one file per execution
# * The target name is used as the directory for each execution
# * The target directory is created in the log repository
# * The calling script is responsible for redirecting the command's output to the target path BL64_LOG_RUNTIME
#
# Arguments:
#   $1: runtime log target. Format: directory name
# Outputs:
#   STDOUT: None
#   STDERR: commands stderr
# Returns:
#   0: set ok
#   >0: unable to set
#######################################
function bl64_log_set_runtime() {
  bl64_dbg_lib_show_function "$@"
  local target="$1"
  local destination="${BL64_LOG_REPOSITORY}/${target}"
  local log=''

  # Check if there is a new target to set
  [[ "$BL64_LOG_RUNTIME" == "$destination" ]] && return 0

  if [[ ! -d "$destination" ]]; then
    "$BL64_FS_CMD_MKDIR" "$destination" &&
      "$BL64_FS_CMD_CHMOD" "$BL64_LOG_REPOSITORY_MODE" "$destination" ||
      return $BL64_LIB_ERROR_TASK_FAILED
  fi

  [[ ! -w "$destination" ]] && return $BL64_LIB_ERROR_TASK_FAILED

  log="$(printf '%(%FT%TZ%z)T' '-1')" &&
    BL64_LOG_RUNTIME="${destination}/${log}.log" ||
    return 0

  return 0
}

#######################################
# BashLib64 / Module / Functions / Write messages to logs
#######################################

#######################################
# Save a log record to the logs repository
#
# Arguments:
#   $1: name of the source that is generating the message
#   $2: log message category. Use any of $BL64_LOG_CATEGORY_*
#   $3: message
# Outputs:
#   STDOUT: None
#   STDERR: execution errors
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#   BL64_LIB_ERROR_MODULE_SETUP_MISSING
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function _bl64_log_register() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local category="$2"
  local payload="$3"

  [[ "$BL64_LOG_MODULE" == "$BL64_VAR_OFF" ]] && return 0
  [[ -z "$source" || -z "$category" || -z "$payload" ]] && return $BL64_LIB_ERROR_PARAMETER_MISSING

  case "$BL64_LOG_FORMAT" in
  "$BL64_LOG_FORMAT_CSV")
    printf '%(%FT%TZ%z)T%s%s%s%s%s%s%s%s%s%s%s%s\n' \
      '-1' \
      "$BL64_LOG_FS" \
      "$BL64_SCRIPT_SID" \
      "$BL64_LOG_FS" \
      "$HOSTNAME" \
      "$BL64_LOG_FS" \
      "$BL64_SCRIPT_ID" \
      "$BL64_LOG_FS" \
      "${source}" \
      "$BL64_LOG_FS" \
      "$category" \
      "$BL64_LOG_FS" \
      "$payload" >>"$BL64_LOG_DESTINATION"
    ;;
  *) return $BL64_LIB_ERROR_MODULE_SETUP_INVALID ;;
  esac
}

#######################################
# Save a single log record of type 'info' to the logs repository.
#
# Arguments:
#   $1: name of the source that is generating the message
#   $2: message to be recorded
# Outputs:
#   STDOUT: message (when BL64_LOG_VERBOSE='1')
#   STDERR: execution errors
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_info() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local payload="$2"

  [[ "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_NONE" ||
    "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_ERROR" ||
    "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_WARNING" ]] &&
    return 0

  _bl64_log_register \
    "$source" \
    "$BL64_LOG_CATEGORY_INFO" \
    "$payload"
}

#######################################
# Save a single log record of type 'error' to the logs repository.
#
# Arguments:
#   $1: name of the source that is generating the message
#   $2: message to be recorded
# Outputs:
#   STDOUT: None
#   STDERR: execution errors, message (when BL64_LOG_VERBOSE='1')
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_error() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local payload="$2"

  [[ "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_NONE" ]] && return 0

  _bl64_log_register \
    "$source" \
    "$BL64_LOG_CATEGORY_ERROR" \
    "$payload"
}

#######################################
# Save a single log record of type 'warning' to the logs repository.
#
# Arguments:
#   $1: name of the source that is generating the message
#   $2: message to be recorded
# Outputs:
#   STDOUT: None
#   STDERR: execution errors, message (when BL64_LOG_VERBOSE='1')
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_warning() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local payload="$2"

  [[ "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_NONE" ||
    "$BL64_LOG_LEVEL" == "$BL64_LOG_CATEGORY_ERROR" ]] &&
    return 0

  _bl64_log_register \
    "$source" \
    "$BL64_LOG_CATEGORY_WARNING" \
    "$payload"
}

#######################################
# BashLib64 / Module / Setup / Manage OS identity and access service
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_iam_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  _bl64_iam_set_command &&
    _bl64_iam_set_alias &&
    _bl64_iam_set_options &&
    BL64_IAM_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'iam'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_iam_set_command() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/useradd'
    BL64_IAM_CMD_ID='/usr/bin/id'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/useradd'
    BL64_IAM_CMD_ID='/usr/bin/id'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/useradd'
    BL64_IAM_CMD_ID='/usr/bin/id'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/adduser'
    BL64_IAM_CMD_ID='/usr/bin/id'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/sysadminctl'
    BL64_IAM_CMD_ID='/usr/bin/id'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_iam_set_alias() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_SLES}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD "
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_iam_set_options() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_IAM_SET_USERADD_CREATE_HOME='--create-home'
    BL64_IAM_SET_USERADD_GECO='--comment'
    BL64_IAM_SET_USERADD_GROUP='--gid'
    BL64_IAM_SET_USERADD_HOME_PATH='--home-dir'
    BL64_IAM_SET_USERADD_SHELL='--shell'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_IAM_SET_USERADD_CREATE_HOME='--create-home'
    BL64_IAM_SET_USERADD_GECO='--comment'
    BL64_IAM_SET_USERADD_GROUP='--gid'
    BL64_IAM_SET_USERADD_HOME_PATH='--home-dir'
    BL64_IAM_SET_USERADD_SHELL='--shell'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_IAM_SET_USERADD_CREATE_HOME='--create-home'
    BL64_IAM_SET_USERADD_GECO='--comment'
    BL64_IAM_SET_USERADD_GROUP='--gid'
    BL64_IAM_SET_USERADD_HOME_PATH='--home-dir'
    BL64_IAM_SET_USERADD_SHELL='--shell'
    ;;
  ${BL64_OS_ALP}-*)
    # Home is created by default
    BL64_IAM_SET_USERADD_CREATE_HOME=' '
    BL64_IAM_SET_USERADD_GECO='-g'
    BL64_IAM_SET_USERADD_GROUP='-G'
    BL64_IAM_SET_USERADD_HOME_PATH='-h'
    BL64_IAM_SET_USERADD_SHELL='-s'
    ;;
  ${BL64_OS_MCOS}-*)
    # Home is created by default
    BL64_IAM_SET_USERADD_CREATE_HOME=' '
    BL64_IAM_SET_USERADD_GECO='-fullName'
    BL64_IAM_SET_USERADD_GROUP='-gid'
    BL64_IAM_SET_USERADD_HOME_PATH='-home'
    BL64_IAM_SET_USERADD_SHELL='-shell'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# BashLib64 / Module / Functions / Manage OS identity and access service
#######################################

#######################################
# Create local OS user
#
# * Wrapper to native user creation command
# * Objective is to cover common options that are available on all suported platforms
#   * set primary group
#   * set shell
#   * set home path
#   * set user description
#   * create home
#   * create primary group
# * If the user is already created nothing is done, no error
#
# Arguments:
#   $1: login name
#   $2: home path. Format: full path. Default: os native
#   $3: primary group ID. Format: group name. Default: os native
#   $4: shell. Format: full path. Default: os native
#   $5: description. Default: none
# Outputs:
#   STDOUT: native user add command output
#   STDERR: native user add command error messages
# Returns:
#   native user add command error status
#######################################
function bl64_iam_user_add() {
  bl64_dbg_lib_show_function "$@"
  local login="${1:-}"
  local home="${2:-$BL64_VAR_DEFAULT}"
  local group="${3:-$BL64_VAR_DEFAULT}"
  local shell="${4:-$BL64_VAR_DEFAULT}"
  local gecos="${5:-$BL64_VAR_DEFAULT}"
  local password=''

  bl64_check_privilege_root &&
    bl64_check_parameter 'login' ||
    return $?

  [[ "$home" == "$BL64_VAR_DEFAULT" ]] && home=''
  [[ "$group" == "$BL64_VAR_DEFAULT" ]] && group=''
  [[ "$shell" == "$BL64_VAR_DEFAULT" ]] && shell=''
  [[ "$gecos" == "$BL64_VAR_DEFAULT" ]] && gecos=''

  if bl64_iam_user_is_created "$login"; then
    bl64_msg_show_warning "${_BL64_IAM_TXT_EXISTING_USER} ($login)"
    return 0
  fi

  bl64_msg_show_lib_subtask "$_BL64_IAM_TXT_ADD_USER ($login)"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    "$BL64_IAM_CMD_USERADD" \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      "$login"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    "$BL64_IAM_CMD_USERADD" \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      "$login"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_dbg_lib_show_comments 'force primary group creation'
    "$BL64_IAM_CMD_USERADD" \
      --user-group \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      "$login"
    ;;
  ${BL64_OS_ALP}-*)
    bl64_dbg_lib_show_comments 'disable automatic password generation'
    "$BL64_IAM_CMD_USERADD" \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      -D \
      "$login"
    ;;
  ${BL64_OS_MCOS}-*)
    password="$(bl64_rnd_get_numeric)" || return $?
    "$BL64_IAM_CMD_USERADD" \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      -addUser "$login" \
      -password "$password"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Determine if the user is created
#
# Arguments:
#   $1: login name
# Outputs:
#   STDOUT: native user add command output
#   STDERR: native user add command error messages
# Returns:
#   native user add command error status
#######################################
function bl64_iam_user_is_created() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"

  bl64_check_parameter 'user' ||
    return $?

  # Use the ID command to detect if the user is created
  bl64_iam_user_get_id "$user" >/dev/null 2>&1

}

#######################################
# Get user's UID
#
# Arguments:
#   $1: user login name. Default: current user
# Outputs:
#   STDOUT: user ID
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_iam_user_get_id() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"

  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_SLES}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_ALP}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_MCOS}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  *) bl64_check_alert_unsupported ;;
  esac

}

#######################################
# Get current user name
#
# Arguments:
#   None
# Outputs:
#   STDOUT: user name
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_iam_user_get_current() {
  bl64_dbg_lib_show_function
  "${BL64_IAM_CMD_ID}" -u -n
}

#######################################
# Check that the user is created
#
# Arguments:
#   $1: user name
#   $2: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_USER_NOT_FOUND
#######################################
function bl64_iam_check_user() {
  bl64_dbg_lib_show_function "$@"
  local user="${1:-}"
  local message="${2:-${_BL64_IAM_TXT_USER_NOT_FOUND}}"

  bl64_check_parameter 'user' || return $?

  if ! bl64_iam_user_is_created "$user"; then
    bl64_msg_show_error "${message} (user: ${user} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_USER_NOT_FOUND
  else
    return 0
  fi
}

#######################################
# BashLib64 / Module / Setup / Manage native OS packages
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_pkg_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  # shellcheck disable=SC2249
  bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    bl64_check_module_imported 'BL64_FS_MODULE' &&
    bl64_check_module_imported 'BL64_RXTX_MODULE' &&
    _bl64_pkg_set_command &&
    _bl64_pkg_set_runtime &&
    _bl64_pkg_set_options &&
    _bl64_pkg_set_alias &&
    BL64_PKG_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'pkg'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_pkg_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_CMD_APT='/usr/bin/apt-get'
    ;;
  ${BL64_OS_FD}-*)
    BL64_PKG_CMD_DNF='/usr/bin/dnf'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_CMD_YUM='/usr/bin/yum'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    BL64_PKG_CMD_DNF='/usr/bin/dnf'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_PKG_CMD_ZYPPER='/usr/bin/zypper'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_CMD_APK='/sbin/apk'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_CMD_BRW='/opt/homebrew/bin/brew'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
# * BL64_PKG_SET_SLIM: used as meta flag to capture options for reducing install disk space
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_pkg_set_options() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_SET_ASSUME_YES='--assume-yes'
    BL64_PKG_SET_SLIM='--no-install-recommends'
    BL64_PKG_SET_QUIET='--quiet --quiet'
    BL64_PKG_SET_VERBOSE='--show-progress'
    ;;
  ${BL64_OS_FD}-*)
    BL64_PKG_SET_ASSUME_YES='--assumeyes'
    BL64_PKG_SET_SLIM='--nodocs'
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--color=never --verbose'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_SET_ASSUME_YES='--assumeyes'
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--color=never --verbose'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    BL64_PKG_SET_ASSUME_YES='--assumeyes'
    BL64_PKG_SET_SLIM='--nodocs'
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--color=never --verbose'
    ;;
  ${BL64_OS_SLES}-15.*)
    BL64_PKG_SET_ASSUME_YES='--no-confirm'
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_SET_ASSUME_YES=' '
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_SET_ASSUME_YES=' '
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--verbose'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_pkg_set_alias() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-*)
    BL64_PKG_ALIAS_DNF_CACHE="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} makecache"
    BL64_PKG_ALIAS_DNF_INSTALL="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} ${BL64_PKG_SET_SLIM} ${BL64_PKG_SET_ASSUME_YES} install"
    BL64_PKG_ALIAS_DNF_CLEAN="$BL64_PKG_CMD_DNF clean all"
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_ALIAS_YUM_CACHE="$BL64_PKG_CMD_YUM ${BL64_PKG_SET_VERBOSE} makecache"
    BL64_PKG_ALIAS_YUM_INSTALL="$BL64_PKG_CMD_YUM ${BL64_PKG_SET_VERBOSE} ${BL64_PKG_SET_ASSUME_YES} install"
    BL64_PKG_ALIAS_YUM_CLEAN="$BL64_PKG_CMD_YUM clean all"
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    BL64_PKG_ALIAS_DNF_CACHE="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} makecache"
    BL64_PKG_ALIAS_DNF_INSTALL="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} ${BL64_PKG_SET_SLIM} ${BL64_PKG_SET_ASSUME_YES} install"
    BL64_PKG_ALIAS_DNF_CLEAN="$BL64_PKG_CMD_DNF clean all"
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_ALIAS_APT_CACHE="$BL64_PKG_CMD_APT update"
    BL64_PKG_ALIAS_APT_INSTALL="$BL64_PKG_CMD_APT install ${BL64_PKG_SET_ASSUME_YES} ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APT_CLEAN="$BL64_PKG_CMD_APT clean"
    ;;
  ${BL64_OS_SLES}-*)
    :
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_ALIAS_APK_CACHE="$BL64_PKG_CMD_APK update ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APK_INSTALL="$BL64_PKG_CMD_APK add ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APK_CLEAN="$BL64_PKG_CMD_APK cache clean ${BL64_PKG_SET_VERBOSE}"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_ALIAS_BRW_CACHE="$BL64_PKG_CMD_BRW update ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_BRW_INSTALL="$BL64_PKG_CMD_BRW install ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_BRW_CLEAN="$BL64_PKG_CMD_BRW cleanup ${BL64_PKG_SET_VERBOSE} --prune=all -s"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Set runtime defaults
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: setting errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function _bl64_pkg_set_runtime() {
  bl64_dbg_lib_show_function

  bl64_pkg_set_paths
}

#######################################
# Set and prepare module paths
#
# * Global paths only
# * If preparation fails the whole module fails
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: paths prepared ok
#   >0: failed to prepare paths
#######################################
# shellcheck disable=SC2120
function bl64_pkg_set_paths() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-*)
    BL64_PKG_PATH_YUM_REPOS_D='/etc/yum.repos.d'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    BL64_PKG_PATH_YUM_REPOS_D='/etc/yum.repos.d'
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_PATH_APT_SOURCES_LIST_D='/etc/apt/sources.list.d'
    BL64_PKG_PATH_GPG_KEYRINGS='/usr/share/keyrings'
    ;;
  ${BL64_OS_SLES}-*)
    :
    ;;
  ${BL64_OS_ALP}-*)
    :
    ;;
  ${BL64_OS_MCOS}-*)
    :
    ;;
  *) bl64_check_alert_unsupported ;;
  esac

  return 0
}

#######################################
# BashLib64 / Module / Functions / Manage native OS packages
#######################################

#######################################
# Add package repository
#
# * Covers simple uses cases that can be applied to most OS versions:
#   * YUM: repo package definition created
#   * APT: repo package definition created, GPGkey downloaded and installed
# * Package cache is not refreshed
# * No replacement done if already present
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   $1: repository name. Format: alphanumeric, _-
#   $2: repository source. Format: URL
#   $3: GPGKey source. Format: URL. Default: $BL64_VAR_NONE
#   $4: extra package specific parameter. For APT: suite. Default: empty
#   $5: extra package specific parameter. For APT: component. Default: empty
#
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   package manager exit status
#######################################
function bl64_pkg_repository_add() {
  bl64_dbg_lib_show_function "$@"
  local name="${1:-}"
  local source="${2:-}"
  local gpgkey="${3:-${BL64_VAR_NONE}}"
  local extra1="${4:-}"
  local extra2="${5:-}"

  bl64_check_privilege_root &&
    bl64_check_parameter 'name' ||
    bl64_check_parameter 'source' ||
    return $?

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_REPOSITORY_ADD (${name})"
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    _bl64_pkg_repository_add_apt "$name" "$source" "$gpgkey" "$extra1" "$extra2"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    _bl64_pkg_repository_add_yum "$name" "$source" "$gpgkey"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_check_alert_unsupported
    ;;
  ${BL64_OS_ALP}-*)
    bl64_check_alert_unsupported
    ;;
  ${BL64_OS_MCOS}-*)
    bl64_check_alert_unsupported
    ;;
  *) bl64_check_alert_unsupported ;;

  esac
}

function _bl64_pkg_repository_add_yum() {
  bl64_dbg_lib_show_function "$@"
  local name="$1"
  local source="$2"
  local gpgkey="$3"
  local definition=''
  local file_mode='0644'

  bl64_check_directory "$BL64_PKG_PATH_YUM_REPOS_D" ||
    return $?

  definition="${BL64_PKG_PATH_YUM_REPOS_D}/${name}.${BL64_PKG_DEF_SUFIX_YUM_REPOSITORY}"
  [[ -f "$definition" ]] &&
    bl64_msg_show_warning "${_BL64_PKG_TXT_REPOSITORY_EXISTING} (${definition})" &&
    return 0

  bl64_msg_show_lib_subtask "${_BL64_PKG_TXT_REPOSITORY_ADD_YUM} (${definition})"
  if [[ "$gpgkey" != "$BL64_VAR_NONE" ]]; then
    printf '[%s]\n
name=%s
baseurl=%s
gpgcheck=1
enabled=1
gpgkey=%s\n' \
      "$name" \
      "$name" \
      "$source" \
      "$gpgkey" \
      >"$definition"
  else
    printf '[%s]\n
name=%s
baseurl=%s
gpgcheck=0
enabled=1\n' \
      "$name" \
      "$name" \
      "$source" \
      >"$definition"
  fi
  [[ -f "$definition" ]] && bl64_fs_run_chmod "$file_mode" "$definition"
}

function _bl64_pkg_repository_add_apt() {
  bl64_dbg_lib_show_function "$@"
  local name="$1"
  local source="$2"
  local gpgkey="$3"
  local suite="$4"
  local component="$5"
  local definition=''
  local gpgkey_file=''
  local file_mode='0644'

  bl64_check_parameter 'suite' &&
    bl64_check_directory "$BL64_PKG_PATH_APT_SOURCES_LIST_D" &&
    bl64_check_directory "$BL64_PKG_PATH_GPG_KEYRINGS" ||
    return $?

  definition="${BL64_PKG_PATH_APT_SOURCES_LIST_D}/${name}.${BL64_PKG_DEF_SUFIX_APT_REPOSITORY}"
  [[ -f "$definition" ]] &&
    bl64_msg_show_warning "${_BL64_PKG_TXT_REPOSITORY_EXISTING} (${definition})" &&
    return 0

  bl64_msg_show_lib_subtask "${_BL64_PKG_TXT_REPOSITORY_ADD_APT} (${definition})"
  if [[ "$gpgkey" != "$BL64_VAR_NONE" ]]; then
    gpgkey_file="${BL64_PKG_PATH_GPG_KEYRINGS}/${name}.${BL64_PKG_DEF_SUFIX_GPG_FILE}"
    printf 'deb [signed-by=%s] %s %s %s\n' \
      "$gpgkey_file" \
      "$source" \
      "$suite" \
      "$component" \
      >"$definition" ||
      return $?
    bl64_msg_show_lib_subtask "${_BL64_PKG_TXT_REPOSITORY_ADD_KEY} (${gpgkey})"
    bl64_rxtx_web_get_file "$gpgkey" "$gpgkey_file" "$BL64_VAR_ON" "$file_mode"
  else
    printf 'deb %s %s %s\n' \
      "$source" \
      "$suite" \
      "$component" \
      >"$definition"
  fi
  [[ -f "$definition" ]] && bl64_fs_run_chmod "$file_mode" "$definition"
}

#######################################
# Refresh package repository
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_pkg_repository_refresh() {
  bl64_dbg_lib_show_function

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_REPOSITORY_REFRESH"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_pkg_run_apt 'update'
    ;;
  ${BL64_OS_FD}-*)
    bl64_pkg_run_dnf 'makecache'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    bl64_pkg_run_yum 'makecache'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    bl64_pkg_run_dnf 'makecache'
    ;;
  ${BL64_OS_SLES}-*)
    bl64_pkg_run_zypper 'refresh'
    ;;
  ${BL64_OS_ALP}-*)
    bl64_pkg_run_apk 'update'
    ;;
  ${BL64_OS_MCOS}-*)
    bl64_pkg_run_brew 'update'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Deploy packages
#
# * Before installation: prepares the package manager environment and cache
# * After installation: removes cache and temporary files
#
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: process output
#   STDERR: process stderr
# Returns:
#   n: process exist status
#######################################
function bl64_pkg_deploy() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none $# || return $?

  bl64_pkg_prepare &&
    bl64_pkg_install "$@" &&
    bl64_pkg_upgrade &&
    bl64_pkg_cleanup
}

#######################################
# Initialize the package manager for installations
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_pkg_prepare() {
  bl64_dbg_lib_show_function

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_PREPARE"
  bl64_pkg_repository_refresh
}

#######################################
# Install packages
#
# * Assume yes
# * Avoid installing docs (man) when possible
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_pkg_install() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none $# || return $?

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_INSTALL (${*})"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_pkg_run_apt 'install' $BL64_PKG_SET_SLIM $BL64_PKG_SET_ASSUME_YES -- "$@"
    ;;
  ${BL64_OS_FD}-*)
    bl64_pkg_run_dnf $BL64_PKG_SET_SLIM $BL64_PKG_SET_ASSUME_YES 'install' -- "$@"
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    bl64_pkg_run_yum $BL64_PKG_SET_ASSUME_YES 'install' -- "$@"
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    bl64_pkg_run_dnf $BL64_PKG_SET_SLIM $BL64_PKG_SET_ASSUME_YES 'install' -- "$@"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_pkg_run_zypper 'install' $BL64_PKG_SET_ASSUME_YES -- "$@"
    ;;
  ${BL64_OS_ALP}-*)
    bl64_pkg_run_apk 'add' -- "$@"
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_PKG_CMD_BRW" 'install' "$@"
    ;;
  *) bl64_check_alert_unsupported ;;

  esac
}

#######################################
# Upgrade packages
#
# * Assume yes
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
# shellcheck disable=SC2120
function bl64_pkg_upgrade() {
  bl64_dbg_lib_show_function "$@"

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_UPGRADE"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_pkg_run_apt 'upgrade' $BL64_PKG_SET_ASSUME_YES -- "$@"
    ;;
  ${BL64_OS_FD}-*)
    bl64_pkg_run_dnf $BL64_PKG_SET_SLIM $BL64_PKG_SET_ASSUME_YES 'upgrade' -- "$@"
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    bl64_pkg_run_yum $BL64_PKG_SET_ASSUME_YES 'upgrade' -- "$@"
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    bl64_pkg_run_dnf $BL64_PKG_SET_SLIM $BL64_PKG_SET_ASSUME_YES 'upgrade' -- "$@"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_pkg_run_zypper 'update' $BL64_PKG_SET_ASSUME_YES -- "$@"
    ;;
  ${BL64_OS_ALP}-*)
    bl64_pkg_run_apk 'upgrade' -- "$@"
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_PKG_CMD_BRW" 'upgrade' "$@"
    ;;
  *) bl64_check_alert_unsupported ;;

  esac
}

#######################################
# Clean up the package manager run-time environment
#
# * Warning: removes cache contents
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_pkg_cleanup() {
  bl64_dbg_lib_show_function
  local target=''

  bl64_msg_show_lib_subtask "$_BL64_PKG_TXT_CLEAN"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_pkg_run_apt 'clean'
    ;;
  ${BL64_OS_FD}-*)
    bl64_pkg_run_dnf 'clean' 'all'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    bl64_pkg_run_yum 'clean' 'all'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_OL}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_RCK}-*)
    BL64_PKG_CMD_DNF='/usr/bin/dnf'
    ;;
  ${BL64_OS_SLES}-*)
    bl64_pkg_run_zypper 'clean' '--all'
    ;;
  ${BL64_OS_ALP}-*)
    bl64_pkg_run_apk 'cache' 'clean'
    target='/var/cache/apk'
    if [[ -d "$target" ]]; then
      bl64_fs_rm_full ${target}/[[:alpha:]]*
    fi
    ;;
  ${BL64_OS_MCOS}-*)
    bl64_pkg_run_brew 'cleanup' --prune=all -s
    ;;
  *) bl64_check_alert_unsupported ;;

  esac
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_dnf() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_DNF" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_yum() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_YUM" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_apt() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  bl64_pkg_blank_apt

  # Verbose is only available for a subset of commands
  if bl64_dbg_lib_command_enabled && [[ "$*" =~ (install|upgrade|remove) ]]; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    export DEBCONF_NOWARNINGS='yes'
    export DEBCONF_TERSE='yes'
    verbose="$BL64_PKG_SET_QUIET"
  fi

  # Avoid interactive questions
  export DEBIAN_FRONTEND="noninteractive"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_APT" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_pkg_blank_apt() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited DEB* shell variables'
  bl64_dbg_lib_trace_start
  unset DEBIAN_FRONTEND
  unset DEBCONF_TERSE
  unset DEBCONF_NOWARNINGS
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_apk() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_APK" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_brew() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_BRW" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_pkg_run_zypper() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_parameters_none "$#" &&
    bl64_check_privilege_root &&
    bl64_check_module 'BL64_PKG_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_PKG_CMD_ZYPPER" $verbose "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# BashLib64 / Module / Setup / Interact with system-wide Python
#######################################

#######################################
# Setup the bashlib64 module
#
# * (Optional) Use virtual environment
#
# Arguments:
#   $1: full path to the virtual environment
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_py_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local venv_path="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$venv_path" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_info "venv requested (${venv_path})"
    if [[ -d "$venv_path" ]]; then
      bl64_dbg_lib_show_info 'use already existing venv'
      _bl64_py_setup "$venv_path"
    else
      bl64_dbg_lib_show_info 'no previous venv, create one'
      _bl64_py_setup "$BL64_VAR_DEFAULT" &&
        bl64_py_venv_create "$venv_path" &&
        _bl64_py_setup "$venv_path"
    fi
  else
    bl64_dbg_lib_show_info "no venv requested"
    _bl64_py_setup "$BL64_VAR_DEFAULT"
  fi

  bl64_check_alert_module_setup 'py'
}

function _bl64_py_setup() {
  bl64_dbg_lib_show_function "$@"
  local venv_path="$1"

  if [[ "$venv_path" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_py_venv_check "$venv_path" ||
      return $?
  fi

  _bl64_py_set_command "$venv_path" &&
    bl64_check_command "$BL64_PY_CMD_PYTHON3" &&
    _bl64_py_set_options &&
    _bl64_py_set_resources &&
    BL64_PY_MODULE="$BL64_VAR_ON"
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
# * (Optional) Enable requested virtual environment
# * If virtual environment is requested, instead of running bin/activate manually set the same variables that it would
# * Python versions are detected up to the subversion, minor is ignored. Example: use python3.6 instead of python3.6.1
#
# Arguments:
#   $1: full path to the virtual environment
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_py_set_command() {
  bl64_dbg_lib_show_function "$@"
  local venv_path="$1"

  if [[ "$venv_path" == "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_info 'identify OS native python3 path'
    # shellcheck disable=SC2034
    case "$BL64_OS_DISTRO" in
    ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*) BL64_PY_CMD_PYTHON36='/usr/bin/python3' ;;
    ${BL64_OS_CNT}-8.* | ${BL64_OS_OL}-8.* | ${BL64_OS_RHEL}-8.* | ${BL64_OS_ALM}-8.* | ${BL64_OS_RCK}-8.*)
      BL64_PY_CMD_PYTHON36='/usr/bin/python3'
      BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
      ;;
    ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-9.* | ${BL64_OS_RHEL}-9.* | ${BL64_OS_ALM}-9.* | ${BL64_OS_RCK}-9.*) BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    ${BL64_OS_FD}-33.* | ${BL64_OS_FD}-34.*) BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    ${BL64_OS_FD}-35.* | ${BL64_OS_FD}-36.*) BL64_PY_CMD_PYTHON310='/usr/bin/python3.10' ;;
    ${BL64_OS_FD}-37.* | ${BL64_OS_FD}-38.*) BL64_PY_CMD_PYTHON311='/usr/bin/python3.11' ;;
    ${BL64_OS_FD}-39.* ) BL64_PY_CMD_PYTHON312='/usr/bin/python3.12' ;;
    ${BL64_OS_DEB}-9.*) BL64_PY_CMD_PYTHON35='/usr/bin/python3.5' ;;
    ${BL64_OS_DEB}-10.*) BL64_PY_CMD_PYTHON37='/usr/bin/python3.7' ;;
    ${BL64_OS_DEB}-11.*) BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    ${BL64_OS_UB}-18.*) BL64_PY_CMD_PYTHON36='/usr/bin/python3.6' ;;
    ${BL64_OS_UB}-20.*) BL64_PY_CMD_PYTHON38='/usr/bin/python3.8' ;;
    ${BL64_OS_UB}-21.*) BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    ${BL64_OS_UB}-22.*) BL64_PY_CMD_PYTHON310='/usr/bin/python3.10' ;;
    ${BL64_OS_UB}-23.*) BL64_PY_CMD_PYTHON310='/usr/bin/python3.11' ;;
    ${BL64_OS_SLES}-15.*)
      # Default
      BL64_PY_CMD_PYTHON36='/usr/bin/python3.6'
      # SP3
      BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
      # SP4
      BL64_PY_CMD_PYTHON310='/usr/bin/python3.10'
      ;;
    "${BL64_OS_ALP}-3.14" | "${BL64_OS_ALP}-3.15") BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    "${BL64_OS_ALP}-3.16" | "${BL64_OS_ALP}-3.17") BL64_PY_CMD_PYTHON39='/usr/bin/python3.10' ;;
    ${BL64_OS_MCOS}-12.* | ${BL64_OS_MCOS}-13.*) BL64_PY_CMD_PYTHON39='/usr/bin/python3.9' ;;
    *)
      if bl64_lib_mode_compability_is_enabled; then
        BL64_PY_CMD_PYTHON3='/usr/bin/python3'
      else
        bl64_check_alert_unsupported
        return $?
      fi
      ;;
    esac

    # Select best match for default python3
    if [[ -x "$BL64_PY_CMD_PYTHON312" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON312"
      BL64_PY_VERSION_PYTHON3='3.12'
    elif [[ -x "$BL64_PY_CMD_PYTHON311" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON311"
      BL64_PY_VERSION_PYTHON3='3.11'
    elif [[ -x "$BL64_PY_CMD_PYTHON310" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON310"
      BL64_PY_VERSION_PYTHON3='3.10'
    elif [[ -x "$BL64_PY_CMD_PYTHON39" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON39"
      BL64_PY_VERSION_PYTHON3='3.9'
    elif [[ -x "$BL64_PY_CMD_PYTHON38" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON38"
      BL64_PY_VERSION_PYTHON3='3.8'
    elif [[ -x "$BL64_PY_CMD_PYTHON37" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON37"
      BL64_PY_VERSION_PYTHON3='3.7'
    elif [[ -x "$BL64_PY_CMD_PYTHON36" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON36"
      BL64_PY_VERSION_PYTHON3='3.6'
    elif [[ -x "$BL64_PY_CMD_PYTHON35" ]]; then
      BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON35"
      BL64_PY_VERSION_PYTHON3='3.5'
    fi

    # Ignore VENV. Use detected python
    export VIRTUAL_ENV=''

  else
    bl64_dbg_lib_show_comments 'use python3 from virtual environment'
    BL64_PY_CMD_PYTHON3="${venv_path}/bin/python3"

    # Emulate bin/activate
    export VIRTUAL_ENV="$venv_path"
    export PATH="${VIRTUAL_ENV}:${PATH}"
    unset PYTHONHOME

    # Let other basthlib64 functions know about this venv
    BL64_PY_VENV_PATH="$venv_path"
  fi

  bl64_dbg_lib_show_vars 'BL64_PY_CMD_PYTHON3' 'BL64_PY_VENV_PATH' 'VIRTUAL_ENV' 'PATH'
  return 0
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_py_set_options() {
  bl64_dbg_lib_show_function
  # Common sets - unversioned
  BL64_PY_SET_PIP_VERBOSE='--verbose'
  BL64_PY_SET_PIP_DEBUG='-vvv'
  BL64_PY_SET_PIP_VERSION='--version'
  BL64_PY_SET_PIP_UPGRADE='--upgrade'
  BL64_PY_SET_PIP_USER='--user'
  BL64_PY_SET_PIP_QUIET='--quiet'
  BL64_PY_SET_PIP_SITE='--system-site-packages'
  BL64_PY_SET_PIP_NO_WARN_SCRIPT='--no-warn-script-location'

  return 0
}

#######################################
# Declare version specific definitions
#
# * Use to capture default file names, values, attributes, etc
# * Do not use to capture CLI flags. Use *_set_options instead
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_py_set_resources() {
  bl64_dbg_lib_show_function

  BL64_PY_DEF_VENV_CFG='pyvenv.cfg'
  BL64_PY_DEF_MODULE_VENV='venv'
  BL64_PY_DEF_MODULE_PIP='pip'

  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with system-wide Python
#######################################

#######################################
# Create virtual environment
#
# Arguments:
#   $1: full path to the virtual environment
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_py_venv_create() {
  bl64_dbg_lib_show_function "$@"
  local venv_path="${1:-}"

  bl64_check_parameter 'venv_path' &&
    bl64_check_path_absolute "$venv_path" &&
    bl64_check_path_not_present "$venv_path" ||
    return $?

  bl64_msg_show_lib_task "${_BL64_PY_TXT_VENV_CREATE} (${venv_path})"
  bl64_py_run_python -m "$BL64_PY_DEF_MODULE_VENV" "$venv_path"

}

#######################################
# Check that the requested virtual environment is created
#
# Arguments:
#   $1: full path to the virtual environment
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_py_venv_check() {
  bl64_dbg_lib_show_function "$@"
  local venv_path="${1:-}"

  bl64_check_parameter 'venv_path' ||
    return $?

  if [[ ! -d "$venv_path" ]]; then
    bl64_msg_show_error "${message} (command: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_PY_TXT_VENV_MISSING}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_MODULE_SETUP_MISSING
  fi

  if [[ ! -r "${venv_path}/${BL64_PY_DEF_VENV_CFG}" ]]; then
    bl64_msg_show_error "${message} (command: ${path} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_PY_TXT_VENV_INVALID}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE})"
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
  fi

  return 0
}

#######################################
# Get Python PIP version
#
# Arguments:
#   None
# Outputs:
#   STDOUT: PIP version
#   STDERR: PIP error
# Returns:
#   0: ok
#   $BL64_LIB_ERROR_APP_INCOMPATIBLE
#######################################
function bl64_py_pip_get_version() {
  bl64_dbg_lib_show_function
  local -a version

  read -r -a version < <(bl64_py_run_pip "$BL64_PY_SET_PIP_VERSION")
  if [[ "${version[1]}" == [0-9.]* ]]; then
    printf '%s' "${version[1]}"
  else
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  return 0
}

#######################################
# Initialize package manager for local-user
#
# * Upgrade pip
# * Install/upgrade setuptools
# * Upgrade is done using the OS provided PIP module. Do not use bl64_py_pip_usr_install as it relays on the latest version of PIP
#
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_py_pip_usr_prepare() {
  bl64_dbg_lib_show_function
  local modules_pip="$BL64_PY_DEF_MODULE_PIP"
  local modules_setup='setuptools wheel stevedore'
  local flag_user="$BL64_PY_SET_PIP_USER"

  [[ -n "$VIRTUAL_ENV" ]] && flag_user=' '

  bl64_msg_show_lib_task "$_BL64_PY_TXT_PIP_PREPARE_PIP"
  # shellcheck disable=SC2086
  bl64_py_run_pip \
    'install' \
    $BL64_PY_SET_PIP_UPGRADE \
    $flag_user \
    $modules_pip ||
    return $?

  bl64_msg_show_lib_task "$_BL64_PY_TXT_PIP_PREPARE_SETUP"
  # shellcheck disable=SC2086
  bl64_py_run_pip \
    'install' \
    $BL64_PY_SET_PIP_UPGRADE \
    $flag_user \
    $modules_setup ||
    return $?

  return 0
}

#######################################
# Install packages for local-user
#
# * Assume yes
# * Assumes that bl64_py_pip_usr_prepare was runned before
# * Uses the latest version of PIP (previously upgraded by bl64_py_pip_usr_prepare)
#
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exit status
#######################################
function bl64_py_pip_usr_install() {
  bl64_dbg_lib_show_function "$@"
  local flag_user="$BL64_PY_SET_PIP_USER"

  bl64_check_parameters_none $# || return $?

  # If venv is in use no need to flag usr install
  [[ -n "$VIRTUAL_ENV" ]] && flag_user=' '

  bl64_msg_show_lib_task "$_BL64_PY_TXT_PIP_INSTALL ($*)"
  # shellcheck disable=SC2086
  bl64_py_run_pip \
    'install' \
    $BL64_PY_SET_PIP_UPGRADE \
    $BL64_PY_SET_PIP_NO_WARN_SCRIPT \
    $flag_user \
    "$@"
}

#######################################
# Deploy PIP packages
#
# * Before installation: prepares the package manager environment and cache
# * After installation: removes cache and temporary files
#
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: process output
#   STDERR: process stderr
# Returns:
#   n: process exist status
#######################################
function bl64_py_pip_usr_deploy() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none $# || return $?

  bl64_py_pip_usr_prepare &&
    bl64_py_pip_usr_install "$@" ||
    return $?

  bl64_py_pip_usr_cleanup
  return 0
}

#######################################
# Clean up pip install environment
#
# * Empty cache
# * Ignore errors and warnings
# * Best effort
#
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   0: always ok
#######################################
function bl64_py_pip_usr_cleanup() {
  bl64_dbg_lib_show_function

  bl64_msg_show_lib_task "$_BL64_PY_TXT_PIP_CLEANUP_PIP"
  bl64_py_run_pip \
    'cache' \
    'purge'

  return 0
}

#######################################
# Python wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_py_run_python() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_PY_MODULE' ||
    return $?

  bl64_py_blank_python

  bl64_dbg_lib_trace_start
  "$BL64_PY_CMD_PYTHON3" "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_py_blank_python() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited PYTHON* shell variables'
  bl64_dbg_lib_trace_start
  unset PYTHONHOME
  unset PYTHONPATH
  unset PYTHONSTARTUP
  unset PYTHONDEBUG
  unset PYTHONUSERBASE
  unset PYTHONEXECUTABLE
  unset PYTHONWARNINGS
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# Python PIP wrapper
#
# * Uses global ephemeral settings when configured for temporal and cache
#
# Arguments:
#   $@: arguments are passes as-is
# Outputs:
#   STDOUT: PIP output
#   STDERR: PIP error
# Returns:
#   PIP exit status
#######################################
function bl64_py_run_pip() {
  bl64_dbg_lib_show_function "$@"
  local debug="$BL64_PY_SET_PIP_QUIET"
  local temporal=' '
  local cache=' '

  bl64_msg_lib_verbose_enabled && debug=' '
  bl64_dbg_lib_command_enabled && debug="$BL64_PY_SET_PIP_DEBUG"

  [[ -n "$BL64_FS_PATH_TEMPORAL" ]] && temporal="TMPDIR=${BL64_FS_PATH_TEMPORAL}"
  [[ -n "$BL64_FS_PATH_CACHE" ]] && cache="--cache-dir=${BL64_FS_PATH_CACHE}"

  # shellcheck disable=SC2086
  eval $temporal bl64_py_run_python \
    -m "$BL64_PY_DEF_MODULE_PIP" \
    $debug \
    $cache \
    "$*"
}

#######################################
# BashLib64 / Module / Setup / Manage archive files
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_arc_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  _bl64_arc_set_command &&
    _bl64_arc_set_options &&
    BL64_ARC_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'arc'
}

#######################################
# Identify and normalize common *nix OS commands
#
# * Commands are exported as variables with full path
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function
function _bl64_arc_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_ARC_CMD_UNZIP='/usr/bin/unzip'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_ARC_CMD_UNZIP='/usr/bin/unzip'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_ARC_CMD_UNZIP='/usr/bin/unzip'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_ARC_CMD_UNZIP='/usr/bin/unzip'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_ARC_CMD_TAR='/usr/bin/tar'
    BL64_ARC_CMD_UNZIP='/usr/bin/unzip'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_arc_set_options() {
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_ARC_SET_TAR_VERBOSE='--verbose'
    BL64_ARC_SET_UNZIP_OVERWRITE='-o'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_ARC_SET_TAR_VERBOSE='--verbose'
    BL64_ARC_SET_UNZIP_OVERWRITE='-o'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_ARC_SET_TAR_VERBOSE='--verbose'
    BL64_ARC_SET_UNZIP_OVERWRITE='-o'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_ARC_SET_TAR_VERBOSE='-v'
    BL64_ARC_SET_UNZIP_OVERWRITE='-o'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_ARC_SET_TAR_VERBOSE='--verbose'
    BL64_ARC_SET_UNZIP_OVERWRITE='-o'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# BashLib64 / Module / Functions / Manage archive files
#######################################

#######################################
# Unzip wrapper debug and common options
#
# * Trust noone. Ignore env args
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_arc_run_unzip() {
  bl64_dbg_lib_show_function "$@"
  local verbosity='-qq'

  bl64_check_module 'BL64_ARC_MODULE' &&
    bl64_check_parameters_none "$#" &&
    bl64_check_command "$BL64_ARC_CMD_UNZIP" || return $?

  bl64_msg_lib_verbose_enabled && verbosity=' '

  bl64_arc_blank_unzip

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_ARC_CMD_UNZIP" \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_arc_blank_unzip() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited UNZIP* shell variables'
  bl64_dbg_lib_trace_start
  unset UNZIP
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# Tar wrapper debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_arc_run_tar() {
  bl64_dbg_lib_show_function "$@"
  bl64_check_parameters_none "$#" || return $?
  local debug=' '

  bl64_check_module 'BL64_ARC_MODULE' &&
    bl64_check_command "$BL64_ARC_CMD_TAR" ||
    return $?

  bl64_msg_lib_verbose_enabled && debug="$BL64_ARC_SET_TAR_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_ARC_CMD_TAR" \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Open tar files and remove the source after extraction
#
# * Preserves permissions but not ownership
# * Overwrites destination
# * Ignore ACLs and extended attributes
#
# Arguments:
#   $1: Full path to the source file
#   $2: Full path to the destination
# Outputs:
#   STDOUT: None
#   STDERR: tar or lib error messages
# Returns:
#   BL64_ARC_ERROR_INVALID_DESTINATION
#   tar error status
#######################################
function bl64_arc_open_tar() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"
  local -i status=0

  bl64_check_module 'BL64_ARC_MODULE' &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_file "$source" &&
    bl64_check_directory "$destination" ||
    return $?

  bl64_msg_show_lib_subtask "$_BL64_ARC_TXT_OPEN_TAR ($source)"

  # shellcheck disable=SC2164
  cd "$destination"

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_arc_run_tar \
      --overwrite \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --force-local \
      --auto-compress \
      --file="$source"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    bl64_arc_run_tar \
      --overwrite \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --force-local \
      --auto-compress \
      --file="$source"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_arc_run_tar \
      --overwrite \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --force-local \
      --auto-compress \
      --file="$source"
    ;;
  ${BL64_OS_ALP}-*)
    bl64_arc_run_tar \
      x \
      --overwrite \
      -f "$source" \
      -o
    ;;
  ${BL64_OS_MCOS}-*)
    bl64_arc_run_tar \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --auto-compress \
      --file="$source"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
  status=$?

  ((status == 0)) && bl64_fs_rm_file "$source"

  return $status
}

#######################################
# Open zip files and remove the source after extraction
#
# * Preserves permissions but not ownership
# * Overwrites destination
# * Ignore ACLs and extended attributes
#
# Arguments:
#   $1: Full path to the source file
#   $2: Full path to the destination
# Outputs:
#   STDOUT: None
#   STDERR: tar or lib error messages
# Returns:
#   BL64_ARC_ERROR_INVALID_DESTINATION
#   tar error status
#######################################
function bl64_arc_open_zip() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"
  local -i status=0

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_file "$source" &&
    bl64_check_directory "$destination" ||
    return $?

  bl64_msg_show_lib_subtask "$_BL64_ARC_TXT_OPEN_ZIP ($source)"
  # shellcheck disable=SC2086
  bl64_arc_run_unzip \
    $BL64_ARC_SET_UNZIP_OVERWRITE \
    -d "$destination" \
    "$source"
  status=$?

  ((status == 0)) && bl64_fs_rm_file "$source"

  return $status
}

#######################################
# BashLib64 / Module / Setup / Interact with Ansible CLI
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: required in order to use the module
# * Check for core commands, fail if not available
#
# Arguments:
#   $1: (optional) Full path where commands are
#   $2: (optional) Full path to the ansible configuration file
#   $3: (optional) Ignore inherited shell environment? Default: BL64_VAR_ON
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_ans_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local ansible_bin="${1:-${BL64_VAR_DEFAULT}}"
  local ansible_config="${2:-${BL64_VAR_DEFAULT}}"
  local env_ignore="${3:-${BL64_VAR_ON}}"

  _bl64_ans_set_command "$ansible_bin" &&
    bl64_check_command "$BL64_ANS_CMD_ANSIBLE" &&
    bl64_check_command "$BL64_ANS_CMD_ANSIBLE_GALAXY" &&
    bl64_check_command "$BL64_ANS_CMD_ANSIBLE_PLAYBOOK" &&
    _bl64_ans_set_runtime "$ansible_config" &&
    _bl64_ans_set_options &&
    _bl64_ans_set_version &&
    BL64_ANS_MODULE="$BL64_VAR_ON" &&
    BL64_ANS_ENV_IGNORE="$env_ignore"

  bl64_check_alert_module_setup 'ans'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_ans_set_command() {
  bl64_dbg_lib_show_function "$@"
  local ansible_bin="$1"

  if [[ "$ansible_bin" == "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_info 'no custom path provided. Using known locations to detect ansible'
    if [[ -n "$BL64_PY_VENV_PATH" && -x "${BL64_PY_VENV_PATH}/bin/ansible" ]]; then
      ansible_bin="${BL64_PY_VENV_PATH}/bin"
    elif [[ -n "$HOME" && -x "${HOME}/.local/bin/ansible" ]]; then
      ansible_bin="${HOME}/.local/bin"
    elif [[ -x '/usr/local/bin/ansible' ]]; then
      ansible_bin='/usr/local/bin'
    elif [[ -x '/home/linuxbrew/.linuxbrew/bin/ansible' ]]; then
      ansible_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/ansible' ]]; then
      ansible_bin='/opt/homebrew/bin'
    elif [[ -x '/opt/ansible/bin/ansible' ]]; then
      ansible_bin='/opt/ansible/bin'
    elif [[ -x '/usr/bin/ansible' ]]; then
      ansible_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'ansible'
      return $?
    fi
  fi

  bl64_check_directory "$ansible_bin" || return $?
  [[ -x "${ansible_bin}/ansible" ]] && BL64_ANS_CMD_ANSIBLE="${ansible_bin}/ansible"
  [[ -x "${ansible_bin}/ansible-galaxy" ]] && BL64_ANS_CMD_ANSIBLE_GALAXY="${ansible_bin}/ansible-galaxy"
  [[ -x "${ansible_bin}/ansible-playbook" ]] && BL64_ANS_CMD_ANSIBLE_PLAYBOOK="${ansible_bin}/ansible-playbook"

  bl64_dbg_lib_show_vars 'BL64_ANS_CMD_ANSIBLE' 'BL64_ANS_CMD_ANSIBLE_GALAXY' 'BL64_ANS_CMD_ANSIBLE_PLAYBOOK'
  return 0
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_ans_set_options() {
  bl64_dbg_lib_show_function

  BL64_ANS_SET_VERBOSE='-v'
  BL64_ANS_SET_DIFF='--diff'
  BL64_ANS_SET_DEBUG='-vvvvv'
}

#######################################
# Set runtime defaults
#
# Arguments:
#   $1: path to ansible_config
# Outputs:
#   STDOUT: None
#   STDERR: setting errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function _bl64_ans_set_runtime() {
  bl64_dbg_lib_show_function "$@"
  local config="$1"

  bl64_ans_set_paths "$config"
}

#######################################
# Set and prepare module paths
#
# * Global paths only
# * If preparation fails the whole module fails
#
# Arguments:
#   $1: path to ansible_config
#   $2: path to ansible collections
#   $3: path to ansible workdir
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: paths prepared ok
#   >0: failed to prepare paths
#######################################
function bl64_ans_set_paths() {
  bl64_dbg_lib_show_function "$@"
  local config="${1:-${BL64_VAR_DEFAULT}}"
  local collections="${2:-${BL64_VAR_DEFAULT}}"
  local ansible="${3:-${BL64_VAR_DEFAULT}}"

  if [[ "$config" == "$BL64_VAR_DEFAULT" ]]; then
    BL64_ANS_PATH_USR_CONFIG=''
  else
    bl64_check_file "$config" || return $?
    BL64_ANS_PATH_USR_CONFIG="$config"
  fi

  if [[ "$ansible" == "$BL64_VAR_DEFAULT" ]]; then
    BL64_ANS_PATH_USR_ANSIBLE="${HOME}/.ansible"
  else
    BL64_ANS_PATH_USR_ANSIBLE="$ansible"
  fi

  if [[ "$collections" == "$BL64_VAR_DEFAULT" ]]; then
    BL64_ANS_PATH_USR_COLLECTIONS="${BL64_ANS_PATH_USR_ANSIBLE}/collections/ansible_collections"
  else
    bl64_check_directory "$collections" || return $?
    BL64_ANS_PATH_USR_COLLECTIONS="$ansible"
  fi

  bl64_dbg_lib_show_vars 'BL64_ANS_PATH_USR_CONFIG' 'BL64_ANS_PATH_USR_ANSIBLE' 'BL64_ANS_PATH_USR_COLLECTIONS'
  return 0
}

#######################################
# Identify and set module components versions
#
# * Version information is stored in module global variables
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: command errors
# Returns:
#   0: version set ok
#   >0: command error
#######################################
function _bl64_ans_set_version() {
  bl64_dbg_lib_show_function
  local cli_version=''

  bl64_dbg_lib_show_info "run ansible to obtain ansible-core version (${BL64_ANS_CMD_ANSIBLE} --version)"
  cli_version="$("$BL64_ANS_CMD_ANSIBLE" --version | bl64_txt_run_awk '/^ansible..core.*$/ { gsub( /\[|\]/, "" ); print $3 }')"
  bl64_dbg_lib_show_vars 'cli_version'

  if [[ -n "$cli_version" ]]; then
    BL64_ANS_VERSION_CORE="$cli_version"
  else
    bl64_msg_show_error "${_BL64_ANS_TXT_ERROR_GET_VERSION} (${BL64_ANS_CMD_ANSIBLE} --version)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  bl64_dbg_lib_show_vars 'BL64_ANS_VERSION_CORE'
  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with Ansible CLI
#######################################

#######################################
# Install Ansible Collections
#
# Arguments:
#   $@: list of ansible collections to install
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_ans_collections_install() {
  bl64_dbg_lib_show_function "$@"
  local collection=''

  bl64_check_parameters_none "$#" || return $?

  for collection in "$@"; do
    bl64_ans_run_ansible_galaxy \
      collection \
      install \
      --upgrade \
      "$collection" ||
      return $?
  done
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_ans_run_ansible() {
  bl64_dbg_lib_show_function "$@"
  local debug=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_ANS_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && debug="${BL64_ANS_SET_VERBOSE} ${BL64_ANS_SET_DIFF}"
  bl64_dbg_lib_command_enabled && debug="$BL64_ANS_SET_DEBUG"

  bl64_ans_blank_ansible

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_ANS_CMD_ANSIBLE" \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust noone. Use default config
#
# Arguments:
#   $1: command
#   $2: subcommand
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_ans_run_ansible_galaxy() {
  bl64_dbg_lib_show_function "$@"
  local command="${1:-${BL64_VAR_NULL}}"
  local subcommand="${2:-${BL64_VAR_NULL}}"
  local debug=' '

  bl64_check_module 'BL64_ANS_MODULE' &&
    bl64_check_parameter 'command' &&
    bl64_check_parameter 'subcommand' ||
    return $?

  bl64_msg_lib_verbose_enabled && debug="$BL64_ANS_SET_VERBOSE"

  bl64_ans_blank_ansible

  shift
  shift
  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_ANS_CMD_ANSIBLE_GALAXY" \
    "$command" \
    "$subcommand" \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust noone. Use default config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_ans_run_ansible_playbook() {
  bl64_dbg_lib_show_function "$@"
  local debug=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_ANS_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && debug="${BL64_ANS_SET_VERBOSE} ${BL64_ANS_SET_DIFF}"
  bl64_dbg_lib_command_enabled && debug="$BL64_ANS_SET_DEBUG"

  bl64_ans_blank_ansible

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_ANS_CMD_ANSIBLE_PLAYBOOK" \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_ans_blank_ansible() {
  bl64_dbg_lib_show_function

  if [[ "$BL64_ANS_ENV_IGNORE" == "$BL64_VAR_ON" ]]; then
    bl64_dbg_lib_show_info 'unset inherited ANSIBLE_* shell variables'
    bl64_dbg_lib_trace_start
    unset ANSIBLE_CACHE_PLUGIN_CONNECTION
    unset ANSIBLE_COLLECTIONS_PATHS
    unset ANSIBLE_CONFIG
    unset ANSIBLE_GALAXY_CACHE_DIR
    unset ANSIBLE_GALAXY_TOKEN_PATH
    unset ANSIBLE_INVENTORY
    unset ANSIBLE_LOCAL_TEMP
    unset ANSIBLE_LOG_PATH
    unset ANSIBLE_PERSISTENT_CONTROL_PATH_DIR
    unset ANSIBLE_PLAYBOOK_DIR
    unset ANSIBLE_PRIVATE_KEY_FILE
    unset ANSIBLE_ROLES_PATH
    unset ANSIBLE_SSH_CONTROL_PATH_DIR
    unset ANSIBLE_VAULT_PASSWORD_FILE
    unset ANSIBLE_RETRY_FILES_SAVE_PATH
    bl64_dbg_lib_trace_stop
  fi

  [[ -n "$BL64_ANS_PATH_USR_CONFIG" ]] && export ANSIBLE_CONFIG="$BL64_ANS_PATH_USR_CONFIG"

  return 0
}

#######################################
# BashLib64 / Module / Setup / Interact with AWS
#######################################

#
# Module attributes getters
#

function bl64_aws_get_cli_config() {
  bl64_dbg_lib_show_function
  bl64_check_module 'BL64_AWS_MODULE' || return $?
  echo "$BL64_AWS_CLI_CONFIG"
}

function bl64_aws_get_cli_credentials() {
  bl64_dbg_lib_show_function
  bl64_check_module 'BL64_AWS_MODULE' || return $?
  echo "$BL64_AWS_CLI_CREDENTIALS"
}

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_aws_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local aws_bin="${1:-${BL64_VAR_DEFAULT}}"

  _bl64_aws_set_command "$aws_bin" &&
    _bl64_aws_set_options &&
    _bl64_aws_set_resources &&
    bl64_check_command "$BL64_AWS_CMD_AWS" &&
    bl64_aws_set_paths &&
    BL64_AWS_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'aws'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_aws_set_command() {
  bl64_dbg_lib_show_function "$@"
  local aws_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$aws_bin" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/aws' ]]; then
      aws_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/aws' ]]; then
      aws_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/aws' ]]; then
      aws_bin='/usr/local/bin'
    elif [[ -x '/opt/aws/bin/aws' ]]; then
      aws_bin='/opt/aws/bin'
    elif [[ -x '/usr/bin/aws' ]]; then
      aws_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'aws-cli'
      return $?
    fi
  fi

  bl64_check_directory "$aws_bin" || return $?
  [[ -x "${aws_bin}/aws" ]] && BL64_AWS_CMD_AWS="${aws_bin}/aws"

  bl64_dbg_lib_show_vars 'BL64_AWS_CMD_AWS'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_aws_set_options() {
  bl64_dbg_lib_show_function

  BL64_AWS_SET_FORMAT_JSON='--output json'
  BL64_AWS_SET_FORMAT_TEXT='--output text'
  BL64_AWS_SET_FORMAT_TABLE='--output table'
  BL64_AWS_SET_FORMAT_YAML='--output yaml'
  BL64_AWS_SET_FORMAT_STREAM='--output yaml-stream'
  BL64_AWS_SET_DEBUG='--debug'
  BL64_AWS_SET_OUPUT_NO_PAGER='--no-cli-pager'
  BL64_AWS_SET_OUPUT_NO_COLOR='--color off'
  BL64_AWS_SET_INPUT_NO_PROMPT='--no-cli-auto-prompt'

  return 0
}

#######################################
# Declare version specific definitions
#
# * Use to capture default file names, values, attributes, etc
# * Do not use to capture CLI flags. Use *_set_options instead
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_aws_set_resources() {
  bl64_dbg_lib_show_function

  BL64_AWS_DEF_SUFFIX_TOKEN='json'
  BL64_AWS_DEF_SUFFIX_HOME='.aws'
  BL64_AWS_DEF_SUFFIX_CACHE='sso/cache'
  BL64_AWS_DEF_SUFFIX_CONFIG='cfg'
  BL64_AWS_DEF_SUFFIX_CREDENTIALS='secret'

  return 0
}

#######################################
# Set runtime defaults
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: setting errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function _bl64_aws_set_runtime() {
  bl64_dbg_lib_show_function

  bl64_aws_set_paths
}

#######################################
# Set and prepare module paths
#
# * Global paths only
# * If preparation fails the whole module fails
#
# Arguments:
#   $1: configuration file name
#   $2: credential file name
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: paths prepared ok
#   >0: failed to prepare paths
#######################################
# shellcheck disable=SC2120
function bl64_aws_set_paths() {
  bl64_dbg_lib_show_function "$@"
  local configuration="${1:-${BL64_SCRIPT_ID}}"
  local credentials="${2:-${BL64_SCRIPT_ID}}"
  local aws_home=''

  bl64_dbg_lib_show_info 'prepare AWS_HOME'
  bl64_check_home || return $?
  aws_home="${HOME}/${BL64_AWS_DEF_SUFFIX_HOME}"
  bl64_fs_create_dir "$BL64_AWS_CLI_MODE" "$BL64_VAR_DEFAULT" "$BL64_VAR_DEFAULT" "$aws_home" || return $?

  bl64_dbg_lib_show_info 'set configuration paths'
  BL64_AWS_CLI_HOME="$aws_home"
  BL64_AWS_CLI_CACHE="${BL64_AWS_CLI_HOME}/${BL64_AWS_DEF_SUFFIX_CACHE}"
  BL64_AWS_CLI_CONFIG="${BL64_AWS_CLI_HOME}/${configuration}.${BL64_AWS_DEF_SUFFIX_CONFIG}"
  BL64_AWS_CLI_CREDENTIALS="${BL64_AWS_CLI_HOME}/${credentials}.${BL64_AWS_DEF_SUFFIX_CREDENTIALS}"

  bl64_dbg_lib_show_vars 'BL64_AWS_CLI_HOME' 'BL64_AWS_CLI_CACHE' 'BL64_AWS_CLI_CONFIG' 'BL64_AWS_CLI_CREDENTIALS'
  return 0
}

#######################################
# Set AWS region
#
# * Use anytime you neeto to change the target region
#
# Arguments:
#   $1: AWS region
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function bl64_aws_set_region() {
  bl64_dbg_lib_show_function "$@"
  local region="${1:-}"

  bl64_check_parameter 'region' || return $?

  BL64_AWS_CLI_REGION="$region"

  bl64_dbg_lib_show_vars 'BL64_AWS_CLI_REGION'
  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with AWS
#######################################

#######################################
# Creates a SSO profile in the AWS CLI configuration file
#
# * Equivalent to aws configure sso
#
# Arguments:
#   $1: profile name
#   $2: start url
#   $3: region
#   $4: account id
#   $5: permission set
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################

function bl64_aws_cli_create_sso() {
  bl64_dbg_lib_show_function "$@"
  local profile="${1:-${BL64_VAR_DEFAULT}}"
  local start_url="${2:-${BL64_VAR_DEFAULT}}"
  local sso_region="${3:-${BL64_VAR_DEFAULT}}"
  local sso_account_id="${4:-${BL64_VAR_DEFAULT}}"
  local sso_role_name="${5:-${BL64_VAR_DEFAULT}}"

  bl64_check_parameter 'profile' &&
    bl64_check_parameter 'start_url' &&
    bl64_check_parameter 'sso_region' &&
    bl64_check_parameter 'sso_account_id' &&
    bl64_check_parameter 'sso_role_name' &&
    bl64_check_module 'BL64_AWS_MODULE' ||
    return $?

  bl64_dbg_lib_show_info "create AWS CLI profile for AWS SSO login (${BL64_AWS_CLI_CONFIG})"
  printf '[profile %s]\n' "$profile" >"$BL64_AWS_CLI_CONFIG" &&
    printf 'sso_start_url = %s\n' "$start_url" >>"$BL64_AWS_CLI_CONFIG" &&
    printf 'sso_region = %s\n' "$sso_region" >>"$BL64_AWS_CLI_CONFIG" &&
    printf 'sso_account_id = %s\n' "$sso_account_id" >>"$BL64_AWS_CLI_CONFIG" &&
    printf 'sso_role_name = %s\n' "$sso_role_name" >>"$BL64_AWS_CLI_CONFIG"

}

#######################################
# Login to AWS using SSO
#
# * Equivalent to aws --profile X sso login
# * The SSO profile must be already created
# * SSO login requires a browser connection. The command will show the URL to open to get the one time code
#
# Arguments:
#   $1: profile name
# Outputs:
#   STDOUT: login process information
#   STDERR: command stderr
# Returns:
#   0: login ok
#   >0: failed to login
#######################################
function bl64_aws_sso_login() {
  bl64_dbg_lib_show_function "$@"
  local profile="${1:-${BL64_VAR_DEFAULT}}"

  bl64_aws_run_aws_profile \
    "$profile" \
    sso \
    login \
    --no-browser

}

#######################################
# Get current caller ARN
#
# Arguments:
#   $1: profile name
# Outputs:
#   STDOUT: ARN
#   STDERR: command stderr
# Returns:
#   0: got value ok
#   >0: failed to get
#######################################
function bl64_aws_sts_get_caller_arn() {
  bl64_dbg_lib_show_function "$@"
  local profile="${1:-${BL64_VAR_DEFAULT}}"

  # shellcheck disable=SC2086
  bl64_aws_run_aws_profile \
    "$profile" \
    $BL64_AWS_SET_FORMAT_TEXT \
    --query '[Arn]' \
    sts \
    get-caller-identity

}

#######################################
# Get file path to the SSO cached token
#
# * Token must first be generated by aws sso login
# * Token is saved in a fixed location, but with random file name
#
# Arguments:
#   $1: profile name
# Outputs:
#   STDOUT: token path
#   STDERR: command stderr
# Returns:
#   0: got value ok
#   >0: failed to get
#######################################
function bl64_aws_sso_get_token() {
  bl64_dbg_lib_show_function "$@"
  local start_url="${1:-}"
  local token_file=''

  bl64_check_module 'BL64_AWS_MODULE' &&
    bl64_check_parameter 'start_url' &&
    bl64_check_directory "$BL64_AWS_CLI_CACHE" ||
    return $?

  bl64_dbg_lib_show_info "search for sso login token (${BL64_AWS_CLI_CACHE})"
  bl64_dbg_lib_trace_start
  token_file="$(bl64_fs_find_files \
    "$BL64_AWS_CLI_CACHE" \
    "*.${BL64_AWS_DEF_SUFFIX_TOKEN}" \
    "$start_url")"
  bl64_dbg_lib_trace_stop

  if [[ -n "$token_file" && -r "$token_file" ]]; then
    echo "$token_file"
  else
    bl64_msg_show_error "$_BL64_AWS_TXT_TOKEN_NOT_FOUND"
    return $BL64_LIB_ERROR_TASK_FAILED
  fi

}

#######################################
# Command wrapper for aws cli with mandatory profile
#
# * profile entry must be previously generated
#
# Arguments:
#   $1: profile name
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_aws_run_aws_profile() {
  bl64_dbg_lib_show_function "$@"
  local profile="${1:-}"

  bl64_check_module 'BL64_AWS_MODULE' &&
    bl64_check_parameter 'profile' &&
    bl64_check_file "$BL64_AWS_CLI_CONFIG" ||
    return $?

  shift
  bl64_aws_run_aws \
    --profile "$profile" \
    "$@"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit config
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_aws_run_aws() {
  bl64_dbg_lib_show_function "$@"
  local verbosity="$BL64_AWS_SET_OUPUT_NO_COLOR"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_AWS_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity=' '
  bl64_dbg_lib_command_enabled && verbosity="$BL64_AWS_SET_DEBUG"

  bl64_aws_blank_aws

  bl64_dbg_lib_show_info 'Set mandatory configuration and credential variables'
  export AWS_CONFIG_FILE="$BL64_AWS_CLI_CONFIG"
  export AWS_SHARED_CREDENTIALS_FILE="$BL64_AWS_CLI_CREDENTIALS"
  bl64_dbg_lib_show_vars 'AWS_CONFIG_FILE' 'AWS_SHARED_CREDENTIALS_FILE'

  if [[ -n "$BL64_AWS_CLI_REGION" ]]; then
    bl64_dbg_lib_show_info 'Set region as requested'
    export AWS_REGION="$BL64_AWS_CLI_REGION"
    bl64_dbg_lib_show_vars 'AWS_REGION'
  else
    bl64_dbg_lib_show_info 'Not setting region, not requested'
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_AWS_CMD_AWS" \
    $BL64_AWS_SET_INPUT_NO_PROMPT \
    $BL64_AWS_SET_OUPUT_NO_PAGER \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_aws_blank_aws() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited AWS_* shell variables'
  bl64_dbg_lib_trace_start
  unset AWS_PAGER
  unset AWS_PROFILE
  unset AWS_REGION
  unset AWS_CA_BUNDLE
  unset AWS_CONFIG_FILE
  unset AWS_DATA_PATH
  unset AWS_DEFAULT_OUTPUT
  unset AWS_DEFAULT_REGION
  unset AWS_MAX_ATTEMPTS
  unset AWS_RETRY_MODE
  unset AWS_ROLE_ARN
  unset AWS_SESSION_TOKEN
  unset AWS_ACCESS_KEY_ID
  unset AWS_CLI_AUTO_PROMPT
  unset AWS_CLI_FILE_ENCODING
  unset AWS_METADATA_SERVICE_TIMEOUT
  unset AWS_ROLE_SESSION_NAME
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SHARED_CREDENTIALS_FILE
  unset AWS_EC2_METADATA_DISABLED
  unset AWS_METADATA_SERVICE_NUM_ATTEMPTS
  unset AWS_WEB_IDENTITY_TOKEN_FILE
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# BashLib64 / Module / Setup / Interact with container engines
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: required in order to use the module
# * Check for core commands, fail if not available
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_cnt_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function

  bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    _bl64_cnt_set_command &&
    bl64_cnt_set_paths &&
    _bl64_cnt_set_options &&
    BL64_CNT_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'cnt'
}

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_cnt_set_command() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_CNT_CMD_PODMAN='/usr/bin/podman'
    BL64_CNT_CMD_DOCKER='/usr/bin/docker'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_CNT_CMD_PODMAN='/usr/bin/podman'
    BL64_CNT_CMD_DOCKER='/usr/bin/docker'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_CNT_CMD_PODMAN='/usr/bin/podman'
    BL64_CNT_CMD_DOCKER='/usr/bin/docker'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_CNT_CMD_PODMAN='/usr/bin/podman'
    BL64_CNT_CMD_DOCKER='/usr/bin/docker'
    ;;
  ${BL64_OS_MCOS}-*)
    # Podman is not available for MacOS
    BL64_CNT_CMD_PODMAN="$BL64_VAR_INCOMPATIBLE"
    # Docker is available using docker-desktop
    BL64_CNT_CMD_DOCKER='/usr/local/bin/docker'
    ;;
  *)
    bl64_check_alert_unsupported
    return $?
    ;;
  esac

  bl64_dbg_lib_show_comments 'detect and set current container driver'
  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    BL64_CNT_DRIVER="$BL64_CNT_DRIVER_DOCKER"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    BL64_CNT_DRIVER="$BL64_CNT_DRIVER_PODMAN"
  else
    bl64_msg_show_error "unable to find a container manager (${BL64_CNT_CMD_DOCKER}, ${BL64_CNT_CMD_PODMAN})"
    return $BL64_LIB_ERROR_APP_MISSING
  fi
  bl64_dbg_lib_show_vars 'BL64_CNT_DRIVER'

  return 0
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_cnt_set_options() {
  bl64_dbg_lib_show_function

  #
  # Standard CLI flags
  #
  # * Common to both podman and docker
  #

  BL64_CNT_SET_DEBUG='--debug'
  BL64_CNT_SET_ENTRYPOINT='--entrypoint'
  BL64_CNT_SET_FILE='--file'
  BL64_CNT_SET_FILTER='--filter'
  BL64_CNT_SET_INTERACTIVE='--interactive'
  BL64_CNT_SET_LOG_LEVEL='--log-level'
  BL64_CNT_SET_NO_CACHE='--no-cache'
  BL64_CNT_SET_PASSWORD_STDIN='--password-stdin'
  BL64_CNT_SET_PASSWORD='--password'
  BL64_CNT_SET_QUIET='--quiet'
  BL64_CNT_SET_RM='--rm'
  BL64_CNT_SET_TAG='--tag'
  BL64_CNT_SET_TTY='--tty'
  BL64_CNT_SET_USERNAME='--username'
  BL64_CNT_SET_VERSION='version'

  #
  # Common parameter values
  #
  # * Common to both podman and docker
  #

  BL64_CNT_SET_FILTER_ID='{{.ID}}'
  BL64_CNT_SET_FILTER_NAME='{{.Names}}'
  BL64_CNT_SET_LOG_LEVEL_DEBUG='debug'
  BL64_CNT_SET_LOG_LEVEL_ERROR='error'
  BL64_CNT_SET_LOG_LEVEL_INFO='info'
  BL64_CNT_SET_STATUS_RUNNING='running'

  return 0
}

#######################################
# Set and prepare module paths
#
# * Global paths only
# * If preparation fails the whole module fails
#
# Arguments:
#   $1: configuration file name
#   $2: credential file name
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: paths prepared ok
#   >0: failed to prepare paths
#######################################
# shellcheck disable=SC2120
function bl64_cnt_set_paths() {
  bl64_dbg_lib_show_function "$@"

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_CNT_PATH_DOCKER_SOCKET='/var/run/docker.sock'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    BL64_CNT_PATH_DOCKER_SOCKET='/var/run/docker.sock'
    ;;
  ${BL64_OS_SLES}-*)
    BL64_CNT_PATH_DOCKER_SOCKET='/var/run/docker.sock'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_CNT_PATH_DOCKER_SOCKET='/var/run/docker.sock'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_CNT_PATH_DOCKER_SOCKET='/var/run/docker.sock'
    ;;
  *) bl64_check_alert_unsupported ;;
  esac

  bl64_dbg_lib_show_vars 'BL64_CNT_PATH_DOCKER_SOCKET'
  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with container engines
#######################################

#######################################
# Check if the current process is running inside a container
#
# * detection is best effort and not guaranteed to cover all possible implementations
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   check status
#######################################
function bl64_cnt_is_inside_container() {
  bl64_dbg_lib_show_function

  _bl64_cnt_find_file_marker '/run/.containerenv' && return 0
  _bl64_cnt_find_file_marker '/run/container_id' && return 0
  _bl64_cnt_find_variable_marker 'container' && return 0
  _bl64_cnt_find_variable_marker 'DOCKER_CONTAINER' && return 0
  _bl64_cnt_find_variable_marker 'KUBERNETES_SERVICE_HOST' && return 0

  return 1
}

function _bl64_cnt_find_file_marker() {
  bl64_dbg_lib_show_function "$@"
  local marker="$1"
  bl64_dbg_lib_show_info "check for file marker (${marker})"
  [[ -f "$marker" ]]
}

function _bl64_cnt_find_variable_marker() {
  bl64_dbg_lib_show_function "$@"
  local marker="$1"
  bl64_dbg_lib_show_info "check for variable marker (${marker})"

  eval "[[ -n \"\${${marker}}\" ]]"
}

#######################################
# Logins the container engine to a container registry. The password is taken from STDIN
#
# Arguments:
#   $1: user
#   $2: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_login_stdin() {
  bl64_dbg_lib_show_function "$@"
  local user="${1:-}"
  local registry="${2:-}"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'user' &&
    bl64_check_parameter 'registry' ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_LOGIN_REGISTRY} (${user}@${registry})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_login" "$user" "$BL64_VAR_DEFAULT" "$BL64_CNT_FLAG_STDIN" "$registry"
}

#######################################
# Logins the container engine to a container registry. The password is stored in a regular file
#
# Arguments:
#   $1: user
#   $2: file
#   $3: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_login_file() {
  bl64_dbg_lib_show_function "$@"
  local user="${1:-}"
  local file="${2:-}"
  local registry="${3:-}"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'user' &&
    bl64_check_parameter 'file' &&
    bl64_check_parameter 'registry' &&
    bl64_check_file "$file" ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_LOGIN_REGISTRY} (${user}@${registry})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_login" "$user" "$BL64_VAR_DEFAULT" "$file" "$registry"
}

#######################################
# Logins the container engine to a container. The password is passed as parameter
#
# Arguments:
#   $1: user
#   $2: password
#   $3: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_login() {
  bl64_dbg_lib_show_function "$@"
  local user="${1:-}"
  local password="${2:-}"
  local registry="${3:-}"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'user' &&
    bl64_check_parameter 'password' &&
    bl64_check_parameter 'registry' ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_LOGIN_REGISTRY} (${user}@${registry})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_login" "$user" "$password" "$BL64_VAR_DEFAULT" "$registry"
}

#######################################
# Open a container image using sh
#
# * Ignores entrypointt
#
# Arguments:
#   $1: container
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_run_sh() {
  bl64_dbg_lib_show_function "$@"
  local container="$1"

  bl64_check_parameter 'container' || return $?
  # shellcheck disable=SC2086
  bl64_cnt_run_interactive $BL64_CNT_SET_ENTRYPOINT 'sh' "$container"
}

#######################################
# Runs a container image using interactive settings
#
# * Allows signals
# * Attaches tty
#
# Arguments:
#   $@: arguments are passed as-is
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_module 'BL64_CNT_MODULE' ||
    return $?

  "_bl64_cnt_${BL64_CNT_DRIVER}_run_interactive" "$@"
}

#######################################
# Builds a container source
#
# Arguments:
#   $1: ui context. Format: full path
#   $2: dockerfile path. Format: relative to the build context
#   $3: tag to be applied to the resulting source. Format: docker tag
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_build() {
  bl64_dbg_lib_show_function "$@"
  local context="$1"
  local file="${2:-Dockerfile}"
  local tag="${3:-latest}"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'context' &&
    bl64_check_directory "$context" &&
    bl64_check_file "${context}/${file}" ||
    return $?

  # Remove used parameters
  shift
  shift
  shift

  # shellcheck disable=SC2164
  cd "${context}"

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_BUILD} (Dockerfile: ${file} ${BL64_MSG_COSMETIC_PIPE} Tag: ${tag})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_build" "$file" "$tag" "$@"
}

#######################################
# Push a local source to the target container registry
#
# * Image is already present in the local destination
#
# Arguments:
#   $1: source. Format: IMAGE:TAG
#   $2: destination. Format: REPOSITORY/IMAGE:TAG
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_PUSH} (${source} ${BL64_MSG_COSMETIC_ARROW2} ${destination})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_push" "$source" "$destination"
}

#######################################
# Pull a remote container image to the local registry
#
# Arguments:
#   $1: source. Format: [REPOSITORY/]IMAGE:TAG
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'source' ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_PULL} (${source})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_pull" "$source"
}

function _bl64_cnt_login_put_password() {
  bl64_dbg_lib_show_function "$@"
  local password="$1"
  local file="$2"

  if [[ "$password" != "$BL64_VAR_DEFAULT" ]]; then
    printf '%s\n' "$password"
  elif [[ "$file" != "$BL64_VAR_DEFAULT" ]]; then
    "$BL64_OS_CMD_CAT" "$file"
  elif [[ "$file" == "$BL64_CNT_FLAG_STDIN" ]]; then
    "$BL64_OS_CMD_CAT"
  fi
}

#######################################
# Assigns a new name to an existing image
#
# Arguments:
#   $1: source. Format: image[:tag]
#   $2: target. Format: image[:tag]
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_tag() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local target="$2"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'target' ||
    return $?

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_TAG} (${source} ${BL64_MSG_COSMETIC_ARROW2} ${target})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_tag" "$source" "$target"
}

#######################################
# Runs a container image
#
# Arguments:
#   $@: arguments are passed as-is
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_run() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_module 'BL64_CNT_MODULE' ||
    return $?

  "_bl64_cnt_${BL64_CNT_DRIVER}_run" "$@"
}

#######################################
# Runs the container manager CLI
#
# * Function provided as-is to catch cases where there is no wrapper
# * Calling function must make sure that the current driver supports provided arguments
#
# Arguments:
#   $@: arguments are passed as-is
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_cli() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_module 'BL64_CNT_MODULE' ||
    return $?

  "bl64_cnt_run_${BL64_CNT_DRIVER}" "$@"
}

#######################################
# Determine if the container is running
#
# * Look for one or more instances of the container
# * The container status is Running
# * Filter by one of: name, id
#
# Arguments:
#   $1: name. Exact match
#   $2: id
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: true
#   >0: false or cmd error
#######################################
function bl64_cnt_container_is_running() {
  bl64_dbg_lib_show_function "$@"
  local name="${1:-${BL64_VAR_DEFAULT}}"
  local id="${2:-${BL64_VAR_DEFAULT}}"
  local result=''

  if [[ "$name" == "$BL64_VAR_DEFAULT" && "$id" == "$BL64_VAR_DEFAULT" ]]; then
    bl64_check_alert_parameter_invalid "$BL64_VAR_DEFAULT" "$_BL64_CNT_TXT_MISSING_FILTER (ID, Name)"
    return $?
  fi

  bl64_check_module 'BL64_CNT_MODULE' ||
    return $?

  result="$("_bl64_cnt_${BL64_CNT_DRIVER}_ps_filter" "$name" "$id" "$BL64_CNT_SET_STATUS_RUNNING")" ||
    return $?
  bl64_dbg_lib_show_vars 'result'

  if [[ "$name" != "$BL64_VAR_DEFAULT" ]]; then
    [[ "$result" == "$name" ]]
  elif [[ "$id" == "$BL64_VAR_DEFAULT" ]]; then
    [[ "$result" != "$id" ]]
  fi
}

#######################################
# Determine if the container network is defined
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function bl64_cnt_network_is_defined() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'network' ||
    return $?

  "_bl64_cnt_${BL64_CNT_DRIVER}_network_is_defined" "$network"
}

#######################################
# Create a container network
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function bl64_cnt_network_create() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"

  bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_parameter 'network' ||
    return $?

  if bl64_cnt_network_is_defined "$network"; then
    bl64_msg_show_lib_info "${_BL64_CNT_TXT_EXISTING_NETWORK} (${network})"
    return 0
  fi

  bl64_msg_show_lib_subtask "${_BL64_CNT_TXT_CREATE_NETWORK} (${network})"
  "_bl64_cnt_${BL64_CNT_DRIVER}_network_create" "$network"
}

#
# Docker
#

#######################################
# Command wrapper: docker login
#
# Arguments:
#   $1: user
#   $2: password
#   $3: file
#   $4: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_login() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local password="$2"
  local file="$3"
  local registry="$4"

  # shellcheck disable=SC2086
  _bl64_cnt_login_put_password "$password" "$file" |
    bl64_cnt_run_docker \
      login \
      $BL64_CNT_SET_USERNAME "$user" \
      $BL64_CNT_SET_PASSWORD_STDIN \
      "$registry"
}

#######################################
# Command wrapper: docker run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" || return $?

  # shellcheck disable=SC2086
  bl64_cnt_run_docker \
    run \
    $BL64_CNT_SET_RM \
    $BL64_CNT_SET_INTERACTIVE \
    $BL64_CNT_SET_TTY \
    "$@"

}

#######################################
# Command wrapper: docker
#
# * Provides debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_run_docker() {
  bl64_dbg_lib_show_function "$@"
  local verbose='error'
  local debug=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_command "$BL64_CNT_CMD_DOCKER" ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_CNT_SET_LOG_LEVEL_DEBUG"
    debug="$BL64_CNT_SET_DEBUG"
  fi

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_CNT_CMD_DOCKER" \
    $BL64_CNT_SET_LOG_LEVEL "$verbose" \
    $debug \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper: docker build
#
# Arguments:
#   $1: file
#   $2: tag
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_build() {
  bl64_dbg_lib_show_function "$@"
  local file="$1"
  local tag="$2"

  # Remove used parameters
  shift
  shift

  # shellcheck disable=SC2086
  bl64_cnt_run_docker \
    build \
    --progress plain \
    $BL64_CNT_SET_TAG "$tag" \
    $BL64_CNT_SET_FILE "$file" \
    "$@" .
}

#######################################
# Command wrapper: docker push
#
# Arguments:
#   $1: source
#   $2: destination
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_cnt_run_docker \
    tag \
    "$source" \
    "$destination"

  bl64_cnt_run_docker \
    push \
    "$destination"
}

#######################################
# Command wrapper: docker pull
#
# Arguments:
#   $1: source
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_cnt_run_docker \
    pull \
    "${source}"
}

#######################################
# Command wrapper: docker tag
#
# Arguments:
#   $1: source. Format: image[:tag]
#   $2: target. Format: image[:tag]
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_tag() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local target="$2"

  bl64_cnt_run_docker \
    tag \
    "$source" \
    "$target"
}

#######################################
# Command wrapper: docker run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_docker_run() {
  bl64_dbg_lib_show_function "$@"

  # shellcheck disable=SC2086
  bl64_cnt_run_docker \
    run \
    "$@"

}

#######################################
# Command wrapper: detect network
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_docker_network_is_defined() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"
  local network_id=''

  network_id="$(
    bl64_cnt_run_docker \
      network ls \
      "$BL64_CNT_SET_QUIET" \
      "$BL64_CNT_SET_FILTER" "name=${network}"
  )"

  bl64_dbg_lib_show_info "check if the network is defined ([${network}] == [${network_id}])"
  [[ -n "$network_id" ]]
}

#######################################
# Command wrapper: create network
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_docker_network_create() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"

  bl64_cnt_run_docker \
    network create \
    "$network"
}

#######################################
# Command wrapper: ps with filters
#
# Arguments:
#   $1: name
#   $2: id
#   $3: status
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_docker_ps_filter() {
  bl64_dbg_lib_show_function "$@"
  local name="$1"
  local id="$2"
  local status="$3"
  local format=''
  local filter=''

  if [[ "$name" != "$BL64_VAR_DEFAULT" ]]; then
    filter="$BL64_CNT_SET_FILTER name=${name}"
    format="$BL64_CNT_SET_FILTER_NAME"
  elif [[ "$id" != "$BL64_VAR_DEFAULT" ]]; then
    filter="$BL64_CNT_SET_FILTER id=${id}"
    format="$BL64_CNT_SET_FILTER_ID"
  fi
  [[ "$status" != "$BL64_VAR_DEFAULT" ]] && filter_status="$BL64_CNT_SET_FILTER status=${status}"

  # shellcheck disable=SC2086
  bl64_cnt_run_docker \
    ps \
    ${filter} ${filter_status} --format "$format"
}

#
# Podman
#

#######################################
# Command wrapper: podman login
#
# Arguments:
#   $1: user
#   $2: password
#   $3: file
#   $4: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_login() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local password="$2"
  local file="$3"
  local registry="$4"

  # shellcheck disable=SC2086
  _bl64_cnt_login_put_password "$password" "$file" |
    bl64_cnt_run_podman \
      login \
      $BL64_CNT_SET_USERNAME "$user" \
      $BL64_CNT_SET_PASSWORD_STDIN \
      "$registry"
}

#######################################
# Command wrapper: podman run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" || return $?

  # shellcheck disable=SC2086
  bl64_cnt_run_podman \
    run \
    $BL64_CNT_SET_RM \
    $BL64_CNT_SET_INTERACTIVE \
    $BL64_CNT_SET_TTY \
    "$@"
}

#######################################
# Command wrapper: podman
#
# * Provides debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_cnt_run_podman() {
  bl64_dbg_lib_show_function "$@"
  local verbose='error'

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_CNT_MODULE' &&
    bl64_check_command "$BL64_CNT_CMD_PODMAN" ||
    return $?

  bl64_dbg_lib_command_enabled && verbose="$BL64_CNT_SET_LOG_LEVEL_DEBUG"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_CNT_CMD_PODMAN" \
    $BL64_CNT_SET_LOG_LEVEL "$verbose" \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper: podman build
#
# Arguments:
#   $1: file
#   $2: tag
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_build() {
  bl64_dbg_lib_show_function "$@"
  local file="$1"
  local tag="$2"

  # Remove used parameters
  shift
  shift

  # shellcheck disable=SC2086
  bl64_cnt_run_podman \
    build \
    $BL64_CNT_SET_TAG "$tag" \
    $BL64_CNT_SET_FILE "$file" \
    "$@" .
}

#######################################
# Command wrapper: podman push
#
# Arguments:
#   $1: source
#   $2: destination
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_cnt_run_podman \
    push \
    "localhost/${source}" \
    "$destination"
}

#######################################
# Command wrapper: podman pull
#
# Arguments:
#   $1: source
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_cnt_run_podman \
    pull \
    "${source}"
}

#######################################
# Command wrapper: podman tag
#
# Arguments:
#   $1: source. Format: image[:tag]
#   $2: target. Format: image[:tag]
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_tag() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local target="$2"

  bl64_cnt_run_podman \
    tag \
    "$source" \
    "$target"
}

#######################################
# Command wrapper: podman run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function _bl64_cnt_podman_run() {
  bl64_dbg_lib_show_function "$@"

  bl64_cnt_run_podman \
    run \
    "$@"
}

#######################################
# Command wrapper: detect network
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_podman_network_is_defined() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"
  local network_id=''

  network_id="$(
    bl64_cnt_run_podman \
      network ls \
      "$BL64_CNT_SET_QUIET" \
      "$BL64_CNT_SET_FILTER" "name=${network}"
  )"

  bl64_dbg_lib_show_info "check if the network is defined ([${network}] == [${network_id}])"
  [[ -n "$network_id" ]]
}

#######################################
# Command wrapper: create network
#
# Arguments:
#   $1: network name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_podman_network_create() {
  bl64_dbg_lib_show_function "$@"
  local network="$1"

  bl64_cnt_run_podman \
    network create \
    "$network"
}

#######################################
# Command wrapper: ps with filters
#
# Arguments:
#   $1: name
#   $2: id
#   $3: status
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: defined
#   >0: not defined or error
#######################################
function _bl64_cnt_podman_ps_filter() {
  bl64_dbg_lib_show_function "$@"
  local name="$1"
  local id="$2"
  local status="$3"
  local format=''
  local filter=''

  if [[ "$name" != "$BL64_VAR_DEFAULT" ]]; then
    filter="$BL64_CNT_SET_FILTER name=${name}"
    format='{{.NAME}}'
  elif [[ "$id" != "$BL64_VAR_DEFAULT" ]]; then
    filter="$BL64_CNT_SET_FILTER id=${id}"
    format="$BL64_CNT_SET_FILTER_ID"
  fi
  [[ "$status" != "$BL64_VAR_DEFAULT" ]] && filter_status="$BL64_CNT_SET_FILTER status=${status}"

  # shellcheck disable=SC2086
  bl64_cnt_run_podman \
    ps \
    ${filter} ${filter_status} --format "$format"
}

#######################################
# BashLib64 / Module / Setup / Interact with GCP
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_gcp_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local gcloud_bin="${1:-${BL64_VAR_DEFAULT}}"

  _bl64_gcp_set_command "$gcloud_bin" &&
    _bl64_gcp_set_options &&
    bl64_check_command "$BL64_GCP_CMD_GCLOUD" &&
    BL64_GCP_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'gcp'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_gcp_set_command() {
  bl64_dbg_lib_show_function "$@"
  local gcloud_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$gcloud_bin" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/gcloud' ]]; then
      gcloud_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/gcloud' ]]; then
      gcloud_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/gcloud' ]]; then
      gcloud_bin='/usr/local/bin'
    elif [[ -x '/usr/bin/gcloud' ]]; then
      gcloud_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'gcloud'
      return $?
    fi
  fi

  bl64_check_directory "$gcloud_bin" || return $?
  [[ -x "${gcloud_bin}/gcloud" ]] && BL64_GCP_CMD_GCLOUD="${gcloud_bin}/gcloud"

  bl64_dbg_lib_show_vars 'BL64_GCP_CMD_GCLOUD'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_gcp_set_options() {
  bl64_dbg_lib_show_function

  BL64_GCP_SET_FORMAT_YAML='--format yaml'
  BL64_GCP_SET_FORMAT_TEXT='--format text'
  BL64_GCP_SET_FORMAT_JSON='--format json'
}

#######################################
# Set target GCP Project
#
# * Available to all gcloud related commands
#
# Arguments:
#   $1: GCP project ID
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function bl64_gcp_set_project() {
  bl64_dbg_lib_show_function "$@"
  local project="${1:-}"

  bl64_check_parameter 'project' || return $?

  BL64_GCP_CLI_PROJECT="$project"

  bl64_dbg_lib_show_vars 'BL64_GCP_CLI_PROJECT'
  return 0
}

#######################################
# Enable service account impersonation
#
# * Available to all gcloud related commands
#
# Arguments:
#   $1: Service Account email
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function bl64_gcp_set_impersonate_sa() {
  bl64_dbg_lib_show_function "$@"
  local impersonate_sa="${1:-}"

  bl64_check_parameter 'impersonate_sa' || return $?

  BL64_GCP_CLI_IMPERSONATE_SA="$impersonate_sa"

  bl64_dbg_lib_show_vars 'BL64_GCP_CLI_IMPERSONATE_SA'
  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with GCP
#######################################

#######################################
# Command wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_gcp_run_gcloud() {
  bl64_dbg_lib_show_function "$@"
  bl64_check_parameters_none "$#" || return $?
  local debug=' '
  local config=' '
  local project=' '
  local impersonate_sa=' '

  bl64_check_module 'BL64_GCP_MODULE' ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    debug='--verbosity debug --log-http'
  else
    debug='--verbosity none --quiet'
  fi

  bl64_gcp_blank_gcloud
  [[ -n "$BL64_GCP_CLI_PROJECT" ]] && project="--project=${BL64_GCP_CLI_PROJECT}"
  [[ -n "$BL64_GCP_CLI_IMPERSONATE_SA" ]] && impersonate_sa="--impersonate-service-account=${BL64_GCP_CLI_IMPERSONATE_SA}"
  [[ "$BL64_GCP_CONFIGURATION_CREATED" == "$BL64_VAR_TRUE" ]] && config="--configuration $BL64_GCP_CONFIGURATION_NAME"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_GCP_CMD_GCLOUD" \
    $debug \
    $config \
    $project \
    $impersonate_sa \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Login to GCP using a Service Account
#
# * key must be in json format
# * previous credentials are revoked
#
# Arguments:
#   $1: key file full path
#   $2: project id
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_gcp_login_sa() {
  bl64_dbg_lib_show_function "$@"
  local key_file="$1"
  local project="$2"

  bl64_check_parameter 'key_file' &&
    bl64_check_parameter 'project' &&
    bl64_check_file "$key_file" || return $?

  _bl64_gcp_configure

  bl64_dbg_lib_show_info 'remove previous credentials'
  bl64_gcp_run_gcloud \
    auth \
    revoke \
    --all

  bl64_dbg_lib_show_info 'login to gcp'
  bl64_gcp_run_gcloud \
    auth \
    activate-service-account \
    --key-file "$key_file" \
    --project "$project"
}

function _bl64_gcp_configure() {
  bl64_dbg_lib_show_function

  if [[ "$BL64_GCP_CONFIGURATION_CREATED" == "$BL64_VAR_FALSE" ]]; then

    bl64_dbg_lib_show_info 'create BL64_GCP_CONFIGURATION'
    bl64_gcp_run_gcloud \
      config \
      configurations \
      create "$BL64_GCP_CONFIGURATION_NAME" &&
      BL64_GCP_CONFIGURATION_CREATED="$BL64_VAR_TRUE"

  else
    :
  fi
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_gcp_blank_gcloud() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited _* shell variables'
  bl64_dbg_lib_trace_start
  unset CLOUDSDK_CONFIG
  unset CLOUDSDK_ACTIVE_CONFIG_NAME

  unset CLOUDSDK_AUTH_ACCESS_TOKEN_FILE
  unset CLOUDSDK_AUTH_DISABLE_CREDENTIALS
  unset CLOUDSDK_AUTH_IMPERSONATE_SERVICE_ACCOUNT
  unset CLOUDSDK_AUTH_TOKEN_HOST

  unset CLOUDSDK_CORE_ACCOUNT
  unset CLOUDSDK_CORE_CONSOLE_LOG_FORMAT
  unset CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE
  unset CLOUDSDK_CORE_DEFAULT_REGIONAL_BACKEND_SERVICE
  unset CLOUDSDK_CORE_DISABLE_COLOR
  unset CLOUDSDK_CORE_DISABLE_FILE_LOGGING
  unset CLOUDSDK_CORE_DISABLE_PROMPTS
  unset CLOUDSDK_CORE_DISABLE_USAGE_REPORTING
  unset CLOUDSDK_CORE_ENABLE_FEATURE_FLAGS
  unset CLOUDSDK_CORE_LOG_HTTP
  unset CLOUDSDK_CORE_MAX_LOG_DAYS
  unset CLOUDSDK_CORE_PASS_CREDENTIALS_TO_GSUTIL
  unset CLOUDSDK_CORE_PROJECT
  unset CLOUDSDK_CORE_SHOW_STRUCTURED_LOGS
  unset CLOUDSDK_CORE_TRACE_TOKEN
  unset CLOUDSDK_CORE_USER_OUTPUT_ENABLED
  unset CLOUDSDK_CORE_VERBOSITY
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# GCP Secrets / Get secret value
#
# * Warning: not intended for Binary payloads as gcloud will return UTF-8 by default
#
# Arguments:
#   $1: Secret Name
#   $2: Version Number
# Outputs:
#   STDOUT: secret value
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_gcp_secret_get() {
  bl64_dbg_lib_show_function "$@"
  local name="$1"
  local secret_version="$2"

  bl64_check_parameter 'name' &&
    bl64_check_parameter 'secret_version' &&
    bl64_check_file "$name" || return $?

  bl64_gcp_run_gcloud \
    'secrets' \
    'versions' \
    'access' \
    "$secret_version" \
    --secret="$name"

}

#######################################
# BashLib64 / Module / Setup / Interact with HLM
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_hlm_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local helm_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$helm_bin" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_check_directory "$helm_bin" ||
      return $?
  fi

  bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    _bl64_hlm_set_command "$helm_bin" &&
    bl64_check_command "$BL64_HLM_CMD_HELM" &&
    _bl64_hlm_set_options &&
    _bl64_hlm_set_runtime &&
    BL64_HLM_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'hlm'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_hlm_set_command() {
  bl64_dbg_lib_show_function "$@"
  local helm_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$helm_bin" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/helm' ]]; then
      helm_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/helm' ]]; then
      helm_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/helm' ]]; then
      helm_bin='/usr/local/bin'
    elif [[ -x '/opt/helm/bin/helm' ]]; then
      helm_bin='/opt/helm/bin'
    elif [[ -x '/usr/bin/helm' ]]; then
      helm_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'helm'
      return $?
    fi
  fi

  bl64_check_directory "$helm_bin" || return $?
  [[ -x "${helm_bin}/helm" ]] && BL64_HLM_CMD_HELM="${helm_bin}/helm"

  bl64_dbg_lib_show_vars 'BL64_HLM_CMD_HELM'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_hlm_set_options() {
  bl64_dbg_lib_show_function

  BL64_HLM_SET_DEBUG='--debug'
  BL64_HLM_SET_OUTPUT_TABLE='--output table'
  BL64_HLM_SET_OUTPUT_JSON='--output json'
  BL64_HLM_SET_OUTPUT_YAML='--output yaml'
}

#######################################
# Set runtime defaults
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_hlm_set_runtime() {
  bl64_dbg_lib_show_function

  bl64_hlm_set_timeout '5m0s'
}

#######################################
# Update runtime variables: timeout
#
# Arguments:
#   $1: timeout value. Format: same as helm --timeout parameter
# Outputs:
#   STDOUT: None
#   STDERR: Validation
# Returns:
#   0: set ok
#   >0: set error
#######################################
function bl64_hlm_set_timeout() {
  bl64_dbg_lib_show_function "$@"
  local timeout="$1"

  bl64_check_parameter 'timeout' || return $?

  BL64_HLM_RUN_TIMEOUT="$timeout"
}

#######################################
# BashLib64 / Module / Functions / Interact with HLM
#######################################

#######################################
# Add a helm repository to the local host
#
# Arguments:
#   $1: repository name
#   $2: repository source
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_hlm_repo_add() {
  bl64_dbg_lib_show_function "$@"
  local repository="${1:-}"
  local source="${2:-}"

  bl64_check_parameter 'repository' &&
    bl64_check_parameter 'source' ||
    return $?

  bl64_msg_show_lib_subtask "${BL64_HLM_TXT_ADD_REPO} (${repository} ${BL64_MSG_COSMETIC_LEFT_ARROW2} ${source})"
  bl64_hlm_run_helm \
    repo add \
    "$repository" \
    "$source" ||
    return $?

  bl64_msg_show_lib_subtask "${BL64_HLM_TXT_UPDATE_REPO} (${repository})"
  bl64_hlm_run_helm repo update "$repository"

  return 0
}

#######################################
# Upgrade or install helm existing chart
#
# * Using atomic and cleanup to ensure deployment integrity
#
# Arguments:
#   $1: full path to the kube/config file with cluster credentials
#   $2: target namespace
#   $3: chart name
#   $4: chart source
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_hlm_chart_upgrade() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-}"
  local namespace="${2:-}"
  local chart="${3:-}"
  local source="${4:-}"

    bl64_check_parameter 'namespace' &&
    bl64_check_parameter 'chart' &&
    bl64_check_parameter 'source' &&
    bl64_check_file "$kubeconfig" ||
    return $?

  [[ "$kubeconfig" == "$BL64_VAR_DEFAULT" ]] && kubeconfig=''

  shift
  shift
  shift
  shift

  bl64_msg_show_lib_subtask "${BL64_HLM_TXT_DEPLOY_CHART} (${namespace}/${chart})"
  bl64_hlm_run_helm \
    upgrade \
    "$chart" \
    "$source" \
    ${kubeconfig:+--kubeconfig="$kubeconfig"} \
    --namespace "$namespace" \
    --timeout "$BL64_HLM_RUN_TIMEOUT" \
    --create-namespace \
    --atomic \
    --cleanup-on-fail \
    --install \
    --wait \
    "$@"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_hlm_run_helm() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_HLM_MODULE' ||
    return $?

  bl64_dbg_lib_command_enabled && verbosity="$BL64_HLM_SET_DEBUG"
  bl64_hlm_blank_helm

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_HLM_CMD_HELM" \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_hlm_blank_helm() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited HELM_* shell variables'
  bl64_dbg_lib_trace_start
  unset HELM_CACHE_HOME
  unset HELM_CONFIG_HOME
  unset HELM_DATA_HOME
  unset HELM_DEBUG
  unset HELM_DRIVER
  unset HELM_DRIVER_SQL_CONNECTION_STRING
  unset HELM_MAX_HISTORY
  unset HELM_NAMESPACE
  unset HELM_NO_PLUGINS
  unset HELM_PLUGINS
  unset HELM_REGISTRY_CONFIG
  unset HELM_REPOSITORY_CACHE
  unset HELM_REPOSITORY_CONFIG
  unset HELM_KUBEAPISERVER
  unset HELM_KUBECAFILE
  unset HELM_KUBEASGROUPS
  unset HELM_KUBEASUSER
  unset HELM_KUBECONTEXT
  unset HELM_KUBETOKEN
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# BashLib64 / Module / Setup / Interact with Kubernetes
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_k8s_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local kubectl_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$kubectl_bin" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_check_directory "$kubectl_bin" ||
      return $?
  fi

  bl64_check_module_imported 'BL64_CHECK_MODULE' &&
    bl64_check_module_imported 'BL64_DBG_MODULE' &&
    bl64_check_module_imported 'BL64_MSG_MODULE' &&
    bl64_check_module_imported 'BL64_TXT_MODULE' &&
    _bl64_k8s_set_command "$kubectl_bin" &&
    bl64_check_command "$BL64_K8S_CMD_KUBECTL" &&
    _bl64_k8s_set_version &&
    _bl64_k8s_set_options &&
    _bl64_k8s_set_runtime &&
    BL64_K8S_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'k8s'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_k8s_set_command() {
  bl64_dbg_lib_show_function "$@"
  local kubectl_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$kubectl_bin" == "$BL64_VAR_DEFAULT" ]]; then
    bl64_dbg_lib_show_info 'no custom path provided. Using known locations to detect ansible'
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/kubectl' ]]; then
      kubectl_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/kubectl' ]]; then
      kubectl_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/kubectl' ]]; then
      kubectl_bin='/usr/local/bin'
    elif [[ -x '/usr/bin/kubectl' ]]; then
      kubectl_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'kubectl'
      return $?
    fi
  fi

  bl64_check_directory "$kubectl_bin" || return $?
  [[ -x "${kubectl_bin}/kubectl" ]] && BL64_K8S_CMD_KUBECTL="${kubectl_bin}/kubectl"

  bl64_dbg_lib_show_vars 'BL64_K8S_CMD_KUBECTL'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_k8s_set_options() {
  bl64_dbg_lib_show_function

  case "$BL64_K8S_VERSION_KUBECTL" in
  1.22 | 1.23 | 1.24 | 1.25 | 1.26 | 1.27 | 1.28)
    BL64_K8S_SET_VERBOSE_NONE='--v=0'
    BL64_K8S_SET_VERBOSE_NORMAL='--v=2'
    BL64_K8S_SET_VERBOSE_DEBUG='--v=4'
    BL64_K8S_SET_VERBOSE_TRACE='--v=6'

    BL64_K8S_SET_OUTPUT_JSON='--output=json'
    BL64_K8S_SET_OUTPUT_YAML='--output=yaml'
    BL64_K8S_SET_OUTPUT_TXT='--output=wide'
    BL64_K8S_SET_OUTPUT_NAME='--output=name'

    BL64_K8S_SET_DRY_RUN_SERVER='--dry-run=server'
    BL64_K8S_SET_DRY_RUN_CLIENT='--dry-run=client'
    ;;
  *)
    bl64_check_compatibility_mode "k8s-api: ${BL64_K8S_VERSION_KUBECTL}" || return $?
    BL64_K8S_SET_VERBOSE_NONE='--v=0'
    BL64_K8S_SET_VERBOSE_NORMAL='--v=2'
    BL64_K8S_SET_VERBOSE_DEBUG='--v=4'
    BL64_K8S_SET_VERBOSE_TRACE='--v=6'

    BL64_K8S_SET_OUTPUT_JSON='--output=json'
    BL64_K8S_SET_OUTPUT_YAML='--output=yaml'
    BL64_K8S_SET_OUTPUT_TXT='--output=wide'
    BL64_K8S_SET_OUTPUT_NAME='--output=name'

    BL64_K8S_SET_DRY_RUN_SERVER='--dry-run=server'
    BL64_K8S_SET_DRY_RUN_CLIENT='--dry-run=client'
    ;;
  esac
}

#######################################
# Identify and set module components versions
#
# * Version information is stored in module global variables
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: command errors
# Returns:
#   0: version set ok
#   >0: command error
#######################################
function _bl64_k8s_set_version() {
  bl64_dbg_lib_show_function
  local cli_version=''

  bl64_dbg_lib_show_info "run kubectl to obtain client version"
  cli_version="$(_bl64_k8s_get_version_1_22)"
  bl64_dbg_lib_show_vars 'cli_version'

  if [[ -n "$cli_version" ]]; then
    BL64_K8S_VERSION_KUBECTL="$cli_version"
  else
    bl64_msg_show_error "$_BL64_K8S_TXT_ERROR_KUBECTL_VERSION"
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  bl64_dbg_lib_show_vars 'BL64_K8S_VERSION_KUBECTL'
  return 0
}

function _bl64_k8s_get_version_1_22() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info "try with kubectl v1.22 options"
  # shellcheck disable=SC2086
  "$BL64_K8S_CMD_KUBECTL" version --client --output=json |
    bl64_txt_run_awk $BL64_TXT_SET_AWS_FS ':' '
    $1 ~ /^ +"major"$/ { gsub( /[" ,]/, "", $2 ); Major = $2 }
    $1 ~ /^ +"minor"$/ { gsub( /[" ,]/, "", $2 ); Minor = $2 }
    END { print Major "." Minor }
  '
}

#######################################
# Set runtime defaults
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: setting errors
# Returns:
#   0: set ok
#   >0: failed to set
#######################################
function _bl64_k8s_set_runtime() {
  bl64_dbg_lib_show_function

  bl64_k8s_set_kubectl_output
}

#######################################
# Set default output type for kubectl
#
# * Not global, the function that needs to use the default must read the variable BL64_K8S_CFG_KUBECTL_OUTPUT
# * Not all types are supported. The calling function is reponsible for checking compatibility
#
# Arguments:
#   $1: output type. Default: json. One of BL64_K8S_CFG_KUBECTL_OUTPUT_*
# Outputs:
#   STDOUT: None
#   STDERR: parameter error
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_PARAMETER_INVALID
#######################################
# shellcheck disable=SC2120
function bl64_k8s_set_kubectl_output() {
  bl64_dbg_lib_show_function "$@"
  local output="${1:-${BL64_K8S_CFG_KUBECTL_OUTPUT_JSON}}"

  case "$output" in
  "$BL64_K8S_CFG_KUBECTL_OUTPUT_JSON") BL64_K8S_CFG_KUBECTL_OUTPUT="$BL64_K8S_SET_OUTPUT_JSON" ;;
  "$BL64_K8S_CFG_KUBECTL_OUTPUT_YAML") BL64_K8S_CFG_KUBECTL_OUTPUT="$BL64_K8S_SET_OUTPUT_YAML" ;;
  *) bl64_check_alert_parameter_invalid ;;
  esac
}

#######################################
# BashLib64 / Module / Functions / Interact with Kubernetes
#######################################

#######################################
# Set label on resource
#
# * Overwrite existing
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: resource type
#   $3: resource name
#   $4: label name
#   $5: label value
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_label_set() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local resource="${2:-${BL64_VAR_NULL}}"
  local name="${3:-${BL64_VAR_NULL}}"
  local key="${4:-${BL64_VAR_NULL}}"
  local value="${5:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'resource' &&
    bl64_check_parameter 'name' &&
    bl64_check_parameter 'key' &&
    bl64_check_parameter 'value' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_SET_LABEL} (${resource}/${name}/${key})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl \
    "$kubeconfig" \
    'label' $verbosity \
    --overwrite \
    "$resource" \
    "$name" \
    "$key"="$value"
}

#######################################
# Set annotation on resource
#
# * Overwrite existing
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: namespace. If not required assign $BL64_VAR_NONE
#   $2: resource type
#   $3: resource name
#   $@: remaining args are passed as is. Use the syntax: key=value
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_annotation_set() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace="${2:-${BL64_VAR_NONE}}"
  local resource="${3:-${BL64_VAR_NULL}}"
  local name="${4:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'resource' &&
    bl64_check_parameter 'name' ||
    return $?

  shift
  shift
  shift
  shift

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"
  [[ "$namespace" == "$BL64_VAR_NONE" ]] && namespace='' || namespace="--namespace ${namespace}"

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_SET_ANNOTATION} (${resource}/${name})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl \
    "$kubeconfig" \
    'annotate' $verbosity $namespace \
    --overwrite \
    "$resource" \
    "$name" \
    "$@"
}

#######################################
# Create namespace
#
# * If already created do nothing
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: namespace name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_namespace_create() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace="${2:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'namespace' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"

  if bl64_k8s_resource_is_created "$kubeconfig" "$BL64_K8S_RESOURCE_NS" "$namespace"; then
    bl64_msg_show_lib_info "${_BL64_K8S_TXT_RESOURCE_EXISTING} (${_BL64_K8S_TXT_CREATE_NS}:${namespace})"
    return 0
  fi

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_CREATE_NS} (${namespace})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl "$kubeconfig" \
    'create' $verbosity "$BL64_K8S_RESOURCE_NS" "$namespace"
}

#######################################
# Create service account
#
# * If already created do nothing
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: target namespace
#   $3: service account name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_sa_create() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace="${2:-${BL64_VAR_NULL}}"
  local sa="${3:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'namespace' &&
    bl64_check_parameter 'sa' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"

  if bl64_k8s_resource_is_created "$kubeconfig" "$BL64_K8S_RESOURCE_SA" "$sa" "$namespace"; then
    bl64_msg_show_lib_info "${_BL64_K8S_TXT_RESOURCE_EXISTING} (${_BL64_K8S_TXT_CREATE_SA}:${sa})"
    return 0
  fi

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_CREATE_SA} (${namespace}/${sa})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl "$kubeconfig" \
    'create' $verbosity --namespace="$namespace" "$BL64_K8S_RESOURCE_SA" "$sa"
}

#######################################
# Create generic secret from file
#
# * If already created do nothing
# * File must containe the secret value only
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: target namespace
#   $3: secret name
#   $4: secret key
#   $5: path to the file with the secret value
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_secret_create() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace="${2:-${BL64_VAR_NULL}}"
  local secret="${3:-${BL64_VAR_NULL}}"
  local key="${4:-${BL64_VAR_NULL}}"
  local file="${5:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'namespace' &&
    bl64_check_parameter 'secret' &&
    bl64_check_parameter 'file' &&
    bl64_check_file "$file" ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"

  if bl64_k8s_resource_is_created "$kubeconfig" "$BL64_K8S_RESOURCE_SECRET" "$secret" "$namespace"; then
    bl64_msg_show_lib_info "${_BL64_K8S_TXT_RESOURCE_EXISTING} (${BL64_K8S_RESOURCE_SECRET}:${secret})"
    return 0
  fi

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_CREATE_SECRET} (${namespace}/${secret}/${key})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl "$kubeconfig" \
    'create' $verbosity --namespace="$namespace" \
    "$BL64_K8S_RESOURCE_SECRET" 'generic' "$secret" \
    --type 'Opaque' \
    --from-file="${key}=${file}"
}

#######################################
# Copy secret between namespaces
#
# * If already created do nothing
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: source namespace
#   $3: target namespace
#   $4: secret name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_secret_copy() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace_src="${2:-${BL64_VAR_NULL}}"
  local namespace_dst="${3:-${BL64_VAR_NULL}}"
  local secret="${4:-${BL64_VAR_NULL}}"
  local resource=''
  local -i status=0

  bl64_check_parameter 'namespace_src' &&
    bl64_check_parameter 'namespace_dst' &&
    bl64_check_parameter 'secret' ||
    return $?

  if bl64_k8s_resource_is_created "$kubeconfig" "$BL64_K8S_RESOURCE_SECRET" "$secret" "$namespace_dst"; then
    bl64_msg_show_lib_info "${_BL64_K8S_TXT_RESOURCE_EXISTING} (${BL64_K8S_RESOURCE_SECRET}:${secret})"
    return 0
  fi

  resource="$($BL64_FS_CMD_MKTEMP)" || return $?

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_GET_SECRET} (${namespace_src}/${secret})"
  bl64_k8s_resource_get "$kubeconfig" "$BL64_K8S_RESOURCE_SECRET" "$secret" "$namespace_src" |
    bl64_txt_run_awk $BL64_TXT_SET_AWS_FS ':' '
      BEGIN { metadata = 0 }
      $1 ~ /"metadata"/ { metadata = 1 }
      metadata == 1 && $1 ~ /"namespace"/ { metadata = 0; next }
      { print $0 }
      ' >"$resource"
  status=$?

  if ((status == 0)); then
    bl64_msg_show_lib_task "${_BL64_K8S_TXT_CREATE_SECRET} (${namespace_dst}/${secret})"
    bl64_k8s_resource_update "$kubeconfig" "$namespace_dst" "$resource"
    status=$?
  fi

  [[ -f "$resource" ]] && bl64_fs_rm_file "$resource"
  return $status
}

#######################################
# Apply updates to resources based on definition file
#
# * Overwrite
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: namespace where resources are
#   $3: full path to the resource definition file
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_resource_update() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local namespace="${2:-${BL64_VAR_NULL}}"
  local definition="${3:-${BL64_VAR_NULL}}"
  local verbosity=''

  bl64_check_parameter 'namespace' &&
    bl64_check_parameter 'definition' &&
    bl64_check_file "$definition" ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_CFG_KUBECTL_OUTPUT"

  bl64_msg_show_lib_task "${_BL64_K8S_TXT_RESOURCE_UPDATE} (${definition} -> ${namespace})"
  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl \
    "$kubeconfig" \
    'apply' $verbosity \
    --namespace="$namespace" \
    --force='false' \
    --force-conflicts='false' \
    --grace-period='-1' \
    --overwrite='true' \
    --validate='strict' \
    --wait='true' \
    --filename="$definition"
}

#######################################
# Get resource definition
#
# * output type is json
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: resource type
#   $3: resource name
#   $4: namespace where resources are (optional)
# Outputs:
#   STDOUT: resource definition
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_resource_get() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local resource="${2:-${BL64_VAR_NULL}}"
  local name="${3:-${BL64_VAR_NULL}}"
  local namespace="${4:-}"

  bl64_check_parameter 'resource' &&
    bl64_check_parameter 'name' ||
    return $?

  [[ -n "$namespace" ]] && namespace="--namespace ${namespace}"

  # shellcheck disable=SC2086
  bl64_k8s_run_kubectl \
    "$kubeconfig" \
    'get' $BL64_K8S_SET_OUTPUT_JSON \
    $namespace "$resource" "$name"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster. Use BL64_VAR_DEFAULT to leave default
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_run_kubectl() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-}"
  local verbosity="$BL64_K8S_SET_VERBOSE_NONE"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_K8S_MODULE' ||
    return $?
  shift
  bl64_check_parameters_none "$#" "$_BL64_K8S_TXT_ERROR_MISSING_COMMAND" ||
    return $?

  if [[ "$kubeconfig" == "$BL64_VAR_DEFAULT" ]]; then
    kubeconfig=''
  else
    bl64_check_file "$kubeconfig" "$_BL64_K8S_TXT_ERROR_INVALID_KUBECONF" ||
      return $?
    kubeconfig="--kubeconfig=${kubeconfig}"
  fi

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_K8S_SET_VERBOSE_NORMAL"
  bl64_dbg_lib_command_enabled && verbosity="$BL64_K8S_SET_VERBOSE_TRACE"

  bl64_k8s_blank_kubectl
  bl64_dbg_lib_command_trace_start
  # shellcheck disable=SC2086
  "$BL64_K8S_CMD_KUBECTL" \
    $kubeconfig \
    $verbosity \
    "$@"
  bl64_dbg_lib_command_trace_stop
}

#######################################
# Command wrapper with trace option for calling kubectl plugins
#
# * Tracing is the only possible option to cover plugins as they have their own set of parameters
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster. Use BL64_VAR_DEFAULT to leave default
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_k8s_run_kubectl_plugin() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-}"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_K8S_MODULE' ||
    return $?
  shift
  bl64_check_parameters_none "$#" "$_BL64_K8S_TXT_ERROR_MISSING_COMMAND" ||
    return $?

  bl64_k8s_blank_kubectl
  if [[ "$kubeconfig" != "$BL64_VAR_DEFAULT" ]]; then
    bl64_check_file "$kubeconfig" "$_BL64_K8S_TXT_ERROR_INVALID_KUBECONF" ||
      return $?
    export KUBECONFIG="$kubeconfig"
  fi

  bl64_dbg_lib_command_trace_start
  # shellcheck disable=SC2086
  "$BL64_K8S_CMD_KUBECTL" \
    "$@"
  bl64_dbg_lib_command_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_k8s_blank_kubectl() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited HELM_* shell variables'
  bl64_dbg_lib_trace_start
  unset POD_NAMESPACE
  unset KUBECONFIG
  bl64_dbg_lib_trace_stop

  return 0
}

#######################################
# Verify that the resource is created
#
# Arguments:
#   $1: full path to the kube/config file for the target cluster
#   $2: resource type
#   $3: resource name
#   $4: namespace where resources are
# Outputs:
#   STDOUT: nothing
#   STDERR: nothing unless debug
# Returns:
#   0: resource exists
#   >0: resources does not exist or execution error
#######################################
function bl64_k8s_resource_is_created() {
  bl64_dbg_lib_show_function "$@"
  local kubeconfig="${1:-${BL64_VAR_NULL}}"
  local type="${2:-${BL64_VAR_NULL}}"
  local name="${3:-${BL64_VAR_NULL}}"
  local namespace="${4:-}"

  bl64_check_parameter 'type' &&
    bl64_check_parameter 'name' ||
    return $?

  [[ -n "$namespace" ]] && namespace="--namespace ${namespace}"

  # shellcheck disable=SC2086
  if bl64_dbg_lib_task_enabled; then
    bl64_k8s_run_kubectl "$kubeconfig" \
      'get' "$type" "$name" \
      $BL64_K8S_SET_OUTPUT_NAME $namespace
  else
    bl64_k8s_run_kubectl "$kubeconfig" \
      'get' "$type" "$name" \
      $BL64_K8S_SET_OUTPUT_NAME $namespace >/dev/null 2>&1
  fi
}

#######################################
# BashLib64 / Module / Setup / Interact with MongoDB
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_mdb_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local mdb_bin="${1:-${BL64_VAR_DEFAULT}}"

  _bl64_mdb_set_command "$mdb_bin" &&
    bl64_check_command "$BL64_MDB_CMD_MONGOSH" &&
    bl64_check_command "$BL64_MDB_CMD_MONGORESTORE" &&
    bl64_check_command "$BL64_MDB_CMD_MONGOEXPORT" &&
    _bl64_mdb_set_options &&
    _bl64_mdb_set_runtime &&
    BL64_MDB_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'mdb'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_mdb_set_command() {
  bl64_dbg_lib_show_function "$@"
  local mdb_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$mdb_bin" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/mongosh' ]]; then
      mdb_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/mongosh' ]]; then
      mdb_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/mongosh' ]]; then
      mdb_bin='/usr/local/bin'
    elif [[ -x '/opt/mongosh/bin/mongosh' ]]; then
      mdb_bin='/opt/mongosh/bin'
    elif [[ -x '/usr/bin/mongosh' ]]; then
      mdb_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'mongo-shell'
      return $?
    fi
  fi

  bl64_check_directory "$mdb_bin" || return $?
  [[ -x "${mdb_bin}/mongosh" ]] && BL64_MDB_CMD_MONGOSH="${mdb_bin}/mongosh"
  [[ -x "${mdb_bin}/mongorestore" ]] && BL64_MDB_CMD_MONGORESTORE="${mdb_bin}/mongorestore"
  [[ -x "${mdb_bin}/mongoexport" ]] && BL64_MDB_CMD_MONGOEXPORT="${mdb_bin}/mongoexport"

  bl64_dbg_lib_show_vars 'BL64_MDB_CMD_MONGOSH'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_mdb_set_options() {
  bl64_dbg_lib_show_function

  BL64_MDB_SET_VERBOSE='--verbose'
  BL64_MDB_SET_QUIET='--quiet'
  BL64_MDB_SET_NORC='--norc'
}

#######################################
# Set runtime variables
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_mdb_set_runtime() {
  bl64_dbg_lib_show_function

  # Write concern defaults
  BL64_MDB_REPLICA_WRITE='majority'
  BL64_MDB_REPLICA_TIMEOUT='1000'
}

#######################################
# BashLib64 / Module / Setup / Interact with MongoDB
#######################################

#######################################
# Restore mongodb dump
#
# * Restore user must exist on authdb and have restore permissions on the target DB
#
# Arguments:
#   $1: full path to the dump file
#   $2: target db name
#   $3: authdb name
#   $4: restore user name
#   $5: restore user password
#   $6: host where mongodb is
#   $7: mongodb tcp port
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_dump_restore() {
  bl64_dbg_lib_show_function "$@"
  local dump="${1:-${BL64_VAR_DEFAULT}}"
  local db="${2:-${BL64_VAR_DEFAULT}}"
  local authdb="${3:-${BL64_VAR_DEFAULT}}"
  local user="${4:-${BL64_VAR_DEFAULT}}"
  local password="${5:-${BL64_VAR_DEFAULT}}"
  local host="${6:-${BL64_VAR_DEFAULT}}"
  local port="${7:-${BL64_VAR_DEFAULT}}"
  local include=' '

  bl64_check_parameter 'dump' &&
    bl64_check_directory "$dump" ||
    return $?

  [[ "$db" != "$BL64_VAR_DEFAULT" ]] && include="--nsInclude=${db}.*" && db="--db=${db}" || db=' '
  [[ "$user" != "$BL64_VAR_DEFAULT" ]] && user="--username=${user}" || user=' '
  [[ "$password" != "$BL64_VAR_DEFAULT" ]] && password="--password=${password}" || password=' '
  [[ "$host" != "$BL64_VAR_DEFAULT" ]] && host="--host=${host}" || host=' '
  [[ "$port" != "$BL64_VAR_DEFAULT" ]] && port="--port=${port}" || port=' '
  [[ "$authdb" != "$BL64_VAR_DEFAULT" ]] && authdb="--authenticationDatabase=${authdb}" || authdb=' '

  # shellcheck disable=SC2086
  bl64_mdb_run_mongorestore \
    --writeConcern="{ w: '${BL64_MDB_REPLICA_WRITE}', j: true, wtimeout: ${BL64_MDB_REPLICA_TIMEOUT} }" \
    --stopOnError \
    $db \
    $include \
    $user \
    $password \
    $host \
    $port \
    $authdb \
    --dir="$dump"

}

#######################################
# Grants role to use in target DB
#
# * You must have the grantRole action on a database to grant a role on that database.
#
# Arguments:
#   $1: connection URI
#   $2: role name
#   $3: user name
#   $4: db where user and role are. Default: admin.
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_role_grant() {
  bl64_dbg_lib_show_function "$@"
  local uri="${1:-${BL64_VAR_DEFAULT}}"
  local role="${2:-${BL64_VAR_DEFAULT}}"
  local user="${3:-${BL64_VAR_DEFAULT}}"
  local db="${4:-admin}"

  bl64_check_parameter 'uri' &&
    bl64_check_parameter 'role' &&
    bl64_check_parameter 'user' ||
    return $?

  printf 'db.grantRolesToUser(
      "%s",
      [ { role: "%s", db: "%s" } ],
      { w: "%s", j: true, wtimeout: %s }
    );\n' "$user" "$role" "$db" "$BL64_MDB_REPLICA_WRITE" "$BL64_MDB_REPLICA_TIMEOUT" |
    bl64_mdb_run_mongosh "$uri"

}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $1: connection URI
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_run_mongosh_eval() {
  bl64_dbg_lib_show_function "$@"
  local uri="${1:-}"
  local verbosity="$BL64_MDB_SET_QUIET"

  shift
  bl64_check_parameters_none "$#" &&
    bl64_check_parameter 'uri' &&
    bl64_check_module 'BL64_MDB_MODULE' ||
    return $?

  bl64_dbg_lib_command_enabled && verbosity="$BL64_MDB_SET_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_MDB_CMD_MONGOSH" \
    $verbosity \
    $BL64_MDB_SET_NORC \
    "$uri" \
    --eval="$*"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
# * Warning: if no command is providded the tool will stay waiting for input from STDIN
#
# Arguments:
#   $1: connection URI
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_run_mongosh() {
  bl64_dbg_lib_show_function "$@"
  local uri="${1:-${BL64_VAR_DEFAULT}}"
  local verbosity="$BL64_MDB_SET_QUIET"

  shift
  bl64_check_parameter 'uri' &&
    bl64_check_module 'BL64_MDB_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_MDB_SET_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_MDB_CMD_MONGOSH" \
    $verbosity \
    $BL64_MDB_SET_NORC \
    "$uri" \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_run_mongorestore() {
  bl64_dbg_lib_show_function "$@"
  local verbosity="$BL64_MDB_SET_QUIET"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_MDB_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_MDB_SET_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_MDB_CMD_MONGORESTORE" \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_mdb_run_mongoexport() {
  bl64_dbg_lib_show_function "$@"
  local verbosity="$BL64_MDB_SET_QUIET"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_MDB_MODULE' ||
    return $?

  bl64_msg_lib_verbose_enabled && verbosity="$BL64_MDB_SET_VERBOSE"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_MDB_CMD_MONGOEXPORT" \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# BashLib64 / Module / Setup / Interact with Terraform
#######################################

#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_tf_setup() {
  [[ -z "$BL64_VERSION" ]] &&
    echo 'Error: bashlib64-module-core.bash should the last module to be sourced' &&
    return 21
  bl64_dbg_lib_show_function "$@"
  local terraform_bin="${1:-${BL64_VAR_DEFAULT}}"

  _bl64_tf_set_command "$terraform_bin" &&
    bl64_check_command "$BL64_TF_CMD_TERRAFORM" &&
    _bl64_tf_set_version &&
    _bl64_tf_set_options &&
    _bl64_tf_set_resources &&
    BL64_TF_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'tf'
}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_tf_set_command() {
  bl64_dbg_lib_show_function "$@"
  local terraform_bin="${1:-${BL64_VAR_DEFAULT}}"

  if [[ "$terraform_bin" == "$BL64_VAR_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/terraform' ]]; then
      terraform_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/terraform' ]]; then
      terraform_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/terraform' ]]; then
      terraform_bin='/usr/local/bin'
    elif [[ -x '/usr/bin/terraform' ]]; then
      terraform_bin='/usr/bin'
    else
      bl64_check_alert_resource_not_found 'terraform'
      return $?
    fi
  fi

  bl64_check_directory "$terraform_bin" || return $?
  [[ -x "${terraform_bin}/terraform" ]] && BL64_TF_CMD_TERRAFORM="${terraform_bin}/terraform"

  bl64_dbg_lib_show_vars 'BL64_TF_CMD_TERRAFORM'
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_tf_set_options() {
  bl64_dbg_lib_show_function

  # TF_LOG values
  BL64_TF_SET_LOG_TRACE='TRACE'
  BL64_TF_SET_LOG_DEBUG='DEBUG'
  BL64_TF_SET_LOG_INFO='INFO'
  BL64_TF_SET_LOG_WARN='WARN'
  BL64_TF_SET_LOG_ERROR='ERROR'
  BL64_TF_SET_LOG_OFF='OFF'
}

#######################################
# Set logging configuration
#
# Arguments:
#   $1: full path to the log file. Default: STDERR
#   $2: log level. One of BL64_TF_SET_LOG_*. Default: INFO
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_tf_log_set() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-$BL64_VAR_DEFAULT}"
  local level="${2:-$BL64_TF_SET_LOG_INFO}"

  bl64_check_module 'BL64_TF_MODULE' ||
    return $?

  BL64_TF_LOG_PATH="$path"
  BL64_TF_LOG_LEVEL="$level"
}

#######################################
# Declare version specific definitions
#
# * Use to capture default file names, values, attributes, etc
# * Do not use to capture CLI flags. Use *_set_options instead
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function _bl64_tf_set_resources() {
  bl64_dbg_lib_show_function

  # Terraform configuration lock file name
  BL64_TF_DEF_PATH_LOCK='.terraform.lock.hcl'

  # Runtime directory created by terraform init
  BL64_TF_DEF_PATH_RUNTIME='.terraform'

  return 0
}

#######################################
# Identify and set module components versions
#
# * Version information is stored in module global variables
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: command errors
# Returns:
#   0: version set ok
#   >0: command error
#######################################
function _bl64_tf_set_version() {
  bl64_dbg_lib_show_function
  local cli_version=''

  bl64_dbg_lib_show_info "run terraforn to obtain ansible-core version"
  cli_version="$("$BL64_TF_CMD_TERRAFORM" --version | bl64_txt_run_awk '/^Terraform v[0-9.]+$/ { gsub( /v/, "" ); print $2 }')"
  bl64_dbg_lib_show_vars 'cli_version'

  if [[ -n "$cli_version" ]]; then
    BL64_TF_VERSION_CLI="$cli_version"
  else
    bl64_msg_show_error "${_BL64_TF_TXT_ERROR_GET_VERSION} (${BL64_TF_CMD_TERRAFORM} --version)"
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  bl64_dbg_lib_show_vars 'BL64_TF_VERSION_CLI'
  return 0
}

#######################################
# BashLib64 / Module / Functions / Interact with Terraform
#######################################

#######################################
# Run terraform output
#
# Arguments:
#   $1: output format. One of BL64_TF_OUTPUT_*
#   $2: (optional) variable name
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_tf_output_export() {
  bl64_dbg_lib_show_function "$@"
  local format="${1:-}"
  local variable="${2:-}"

  case "$format" in
  "$BL64_TF_OUTPUT_RAW") format='-raw' ;;
  "$BL64_TF_OUTPUT_JSON") format='-json' ;;
  "$BL64_TF_OUTPUT_TEXT") format='' ;;
  *) bl64_check_alert_undefined ;;
  esac

  # shellcheck disable=SC2086
  bl64_tf_run_terraform \
    output \
    -no-color \
    $format \
    "$variable"
}

#######################################
# Command wrapper with verbose, debug and common options
#
# * Trust no one. Ignore inherited config and use explicit
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   0: operation completed ok
#   >0: operation failed
#######################################
function bl64_tf_run_terraform() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_TF_MODULE' ||
    return $?

  bl64_tf_blank_terraform

  if bl64_dbg_lib_command_enabled; then
    export TF_LOG="$BL64_TF_SET_LOG_TRACE"
  else
    export TF_LOG="$BL64_TF_LOG_LEVEL"
  fi
  [[ "$BL64_TF_LOG_PATH" != "$BL64_VAR_DEFAULT" ]] && export TF_LOG_PATH="$BL64_TF_LOG_PATH"
  bl64_dbg_lib_show_vars 'TF_LOG' 'TF_LOG_PATH'

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_TF_CMD_TERRAFORM" \
    "$@"
  bl64_dbg_lib_trace_stop
}

#######################################
# Remove or nullify inherited shell variables that affects command execution
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_tf_blank_terraform() {
  bl64_dbg_lib_show_function

  bl64_dbg_lib_show_info 'unset inherited TF_* shell variables'
  bl64_dbg_lib_trace_start
  unset TF_LOG
  unset TF_LOG_PATH
  unset TF_CLI_CONFIG_FILE
  unset TF_LOG
  unset TF_LOG_PATH
  unset TF_IN_AUTOMATION
  unset TF_INPUT
  unset TF_DATA_DIR
  unset TF_PLUGIN_CACHE_DIR
  unset TF_REGISTRY_DISCOVERY_RETRY
  unset TF_REGISTRY_CLIENT_TIMEOUT
  bl64_dbg_lib_trace_stop

  return 0
}

#
# Main
#

# Normalize locales to C until a better locale is found in bl64_os_setup
if bl64_lib_lang_is_enabled; then
  LANG='C'
  LC_ALL='C'
  LANGUAGE='C'
fi

# Set strict mode for enhanced security
if bl64_lib_mode_strict_is_enabled; then
  set -o 'nounset'
  set -o 'privileged'
fi

# Initialize modules
[[ -n "$BL64_DBG_MODULE" ]] && { bl64_dbg_setup || exit $?; }
[[ -n "$BL64_CHECK_MODULE" ]] && { bl64_check_setup || exit $?; }
[[ -n "$BL64_MSG_MODULE" ]] && { bl64_msg_setup || exit $?; }
[[ -n "$BL64_BSH_MODULE" ]] && { bl64_bsh_setup || exit $?; }
[[ -n "$BL64_RND_MODULE" ]] && { bl64_rnd_setup || exit $?; }
[[ -n "$BL64_UI_MODULE" ]] && { bl64_ui_setup || exit $?; }
[[ -n "$BL64_OS_MODULE" ]] && { bl64_os_setup || exit $?; }
[[ -n "$BL64_TXT_MODULE" ]] && { bl64_txt_setup || exit $?; }
[[ -n "$BL64_FMT_MODULE" ]] && { bl64_fmt_setup || exit $?; }
[[ -n "$BL64_FS_MODULE" ]] && { bl64_fs_setup || exit $?; }
[[ -n "$BL64_IAM_MODULE" ]] && { bl64_iam_setup || exit $?; }
[[ -n "$BL64_RBAC_MODULE" ]] && { bl64_rbac_setup || exit $?; }
[[ -n "$BL64_RXTX_MODULE" ]] && { bl64_rxtx_setup || exit $?; }
[[ -n "$BL64_API_MODULE" ]] && { bl64_api_setup || exit $?; }
[[ -n "$BL64_VCS_MODULE" ]] && { bl64_vcs_setup || exit $?; }

bl64_dbg_lib_show_comments 'Set signal handlers'
# shellcheck disable=SC2064
if bl64_lib_trap_is_enabled; then
  bl64_dbg_lib_show_info 'enable traps'
  trap "$BL64_LIB_SIGNAL_HUP" 'SIGHUP'
  trap "$BL64_LIB_SIGNAL_STOP" 'SIGINT'
  trap "$BL64_LIB_SIGNAL_QUIT" 'SIGQUIT'
  trap "$BL64_LIB_SIGNAL_QUIT" 'SIGTERM'
  trap "$BL64_LIB_SIGNAL_DEBUG" 'DEBUG'
  trap "$BL64_LIB_SIGNAL_EXIT" 'EXIT'
  trap "$BL64_LIB_SIGNAL_ERR" 'ERR'
fi

bl64_dbg_lib_show_comments 'Set default umask'
umask -S 'u=rwx,g=,o=' > /dev/null

bl64_bsh_script_set_identity

bl64_dbg_lib_show_comments 'Enable command mode: the library can be used as a stand-alone script to run embeded functions'
if bl64_lib_mode_command_is_enabled; then
  bl64_dbg_lib_show_info 'run bashlib64 in command mode'
  "$@"
else
  bl64_dbg_lib_show_info 'run bashlib64 in source mode'
  :
fi


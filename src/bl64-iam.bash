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
    bl64_iam_run_useradd \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      "$login"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_AMZ}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    bl64_iam_run_useradd \
      ${shell:+${BL64_IAM_SET_USERADD_SHELL} "${shell}"} \
      ${group:+${BL64_IAM_SET_USERADD_GROUP} "${group}"} \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      ${geco:+${BL64_IAM_SET_USERADD_GECO} "${geco}"} \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      "$login"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_dbg_lib_show_comments 'force primary group creation'
    bl64_iam_run_useradd \
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
    bl64_iam_run_adduser \
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
    bl64_iam_run_sysadminctl \
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
# Create local user group
#
# Arguments:
#   $1: group name
#   $2: (optional) group ID
# Outputs:
#   STDOUT: Progress info
#   STDERR: Command execution error
# Returns:
#   0: group created ok
#   >0: failed to create group
#######################################
function bl64_iam_group_add() {
  bl64_dbg_lib_show_function "$@"
  local group_name="$1"
  local group_id="${2:-$BL64_VAR_DEFAULT}"

  [[ "$group_id" == "$BL64_VAR_DEFAULT" ]] && group_id=''
  bl64_check_parameter 'group_name' ||
    return $?

  bl64_msg_show_lib_subtask "$_BL64_IAM_TXT_ADD_GROUP ($group_name)"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    bl64_iam_run_groupadd \
      ${group_id:+--gid ${group_id}} \
      "$group_name"
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_AMZ}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    bl64_iam_run_groupadd \
      ${group_id:+--gid ${group_id}} \
      "$group_name"
    ;;
  ${BL64_OS_SLES}-*)
    bl64_iam_run_groupadd \
      ${group_id:+--gid ${group_id}} \
      "$group_name"
    ;;
  ${BL64_OS_ALP}-*)
    bl64_iam_run_groupadd \
      ${group_id:+--gid ${group_id}} \
      "$group_name"
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
#   0: it is
#   BL64_LIB_ERROR_IS_NOT
#   command error status
#######################################
function bl64_iam_user_is_created() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"

  bl64_check_parameter 'user' ||
    return $?

  bl64_iam_user_get_id "$user" >/dev/null 2>&1 || return $BL64_LIB_ERROR_IS_NOT
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
    bl64_iam_run_id -u $user
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_AMZ}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    bl64_iam_run_id -u $user
    ;;
  ${BL64_OS_SLES}-*)
    bl64_iam_run_id -u $user
    ;;
  ${BL64_OS_ALP}-*)
    bl64_iam_run_id -u $user
    ;;
  ${BL64_OS_MCOS}-*)
    bl64_iam_run_id -u $user
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
  bl64_iam_run_id -u -n
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
    bl64_msg_show_error "${message} (user: ${user} ${BL64_MSG_COSMETIC_PIPE} ${_BL64_CHECK_TXT_FUNCTION}: ${FUNCNAME[1]:-NONE}@${BASH_LINENO[1]:-NONE}.${FUNCNAME[2]:-NONE}@${BASH_LINENO[2]:-NONE})"
    return $BL64_LIB_ERROR_USER_NOT_FOUND
  else
    return 0
  fi
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
function bl64_iam_run_useradd() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_USERADD" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_USERADD" \
    $verbosity \
    "$@"
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
function bl64_iam_run_groupadd() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_GROUPADD" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_GROUPADD" \
    $verbosity \
    "$@"
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
function bl64_iam_run_groupmod() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_GROUPMOD" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_GROUPMOD" \
    $verbosity \
    "$@"
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
function bl64_iam_run_usermod() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_USERMOD" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_USERMOD" \
    $verbosity \
    "$@"
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
function bl64_iam_run_adduser() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_ADDUSER" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_ADDUSER" \
    $verbosity \
    "$@"
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
function bl64_iam_run_addgroup() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_ADDGROUP" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_ADDGROUP" \
    $verbosity \
    "$@"
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
function bl64_iam_run_id() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_command "$BL64_IAM_CMD_ID" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_ID" \
    $verbosity \
    "$@"
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
function bl64_iam_run_sysadminctl() {
  bl64_dbg_lib_show_function "$@"
  local verbosity=' '

  bl64_check_parameters_none "$#" &&
    bl64_check_module 'BL64_IAM_MODULE' &&
    bl64_check_privilege_root &&
    bl64_check_command "$BL64_IAM_CMD_SYSADMINCTL" ||
    return $?

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_IAM_CMD_SYSADMINCTL" \
    $verbosity \
    "$@"
  bl64_dbg_lib_trace_stop
}

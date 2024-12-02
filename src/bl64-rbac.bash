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
    bl64_fs_run_cp "${BL64_RBAC_FILE_SUDOERS}" "$old_sudoers"
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

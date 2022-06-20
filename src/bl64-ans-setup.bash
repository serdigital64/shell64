#######################################
# BashLib64 / Module / Setup / Interact with Ansible CLI
#
# Version: 1.2.0
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: required in order to use the module
# * Check for core commands, fail if not available
#
# Arguments:
#   $1: (optional) Full path to the ansible command
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_ans_setup() {
  bl64_dbg_lib_show_function "$@"
  local cmd_ansible="${1:-}"

  # Use provided path if requested
  if [[ -n "$cmd_ansible" ]]; then
    BL64_ANS_CMD_ANSIBLE="$cmd_ansible"
    BL64_ANS_CMD_ANSIBLE_GALAXY="${cmd_ansible}-galaxy"
    BL64_ANS_CMD_ANSIBLE_PLAYBOOK="${cmd_ansible}-playbook"
  fi

  bl64_ans_set_command &&
    bl64_ans_set_options &&
    bl64_check_command "$BL64_ANS_CMD_ANSIBLE" &&
    BL64_ANS_MODULE="$BL64_LIB_VAR_ON"

}

#######################################
# Identify and normalize commands
#
# * If no values are providedprovied, try to detect commands looking for common paths
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
function bl64_ans_set_command() {
  bl64_dbg_lib_show_function
  local ansible_root=''

  if [[ -z "$BL64_ANS_CMD_ANSIBLE" ]]; then
    if [[ -n "$BL64_PY_VENV_PATH" && -x "${BL64_PY_VENV_PATH}/bin/ansible" ]]; then
      ansible_root="${BL64_PY_VENV_PATH}/bin"
    elif [[ -n "$HOME" && -x "${HOME}/.local/bin/ansible" ]]; then
      ansible_root="${HOME}/.local/bin"
    elif [[ -x '/usr/local/bin/ansible' ]]; then
      ansible_root='/usr/local/bin'
    elif [[ -x '/home/linuxbrew/.linuxbrew/bin/ansible' ]]; then
      ansible_root='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/ansible' ]]; then
      ansible_root='/opt/homebrew/bin'
    elif [[ -x '/opt/ansible/bin/ansible' ]]; then
      ansible_root='/opt/ansible/bin'
    elif [[ -x '/usr/bin/ansible' ]]; then
      ansible_root='/usr/bin'
    fi
    if [[ -n "$ansible_root" ]]; then
      BL64_ANS_CMD_ANSIBLE="${ansible_root}/ansible"
    else
      BL64_ANS_CMD_ANSIBLE="$BL64_LIB_UNAVAILABLE"
    fi
  fi

  if [[ -z "$BL64_ANS_CMD_ANSIBLE_GALAXY" ]]; then
    if [[ -n "$ansible_root" && -x "${ansible_root}/ansible-galaxy" ]]; then
      BL64_ANS_CMD_ANSIBLE_GALAXY="${ansible_root}/ansible-galaxy"
    else
      BL64_ANS_CMD_ANSIBLE_GALAXY="$BL64_LIB_UNAVAILABLE"
    fi
  fi

  if [[ -z "$BL64_ANS_CMD_ANSIBLE_PLAYBOOK" ]]; then
    if [[ -n "$ansible_root" && -x "${ansible_root}/ansible-playbook" ]]; then
      BL64_ANS_CMD_ANSIBLE_PLAYBOOK="${ansible_root}/ansible-playbook"
    else
      BL64_ANS_CMD_ANSIBLE_PLAYBOOK="$BL64_LIB_UNAVAILABLE"
    fi
  fi

  # Publish common paths
  BL64_ANS_PATH_USR_ANSIBLE="${HOME}/.ansible"
  BL64_ANS_PATH_USR_COLLECTIONS="${BL64_ANS_PATH_USR_ANSIBLE}/collections/ansible_collections"

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
function bl64_ans_set_options() {
  BL64_ANS_SET_VERBOSE='-v'
  BL64_ANS_SET_DIFF='--diff'
  BL64_ANS_SET_DEBUG='-vvvvv'
}

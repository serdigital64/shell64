#######################################
# BashLib64 / Module / Functions / Interact with GCP
#
# Version: 1.3.0
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
#   command exit status
#######################################
function bl64_gcp_run_gcloud() {
  bl64_dbg_lib_show_function "$@"
  bl64_check_parameters_none "$#" || return $?
  local debug=' '
  local config=' '

  bl64_check_module_setup "$BL64_GCP_MODULE" ||
    return $?

  if bl64_dbg_lib_command_enabled; then
    debug='--verbosity debug --log-http'
  else
    debug='--verbosity none --quiet'
  fi

  bl64_gcp_blank_gcloud

  [[ "$BL64_GCP_CONFIGURATION_CREATED" == "$BL64_LIB_VAR_TRUE" ]] && config="--configuration $BL64_GCP_CONFIGURATION_NAME"

  bl64_dbg_lib_trace_start
  # shellcheck disable=SC2086
  "$BL64_GCP_CMD_GCLOUD" \
    $debug \
    $config \
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
#   command exit status
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

  if [[ "$BL64_GCP_CONFIGURATION_CREATED" == "$BL64_LIB_VAR_FALSE" ]]; then

    bl64_dbg_lib_show_info 'create BL64_GCP_CONFIGURATION'
    bl64_gcp_run_gcloud \
      config \
      configurations \
      create "$BL64_GCP_CONFIGURATION_NAME" &&
      BL64_GCP_CONFIGURATION_CREATED="$BL64_LIB_VAR_TRUE"

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

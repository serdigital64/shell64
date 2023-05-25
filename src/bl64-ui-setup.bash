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
  bl64_dbg_lib_show_function

  BL64_UI_MODULE="$BL64_VAR_ON"

  bl64_check_alert_module_setup 'ui'
}

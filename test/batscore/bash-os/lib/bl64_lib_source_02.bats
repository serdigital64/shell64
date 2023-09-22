setup() {
  . "$TESTMANSH_CMD_BATS_HELPER_SUPPORT"
  . "$TESTMANSH_CMD_BATS_HELPER_ASSERT"
  . "$TESTMANSH_CMD_BATS_HELPER_FILE"
}

@test "bl64_lib_source: script vars are set" {

  BL64_LIB_TRAPS='0'
  . "${TESTMANSH_PROJECT_BUILD}/test/bashlib64.bash"
  set -o 'errexit'
  set +o 'nounset'

  assert_not_equal "$BL64_SCRIPT_SID" ''
}

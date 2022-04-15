setup() {
  . "$DEVBL_TEST_BASHLIB64"
  . "${DEVBL_BATS_HELPER}/bats-support/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-assert/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-file/load.bash"

  BATSLIB_TEMP_PRESERVE=0
  BATSLIB_TEMP_PRESERVE_ON_FAILURE=1

  TEST_SANDBOX="$(temp_make)"
  TEST_SOURCE="$DEVBL_SAMPLES"
  TEST_FILE1='text_01.txt'
  TEST_FILE2='text_02.txt'
}

@test "bl64_fs_copy_files: copy files" {
  set +u # to avoid IFS missing error in run function
  run bl64_fs_copy_files \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "$TEST_SANDBOX" \
    "${TEST_SOURCE}/${TEST_FILE1}" \
    "${TEST_SOURCE}/${TEST_FILE2}"
  assert_success
  assert_file_exist "${TEST_SANDBOX}/${TEST_FILE1}"
  assert_file_exist "${TEST_SANDBOX}/${TEST_FILE2}"
}

@test "bl64_fs_copy_files: copy files + missing target" {
  set +u # to avoid IFS missing error in run function
  run bl64_fs_copy_files \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "/fake/destination" \
    "${TEST_SOURCE}/${TEST_FILE1}" \
    "${TEST_SOURCE}/${TEST_FILE2}"
  assert_failure
}

@test "bl64_fs_copy_files: copy files + missing source" {
  set +u # to avoid IFS missing error in run function
  run bl64_fs_copy_files \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "$BL64_LIB_VAR_TBD" \
    "$TEST_SANDBOX" \
    "/fake/source" \
    "${TEST_SOURCE}/${TEST_FILE2}"
  assert_failure
}


teardown() {
  temp_del "$TEST_SANDBOX"
}

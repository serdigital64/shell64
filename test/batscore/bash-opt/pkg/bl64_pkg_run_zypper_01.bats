@test "bl64_pkg_run_zypper: parameters are not present" {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
  run bl64_pkg_run_zypper
  assert_failure
}

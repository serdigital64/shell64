setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
}

@test "_bl64_vcs_set_options: run function" {
  run _bl64_vcs_set_options
  assert_success
}

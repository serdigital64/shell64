setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"

  _bl64_rxtx_web_get_file_destination="$(mktemp -d)"
  _bl64_rxtx_web_get_file_source='https://raw.githubusercontent.com/serdigital64/bashlib64/main/bashlib64.bash'
  export _bl64_rxtx_web_get_file_destination
  export _bl64_rxtx_web_get_file_source
}

teardown() {

  [[ -d "$_bl64_rxtx_web_get_file_destination" ]] && rm -Rf "$_bl64_rxtx_web_get_file_destination"

}

@test "bl64_rxtx_web_get_file: function parameter missing" {
  run bl64_rxtx_web_get_file
}

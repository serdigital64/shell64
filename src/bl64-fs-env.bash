#######################################
# BashLib64 / Module / Globals / Manage local filesystem
#######################################

# shellcheck disable=SC2034
{
  declare BL64_FS_VERSION='5.8.0'

  declare BL64_FS_MODULE='0'

  declare BL64_FS_PATH_TEMPORAL=''
  declare BL64_FS_PATH_CACHE=''
  # Location for temporary files generated by bashlib64 functions
  declare BL64_FS_PATH_TMP='/tmp'

  declare BL64_FS_CMD_CHMOD=''
  declare BL64_FS_CMD_CHOWN=''
  declare BL64_FS_CMD_CP=''
  declare BL64_FS_CMD_FIND=''
  declare BL64_FS_CMD_LN=''
  declare BL64_FS_CMD_LS=''
  declare BL64_FS_CMD_MKDIR=''
  declare BL64_FS_CMD_MKTEMP=''
  declare BL64_FS_CMD_MV=''
  declare BL64_FS_CMD_RM=''
  declare BL64_FS_CMD_TOUCH=''

  declare BL64_FS_ALIAS_CHOWN_DIR=''
  declare BL64_FS_ALIAS_CP_FILE=''
  declare BL64_FS_ALIAS_LN_SYMBOLIC=''
  declare BL64_FS_ALIAS_LS_FILES=''
  declare BL64_FS_ALIAS_MKDIR_FULL=''
  declare BL64_FS_ALIAS_MV=''
  declare BL64_FS_ALIAS_RM_FILE=''
  declare BL64_FS_ALIAS_RM_FULL=''

  declare BL64_FS_SET_CHMOD_RECURSIVE=''
  declare BL64_FS_SET_CHMOD_VERBOSE=''
  declare BL64_FS_SET_CHOWN_RECURSIVE=''
  declare BL64_FS_SET_CHOWN_VERBOSE=''
  declare BL64_FS_SET_CP_FORCE=''
  declare BL64_FS_SET_CP_RECURSIVE=''
  declare BL64_FS_SET_CP_VERBOSE=''
  declare BL64_FS_SET_FIND_NAME=''
  declare BL64_FS_SET_FIND_PRINT=''
  declare BL64_FS_SET_FIND_RUN=''
  declare BL64_FS_SET_FIND_STAY=''
  declare BL64_FS_SET_FIND_TYPE_DIR=''
  declare BL64_FS_SET_FIND_TYPE_FILE=''
  declare BL64_FS_SET_LN_FORCE=''
  declare BL64_FS_SET_LN_SYMBOLIC=''
  declare BL64_FS_SET_LN_VERBOSE=''
  declare BL64_FS_SET_LS_NOCOLOR=''
  declare BL64_FS_SET_MKDIR_PARENTS=''
  declare BL64_FS_SET_MKDIR_VERBOSE=''
  declare BL64_FS_SET_MKTEMP_DIRECTORY=''
  declare BL64_FS_SET_MKTEMP_QUIET=''
  declare BL64_FS_SET_MKTEMP_TMPDIR=''
  declare BL64_FS_SET_MV_FORCE=''
  declare BL64_FS_SET_MV_VERBOSE=''
  declare BL64_FS_SET_RM_FORCE=''
  declare BL64_FS_SET_RM_RECURSIVE=''
  declare BL64_FS_SET_RM_VERBOSE=''

  #
  # File permission modes
  #
  # shellcheck disable=SC2034
  declare BL64_FS_UMASK_RW_USER='u=rwx,g=,o='
  declare BL64_FS_UMASK_RW_GROUP='u=rwx,g=rwx,o='
  declare BL64_FS_UMASK_RW_ALL='u=rwx,g=rwx,o=rwx'
  declare BL64_FS_UMASK_RW_USER_RO_ALL='u=rwx,g=rx,o=rx'
  declare BL64_FS_UMASK_RW_GROUP_RO_ALL='u=rwx,g=rwx,o=rx'

  declare BL64_FS_SAFEGUARD_POSTFIX='.bl64_fs_safeguard'

  declare BL64_FS_TMP_PREFIX='bl64tmp'
}

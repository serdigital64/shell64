#######################################
# BashLib64 / Module / Globals / Manage local filesystem
#######################################

export BL64_FS_VERSION='4.2.2'

export BL64_FS_MODULE="$BL64_VAR_OFF"

export BL64_FS_PATH_TEMPORAL=''
export BL64_FS_PATH_CACHE=''

export BL64_FS_CMD_CHMOD=''
export BL64_FS_CMD_CHOWN=''
export BL64_FS_CMD_CP=''
export BL64_FS_CMD_FIND=''
export BL64_FS_CMD_LN=''
export BL64_FS_CMD_LS=''
export BL64_FS_CMD_MKDIR=''
export BL64_FS_CMD_MKTEMP=''
export BL64_FS_CMD_MV=''
export BL64_FS_CMD_RM=''
export BL64_FS_CMD_TOUCH=''

export BL64_FS_ALIAS_CHOWN_DIR=''
export BL64_FS_ALIAS_CP_FILE=''
export BL64_FS_ALIAS_LN_SYMBOLIC=''
export BL64_FS_ALIAS_LS_FILES=''
export BL64_FS_ALIAS_MKDIR_FULL=''
export BL64_FS_ALIAS_MV=''
export BL64_FS_ALIAS_RM_FILE=''
export BL64_FS_ALIAS_RM_FULL=''

export BL64_FS_SET_CHMOD_RECURSIVE=''
export BL64_FS_SET_CHMOD_VERBOSE=''
export BL64_FS_SET_CHOWN_RECURSIVE=''
export BL64_FS_SET_CHOWN_VERBOSE=''
export BL64_FS_SET_CP_FORCE=''
export BL64_FS_SET_CP_RECURSIVE=''
export BL64_FS_SET_CP_VERBOSE=''
export BL64_FS_SET_FIND_PRINT=''
export BL64_FS_SET_FIND_RUN=''
export BL64_FS_SET_FIND_STAY=''
export BL64_FS_SET_FIND_TYPE_DIR=''
export BL64_FS_SET_FIND_TYPE_FILE=''
export BL64_FS_SET_LN_SYMBOLIC=''
export BL64_FS_SET_LN_VERBOSE=''
export BL64_FS_SET_LS_NOCOLOR=''
export BL64_FS_SET_MKDIR_PARENTS=''
export BL64_FS_SET_MKDIR_VERBOSE=''
export BL64_FS_SET_MV_FORCE=''
export BL64_FS_SET_MV_VERBOSE=''
export BL64_FS_SET_RM_FORCE=''
export BL64_FS_SET_RM_RECURSIVE=''
export BL64_FS_SET_RM_VERBOSE=''


export BL64_FS_UMASK_RW_USER='u=rwx,g=,o='
export BL64_FS_UMASK_RW_GROUP='u=rwx,g=rwx,o='
export BL64_FS_UMASK_RW_ALL='u=rwx,g=rwx,o=rwx'
export BL64_FS_UMASK_RW_USER_RO_ALL='u=rwx,g=rx,o=rx'
export BL64_FS_UMASK_RW_GROUP_RO_ALL='u=rwx,g=rwx,o=rx'

export BL64_FS_SAFEGUARD_POSTFIX='.bl64_fs_safeguard'

export _BL64_FS_TXT_COPY_FILE_PATH='copy file'
export _BL64_FS_TXT_CREATE_DIR_PATH='create directory'
export _BL64_FS_TXT_MERGE_ADD_SOURCE='merge content from source'
export _BL64_FS_TXT_RESTORE_OBJECT='restore original file from backup'
export _BL64_FS_TXT_SAFEGUARD_FAILED='unable to safeguard requested path'
export _BL64_FS_TXT_SAFEGUARD_OBJECT='backup original file'
export _BL64_FS_TXT_CLEANUP_CACHES='clean up OS cache contents'
export _BL64_FS_TXT_CLEANUP_LOGS='clean up OS logs'
export _BL64_FS_TXT_CLEANUP_TEMP='clean up OS temporary files'
export _BL64_FS_TXT_MERGE_DIRS='merge directories content'

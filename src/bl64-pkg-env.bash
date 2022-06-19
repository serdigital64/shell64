#######################################
# BashLib64 / Module / Globals / Manage native OS packages
#
# Version: 1.7.0
#######################################

export BL64_PKG_MODULE="$BL64_LIB_VAR_OFF"

export BL64_PKG_CMD_APK=''
export BL64_PKG_CMD_APT=''
export BL64_PKG_CMD_BRW=''
export BL64_PKG_CMD_DNF=''
export BL64_PKG_CMD_YUM=''

export BL64_PKG_ALIAS_APK_CLEAN=''
export BL64_PKG_ALIAS_APK_INSTALL=''
export BL64_PKG_ALIAS_APK_CACHE=''
export BL64_PKG_ALIAS_APT_CLEAN=''
export BL64_PKG_ALIAS_APT_INSTALL=''
export BL64_PKG_ALIAS_APT_CACHE=''
export BL64_PKG_ALIAS_BRW_CLEAN=''
export BL64_PKG_ALIAS_BRW_INSTALL=''
export BL64_PKG_ALIAS_BRW_CACHE=''
export BL64_PKG_ALIAS_DNF_CACHE=''
export BL64_PKG_ALIAS_DNF_CLEAN=''
export BL64_PKG_ALIAS_DNF_INSTALL=''
export BL64_PKG_ALIAS_YUM_CACHE=''
export BL64_PKG_ALIAS_YUM_CLEAN=''
export BL64_PKG_ALIAS_YUM_INSTALL=''

export BL64_PKG_SET_ASSUME_YES=''
export BL64_PKG_SET_QUIET=''
export BL64_PKG_SET_SLIM=''
export BL64_PKG_SET_VERBOSE=''

declare _BL64_PKG_TXT_CLEAN='clean up package manager run-time environment'
declare _BL64_PKG_TXT_INSTALL='install packages'
declare _BL64_PKG_TXT_PREPARE='initialize package manager'

# External commands variables
export DEBIAN_FRONTEND
export DEBCONF_TERSE
export DEBCONF_NOWARNINGS
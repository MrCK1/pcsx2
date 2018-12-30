; =======================================================================
;                         Shared Install Functions
; =======================================================================

Function .onInit

  ;prepare Advanced Uninstall log always within .onInit function
  !insertmacro UNINSTALL.LOG_PREPARE_INSTALL

FunctionEnd

Function .onInstSuccess

  ;create/update log always within .onInstSuccess function
  !insertmacro UNINSTALL.LOG_UPDATE_INSTALL

FunctionEnd

; =======================================================================
;                         Shared Uninstall Functions
; =======================================================================

; begin uninstall, could be added on top of uninstall section instead
Function un.onInit
  !insertmacro UNINSTALL.LOG_BEGIN_UNINSTALL
  FunctionEnd

Function un.onUninstSuccess
  !insertmacro UNINSTALL.LOG_END_UNINSTALL
  ; And remove the various install dir(s) but only if they're clean of user content:

  RMDir "$DOCUMENTS\PCSX2"
  RMDir "$INSTDIR\langs"

  RMDir /r "$INSTDIR\plugins"
  RMDir "$INSTDIR"
  FunctionEnd
; =======================================================================
;                           Un.Installer Sections
; =======================================================================
Section "Un.Program and Plugins ${APP_NAME}"

  ; First thing, remove the registry entry in case uninstall doesn't complete successfully
  ;   otherwise, pcsx2 will be "confused" if it's re-installed later.
  DeleteRegKey HKLM Software\PCSX2

  ; Remove regkey generated by NSIS for uninstall functions
  DeleteRegKey HKLM "${INSTDIR_REG_KEY}"

  ; This key is generated by PCSX2 and *not* NSIS! 
  ; Failure to delete this key can result in configuration errors after a fresh install.
  DeleteRegKey HKCU Software\PCSX2

  !insertmacro UNINSTALL.LOG_UNINSTALL "$INSTDIR"
  
  ; Remove shortcuts, if any
  Delete "$DESKTOP\${APP_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\PCSX2"

  Delete "$INSTDIR\GameIndex.dbf"
  Delete "$INSTDIR\cheats_ws.zip"
  Delete "$INSTDIR\PCSX2_keys.ini.default"
  Delete "$INSTDIR\pcsx2.exe"
  RMDir /r "$INSTDIR\Langs"
  RMDir /r "$INSTDIR\Plugins"
  RMDir /r "$INSTDIR\Docs"
  RMDir /r "$INSTDIR\Shaders"

  SetShellVarContext current
  Delete $DOCUMENTS\PCSX2\inis\PCSX2_ui.ini
SectionEnd

# FIXME: The uninstaller currently does not account for non-default paths
# that have been changed by the user when deleting folders.
# While we already have ways to read the registry
# PCSX2 does not supply those paths for us outside of the .ini files

; /o for optional and unticked by default
Section /o "Un.Configuration files (Programs and Plugins)"
  SetShellVarContext current
  RMDir /r "$DOCUMENTS\PCSX2\inis\"
SectionEnd

Section /o "Un.Memory Cards and Savestates"
  SetShellVarContext current
  RMDir /r "$DOCUMENTS\PCSX2\memcards\"
  RMDir /r "$DOCUMENTS\PCSX2\sstates\"
SectionEnd

; /o for optional and unticked by default
Section /o "Un.User files (Cheats, Logs, Snapshots)"
  SetShellVarContext current
  RMDir /r "$DOCUMENTS\PCSX2\Cheats_ws\"
  RMDir /r "$DOCUMENTS\PCSX2\cheats\"
  RMDir /r "$DOCUMENTS\PCSX2\logs\"
  RMDir /r "$DOCUMENTS\PCSX2\snaps\"
SectionEnd

; /o for optional and unticked by default
Section /o "Un.BIOS files"

  SetShellVarContext current
  RMDir /r "$DOCUMENTS\PCSX2\bios\"

SectionEnd
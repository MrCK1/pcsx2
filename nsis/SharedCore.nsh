
  ; --- UAC NIGHTMARES ---
  ; Ideally this would default to 'current' for user-level installs and 'all' for admin-level installs.
  ; There are problems to be aware of, however!
  ;
  ; * If the user is an admin, Windows Vista/7 will DEFAULT to an "all" shell context (installing shortcuts
  ;   for all users), even if we don't want it to (which causes the uninstaller to fail!)
  ; * If the user is not an admin, setting Shell Context to all will cause the installer to fail because the
  ;   user won't have permission enough to install it at all (sigh).

  ; (note!  the SetShellVarContext use in the uninstaller section must match this one!)

  ;SetShellVarContext all
  ;SetShellVarContext current

Section "!${APP_NAME} (required)" SEC_CORE

    SectionIn RO

  SetOutPath "$INSTDIR"
  ; Test the INSTDIR directory to make sure the user has permissions.
  ClearErrors
  FileOpen $R0 $INSTDIR\tmp.dat w
  FileClose $R0
  Delete $INSTDIR\tmp.dat
${If} ${Errors}
  Abort
${EndIf}
    File ..\bin\pcsx2.exe
    File ..\bin\GameIndex.dbf
    File ..\bin\cheats_ws.zip
    File ..\bin\PCSX2_keys.ini.default

  SetOutPath "$INSTDIR\docs"
    File ..\bin\docs\*

  SetOutPath "$INSTDIR\shaders"
    File ..\bin\shaders\GSdx.fx
    File ..\bin\shaders\GSdx_FX_Settings.ini

  SetOutPath "$INSTDIR\plugins"
    File /nonfatal ..\bin\plugins\gsdx32-sse2.dll
    File /nonfatal ..\bin\plugins\gsdx32-sse4.dll
    File /nonfatal ..\bin\plugins\gsdx32-avx2.dll
    File /nonfatal ..\bin\plugins\spu2-x.dll
    File /nonfatal ..\bin\plugins\cdvdGigaherz.dll
    File /nonfatal ..\bin\plugins\lilypad.dll
    File /nonfatal ..\bin\plugins\USBnull.dll
    File /nonfatal ..\bin\plugins\DEV9null.dll
    File /nonfatal ..\bin\plugins\FWnull.dll
SectionEnd

Section "Additional Languages" SEC_LANGS
    SetOutPath $INSTDIR\langs
    File /nonfatal /r ..\bin\langs\*.mo
SectionEnd

!include "SharedShortcuts.nsh"

LangString DESC_CORE       ${LANG_ENGLISH} "Core components (binaries, plugins, documentation, etc)."
LangString DESC_STARTMENU  ${LANG_ENGLISH} "Adds shortcuts for PCSX2 to the start menu (all users)."
LangString DESC_DESKTOP    ${LANG_ENGLISH} "Adds a shortcut for PCSX2 to the desktop (all users)."
LangString DESC_LANGS      ${LANG_ENGLISH} "Adds additional languages other than the system default to PCSX2."

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_CORE}        $(DESC_CORE)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_STARTMENU}   $(DESC_STARTMENU)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOP}     $(DESC_DESKTOP)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_LANGS}       $(DESC_LANGS)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
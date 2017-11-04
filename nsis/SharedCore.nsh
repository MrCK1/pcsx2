
  ; --- UAC NIGHTMARES ---
  ; Ideally this would default to 'current' for user-level installs and 'all' for admin-level installs.
  ; There are problems to be aware of, however!
  ;
  ; * If the user is an admin, Windows Vista/7 will DEFAULT to an "all" shell context (installing shortcuts
  ;   for all users), even if we don't want it to (which causes the uninstaller to fail!)
  ; * If the user is not an admin, setting Shell Context to all will cause the installer to fail because the
  ;   user won't have permission enough to install it at all (sigh).

  ; (note!  the SetShellVarContext use in the uninstaller section must match this one!)
Var CustomImage
Var CustomImage.Bitmap
  
  ;SetShellVarContext all
  ;SetShellVarContext current
Page Custom PortableInstall_ComponentSelection Install_SelectionCheck
Var PortableInstall_ComponentPage
;Page Custom PortableInstall_InstdirSelection
Var SharedCore_VersionStatic
Var SharedCore_CoreCheckbox
Var SharedCore_LanguageCheckbox
Var SharedCore_SM_Checkbox
Var SharedCore_DT_Checkbox

Function PortableInstall_ComponentSelection
nsDialogs::Create /NOUNLOAD 1044
Pop $PortableInstall_ComponentPage

   ${NSD_CreateBitmap} 0u -193u 0u 300u ""

    Pop $CustomImage

    ${NSD_SetImage} $CustomImage "C:\Program Files (x86)\NSIS\Contrib\Graphics\Header\pcsx2banner.bmp" $CustomImage.Bitmap

${NSD_CreateLabel} 10 65 95% 10u "Select PCSX2 components to install."
Pop $SharedCore_VersionStatic

${NSD_CreateCheckBox} 10 95 95% 10u "PCSX2 ${APP_VERSION} (required)."
Pop $SharedCore_CoreCheckbox
${NSD_Check} $SharedCore_CoreCheckbox
EnableWindow $SharedCore_CoreCheckbox 0

;${NSD_OnClick} $InstallMode_Full InstallMode_UsrWait
${NSD_CreateCheckBox} 10 125 95% 10u "Additional Languages"
Pop $SharedCore_LanguageCheckbox

${NSD_CreateCheckBox} 10 155 95% 10u "Start Menu Shortcuts"
Pop $SharedCore_SM_Checkbox

${NSD_CreateCheckBox} 10 185 95% 10u "Desktop Shortcut"
Pop $SharedCore_DT_Checkbox

nsDialogs::Show
FunctionEnd

Function Install_SelectionCheck
Pop $InstallMode_Portable
${NSD_GetState} $InstallMode_Portable $1
${NSD_GetState} $SharedCore_CoreCheckbox $2
${NSD_GetState} $SharedCore_LanguageCheckbox $3
${NSD_GetState} $SharedCore_SM_Checkbox $4
${NSD_GetState} $SharedCore_DT_Checkbox $5

${If} ${BST_CHECKED} == $2
	SetOutPath "$INSTDIR"
	;File portable.ini
	File ..\bin\pcsx2.exe
    File ..\bin\GameIndex.dbf
    File ..\bin\cheats_ws.zip
    File ..\bin\PCSX2_keys.ini.default
  SetOutPath "$INSTDIR\Docs"
    File ..\bin\docs\*

  SetOutPath "$INSTDIR\Shaders"
    File ..\bin\shaders\GSdx.fx
    File ..\bin\shaders\GSdx_FX_Settings.ini

  SetOutPath "$INSTDIR\Plugins"
    File /nonfatal ..\bin\Plugins\gsdx32-sse2.dll
    File /nonfatal ..\bin\Plugins\gsdx32-sse4.dll
    File /nonfatal ..\bin\Plugins\gsdx32-avx2.dll
    File /nonfatal ..\bin\Plugins\spu2-x.dll
    File /nonfatal ..\bin\Plugins\cdvdGigaherz.dll
    File /nonfatal ..\bin\Plugins\lilypad.dll
    File /nonfatal ..\bin\Plugins\USBnull.dll
    File /nonfatal ..\bin\Plugins\DEV9null.dll
    File /nonfatal ..\bin\Plugins\FWnull.dll
${EndIf}

${NSD_GetState} $InstallMode_Portable $1

${If} $InstallMode_Portable == $1
${AndIf} ${BST_CHECKED} == $2 
SetOutPath "$INSTDIR"
File portable.ini
${EndIf}

${If} ${BST_CHECKED} == $3
    SetOutPath $INSTDIR\Langs
    File /nonfatal /r ..\bin\Langs\*.mo
${EndIf}

${If} ${BST_CHECKED} == $4

  ; CreateShortCut gets the working directory from OutPath
  SetOutPath "$INSTDIR"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk"                "${APP_EXE}"         ""    "${APP_EXE}"       0
${EndIf}

${If} ${BST_CHECKED} == $5
  ; CreateShortCut gets the working directory from OutPath
  SetOutPath "$INSTDIR"
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk"            "${APP_EXE}"      "" "${APP_EXE}"     0 "" "" "A Playstation 2 Emulator"
${EndIf}
FunctionEnd
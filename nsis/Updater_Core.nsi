; PCSX2 Pre-Installer Script
; Copyright (C) 2018 Christian Kenny

!include "Updater_SharedDefs.nsh"
!include "StrContains.nsh"
RequestExecutionLevel user

OutFile "pcsx2_updater.exe"

Var UserPrivileges
Var IsAdmin

; Dialog Vars
Var PreInstall_Dialog
Var hwnd
Var Updater_BranchDropdown

Var InstallMode_Dialog
Var InstallMode_DlgBack
Var InstallMode_DlgNext
Var Updater_RevLabel
!include "nsDialogs.nsh"

Page Custom IsUserAdmin
Page Custom InstallMode InstallModeLeave
;Page Custom PreInstallDialog


Function IsUserAdmin
!include WinVer.nsh
  ${IfNot} ${AtLeastWinVista}
    MessageBox MB_OK "Your operating system is unsupported by PCSX2. Please upgrade your operating system or install PCSX2 1.4.0."
    Quit
  ${EndIf}

ClearErrors
UserInfo::GetName
  Pop $R8

UserInfo::GetOriginalAccountType
Pop $UserPrivileges

  # GetOriginalAccountType will check the tokens of the original user of the
  # current thread/process. If the user tokens were elevated or limited for
  # this process, GetOriginalAccountType will return the non-restricted
  # account type.
  # On Vista with UAC, for example, this is not the same value when running
  # with `RequestExecutionLevel user`. GetOriginalAccountType will return
  # "admin" while GetAccountType will return "user".
  ;UserInfo::GetOriginalAccountType
  ;Pop $R2

${If} $UserPrivileges == "Admin"
    StrCpy $IsAdmin 1
    ${ElseIf} $UserPrivileges == "User"
    StrCpy $IsAdmin 0
${EndIf}
FunctionEnd

Function InstallMode

nsDialogs::Create /NOUNLOAD 1018
Pop $InstallMode_Dialog

    GetDlgItem $InstallMode_DlgBack $HWNDPARENT 3
    EnableWindow $InstallMode_DlgBack 0

    GetDlgItem $InstallMode_DlgNext $HWNDPARENT 1
    EnableWindow $InstallMode_DlgNext 0

; Units are used here instead of % to avoid blocking the selection area for the dropdown menu
${NSD_CreateLabel} 0 4 144u 10u "Check for newer revisions of PCSX2 from the"
Pop $Updater_RevLabel

 ${NSD_CreateListBox} 218 0 40% 15% ""

Pop $Updater_BranchDropdown
SendMessage $Updater_BranchDropdown ${LB_ADDSTRING} 0 "STR:stable branch"
SendMessage $Updater_BranchDropdown ${LB_ADDSTRING} 0 "STR:development branch"

nsDialogs::CreateControl /NOUNLOAD ${__NSD_Text_CLASS} ${DEFAULT_STYLES}|${WS_TABSTOP}|${ES_AUTOHSCROLL}|${ES_MULTILINE}|${WS_VSCROLL}|${WS_HSCROLL} ${__NSD_Text_EXSTYLE} 160 150 290 50
;CustomLicense::LoadFile "EULA.txt" "$0"

${NSD_OnChange} $Updater_BranchDropdown InstallMode_UsrWait
nsDialogs::Show

FunctionEnd

Function InstallMode_UsrWait
GetDlgItem $InstallMode_DlgNext $HWNDPARENT 1
SendMessage $Updater_BranchDropdown ${LB_GETCURSEL} 0 0 $1
System::Call user32::SendMessage(i$Updater_BranchDropdown,i${LB_GETTEXT},ir1,t.r1)

${If} $1 == "stable branch"
inetc::get

File "ArchiveName.7z"
    Nsis7z::Extract "ArchiveName.7z"
    Delete "$OUTDIR\ArchiveName.7z" 
${Else}
MessageBox MB_OK "We didn't find jack shit!"
${EndIf}


EnableWindow $InstallMode_DlgNext 1
FunctionEnd

Function InstallModeLeave
${NSD_GetState} $InstallMode_Full $0
${NSD_GetState} $InstallMode_Portable $1

${If} ${BST_CHECKED} == $0
SetOutPath "$TEMP"
${EndIf}
FunctionEnd

Function PreInstallDialog

nsDialogs::Create /NOUNLOAD 1018
Pop $PreInstall_Dialog

${NSD_CreateProgressBar} 0 75 100% 10% "Test"
    Pop $hwnd

  ${NSD_CreateTimer} NSD_Timer.Callback 1

;nsDialogs::Show
FunctionEnd

Function NSD_Timer.Callback
${NSD_KillTimer} NSD_Timer.Callback
    SendMessage $hwnd ${PBM_SETRANGE32} 0 100

Pop $hwnd
;inetc::get "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe" "$TEMP\vcredist_2015_Update_1_x86.exe" /SILENT /CONNECTTIMEOUT 30 /RECEIVETIMEOUT 30 /END
    Pop $hwnd
FunctionEnd

; ----------------------------------
;     Portable Install Section
; ----------------------------------
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

Section "" SID_PCSX2
SectionEnd
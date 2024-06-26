; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Price List"
#define MyAppVersion "1.4"
#define MyAppPublisher "MLG GRAND"
#define MyAppURL "https://www.mlggrand.ir"
#define MyAppExeName "price_list.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{2E72499F-A89C-402A-B41C-E3BBF6552715}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\MLG GRAND\StudioProjects\price_list\installers
OutputBaseFilename=price-list-1.4-setup
SetupIconFile=E:\install_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\file_selector_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\image_compression_flutter_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\permission_handler_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\share_plus_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\MLG GRAND\StudioProjects\price_list\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent


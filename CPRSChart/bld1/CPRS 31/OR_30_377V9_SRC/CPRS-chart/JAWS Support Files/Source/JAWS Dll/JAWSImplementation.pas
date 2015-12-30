{ ******************************************************************************
{
{                                 JAWS FrameWork
{
{ The framework keeps the jaws scripts updated and acts as a middle man to the
{ Jaws application.
{
{
{
{ Last modified by: Chris Bell
{ Last modified: 5/6/14
{ Last Modified Description:
{
{
{ DONE -oJeremy Merrill -c508 :
  Add something that prevents overwriting of the script files if another
  app is running that's using the JAWS DLL }
{ DONE -oJeremy Merrill -c508 : Add check in here to look at script version in JSS file -
  VHAISPBELLC: This appears to already be added. Marking as done}
{ DONE -oJeremy Merrill -c508 :
  Replace registry communication with multiple windows - save strings in the window titles
  Use EnumerateChildWindows jaws script function in place of the FindWindow function
  that's being used right now.- EnumerateChildWindows with a window handle of 0
  enumerates all windows on the desktop.  Will have to use the first part of the window
  title as an ID, and the last part as the string values.  Will need to check for a maximum
  string lenght, probably have to use multiple windows for long text.
  Will also beed to have a global window shared by muiltiple instances of the JAWS.SR DLL. }
{ DONE -oJeremy Merrill -c508 :
  Need to add version checking to TVA508AccessibilityManager component
  and JAWS.DLL.  Warning needs to display just like JAWS.DLL and JAWS. }
{ DONE -oJeremy Merrill -c508 :Figure out why Delphi IDE is loading the DLL when JAWS is running  -
  probably has something to do with the VA508 package being installed -
  need to test for csDesigning some place that we're not testing for (maybe?) }
{ DONE -oJeremy Merrill -c508 :
    Change APP_DATA so that "application data" isn't used - Windows Vista
    doesn't use this value - get data from Windows API call - VHAISPBELLC:
    This is no longer an issue since we do not call this function.}

{ DONE -oChris Bell -c508 : Add log ability }
{ DONE -oChris Bell -c508 : Merge dispatcher into DLL to circumvent the UAC warning with windows 7 }
{ DONE -oChris Bell -c508 : Correct issue with UIPI since Jaws runs at a higher priority as CPRS. This limits API calls. }
{ DONE -oChris Bell -c508 : Modify code to accommodate for users lack of Admin rights. }
{ TODO -oChris Bell -c508 : Mass code cleanup. }
{ TODO -oChris Bell -c508 : Update jcScriptMerge code }
{ ****************************************************************************** }

unit JAWSImplementation;

interface


uses SysUtils, Windows, Classes, Registry, StrUtils, Forms, Dialogs,
  ExtCtrls, VAUtils, DateUtils, PSApi, IniFiles, ActiveX,
  SHFolder, ShellAPI, VA508AccessibilityConst, fVA508DispatcherHiddenWindow,
     {$Ifdef VER180}
    Messages;
    {$Else}
     Winapi.Messages;
    {$EndIf}


{$I 'VA508ScreenReaderDLLStandard.inc'}


exports Initialize, ShutDown, RegisterCustomBehavior, ComponentData, SpeakText,
  IsRunning, ConfigChangePending
  {$Ifdef VER180}
    ;
  {$Else}
    , FindJaws;
  {$EndIf}

implementation

uses fVA508HiddenJawsMainWindow, FSAPILib_TLB, ComObj, tlhelp32;

const
{$Region '************************** Archived Const **************************'}
// JAWS_REQUIRED_VERSION     = '7.10.500'; in VA508AccessibilityConst unit
// VA508_REG_PARAM_KEY = 'Software\Vista\508\JAWS';
// VA508_ERRORS_SHOWN_STATE = 'ErrorsShown';
// RELOAD_CONFIG_SCRIPT = 'VA508Reload';
// APP_DATA = SLASH + 'application data' + SLASH;
// JAWS_COMMON_SCRIPT_PATH_TEXT_LEN = length(JAWS_COMMON_SCRIPT_PATH_TEXT);
//MAX_REG_CHARS = 125;
// When Jaws reads over 126 chars it returns a blank string
//MORE_STRINGS = '+';
//LAST_STRING = '-';
//MAX_COUNT_KEY = 'Max';

{$EndRegion}

  JAWS_COM_OBJECT_VERSION = '8.0.2173';
  VA508_REG_COMPONENT_CAPTION = 'Caption';
  VA508_REG_COMPONENT_VALUE = 'Value';
  VA508_REG_COMPONENT_CONTROL_TYPE = 'ControlType';
  VA508_REG_COMPONENT_STATE = 'State';
  VA508_REG_COMPONENT_INSTRUCTIONS = 'Instructions';
  VA508_REG_COMPONENT_ITEM_INSTRUCTIONS = 'ItemInstructions';
  VA508_REG_COMPONENT_DATA_STATUS = 'DataStatus';
  SLASH = '\';
  JAWS_COMMON_SCRIPT_PATH_TEXT = 'freedom scientific\jaws\';
  JAWS_REGROOT = 'SOFTWARE\Freedom Scientific\JAWS';
  JAWS_SCRIPTDIR = 'SETTINGS\enu';
  JAWS_INSTALL_DIRECTORY_VAR = 'Target';
  JAWS_SHARED_DIR = 'Shared\';
  KEY_WOW64_64KEY = $0100;

type
  TCompareType = (jcPrior, jcINI, jcLineItems, jcVersion, jcScriptMerge);

  {TFileInfo = record
    AppFile: boolean;
    Ext: string;
    CompareType: TCompareType;
    Required: boolean;
    Compile: boolean;
  end;  }

  TFileInfo = record
    FileName: string;
    CompareType: TCompareType;
    Required: boolean;
    Compile: boolean;
  end;
  TFileInfoArray = Array of TFileInfo;

const
  JAWS_SCRIPT_NAME = 'VA508JAWS';
  JAWS_APP_NAME = 'VA508APP';
  JAWS_SCRIPT_VERSION = 'VA508_Script_Version';
  JAWS_SCRIPT_LIST = 'VA508ScriptList.INI';
  CompiledScriptFileExtension = '.JSB';
  ScriptFileExtension = '.JSS';
  ScriptDocExtension = '.JSD';
  ConfigFileExtension = '.JCF';
  KeyMapExtension = '.JKM';
  DictionaryFileExtension = '.JDF';

 { FileInfo: array [1 .. 6] of
    TFileInfo = (
    (AppFile: FALSE; Ext: ScriptFileExtension; CompareType: jcVersion;
     Required: TRUE; Compile: TRUE),
    (AppFile: FALSE; Ext: ScriptDocExtension; CompareType: jcPrior;
     Required: TRUE; Compile: FALSE),
    (AppFile: TRUE; Ext: ScriptFileExtension; CompareType: jcScriptMerge;
     Required: TRUE; Compile: TRUE),
    (AppFile: TRUE; Ext: ConfigFileExtension; CompareType: jcINI;
     Required: TRUE; Compile: FALSE),
    (AppFile: TRUE; Ext: DictionaryFileExtension; CompareType: jcLineItems;
     Required: FALSE; Compile: FALSE),
    (AppFile: TRUE; Ext: KeyMapExtension; CompareType: jcINI;
     Required: FALSE; Compile: FALSE));}

  JAWS_VERSION_ERROR = ERROR_INTRO +
    'The Accessibility Framework can only communicate with JAWS ' +
    JAWS_REQUIRED_VERSION + CRLF +
    'or later versions.  Please update your version of JAWS to a minimum of' +
    CRLF + JAWS_REQUIRED_VERSION +
    ', or preferably the most recent release, to allow the Accessibility' + CRLF
    + 'Framework to communicate with JAWS.  If you are getting this message' +
    CRLF + 'and you already have a compatible version of JAWS, please contact your'
    + CRLF + 'system administrator, and request that they run, with administrator rights,'
    + CRLF + 'the JAWSUpdate application located in the \Program Files\VistA\' +
    CRLF + 'Common Files directory. JAWSUpdate is not required for JAWS' + CRLF
    + 'versions ' + JAWS_COM_OBJECT_VERSION + ' and above.' + CRLF;

  JAWS_FILE_ERROR = ERROR_INTRO +
    'The JAWS interface with the Accessibility Framework requires the ability' +
    CRLF + 'to write files to the hard disk, but the following error is occurring trying to'
    + CRLF + 'write to the disk:' + CRLF + '%s' + CRLF +
    'Please contact your system administrator in order to ensure that your ' +
    CRLF + 'security privileges allow you to write files to the hard disk.' +
    CRLF + 'If you are sure you have these privileges, your hard disk may be full.  Until'
    + CRLF + 'this problem is resolved, the Accessibility Framework will not be able to'
    + CRLF + 'communicate with JAWS.';

  JAWS_USER_MISSMATCH_ERROR = ERROR_INTRO +
    'An error has been detected in the state of JAWS that will not allow the' +
    CRLF + 'Accessibility Framework to communicate with JAWS until JAWS is shut'
    + CRLF + 'down and restarted.  Please restart JAWS at this time.';

  DLL_VERSION_ERROR = ERROR_INTRO +
    'The Accessibility Framework is at version %s, but the required JAWS' + CRLF
    + 'support files are only at version %s.  The new support files should have'
    + CRLF + 'been released with the latest version of the software you are currently'
    + CRLF + 'running.  The Accessibility Framework will not be able to communicate'
    + CRLF + 'with JAWS until these support files are installed.  Please contact your'
    + CRLF + 'system administrator for assistance.';

  JAWS_AUTO_NOT_RUNNING =  ERROR_INTRO +
  'The Accessibility Framework was unable to identify a running instance of JAWS.'
  + ' If you are running JAWS ' + JAWS_REQUIRED_VERSION + ' or later please ' +
  'verify your shortcut contains the JAWS executable name' +
    CRLF + CRLF
  + 'Example: /SCREADER:JAWS Application Name.exe.' + CRLF +
  'If you do not have access to update the %s shortcut, please contact your local ' +
  ' support/help personnel.' + CRLF +
  'This message box will automatically close after 30 seconds';

  JAWS_NOT_RUNNING =  ERROR_INTRO +
  'The Accessibility Framework was unable to identify a running instance of JAWS.'
  + ' The Accessibility Framework will not be able to communicate'
     + 'with JAWS until the correct JAWS application name is passed into the shortcut for %s .' +
    CRLF + CRLF + '/SCREADER=:%s is not running ' +
    CRLF + 'If you do not have access to update the %s shortcut, please contact your local ' +
  ' support/help personnel.' + CRLF +
   'This message box will automatically close after 30 seconds';

  JAWS_ERROR_VERSION = 1;
  JAWS_ERROR_FILE_IO = 2;
  JAWS_ERROR_USER_PROBLEM = 3;
  DLL_ERROR_VERSION = 4;
  JAWS_ERROR_COUNT = 4;
  JAWS_RELOAD_DELAY = 500;
  MB_TIMEDOUT = 32000;

var
  JAWSErrorMessage: array [1 .. JAWS_ERROR_COUNT] of string = (
    JAWS_VERSION_ERROR,
    JAWS_FILE_ERROR,
    JAWS_USER_MISSMATCH_ERROR,
    DLL_VERSION_ERROR
  );

  JAWSErrorsShown: array [1 .. JAWS_ERROR_COUNT] of boolean = (
    FALSE,
    FALSE,
    FALSE,
    FALSE
  );

type
  TJAWSSayString = function(StringToSpeak: PChar; Interrupt: BOOL)
    : BOOL; stdcall;
  TJAWSRunScript = function(ScriptName: PChar): BOOL; stdcall;

  TStartupID = record
    Handle: HWND;
    InstanceID: Integer;
    MsgID: Integer;
  end;

  TJawsRecord = record
    Version: Double;
    Compiler: string;
    DefaultScriptDir: String;
    UserScriptDir: String;
    FDictionaryFileName: string;
    FConfigFile: string;
    FKeyMapFile: string;
    FKeyMapINIFile: TINIFile;
    FKeyMapINIFileModified: boolean;
    FAssignedKeys: TStringList;
    FConfigINIFile: TINIFile;
    FConfigINIFileModified: boolean;
    FDictionaryFile: TStringList;
    FDictionaryFileModified: boolean;
  end;

  TJAWSManager = class
  strict private
    FRequiredFilesFound: boolean;
    FMainForm: TfrmVA508HiddenJawsMainWindow;
    FWasShutdown: boolean;
    FJAWSFileError: string;
    FHiddenJaws: TForm;
    FRootScriptFileName: string;
    FRootScriptAppFileName: string;
    JAWSAPI: IJawsApi;
  private
    procedure ShutDown;
    procedure MakeFileWritable(FileName: string);
    procedure LaunchMasterApplication;
    procedure KillINIFiles(Sender: TObject);
    procedure ReloadConfiguration;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure ShowError(ErrorNumber: Integer); overload;
    class procedure ShowError(ErrorNumber: Integer;
      data: array of const); overload;
   // class function GetPathFromJAWS(PathID: Integer;
  //    DoLowerCase: boolean = TRUE): string;
    class function GetJAWSWindow: HWND;
    class function IsRunning(HighVersion, LowVersion: Word): BOOL;
    class function FindJaws(): hwnd;
    function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL;
    procedure SendComponentData(WindowHandle: HWND; DataStatus: LongInt;
      Caption, Value, data, ControlType, State, Instructions,
      ItemInstructions: PChar);
    procedure SpeakText(Text: PChar);
    procedure RegisterCustomBehavior(Before, After: string; Action: Integer);
    class function JAWSVersionOK: boolean;
    class function JAWSTalking2CurrentUser: boolean;
    function FileErrorExists: boolean;
    function GetScriptFiles(var info: TFileInfoArray): Boolean;
    property RequiredFilesFound: boolean read FRequiredFilesFound;
    property MainForm: TfrmVA508HiddenJawsMainWindow read FMainForm;
   end;

function MessageBoxTimeOutW(hWnd: HWND; lpText: PWideChar; lpCaption: PWideChar;
                            uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall; external user32 name 'MessageBoxTimeoutW';
function MessageBoxTimeOutA(hWnd: HWND; lpText: PChar; lpCaption: PChar;
                            uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall; external user32 name 'MessageBoxTimeoutA';



var
//******************************************************************
//               Archived Variable
//******************************************************************
//  DLLMessageID: UINT = 0;

  JAWSManager: TJAWSManager = nil;
  JawsRecord: array of TJawsRecord;
  JAWSHandle: HWND = 0;

{$Region 'Add debug methods to this region'}

//******************************************************************
// Adds text paramter to log file (used for debuging in the field)
// Conditional define LogMode must be set
//******************************************************************
procedure AddToLog(TextToAdd: string; Level: Integer = 1);
{$IFDEF LogMode}
VAR
  OurLogFile, LocalOnly, AppDir: string;
  FS: TFileStream;
  Flags: Word;
  logFile: File;
  I: Integer;
 {$ENDIF}
  //******************************************************************
  // Finds the users special directory
  //******************************************************************
  function LocalAppDataPath: string;

  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MaxChar] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
 {$IFDEF LogMode}
  OurLogFile := LocalAppDataPath;
  if (copy(OurLogFile, length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';

  LocalOnly := OurLogFile;

  // Now set the application level
  OurLogFile := OurLogFile + Application.title;
  if (copy(OurLogFile, length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';
  AppDir := OurLogFile;

  // try to create or use base direcrtory
  if not DirectoryExists(AppDir) then
    if not ForceDirectories(AppDir) then
      OurLogFile := LocalOnly;

  OurLogFile := OurLogFile + 'JAWSLog.txt';

  If FileExists(OurLogFile) then
    Flags := fmOpenReadWrite
  else
    Flags := fmCreate;

  for I := 2 to Level do
    TextToAdd := ' ' + TextToAdd;

  TextToAdd := #13#10 + TextToAdd;
  FS := TFileStream.Create(OurLogFile, Flags);
  try
    FS.Position := FS.Size;
    FS.Write(TextToAdd[1], length(TextToAdd) * SizeOf(char));
  finally
    FS.Free;
  end;
 {$ENDIF}
end;

{$EndRegion}

{$Region 'Add export methods to this region'}

//******************************************************************
// Ensure the JAWSmanager object exist
//******************************************************************
procedure EnsureManager;
begin
  if not assigned(JAWSManager) then
    JAWSManager := TJAWSManager.Create;
end;

//******************************************************************
// Checks to see if the screen reader is currently running
//******************************************************************
function IsRunning(HighVersion, LowVersion: Word): BOOL; stdcall;
begin
  EnsureManager; // need to preload the directories
  Result := TJAWSManager.IsRunning(HighVersion, LowVersion);
  AddToLog('IsRunning: ' + BoolToStr(Result), 3);
end;

function FindJaws(): BOOL; stdcall;
begin
  EnsureManager; // need to preload the directories
  JAWSHandle := TJAWSManager.FindJaws;
  Result := (JAWSHandle <> 0);
  AddToLog('FindJaws: ' + BoolToStr(Result), 3);
end;


//******************************************************************
// Executed after IsRunning returns TRUE, when the DLL is accepted
// as the screen reader of choice
//******************************************************************
function Initialize(ComponentCallBackProc: TComponentDataRequestProc)
  : BOOL; stdcall;
begin
  EnsureManager;
  Result := JAWSManager.Initialize(ComponentCallBackProc);
end;

//******************************************************************
// Executed when the DLL is unloaded or screen reader is no longer
// needed
//******************************************************************
procedure ShutDown; stdcall;
begin
  if assigned(JAWSManager) then
  begin
    JAWSManager.ShutDown;
    FreeAndNil(JAWSManager);
  end;
end;

//******************************************************************
// Determines if configuration changes are pending
//******************************************************************
function ConfigChangePending: boolean; stdcall;
begin
  Result := FALSE;
  if assigned(JAWSManager) and assigned(JAWSManager.MainForm) and
    (JAWSManager.MainForm.ConfigChangePending) then
    Result := TRUE;
end;

//******************************************************************
// Returns Component Data as requested by the screen reader
//******************************************************************
procedure ComponentData(WindowHandle: HWND; DataStatus: LongInt = DATA_NONE;
  Caption: PChar = nil; Value: PChar = nil; data: PChar = nil;
  ControlType: PChar = nil; State: PChar = nil; Instructions: PChar = nil;
  ItemInstructions: PChar = nil); stdcall;
begin
  EnsureManager;
  JAWSManager.SendComponentData(WindowHandle, DataStatus, Caption, Value, data,
    ControlType, State, Instructions, ItemInstructions);
end;

//******************************************************************
// Instructs the Screen Reader to say the specified text
//******************************************************************
procedure SpeakText(Text: PChar); stdcall;
begin
  EnsureManager;
  JAWSManager.SpeakText(Text);
end;

//******************************************************************
// Registers any custom behavior
//******************************************************************
procedure RegisterCustomBehavior(BehaviorType: Integer; Before, After: PChar);
begin
  EnsureManager;
  JAWSManager.RegisterCustomBehavior(Before, After, BehaviorType);
end;

{$EndRegion}

{$Region 'Add TJAWSManager methods to this region'}

//******************************************************************
// Makes a file writable
//******************************************************************
procedure TJAWSManager.MakeFileWritable(FileName: string);
const
{$WARNINGS OFF} // Don't care about platform specific warning
  NON_WRITABLE_FILE_ATTRIB = faReadOnly or faHidden;
{$WARNINGS ON}
  WRITABLE_FILE_ATTRIB = faAnyFile and (not NON_WRITABLE_FILE_ATTRIB);

var
  Attrib: Integer;
begin
{$WARNINGS OFF} // Don't care about platform specific warning
  Attrib := FileGetAttr(FileName);
{$WARNINGS ON}
  if (Attrib and NON_WRITABLE_FILE_ATTRIB) <> 0 then
  begin
    Attrib := Attrib and WRITABLE_FILE_ATTRIB;
{$WARNINGS OFF} // Don't care about platform specific warning
    if FileSetAttr(FileName, Attrib) <> 0 then
{$WARNINGS ON}
      FJAWSFileError := 'Could not change read-only attribute of file "' +
        FileName + '"';
  end;
end;

//******************************************************************
// Create method for the JawsManager
//******************************************************************
constructor TJAWSManager.Create;
const
  COMPILER_FILENAME = 'scompile.exe';
//  JAWS_APP_NAME = 'VA508APP';

  function ContinueToLoad(TempSubDir: string): Boolean;
  Var
   TempUSDir, TempDSDir, PathToCheck: String;
   idx1, idx2: Integer;
  begin
   //Default Script
   TempDSDir := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) +
              JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(TempSubDir);

   //User Script
   TempUSDir := GetSpecialFolderPath(CSIDL_APPDATA) +
          JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(TempSubDir);

   //Script Folder
   PathToCheck := '';
   idx1 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, TempUSDir);
   idx2 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, TempDSDir);

  PathToCheck := copy(TempUSDir, 1, idx1 - 1) +
        copy(TempDSDir, idx2, MaxInt);


   Result := DirectoryExists(PathToCheck);  //Check to see if directory exist (they have ran jaws)

  end;

  //******************************************************************
  // Load the jaws directories via regestries
  //******************************************************************
  procedure LoadJawsDirectories;
  var
    reg: TRegistry;
    keys: TStringList;
    I: Integer;
    key, Dir, SubDir, Version, UserScriptDir, DefaultScriptDir: string;
  begin
    keys := TStringList.Create;
    try
      reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey(JAWS_REGROOT, FALSE);
        reg.GetKeyNames(keys);
        for I := 0 to keys.Count - 1 do
        begin
          Version := keys[I];
          key := JAWS_REGROOT + '\' + keys[I] + '\';
          reg.CloseKey;
          AddToLog(Version, 3);
          SubDir := Version + '\' + JAWS_SCRIPTDIR;
          if reg.OpenKey(key, FALSE) then
          begin
            Dir := LowerCase(reg.ReadString(JAWS_INSTALL_DIRECTORY_VAR));
            Dir := AppendBackSlash(Dir) + COMPILER_FILENAME;
            AddToLog(Dir, 4);
            if FileExists(Dir) and ContinueToLoad(SubDir) then
            begin
              SetLength(JawsRecord, length(JawsRecord) + 1);
              JawsRecord[high(JawsRecord)].Version :=
                StrTofloatDef(Version, -1);
              JawsRecord[high(JawsRecord)].Compiler := Dir;
              Dir := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) +
                JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(SubDir);
              JawsRecord[high(JawsRecord)].DefaultScriptDir := Dir;
              Dir := GetSpecialFolderPath(CSIDL_APPDATA) +
                JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(SubDir);
              JawsRecord[high(JawsRecord)].UserScriptDir := Dir;
            end;
          end;
        end;
      finally
        reg.Free;
      end;
    finally
      keys.Free;
    end;
  end;

  //******************************************************************
  // Ensure all the required files are present in the vista folder
  //******************************************************************
  procedure FindJAWSRequiredFiles;
  var
    path: string;
    I: Integer;
    FileName: string;
    info: TFileInfoArray;
  begin
    SetLength(path, MAX_PATH);
    SetLength(path, GetModuleFileName(HInstance, PChar(path), length(path)));
    path := ExtractFilePath(path);
    path := AppendBackSlash(path);
    // look for the script files in the same directory as this DLL

    FRequiredFilesFound := TRUE;
    AddToLog('Checking files', 3);
    //Look up the files
    GetScriptFiles(info);

    //now ensure that the required files are there
    for I := low(info) to high(info) do
    begin
      if info[i].Required then
      begin
        if not FileExists(info[i].FileName) then
        begin
          FRequiredFilesFound := FALSE;
          AddToLog(FileName + ' does not exist', 4);
          break;
        end
        else
          AddToLog(FileName + ' does exist', 4);
      end;
    end;
  end;

begin
  AddToLog(StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss', now) +
    StringOfChar('*', 20));
  SetLength(JawsRecord, 0);
  AddToLog('Loading Jaws files', 2);
  LoadJawsDirectories;
  if length(JawsRecord) > 0 then
    FindJAWSRequiredFiles;
  if not FRequiredFilesFound then
   ShowError(JAWS_ERROR_FILE_IO, ['Required files missing'])
end;

//******************************************************************
// Destroy method for the JawsManager
//******************************************************************
destructor TJAWSManager.Destroy;
begin
  SetLength(JawsRecord, 0);
  ShutDown;
  inherited;
end;

//******************************************************************
// Returns if an error has been captured
//******************************************************************
function TJAWSManager.FileErrorExists: boolean;
begin
  Result := (FJAWSFileError <> '');
end;

//******************************************************************
// Fills out the file array with sciprts to be moved over
//******************************************************************
 function TJAWSManager.GetScriptFiles(var info: TFileInfoArray): Boolean;
  var
    ScriptsFile: TINIFile;
    path, ScriptsFileName, TmpStr: string;
    Scripts: TStringList;
    I: Integer;


    function LoadInfoRec(Name, Value: String): TFileInfo;
    var
      TmpCompare: string;
    begin
      Result.FileName := Name;

      TmpCompare := Piece(Value, '|', 1);
      if UpperCase(TmpCompare) = 'JCPRIOR' then
        Result.CompareType := jcPrior
      else if UpperCase(TmpCompare) = 'JCINI' then
        Result.CompareType := jcINI
      else if UpperCase(TmpCompare) = 'JCLINEITEMS' then
        Result.CompareType := jcLineItems
      else if UpperCase(TmpCompare) = 'JCVERSION' then
        Result.CompareType := jcVersion
      else if UpperCase(TmpCompare) = 'JCSCRIPTMERGE' then
        Result.CompareType := jcScriptMerge;

      TmpCompare := Piece(Value, '|', 2);
      if UpperCase(TmpCompare) = 'TRUE' then
        Result.Required := TRUE
      else if UpperCase(TmpCompare) = 'FALSE' then
        Result.Required := FALSE;

      TmpCompare := Piece(Value, '|', 3);
      if UpperCase(TmpCompare) = 'TRUE' then
        Result.Compile := TRUE
      else if UpperCase(TmpCompare) = 'FALSE' then
        Result.Compile := FALSE;
    end;


    function LoadOverWrites(SectionName: String): boolean;
    var
     i, X: integer;
     FileName, extName: String;
    begin
     if ScriptsFile.SectionExists(SectionName) then
     begin
      result := true;
      ScriptsFile.ReadSectionValues(SectionName, Scripts);
      for I := 0 to Scripts.Count - 1 do
      begin
       //if script is named after the app then replace
       FileName := Piece(ExtractFileName(Scripts.Names[i]), '.', 1);
       extName := Piece(ExtractFileName(Scripts.Names[i]), '.', 2);
       //Section name sshould be the applications name
       if UpperCase(FileName) = UpperCase(SectionName) then
       begin
        for x := Low(info) to High(info) do
        begin
          if (UpperCase(Piece(ExtractFileName(info[x].FileName), '.', 1)) = UpperCase(JAWS_APP_NAME))
          and (UpperCase(Piece(ExtractFileName(info[x].FileName), '.', 2)) = UpperCase(extName)) then
          begin
            //overwrite its corrisponding va508app file
            info[x] := LoadInfoRec(Path + Scripts.Names[I], Scripts.Values[Scripts.Names[I]]);
            break;
          end;
        end;
       end else begin
         SetLength(info, Length(Info) + 1);
         info[High(info)] := LoadInfoRec(Path + Scripts.Names[I], Scripts.Values[Scripts.Names[I]]);
       end;
      end;
     end else result := False;
    end;

  begin
    Result := false;

    SetLength(path, MAX_PATH);
    SetLength(path, GetModuleFileName(HInstance, PChar(path), length(path)));
    path := ExtractFilePath(path);
    path := AppendBackSlash(path);
    ScriptsFileName := path + JAWS_SCRIPT_LIST;
    if FileExists(ScriptsFileName) then
    begin
      ScriptsFile := TINIFile.Create(ScriptsFileName);
      Scripts := TStringList.Create;
      try
       SetLength(info, 0);
       ScriptsFile.ReadSectionValues('SCRIPTS', Scripts);
       for I := 0 to Scripts.Count - 1 do
       begin
         SetLength(info, Length(Info) + 1);
         info[High(info)] := LoadInfoRec(Path + Scripts.Names[I], Scripts.Values[Scripts.Names[I]]);
       end;

       //Now check for custom overwrites
       //first look for general App
       TmpStr := Piece(ExtractFileName(Application.ExeName), '.', 1);
       LoadOverWrites(TmpStr);

       //second look for a specific version
       TmpStr := TmpStr + '|' + FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
       LoadOverWrites(TmpStr);

      finally
        ScriptsFile.Free;
      end;
    end;
    Result := Length(info) > 0;
  end;



//******************************************************************
// Return the handle of the Jaws application
//******************************************************************
class function TJAWSManager.GetJAWSWindow: HWND;
const
  VISIBLE_WINDOW_CLASS: PChar = 'JFWUI2';
  VISIBLE_WINDOW_TITLE: PChar = 'JAWS';
  VISIBLE_WINDOW_TITLE2: PChar = 'Remote JAWS';
begin
 if JAWSHandle = 0 then
 begin
  JAWSHandle := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE);
  if JAWSHandle = 0 then
    JAWSHandle := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE2);
  if JAWSHandle = 0 then
    JAWSHandle := FindJaws();
 end;

 result := JAWSHandle;
end;

//******************************************************************
// Return the handle of an application
//******************************************************************
function FindHandle(exeFileName: string): hwnd;
 type
  TEInfo = record
   PID: DWORD;
   HWND: THandle;
  end;

  function CallBack(Wnd: DWORD; var EI: TEInfo): Bool; stdcall;
  var
   PID: DWORD;
  begin
   GetWindowThreadProcessID(Wnd, @PID);;
   Result := (PID <> EI.PID) or (not IsWindowVisible(Wnd)) or
      (not IsWindowEnabled(Wnd));
   if not Result then
    EI.HWND := Wnd;
  end;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  EInfo: TEInfo;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      EInfo.PID := FProcessEntry32.th32ProcessID;
      EInfo.HWND := 0;
      EnumWindows(@CallBack, Integer(@EInfo));
      Result := EInfo.HWND;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

//******************************************************************
// Is jaws running? and if so set the return var to the handle
//******************************************************************
class function TJAWSManager.FindJaws(): hwnd;
const
   ORIGNIAL_JAWS_EXE = 'jfw.exe';
var
 JawsParam, ErrMsg: String;
 reg: TRegistry;
 CanContinue: Boolean;
begin
  //assume its not running
  Result := 0;

  //Allow to turn off jaws if not wanted
  {$Ifdef VER180}
    D2006FindCmdLineSwitch('SCREADER', JawsParam, True, [clstD2006ValueAppended]);
  {$Else}
    FindCmdLineSwitch('SCREADER', JawsParam, True, [clstValueAppended]);
  {$EndIf}
  CanContinue := not (Uppercase(JawsParam) = 'NONE');

  //check for the registry
  if CanContinue then
  begin
   //check if JAWS has been installed by looking at the registry
   reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
   try
     reg.RootKey := HKEY_LOCAL_MACHINE;
     CanContinue := reg.KeyExists(JAWS_REGROOT);
   finally
     reg.Free;
   end;
  end;

  //look for the exe (jaws 16 and up)
  if CanContinue then
  begin
   Result := FindHandle(ORIGNIAL_JAWS_EXE);

   //cant find expected app running so look for paramater
   if Result = 0 then
   begin
    JawsParam := '';
    {$Ifdef VER180}
     D2006FindCmdLineSwitch('SCREADER', JawsParam, True, [clstD2006ValueAppended]);
    {$Else}
      FindCmdLineSwitch('SCREADER', JawsParam, True, [clstValueAppended]);
    {$EndIf}
    if Trim(JawsParam) <> '' then
    begin
     //Look for the paramater exe
     Result := FindHandle(JawsParam);
     if Result = 0 then
     begin
       //could not find the parameter exe running
       ErrMsg := Format(JAWS_NOT_RUNNING, [ExtractFileName(Application.ExeName), JawsParam, ExtractFileName(Application.ExeName)]);
      {$Ifdef VER180}
        MessageBoxTimeOutA(Application.Handle, PChar(ErrMsg),
        'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
        MB_TASKMODAL or MB_TOPMOST, 0, 30000);
      {$Else}
        MessageBoxTimeOutW(Application.Handle, PChar(ErrMsg),
          'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
          MB_TASKMODAL or MB_TOPMOST, 0, 30000);
      {$EndIf}


     end;
    end else
    begin
     //no parameter and expected exe is not running
     {$Ifdef VER180}
        ErrMsg := Format(JAWS_AUTO_NOT_RUNNING, [ExtractFileName(Application.ExeName), ExtractFileName(Application.ExeName)]);
        MessageBoxTimeOutA(Application.Handle, PChar(ErrMsg),
        'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
         MB_TASKMODAL or MB_TOPMOST, 0, 30000);
     {$Else}
       ErrMsg := Format(JAWS_AUTO_NOT_RUNNING, [ExtractFileName(Application.ExeName), ExtractFileName(Application.ExeName)]);
        MessageBoxTimeOutW(Application.Handle, PChar(ErrMsg),
        'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
         MB_TASKMODAL or MB_TOPMOST, 0, 30000);
       {$EndIf}
    end;

   //set the global and return
   JAWSHandle := result;

  end;
 end;
end;

//******************************************************************
// Initial setup for JawsManager
//******************************************************************
function TJAWSManager.Initialize(ComponentCallBackProc
  : TComponentDataRequestProc): BOOL;
var
  DestPath: string;
  ScriptFileChanges: boolean;
  LastFileUpdated: boolean;
  CompileCommands: TStringList;
  ArryCnt: Integer;

  //******************************************************************
  //  Ensure the hidden main window is created and recompile
  //******************************************************************
  procedure EnsureWindow;
  begin
    if not assigned(FMainForm) then
      FMainForm := TfrmVA508HiddenJawsMainWindow.Create(nil);
    FMainForm.ComponentDataCallBackProc := ComponentCallBackProc;
    FMainForm.ConfigReloadProc := ReloadConfiguration;
    FMainForm.HandleNeeded;
    Application.ProcessMessages;
  end;

  //******************************************************************
  // Retrieves the JAWS_SCRIPT_VERSION from a script file
  //******************************************************************
  function GetVersion(FileName: string): Integer;
  var
    list: TStringList;
    p, I: Integer;
    line: string;
    working: boolean;
  begin
    Result := 0;
    list := TStringList.Create;
    try
      list.LoadFromFile(FileName);
      I := 0;
      working := TRUE;
      while working and (I < list.Count) do
      begin
        line := list[I];
        p := pos('=', line);
        if p > 0 then
        begin
          if trim(copy(line, 1, p - 1)) = JAWS_SCRIPT_VERSION then
          begin
            line := trim(copy(line, p + 1, MaxInt));
            if copy(line, length(line), 1) = ',' then
              delete(line, length(line), 1);
            Result := StrToIntDef(line, 0);
            working := FALSE;
          end;
        end;
        inc(I);
      end;
    finally
      list.Free;
    end;
  end;

  //******************************************************************
  // Compares versions between two script files
  //******************************************************************
  function VersionDifferent(FromFile, ToFile: string): boolean;
  var
    FromVersion, ToVersion: Integer;
  begin
    FromVersion := GetVersion(FromFile);
    ToVersion := GetVersion(ToFile);
    Result := (FromVersion > ToVersion);
  end;

  //******************************************************************
  // Determines if a line From FromFile is missing in the ToFile
  //******************************************************************
  function LineItemUpdateNeeded(FromFile, ToFile: string): boolean;
  var
    fromList, toList: TStringList;
    I, idx: Integer;
    line: string;
  begin
    Result := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(ToFile);
      for I := 0 to fromList.Count - 1 do
      begin
        line := fromList[I];
        if trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            Result := TRUE;
            break;
          end;
        end;
      end;
    finally
      toList.Free;
      fromList.Free;
    end;
  end;

  //******************************************************************
  // Determines if an INI value from FromFile is missing in the ToFile
  //******************************************************************
  function INIUpdateNeeded(FromFile, ToFile: string): boolean;
  var
    FromINIFile, ToINIFile: TINIFile;
    Sections, Values: TStringList;
    I, j: Integer;
    section, key, val1, val2: string;
  begin
    Result := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TINIFile.Create(FromFile);
      try
        ToINIFile := TINIFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for I := 0 to Sections.Count - 1 do
          begin
            section := Sections[I];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(section, key, '');
              Result := (val1 <> val2);
              if Result then
                break;
            end;
            if Result then
              break;
          end;
        finally
          ToINIFile.Free;
        end;
      finally
        FromINIFile.Free;
      end;
    finally
      Sections.Free;
      Values.Free;
    end;
  end;

  {$Region '*********************** Archived Sub Methods ***********************'}
  {
  function IsUseLine(data: string): boolean;
  var
    p: Integer;
  begin
    Result := (copy(data, 1, 4) = 'use ');
    if Result then
    begin
      Result := FALSE;
      p := pos('"', data);
      if p > 0 then
      begin
        p := posEX('"', data, p + 1);
        if p = length(data) then
          Result := TRUE;
      end;
    end;
  end;

  function IsFunctionLine(data: string): boolean;
  var
    p1, p2: Integer;
    line: string;
  begin
    Result := FALSE;
    line := data;
    p1 := pos(' ', line);
    if (p1 > 0) then
    begin
      if copy(line, 1, p1 - 1) = 'script' then
        Result := TRUE
      else
      begin
        p2 := posEX(' ', line, p1 + 1);
        if p2 > 0 then
        begin
          line := copy(line, p1 + 1, p2 - p1 - 1);
          if (line = 'function') then
            Result := TRUE;
        end;
      end;
    end;
  end;

  function CheckForUseLineAndFunction(FromFile, ToFile: string): boolean;
  var
    FromData: TStringList;
    ToData: TStringList;
    UseLine: string;
    I: Integer;
    line: string;

  begin
    Result := FALSE;
    FromData := TStringList.Create;
    ToData := TStringList.Create;
    try
      UseLine := '';
      AppUseLine := '';
      AppStartFunctionLine := -1;
      FromData.LoadFromFile(FromFile);
      for I := 0 to FromData.Count - 1 do
      begin
        line := LowerCase(trim(FromData[I]));
        if (UseLine = '') and IsUseLine(line) then
        begin
          UseLine := line;
          AppUseLine := FromData[I];
        end
        else if (AppStartFunctionLine < 0) and IsFunctionLine(line) then
          AppStartFunctionLine := I;
        if (UseLine <> '') and (AppStartFunctionLine >= 0) then
          break;
      end;
      if (UseLine = '') or (AppStartFunctionLine < 0) then
        exit;

      AppNeedsUseLine := TRUE;
      AppScriptNeedsFunction := TRUE;
      ToData.LoadFromFile(ToFile);
      for I := 0 to ToData.Count - 1 do
      begin
        line := LowerCase(trim(ToData[I]));
        if AppNeedsUseLine and IsUseLine(line) and (line = UseLine) then
          AppNeedsUseLine := FALSE
        else if AppScriptNeedsFunction and IsFunctionLine(line) then
          AppScriptNeedsFunction := FALSE;
        if (not AppNeedsUseLine) and (not AppScriptNeedsFunction) then
          break;
      end;
      if AppNeedsUseLine or AppScriptNeedsFunction then
        Result := TRUE;
    finally
      FromData.Free;
      ToData.Free;
    end;
  end;

    function DoScriptMerge(FromFile, ToFile, ThisCompiler: string): boolean;
  var
    BackupFile: string;
    FromData: TStringList;
    ToData: TStringList;
    I, idx: Integer;
    ExitCode: Integer;
  begin
    Result := TRUE;
    BackupFile := ToFile + '.BACKUP';
    if FileExists(BackupFile) then
    begin
      MakeFileWritable(BackupFile);
      DeleteFile(PChar(BackupFile));
    end;
    DeleteCompiledFile(ToFile);
    CopyFile(PChar(ToFile), PChar(BackupFile), FALSE);
    MakeFileWritable(ToFile);
    FromData := TStringList.Create;
    ToData := TStringList.Create;
    try
      ToData.LoadFromFile(ToFile);
      if AppNeedsUseLine then
        ToData.Insert(0, AppUseLine);
      if AppScriptNeedsFunction then
      begin
        FromData.LoadFromFile(FromFile);
        ToData.Insert(1, '');
        idx := 2;
        for I := AppStartFunctionLine to FromData.Count - 1 do
        begin
          ToData.Insert(idx, FromData[I]);
          inc(idx);
        end;
        ToData.Insert(idx, '');
      end;
      if not assigned(JAWSAPI) then
        JAWSAPI := CoJawsApi.Create;
      ToData.SaveToFile(ToFile);
      ExitCode := ExecuteAndWait('"' + ThisCompiler + '"', '"' + ToFile + '"');
      JAWSAPI.StopSpeech;
      if ExitCode = 0 then // compile succeeded!
        ReloadConfiguration
      else
        Result := FALSE; // compile failed - just copy the new one
    finally
      FromData.Free;
      ToData.Free;
    end;
  end;

  }
  {$EndRegion}

  //******************************************************************
  // Fire off the correct check based on the CompareType
  //******************************************************************
  function UpdateNeeded(FromFile, ToFile: string;
    CompareType: TCompareType): boolean;
  begin
    Result := TRUE;
    try
      case CompareType of
        jcScriptMerge:
           Result := VersionDifferent(FromFile, ToFile);
        jcPrior:
          Result := LastFileUpdated;
        jcVersion:
          Result := VersionDifferent(FromFile, ToFile);
        jcINI:
          Result := INIUpdateNeeded(FromFile, ToFile);
        jcLineItems:
          Result := LineItemUpdateNeeded(FromFile, ToFile);
      end;
      If Result then
       AddToLog('Update needed', 4)
      else
       AddToLog('No Update needed', 4);
    except
      on E: Exception do
        FJAWSFileError := E.Message;
    end;
  end;

  //******************************************************************
  // Update the Ini File
  //******************************************************************
  procedure INIFileUpdate(FromFile, ToFile: String);
  var
    FromINIFile, ToINIFile: TINIFile;
    Sections, Values: TStringList;
    I, j: Integer;
    section, key, val1, val2: string;
    modified: boolean;
  begin
    modified := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TINIFile.Create(FromFile);
      try
        ToINIFile := TINIFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for I := 0 to Sections.Count - 1 do
          begin
            section := Sections[I];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(section, key, '');
              if (val1 <> val2) then
              begin
                ToINIFile.WriteString(section, key, val1);
                modified := TRUE;
              end;
            end;
          end;
        finally
          if modified then
            ToINIFile.UpdateFile();
          ToINIFile.Free;
        end;
      finally
        FromINIFile.Free;
      end;
    finally
      Sections.Free;
      Values.Free;
    end;
  end;

  //******************************************************************
  // Update the Line Item
  //******************************************************************
  procedure LineItemFileUpdate(FromFile, ToFile: string);
  var
    fromList, toList: TStringList;
    I, idx: Integer;
    line: string;
    modified: boolean;
  begin
    modified := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(ToFile);
      for I := 0 to fromList.Count - 1 do
      begin
        line := fromList[I];
        if trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            toList.Add(line);
            modified := TRUE;
          end;
        end;
      end;
    finally
      if modified then
        toList.SaveToFile(ToFile);
      toList.Free;
      fromList.Free;
    end;
  end;

  //******************************************************************
  // Remove a Compiled file
  //******************************************************************
  procedure DeleteCompiledFile(ToFile: string);
  var
    CompiledFile: string;
  begin
    CompiledFile := copy(ToFile, 1, length(ToFile) -
      length(ExtractFileExt(ToFile)));
    CompiledFile := CompiledFile + CompiledScriptFileExtension;
    if FileExists(CompiledFile) then
    begin
      MakeFileWritable(CompiledFile);
      DeleteFile(PChar(CompiledFile));
    end;
  end;

  //******************************************************************
  // Update the ToFile from the FromFile
  //******************************************************************
  procedure UpdateFile(FromFile, ToFile, ThisCompiler: string; info: TFileInfo);
  var
    DoCopy: boolean;
    error: boolean;
    CheckOverwrite: boolean;
  begin
    DoCopy := FALSE;
    if FileExists(ToFile) then
    begin
      MakeFileWritable(ToFile);
      CheckOverwrite := TRUE;
      try
        case info.CompareType of
          jcScriptMerge:
            DoCopy := TRUE;
          jcPrior, jcVersion:
            DoCopy := TRUE;
          jcINI:
            INIFileUpdate(FromFile, ToFile);
          jcLineItems:
            LineItemFileUpdate(FromFile, ToFile);
        end;
      except
        on E: Exception do
          FJAWSFileError := E.Message;
      end;
    end
    else
    begin
      CheckOverwrite := FALSE;
      DoCopy := TRUE;
    end;

    if DoCopy then
    begin
      error := FALSE;
      if not CopyFile(PChar(FromFile), PChar(ToFile), FALSE) then
      begin
        error := TRUE;
        AddToLog('Error copying to "' + ToFile + '". Error in CopyFile method', 4)
      end else
        AddToLog('copied to "' + ToFile + '".', 4);
      if (not error) and (not FileExists(ToFile)) then
      begin
        error := TRUE;
      end;
      if (not error) and CheckOverwrite and (info.CompareType <> jcPrior) and
        UpdateNeeded(FromFile, ToFile, info.CompareType) then
        error := TRUE;
      if error and (not FileErrorExists) then
        FJAWSFileError := 'Error copying "' + FromFile + '" to' + CRLF + '"' +
          ToFile + '".';
      if (not error) and (info.Compile) then
      begin
        DeleteCompiledFile(ToFile);
        CompileCommands.Add('"'+ ToFile +'"');
        AddToLog('File added to compiler', 4);
      end;
    end;
  end;

  //******************************************************************
  // Keeps Jaws files aliged with the ones in Vist\Common Files
  //******************************************************************
  procedure EnsureJAWSScriptsAreUpToDate(var ThisJawsRec: TJawsRecord);
  var
    DestFile, FromFile, ToFile, AppName, Ext, path: string;
    idx1, idx2, I: Integer;
    DoUpdate: boolean;
    info: TFileInfoArray;

  begin
    AddToLog('Checking files for JAWS' + FloatToStr(ThisJawsRec.Version), 2);
    AppName := ExtractFileName(ParamStr(0));
    Ext := ExtractFileExt(AppName);
    AppName := LeftStr(AppName, length(AppName) - length(Ext));
    DestPath := '';
    idx1 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, ThisJawsRec.UserScriptDir);
    idx2 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, ThisJawsRec.DefaultScriptDir);
    if (idx1 > 0) and (idx2 > 0) then
    begin
      DestPath := copy(ThisJawsRec.UserScriptDir, 1, idx1 - 1) +
        copy(ThisJawsRec.DefaultScriptDir, idx2, MaxInt);

      DestFile := DestPath + AppName;
      ThisJawsRec.FDictionaryFileName := DestFile + DictionaryFileExtension;
      ThisJawsRec.FConfigFile := DestFile + ConfigFileExtension;
      ThisJawsRec.FKeyMapFile := DestFile + KeyMapExtension;
      LastFileUpdated := FALSE;

      //Look up the files
      GetScriptFiles(info);

      for I := low(info) to high(info) do
      begin
        if Uppercase(Piece(ExtractFileName(info[i].FileName), '.', 1)) = JAWS_APP_NAME then
        begin
          FromFile := info[i].FileName;
          ToFile := DestFile + ExtractFileExt(info[i].FileName);
        end
        else
        begin
          FromFile := info[i].FileName;
          ToFile := DestPath + ExtractFileName(info[i].FileName);
        end;
        AddToLog(FromFile, 3);
        if not FileExists(FromFile) then
          continue;
        if FileExists(ToFile) then
        begin
          DoUpdate := UpdateNeeded(FromFile, ToFile, info[i].CompareType);
          if DoUpdate then
            MakeFileWritable(ToFile);
        end
        else
          DoUpdate := TRUE;
        LastFileUpdated := DoUpdate;
        if DoUpdate and (not FileErrorExists) then
        begin
          UpdateFile(FromFile, ToFile, ThisJawsRec.Compiler, info[i]);
          ScriptFileChanges := TRUE;
        end;
        if FileErrorExists then
          break;
      end;
    end
    else
      FJAWSFileError := 'Unknown File Error';
    // should never happen - condition checked previously
  end;

  //******************************************************************
  // Recompile Jaws with the new files
  //******************************************************************
  procedure DoCompiles(ThisJawsRec: TJawsRecord);
  var
    I: Integer;
  begin
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;
    AddToLog('Compiling files with ' + ThisJawsRec.Compiler, 3);
    for I := 0 to CompileCommands.Count - 1 do
    begin
      ExecuteAndWait('"' + ThisJawsRec.Compiler + '"', CompileCommands[I]);
      AddToLog('Compiled ' + CompileCommands[I], 4);
      JAWSAPI.StopSpeech;
    end;
    ReloadConfiguration;
  end;

begin
  Result := FALSE;
  for ArryCnt := Low(JawsRecord) to High(JawsRecord) do
  begin
    AddToLog('Start version : ' + FloatToStr(JawsRecord[ArryCnt].Version), 2);
    ScriptFileChanges := FALSE;
    if JAWSManager.RequiredFilesFound then
    begin
      FJAWSFileError := '';
      CompileCommands := TStringList.Create;
      try
        EnsureJAWSScriptsAreUpToDate(JawsRecord[ArryCnt]);
        AddToLog('Compile', 3);
        if CompileCommands.Count > 0 then
          DoCompiles(JawsRecord[ArryCnt]);
      finally
        CompileCommands.Free;
      end;
      if FileErrorExists then
        ShowError(JAWS_ERROR_FILE_IO, [FJAWSFileError])
      else if JAWSTalking2CurrentUser then
      begin
        EnsureWindow;
        AddToLog('Launching master app', 3);
        LaunchMasterApplication;
        if ScriptFileChanges then
        begin
          FMainForm.ConfigReloadNeeded;
        end;
        Result := TRUE;
      end;
    end;
  end;
end;

//******************************************************************
// Returns if the JawsManager is running
//******************************************************************
class function TJAWSManager.IsRunning(HighVersion, LowVersion: Word): BOOL;

  function ComponentVersionSupported: boolean;
  var
    SupportedHighVersion, SupportedLowVersion: Integer;
    FileName, newVersion, convertedVersion, currentVersion: string;
    addr: pointer;

  begin
    addr := @TJAWSManager.IsRunning;
    FileName := GetDLLFileName(addr);
    currentVersion := FileVersionValue(FileName, FILE_VER_FILEVERSION);
    VersionStringSplit(currentVersion, SupportedHighVersion,
      SupportedLowVersion);
    Result := FALSE;
    if (HighVersion < SupportedHighVersion) then
      Result := TRUE
    else if (HighVersion = SupportedHighVersion) and
      (LowVersion <= SupportedLowVersion) then
      Result := TRUE;
    if not Result then
    begin
      newVersion := IntToStr(HighVersion) + '.' + IntToStr(LowVersion);
      convertedVersion := IntToStr(SupportedHighVersion) + '.' +
        IntToStr(SupportedLowVersion);
      ShowError(DLL_ERROR_VERSION, [newVersion, convertedVersion]);
    end;
    AddToLog('DLL Version (' + currentVersion + ') Supported: ' +
      BoolToStr(Result), 3);
  end;

begin
  Result := (GetJAWSWindow <> 0);
  if Result then
    Result := ComponentVersionSupported;
  if Result then
    Result := JAWSVersionOK;
  if Result then
  begin
    EnsureManager;
    with JAWSManager do
      Result := RequiredFilesFound;
  end;
end;

//******************************************************************
// Verfiy jaws and application are ran by the same user
//******************************************************************
class function TJAWSManager.JAWSTalking2CurrentUser: boolean;
var
  CurrentUserPath: string;
  WhatJAWSThinks: string;

  //******************************************************************
  // Gathers the username that ran the process
  //******************************************************************
  function GetProcessUserAndDomain(Pid: DWORD): string;
  const
    FlgFoward = $00000020;
  var
    WbemLocator, WMIService, WbemObject, WbemObjectSet: OLEVariant;
    UserName, DomainName: OLEVariant;
    ProcessEnum: IEnumvariant;
    iValue: LongWord;
    QueryToRun: String;
  begin
    QueryToRun := 'SELECT * FROM Win32_Process where Handle=' + IntToStr(Pid);
    WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    WMIService := WbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
    WbemObjectSet := WMIService.ExecQuery(QueryToRun, 'WQL', FlgFoward);
    ProcessEnum := IUnknown(WbemObjectSet._NewEnum) as IEnumvariant;
    if ProcessEnum.Next(1, WbemObject, iValue) = 0 then
    begin
      WbemObject.GetOwner(UserName, DomainName);
      Result := DomainName + '/' + UserName;
    end
    else
      Result := '';
  end;

 {$Region '*********************** Archived Sub Method ***********************'}
 {
  procedure Fix(var path: string);
  var
    idx: Integer;
  begin
    idx := pos(APP_DATA, LowerCase(path));
    if idx > 0 then
      path := LeftStr(path, idx - 1);
    idx := length(path);
    while (idx > 0) and (path[idx] <> '\') do
      dec(idx);
    delete(path, 1, idx);
  end;
  }
  {$ENDREGION}

  //******************************************************************
  // Verify same user using Jaws and Application
  //******************************************************************
  function UserProblemExists: boolean;
  var
    JAWSWindow: HWND;
    pPid: DWORD;
  begin
    JAWSWindow := GetJAWSWindow;
    pPid := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(JAWSWindow, @pPid);
    CurrentUserPath := GetProcessUserAndDomain(GetCurrentProcessId);

    WhatJAWSThinks := GetProcessUserAndDomain(pPid);
    Result := (LowerCase(CurrentUserPath) <> LowerCase(WhatJAWSThinks));
  end;

begin
  if UserProblemExists then
  begin
    ShowError(JAWS_ERROR_USER_PROBLEM);
    Result := FALSE;
  end
  else
    Result := TRUE;
end;

//******************************************************************
// Verify the version of Jaws is supported
//******************************************************************
class function TJAWSManager.JAWSVersionOK: boolean;
var
  JFileVersion: string;
  JFile: string;
  I: Integer;
  ErrFound, Ok: boolean;

  //******************************************************************
  // Try to create the Jaws Api
  //******************************************************************
  function OlderVersionOKIfCOMObjectInstalled: boolean;
  var
    api: IJawsApi;
  begin
    Result := VersionOK(JAWS_REQUIRED_VERSION, JFileVersion);
    if Result then
    begin
      try
        try
          api := CoJawsApi.Create;
        except
          Result := FALSE;
        end;
      finally
        api := nil;
      end;
    end;
  end;

begin
  ErrFound := FALSE;
  for I := Low(JawsRecord) to High(JawsRecord) do
  begin
    JFile := ExtractFilePath(JawsRecord[I].Compiler) +
      JAWS_APPLICATION_FILENAME;
    if FileExists(JFile) then
    begin
      JFileVersion := FileVersionValue(JFile, FILE_VER_FILEVERSION);
      Ok := VersionOK(JAWS_COM_OBJECT_VERSION, JFileVersion);
      if not Ok then
        Ok := OlderVersionOKIfCOMObjectInstalled;
    end
    else
    begin
      // if file not found, then assume a future version where the exe was moved
      // to a different location
      Ok := TRUE;
    end;
    if not Ok then
    begin
      ErrFound := TRUE;
      break;
    end;
    AddToLog('Jaws Application (' + JFileVersion + ') Supported: ' +
      BoolToStr(Ok), 3);
  end;
  if ErrFound then
    ShowError(JAWS_ERROR_VERSION);

  Result := not ErrFound;

end;

//******************************************************************
// Delete Ini files
//******************************************************************
procedure TJAWSManager.KillINIFiles(Sender: TObject);
var
 I: Integer;
begin
  for I := Low(JawsRecord) to High(JawsRecord) do
  begin
  if assigned(JawsRecord[i].FDictionaryFile) then
  begin
    if JawsRecord[i].FDictionaryFileModified then
    begin
      MakeFileWritable(JawsRecord[i].FDictionaryFileName);
      JawsRecord[i].FDictionaryFile.SaveToFile(JawsRecord[i].FDictionaryFileName);
    end;
    FreeAndNil(JawsRecord[i].FDictionaryFile);
  end;

  if assigned(JawsRecord[i].FConfigINIFile) then
  begin
    if JawsRecord[i].FConfigINIFileModified then
    begin
      JawsRecord[i].FConfigINIFile.UpdateFile;
    end;
    FreeAndNil(JawsRecord[i].FConfigINIFile);
  end;

  if assigned(JawsRecord[i].FKeyMapINIFile) then
  begin
    if JawsRecord[i].FKeyMapINIFileModified then
    begin
      JawsRecord[i].FKeyMapINIFile.UpdateFile;
    end;
    FreeAndNil(JawsRecord[i].FKeyMapINIFile);
  end;

  if assigned(JawsRecord[i].FAssignedKeys) then
    FreeAndNil(JawsRecord[i].FAssignedKeys);
  end;
end;

//******************************************************************
// Create the dispatcher window
//******************************************************************
procedure TJAWSManager.LaunchMasterApplication;
begin
 if not Assigned(FHiddenJaws) then
   FHiddenJaws := TfrmVA508JawsDispatcherHiddenWindow.Create(Application);
end;

procedure TJAWSManager.RegisterCustomBehavior(Before, After: string;
  Action: Integer);

const
  WindowClassesSection = 'WindowClasses';
  MSAAClassesSection = 'MSAAClasses';
  DICT_DELIM: char = char($2E);
  CommonKeysSection = 'Common Keys';
  CustomCommandHelpSection = 'Custom Command Help';
  KeyCommand = 'VA508SendCustomCommand(';
  KeyCommandLen = length(KeyCommand);

var
  modified: boolean;

  procedure Add2INIFile(var INIFile: TINIFile; var FileModified: boolean;
    FileName, SectionName, data, Value: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    oldValue := INIFile.ReadString(SectionName, data, '');
    if oldValue <> Value then
    begin
      INIFile.WriteString(SectionName, data, Value);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RemoveFromINIFile(var INIFile: TINIFile; var FileModified: boolean;
    FileName, SectionName, data: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    oldValue := INIFile.ReadString(SectionName, data, '');
    if oldValue <> '' then
    begin
      INIFile.DeleteKey(SectionName, data);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RegisterCustomClassChange;
  Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
     Add2INIFile(JawsRecord[i].FConfigINIFile, JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
      WindowClassesSection, Before, After);
  end;

  procedure RegisterMSAAClassChange;
  Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
    Add2INIFile(JawsRecord[i].FConfigINIFile, JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
      MSAAClassesSection, Before, '1');
  end;

  procedure RegisterCustomKeyMapping;
  Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
    begin
    Add2INIFile(JawsRecord[i].FKeyMapINIFile, JawsRecord[i].FKeyMapINIFileModified, JawsRecord[i].FKeyMapFile,
      CommonKeysSection, Before, KeyCommand + After + ')');
    if not assigned(JawsRecord[i].FAssignedKeys) then
      JawsRecord[i].FAssignedKeys := TStringList.Create;
    JawsRecord[i].FAssignedKeys.Add(Before);
    end;
  end;

  procedure RegisterCustomKeyDescription;
  Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
    Add2INIFile(JawsRecord[i].FConfigINIFile, JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
      CustomCommandHelpSection, Before, After);
  end;

  procedure DecodeLine(line: string; var before1, after1: string);
  var
    I, j, len: Integer;
  begin
    before1 := '';
    after1 := '';
    len := length(line);
    if (len < 2) or (line[1] <> DICT_DELIM) then
      exit;
    I := 2;
    while (I < len) and (line[I] <> DICT_DELIM) do
      inc(I);
    before1 := copy(line, 2, I - 2);
    j := I + 1;
    while (j <= len) and (line[j] <> DICT_DELIM) do
      inc(j);
    after1 := copy(line, I + 1, j - I - 1);
  end;

  procedure RegisterCustomDictionaryChange;
  var
    I, idx, X: Integer;
    line, before1, after1: string;
    Add: boolean;
  begin
    for X := Low(JawsRecord) to High(JawsRecord) do
    begin
    if not assigned(JawsRecord[X].FDictionaryFile) then
    begin
      JawsRecord[X].FDictionaryFile := TStringList.Create;
      JawsRecord[X].FDictionaryFileModified := FALSE;
      if FileExists(JawsRecord[X].FDictionaryFileName) then
        JawsRecord[X].FDictionaryFile.LoadFromFile(JawsRecord[X].FDictionaryFileName);
    end;

    Add := TRUE;
    idx := -1;
    for I := 0 to JawsRecord[X].FDictionaryFile.Count - 1 do
    begin
      line := JawsRecord[X].FDictionaryFile[I];
      DecodeLine(line, before1, after1);
      if (before1 = Before) then
      begin
        idx := I;
        if after1 = After then
          Add := FALSE;
        break;
      end;
    end;
    if Add then
    begin
      line := DICT_DELIM + Before + DICT_DELIM + After + DICT_DELIM;
      if idx < 0 then
        JawsRecord[X].FDictionaryFile.Add(line)
      else
        JawsRecord[X].FDictionaryFile[idx] := line;
      modified := TRUE;
      JawsRecord[X].FDictionaryFileModified := TRUE;
    end;
    end;
  end;

  procedure RemoveComponentClass;
  Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
    RemoveFromINIFile(JawsRecord[i].FConfigINIFile, JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
      WindowClassesSection, Before);
  end;

  procedure RemoveMSAAClass;
   Var
   I:Integer;
  begin
    for I := Low(JawsRecord) to High(JawsRecord) do
    RemoveFromINIFile(JawsRecord[i].FConfigINIFile, JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
      MSAAClassesSection, Before);
  end;

  procedure PurgeKeyMappings;
  var
    I, X: Integer;
    name, Value: string;
    keys: TStringList;
    delete: boolean;
  begin
    for X := Low(JawsRecord) to High(JawsRecord) do
    begin
    if not assigned(JawsRecord[X].FKeyMapINIFile) then
    begin
      MakeFileWritable(JawsRecord[X].FKeyMapFile);
      JawsRecord[X].FKeyMapINIFile := TINIFile.Create(JawsRecord[X].FKeyMapFile);
      JawsRecord[X].FKeyMapINIFileModified := FALSE;
    end;
    keys := TStringList.Create;
    try
      JawsRecord[X].FKeyMapINIFile.ReadSectionValues(CommonKeysSection, keys);
      for I := keys.Count - 1 downto 0 do
      begin
        Value := copy(keys.ValueFromIndex[I], 1, KeyCommandLen);
        if Value = KeyCommand then
        begin
          name := keys.Names[I];
          delete := (not assigned(JawsRecord[X].FAssignedKeys));
          if not delete then
            delete := (JawsRecord[X].FAssignedKeys.IndexOf(name) < 0);
          if delete then
          begin
            JawsRecord[X].FKeyMapINIFile.DeleteKey(CommonKeysSection, name);
            JawsRecord[X].FKeyMapINIFileModified := TRUE;
            modified := TRUE;
          end;
        end;
      end;
    finally
      keys.Free;
    end;
    end;
  end;

begin
  { TODO : check file io errors when updating config files }
  modified := FALSE;
  case Action of
    BEHAVIOR_ADD_DICTIONARY_CHANGE:
      RegisterCustomDictionaryChange;
    BEHAVIOR_ADD_COMPONENT_CLASS:
      RegisterCustomClassChange;
    BEHAVIOR_ADD_COMPONENT_MSAA:
      RegisterMSAAClassChange;
    BEHAVIOR_ADD_CUSTOM_KEY_MAPPING:
      RegisterCustomKeyMapping;
    BEHAVIOR_ADD_CUSTOM_KEY_DESCRIPTION:
      RegisterCustomKeyDescription;
    BEHAVIOR_REMOVE_COMPONENT_CLASS:
      RemoveComponentClass;
    BEHAVIOR_REMOVE_COMPONENT_MSAA:
      RemoveMSAAClass;
    BEHAVIOR_PURGE_UNREGISTERED_KEY_MAPPINGS:
      PurgeKeyMappings;
  end;
  if modified and assigned(FMainForm) then
  begin
    FMainForm.ResetINITimer(KillINIFiles);
    FMainForm.ConfigReloadNeeded;
  end;
end;

//******************************************************************
// Fires off the reload all configs through Jaws
//******************************************************************
procedure TJAWSManager.ReloadConfiguration;
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.RunFunction('ReloadAllConfigs');
end;

//******************************************************************
// Send either data or event to Jaws
//******************************************************************
procedure TJAWSManager.SendComponentData(WindowHandle: HWND;
  DataStatus: LongInt; Caption, Value, data, ControlType, State, Instructions,
  ItemInstructions: PChar);

  //******************************************************************
  // Send to dispatcher
  //******************************************************************
  procedure SendRequestResponse;
  begin
    FMainForm.WriteData(VA508_REG_COMPONENT_CAPTION, Caption);
    FMainForm.WriteData(VA508_REG_COMPONENT_VALUE, Value);
    FMainForm.WriteData(VA508_REG_COMPONENT_CONTROL_TYPE, ControlType);
    FMainForm.WriteData(VA508_REG_COMPONENT_STATE, State);
    FMainForm.WriteData(VA508_REG_COMPONENT_INSTRUCTIONS, Instructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_ITEM_INSTRUCTIONS,
      ItemInstructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_DATA_STATUS, IntToStr(DataStatus));
    FMainForm.PostData;
  end;

  //******************************************************************
  // Run the change event through Jaws
  //******************************************************************
  procedure SendChangeEvent;
  var
    Event: WideString;
  begin
    Event := 'VA508ChangeEvent(' + IntToStr(WindowHandle) + ',' +
      IntToStr(DataStatus) + ',"' + StrPas(Caption) + '","' + StrPas(Value) +
      '","' + StrPas(ControlType) + '","' + StrPas(State) + '","' +
      StrPas(Instructions) + '","' + StrPas(ItemInstructions) + '"';
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;
    JAWSAPI.RunFunction(Event)
  end;

begin
  if (data <> nil) and (length(data) > 0) then
  begin
    Value := data;
    DataStatus := DataStatus AND DATA_MASK_DATA;
    DataStatus := DataStatus OR DATA_VALUE;
  end;
  if (DataStatus and DATA_CHANGE_EVENT) <> 0 then
  begin
    DataStatus := DataStatus AND DATA_MASK_CHANGE_EVENT;
    SendChangeEvent;
  end
  else
    SendRequestResponse;
end;

//******************************************************************
// Display a certian error
//******************************************************************
class procedure TJAWSManager.ShowError(ErrorNumber: Integer);
begin
  ShowError(ErrorNumber, []);
end;

//******************************************************************
// Display a certian formated error
//******************************************************************
class procedure TJAWSManager.ShowError(ErrorNumber: Integer;
  data: array of const);
var
  error: string;

begin
  if not JAWSErrorsShown[ErrorNumber] then
  begin
    error := JAWSErrorMessage[ErrorNumber];
    if length(data) > 0 then
      error := Format(error, data);
    JAWSErrorsShown[ErrorNumber] := TRUE;
    MessageBox(0, PChar(error), 'JAWS Accessibility Component Error',
      MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_TOPMOST);
  end;
end;

//******************************************************************
// Clean up files and memory
//******************************************************************
procedure TJAWSManager.ShutDown;
begin
  if FWasShutdown then
    exit;
  if assigned(JAWSAPI) then
  begin
    try
      JAWSAPI := nil; // causes access violation
    except
    end;
  end;
  KillINIFiles(nil);
  if assigned(FMainForm) then
    FreeAndNil(FMainForm);
  FWasShutdown := TRUE;
  if Assigned(FHiddenJaws) then
   FHiddenJaws.Free;
end;

//******************************************************************
// Say a specific string through Jaws
//******************************************************************
procedure TJAWSManager.SpeakText(Text: PChar);
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.SayString(Text, FALSE);
end;

{$Region '************************** Archived Method *************************'}
{
class function TJAWSManager.GetPathFromJAWS(PathID: Integer;
  DoLowerCase: boolean = TRUE): string;
const
  JAWS_MESSAGE_ID = 'JW_GET_FILE_PATH';
  // version is in directory after JAWS \Freedom Scientific\JAWS\*.*\...
  JAWS_PATH_ID_APPLICATION = 0;
  JAWS_PATH_ID_USER_SCRIPT_FILES = 1;
  JAWS_PATH_ID_JAWS_DEFAULT_SCRIPT_FILES = 2;
  // 0 = C:\Program Files\Freedom Scientific\JAWS\8.0\jfw.INI
  // 1 = D:\Documents and Settings\vhaislmerrij\Application Data\Freedom Scientific\JAWS\8.0\USER.INI
  // 2 = D:\Documents and Settings\All Users\Application Data\Freedom Scientific\JAWS\8.0\Settings\enu\DEFAULT.SBL
var
  atm: ATOM;
  len: Integer;
  path: string;
  JAWSWindow: HWND;
  JAWSMsgID: UINT = 0;
begin
  JAWSWindow := GetJAWSWindow;
  if JAWSMsgID = 0 then
    JAWSMsgID := RegisterWindowMessage(JAWS_MESSAGE_ID);
  Result := '';
  atm := SendMessage(JAWSWindow, JAWSMsgID, PathID, 0);
  if atm <> 0 then
  begin
    SetLength(path, MAX_PATH * 2);
    len := GlobalGetAtomName(atm, PChar(path), MAX_PATH * 2);
    GlobalDeleteAtom(atm);
    if len > 0 then
    begin
      SetLength(path, len);
      Result := ExtractFilePath(path);
      if DoLowerCase then
        Result := LowerCase(Result);
    end;
  end;
end;
}
{$EndRegion}

{$EndRegion}

initialization

CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

finalization

ShutDown;
CoUninitialize;

end.

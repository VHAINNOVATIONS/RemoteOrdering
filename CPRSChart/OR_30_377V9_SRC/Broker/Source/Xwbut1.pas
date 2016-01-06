{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains utilities used by the BDK.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit Xwbut1;

interface

Uses
Sysutils, Classes, Messages, WinProcs, IniFiles,
Dialogs, Registry;

const
  xwb_ConnectAction = wm_User + 200;
  IniFile = 'VISTA.INI';
  BrokerSection = 'RPCBroker';
  BrokerServerSection = 'RPCBroker_Servers';
  TAB = #9;
  {For Registry interaction}
    {Roots}
    HKCR = HKEY_CLASSES_ROOT;
    HKCU = HKEY_CURRENT_USER;
    HKU  = HKEY_USERS;
    HKCC = HKEY_CURRENT_CONFIG;
    HKDD = HKEY_DYN_DATA;
    {Keys}

var
  RetryLimit: integer;
  Is64BitMachine: boolean;
  REG_BASE: string;
  RegRoot: HKEY;

const
  REG_BROKER  = 'Vista\Broker';
  REG_VISTA   = 'Vista';
  REG_SIGNON  = 'Vista\Signon';
  REG_SERVERS = 'Vista\Broker\Servers';

function  BuildSect(s1: string; s2: string): string;
procedure GetHostList(HostList: TStrings);
function  GetIniValue(Value, Default: string): string;
function  Iff(Condition: boolean; strTrue, strFalse: string): string;
function  Sizer (s1: string; s2: string): string;
function  ReadRegData(Root : HKEY; Key, Name : string) : string;
procedure WriteRegData(Root: HKEY; Key, Name, Value : string);
procedure DeleteRegData(Root: HKEY; Key, Name : string);
function  ReadRegDataDefault(Root: HKEY; Key, Name, Default : string) : string;
procedure ReadRegValues(Root: HKEY; Key : string; var RegValues : TStringList);
procedure ReadRegValueNames(Root:HKEY; Key : string; var RegNames : TStringlist);

implementation
uses
  uNetPlace;

{---------------------------- BuildSect ---------------------------
------------------------------------------------------------------}
Function BuildSect(s1: string; s2: string): string;
var
  s, x: string;  // JLI 090804
begin
  if s2 <> '' then
    s := s1 + s2
  else
    s := s1;

  x := IntToStr(length(s));
  if length(x) = 1 then x := '00' + x;
  if length(x) = 2 then x := '0' + x;
  Result := x + s;
end;


{--------------------------- GetHostList --------------------------
Reads HOSTS file and fills the passed HostList with all
entries from that file.
------------------------------------------------------------------}
procedure GetHostList(HostList: TStrings);
var
  I, SpacePos: integer;
  IP, HostName: string;
  S : string;                             //Individual line from Hosts file.
  WholeList: TStringList;
begin

  HostList.Clear;
  WholeList := nil;
  try
    WholeList := TStringList.Create;             {create temp buffer}
    WholeList.LoadFromFile(HostFileLocation + '\HOSTS');  {read in the file}
    for I := 0 to WholeList.Count - 1 do
    begin
        S := WholeList[I];
        {ignore lines that start with '#' and empty lines}
        if (Copy(S,1,1) <> '#') and (Length(S) > 0) then
        begin
           while Pos(TAB, S) > 0 do              //Convert tabs to spaces
{$WARN UNSAFE_CODE OFF}
              S[Pos(TAB, S)] := ' ';
{$WARN UNSAFE_CODE ON}
           IP := Copy(S,1,pos(' ', S)-1);  {get IP addr}
           {parse out Host name}
           SpacePos := Length(IP) + 1;
           while Copy(S,SpacePos,1) = ' ' do inc(SpacePos);
           HostName := Copy(S,SpacePos,255);
           if pos(' ',HostName) > 0 then
              HostName := Copy(HostName,1,pos(' ',HostName)-1);
           if pos('#',HostName) > 0 then
              HostName := Copy(HostName,1,pos('#',HostName)-1);
           HostList.Add(HostName+'   [' + IP + ']');
        end{if};
    end{for};
  finally
    WholeList.Free;
  end{try};
end;

{-------------------------- GetIniValue --------------------------
------------------------------------------------------------------}
function GetIniValue(Value, Default: string): string;
var
  DhcpIni: TIniFile;
  pchWinDir: array[0..100] of char;
begin
  GetWindowsDirectory(pchWinDir, SizeOf(pchWinDir));
  DhcpIni := TIniFile.Create(IniFile);
  Result := DhcpIni.ReadString(BrokerSection, Value, 'Could not find!');
  if Result = 'Could not find!' then begin
     if ((Value <> 'Installing') and (GetIniValue('Installing','0') <> '1')) then
        {during Broker install Installing=1 so warnings should not display}
     begin
        DhcpIni.WriteString(BrokerSection, Value, Default);   {Creates vista.ini
                                                               if necessary}
     end;
     Result := Default;
  end;
  DhcpIni.Free;
end;



{------------------------------ Iff ------------------------------
------------------------------------------------------------------}
function Iff(Condition: boolean; strTrue, strFalse: string): string;
begin
  if Condition then Result := strTrue else Result := strFalse;
end;


{------------------------------ Sizer -----------------------------
This function is used in conjunction with the ListSetUp function.  It returns
the number of characters found in the string passed in.  The string is
returned with a leading 0 for the 3 character number format required by the
broker call.
------------------------------------------------------------------}
function Sizer (s1: string; s2: string): string;
var
   x: integer;
   st: string;
begin
  st := s1 + s2;
  x := Length(st);
  st := IntToStr(x);
  if length(st) < 3 then
     Result := '0' + st
  else
      Result := st;
end;

{Function to retrieve a data value from the Windows Registry.
If Key or Name does not exist, null returned.}
function  ReadRegData(Root: HKEY; Key, Name : string) : string;
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := Root;
    if Registry.OpenKeyReadOnly(Key) then
    begin
      Result := Registry.ReadString(Name);
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

{Function to set a data value into the Windows Registry.
If Key or Name does not exist, it is created.}
procedure  WriteRegData(Root: HKEY; Key, Name, Value : string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := Root;
    if Registry.OpenKey(Key, True) then
    begin
      Registry.WriteString(Name, Value);
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

{Procedure to delete a data value into the Windows Registry.}
procedure  DeleteRegData(Root: HKEY; Key, Name : string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := Root;
    if Registry.OpenKey(Key, True) then
    begin
      Registry.DeleteValue(Name);
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;


{Returns string value from registry.  If value is '', then Default
value is filed in Registry and Default is returned.}
function  ReadRegDataDefault(Root: HKEY; Key, Name, Default : string) : string;
begin
  Result := ReadRegData(Root, Key, Name);
  if Result = '' then
  begin
    WriteRegData(Root, Key, Name, Default);
    Result := Default;
  end;
end;

{Returns name=value pairs for a key.  Format returned same as found in .ini
files.  Useful with the Values method of TStringList.}
procedure  ReadRegValues(Root: HKEY; Key : string; var RegValues : TStringList);
var
  RegNames : TStringList;
  Registry  : TRegistry;
  i         : integer;
begin
  RegNames := TStringlist.Create;
  Registry  := TRegistry.Create;
  try
    Registry.RootKey := Root;
    if Registry.OpenKeyReadOnly(Key) then
    begin
      Registry.GetValueNames(RegNames);
      for i := 0 to (RegNames.Count - 1) do
        RegValues.Add(RegNames.Strings[i] + '='
                   + Registry.ReadString(RegNames.Strings[i]));
    end
    else
      RegValues.Add('');
  finally
    Registry.Free;
    RegNames.Free;
  end;
end;

procedure ReadRegValueNames(Root:HKEY; Key : string; var RegNames : TStringlist);
var
  Registry  : TRegistry;
  ReturnedNames : TStringList;
begin
  RegNames.Clear;
  Registry  := TRegistry.Create;
  ReturnedNames := TStringList.Create;
  try
    Registry.RootKey := Root;
    if Registry.OpenKeyReadOnly(Key) then
    begin
      Registry.GetValueNames(ReturnedNames);
      RegNames.Assign(ReturnedNames);
    end;
  finally
    Registry.Free;
    ReturnedNames.Free;
  end;
end;


initialization
  Is64BitMachine := (TOSVersion.Architecture = arIntelX64);
  if Is64Bitmachine then begin
    REG_BASE := 'Software\Wow6432Node\';
  end else begin
    REG_BASE := 'Software\';
  end;
  if VerifyVistaServerRegistry then
    RegRoot := HKEY_CURRENT_USER
  else
    RegRoot := HKEY_LOCAL_MACHINE;

finalization

end.


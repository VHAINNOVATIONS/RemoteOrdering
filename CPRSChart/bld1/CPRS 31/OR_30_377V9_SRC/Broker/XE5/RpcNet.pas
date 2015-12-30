{$WARN UNSAFE_CODE OFF}
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: winsock utilities.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit RpcNet;
{
  Changes in v1.1.13 (JLI -- 8/23/00) -- XWB*1.1*13
    Made changes to cursor dependent on current cursor being crDefault so
       that the application can set it to a different cursor for long or
       repeated processes without the cursor 'flashing' repeatedly.
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, winsock{, winsock2};

const XWB_GHIP = WM_USER + 10000;
//Const XWB_SELECT = WM_USER + 10001;

const WINSOCK1_1 = $0101;
const PF_INET = 2;
const SOCK_STREAM = 1;
const IPPROTO_TCP = 6;
const INVALID_SOCKET = -1;
const SOCKET_ERROR = -1;
const FIONREAD = $4004667F;
const ActiveConnection: boolean = False;

type
  EchatError = class(Exception);

type
  TRPCFRM1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure XWBGHIP(var msgSock: TMessage);
    //procedure xwbSelect(var msgSock: TMessage);           //P14
    procedure WndProc(var Message : TMessage); reintroduce; //P14
  end;

type
  WinTaskRec = record
     InUse: boolean;
     pTCPResult: Pointer;
     strTemp: string; {generic output string for async calls}
     chrTemp: PAnsiChar; {generic out PChar for async calls}  // JLI 090804
     hTCP: THandle; {pseudo handle for async calls}
     hWin: hWnd; {handle for owner window}
     CallWait: boolean;
     CallAbort: boolean;
     RPCFRM1: TRPCFRM1;
  end;

var
   WRec: array[1..128] of WinTaskRec;
   Hash: array[0..159] of char;

{Windows OS abstraction functions.  Should be taken over by VA Kernel}

function libGetCurrentProcess: word;

{Socket functions using library RPCLIB.DLL, in this case called locally}

//function  libAbortCall(inst: integer): integer; export;   //P14
//function  libGetHostIP1(inst: integer; HostName: PChar;  // JLI 090804
//          var outcome: PChar): integer; export;  // JLI 090804
function  libGetHostIPStr(inst: integer; HostName: string; var outcome: string): integer;  // JLI 090804
function  libGetHostIP1(inst: integer; HostName: PAnsiChar;  // JLI 090804
          var outcome: PAnsiChar): integer; export;  // JLI 090804
//function  libGetLocalIP(inst: integer; var outcome: PChar): integer; export;  // JLI 090804
function  libGetLocalIP(inst: integer; var outcome: PAnsiChar): integer; export;  // JLI 090804
procedure libClose(inst: integer); export;
function  libOpen:integer; export;

function GetTheHostIP(HostName: string; var Outcome: string): boolean;

function GetTCPError:string;

{Secure Hash Algorithm functions, library SHA.DLL and local interfaces}

function libGetLocalModule: PChar; export;
//function GetFileHash(fn: PChar): longint; export;  // JLI 090804
function GetFileHash(fn: PAnsiChar): longint; export;  // JLI 090804

implementation

uses
  AnsiStrings, rpcconf1;

{function shsTest: integer; far; external 'SHA';
procedure shsHash(plain: PChar; size: integer;
          Hash: PChar); far; external 'SHA';}    //Removed in P14

{$R *.DFM}

function libGetCurrentProcess: word;
begin
  Result := GetCurrentProcess;
end;

//function libGetLocalIP(inst: integer; var outcome: PChar): integer;  // JLI 090804
function libGetLocalIP(inst: integer; var outcome: PAnsiChar): integer;  // JLI 090804
var
//   local: PChar;  // JLI 090804
   local: PAnsiChar;  // JLI 090804
begin
  //     local := StrAlloc(255);  // JLI 090804
  local := PAnsiChar(StrAlloc(255));  // JLI 090804
  gethostname( local, 255);
  Result := libGetHostIP1(inst, local, outcome);
  AnsiStrings.StrDispose(local);
end;

function libGetLocalModule: PChar;
var
  tsk: THandle;
  name: PChar;
begin
  tsk := GetCurrentProcess;
  name := StrAlloc(1024);
  GetModuleFilename(tsk, name, 1024);
  Result := name;
end;

//function GetFileHash(fn: PChar): longint;  // JLI 090804
function GetFileHash(fn: PAnsiChar): longint;  // JLI 090804
var
  hFn: integer;
  finfo: TOFSTRUCT;
  bytesRead, status: longint;
  tBuf: PChar;

begin
  tBuf := StrAlloc(160);
  hFn := OpenFile(fn, finfo, OF_READ);
  bytesRead := 0;
  status := _lread(hFn, tBuf, sizeof(tBuf));
  while status <> 0 do begin
    status := _lread(hFn, tBuf, sizeof(tBuf));
    inc(bytesRead,status);
  end;
  _lclose(hFn);
  StrDispose(tBuf);
  Result := bytesRead;
end;

function libOpen:integer;
var
  inst: integer;
  WSData: TWSADATA;
  RPCFRM1: TRPCFRM1;
begin
  inst := 1; {in this case, no DLL so instance is always 1}
  RPCFRM1 := TRPCFRM1.Create(nil);    //P14
  WRec[inst].hWin := AllocateHWnd(RPCFRM1.wndproc);

  WSAStartUp(WINSOCK1_1, WSData);
  WSAUnhookBlockingHook;

  Result := inst;
  WRec[inst].InUse := True;
  RPCFRM1.Release;                    //P14
end;

procedure libClose(inst: integer);
begin
  WRec[inst].InUse := False;
  WSACleanup;
  DeallocateHWnd(WRec[inst].hWin);
end;

function GetTheHostIP(HostName: string; var Outcome: string): boolean;
var
  OldCur: TCursor;
  pHost: PHostEnt;
  i: integer;

begin
  Outcome := '';

  OldCur := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if HostName = '' then begin
      Outcome := 'No Name to Resolve!';
      Result := False;
    end else begin
      pHost := GetHostByName(PAnsiChar(AnsiString(HostName)));
      if pHost.h_addrtype = AF_INET then begin
        Outcome := IntToStr(ord(pHost.h_addr_list^[0]));
        for i := 1 to pHost.h_length - 1 do begin
          Outcome := Outcome + '.' + IntToStr(ord(pHost.h_addr_list^[i]));
        end;
        Result := True;
      end else begin
        Outcome := 'No IP Address';
        Result := False;
      end;
    end;
  finally
    Screen.Cursor := OldCur;
  end;
end;


function libGetHostIP1(inst: integer; HostName: PAnsiChar; var outcome: PAnsiChar): integer;  // JLI 090804
var
   //RPCFRM1: TRPCFRM1; {P14}
   //wMsg: TMSG;        {P14}
   //hWnd: THandle;     {P14}
   ChangeCursor: Boolean;

begin
  outcome[0] := #0;

  ChangeCursor := (Screen.Cursor = crDefault);
  if ChangeCursor then
    Screen.Cursor := crHourGlass;

  with WRec[inst] do begin
    if HostName[0] = #0 then begin
      AnsiStrings.StrCat(outcome,'No Name to Resolve!');
      Result := -1;
      exit;
    end;

    if CallWait then begin
      outcome[0] := #0;
      AnsiStrings.StrCat(outcome, 'Call in Progress');
      Result := -1;
      exit;
    end;

    if inet_addr(HostName) > INADDR_ANY then begin
      outcome := Hostname;
      Result := 0;
      if ChangeCursor then
        Screen.Cursor := crDefault;
      WSACleanup;
      exit;
    end;

    GetMem(pTCPResult, MAXGETHOSTSTRUCT+1);
    try
      CallWait := True;
      CallAbort := False;
      PHostEnt(pTCPResult)^.h_name := nil;
      hTCP := WSAAsyncGetHostByName(hWin, XWB_GHIP, HostName, pTCPResult, MAXGETHOSTSTRUCT );
      { loop while CallWait is True }
      CallAbort := False;
      while CallWait do
        Application.ProcessMessages;
    except
      on EInValidPointer do begin
        AnsiStrings.StrCat(outcome,'Error in GetHostByName');
        if ChangeCursor then
          Screen.Cursor := crDefault;
     end;
    end;

    FreeMem(pTCPResult, MAXGETHOSTSTRUCT+1);
    AnsiStrings.StrCopy(outcome,chrTemp);
    Result := 0;
    if ChangeCursor then
      Screen.Cursor := crDefault;
  end;
end;

function libGetHostIPStr(inst: integer; HostName: string; var outcome: string): integer;  // JLI 090804
var
  OldCur: TCursor;
  Host: AnsiString;
  pHost: PAnsiChar;

begin
  outcome := '';
  Host := AnsiString(HostName);
  pHost := PAnsiChar(Host);

  OldCur := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    with WRec[inst] do begin
      if HostName = '' then begin
        outcome := 'No Name to Resolve!';
        Result := -1;
      end else if CallWait then begin
        outcome := 'Call in Progress';
        Result := -1;
      end else if inet_addr(pHost) > INADDR_ANY then begin
        outcome := Hostname;
        Result := 0;
        WSACleanup;
      end else begin
        GetMem(pTCPResult, MAXGETHOSTSTRUCT+1);
        try
          try
            CallWait := True;
            CallAbort := False;
            PHostEnt(pTCPResult)^.h_name := nil;
            hTCP := WSAAsyncGetHostByName(hWin, XWB_GHIP, pHost, pTCPResult, MAXGETHOSTSTRUCT );
            { loop while CallWait is True }
            CallAbort := False;
            while CallWait do
              Application.ProcessMessages;
          except
            on EInValidPointer do begin
              outcome := 'Error in GetHostByName';
           end;
          end;
        finally
          FreeMem(pTCPResult, MAXGETHOSTSTRUCT+1);
        end;

        outcome := string(chrTemp);
        Result := 0;
      end;
    end;
  finally
    Screen.Cursor := OldCur;
  end;
end;

(*procedure TRPCFRM1.XWBSELECT(var msgSock: TMessage);
var
   noop: integer;
begin
     case msgSock.lparam of
       FD_ACCEPT: {connection arrived}
          begin
               noop := 1;
          end;
       FD_CONNECT: {connection initiated}
          begin
               noop := 1;
          end;
       FD_READ:    {data received, put in display}
          begin
               noop := 1;
          end;
       FD_CLOSE:   {disconnection of accepted socket}
          begin
               noop := 1;
          end;
       else
              noop := 1;
       end;
end;*)     //Procedure removed in P14.

procedure TRPCFRM1.WndProc(var Message : TMessage);
begin
  with Message do
    case Msg of
        {XWB_SELECT : xwbSelect(Message);}    //P14
      XWB_GHIP: xwbghip(Message);
    else
      DefWindowProc(WRec[1].hWin, Msg, wParam, lParam);
       {Inherited WndProc(Message);}
    end;
end;

procedure TRPCFRM1.XWBGHIP(var msgSock: TMessage);
var
  TCPResult: PHostEnt;
  WSAError: integer;
  HostAddr: TSockaddr;
  inst: integer;
  RPCConfig: TrpcConfig;

begin
  inst := 1; {local case is always 1}

  with WRec[inst] do begin

    hTCP := msgSock.WParam;

    //   chrTemp := StrAlloc(512);  // JLI 090804
    chrTemp := PAnsiChar(StrAlloc(512));  // JLI 090804

    CallWait := False;
    if CallAbort = True then begin  { User aborted call }
      AnsiStrings.StrCopy(ChrTemp,'Abort!');
      exit;
    end;

    WSAError := WSAGetAsyncError(hTCP); { in case async call failed }
    if WSAError < 0 then begin
      AnsiStrings.StrPCopy(chrTemp,AnsiString(IntToStr(WSAError)));
      exit;
    end;

    try
      TCPResult := PHostEnt(pTCPResult);
      StrTemp := '';
      if TCPResult^.h_name = nil then begin
        AnsiStrings.StrCopy(chrTemp, 'Unknown!');
        RPCConfig := TrpcConfig.GetInstance;
        if rpcConfig <> nil then
          rpcconfig.pnlIP.Caption := string(chrTemp);
        exit;
      end;
      {success, return resolved address}
      HostAddr.sin_addr.S_addr := longint(plongint(TCPResult^.h_addr_list^)^);
      chrTemp := inet_ntoa(HostAddr.sin_addr);
    except on EInValidPointer do AnsiStrings.StrCat(chrTemp, 'Error in GetHostByName');
    end;
  end;
end;

(*function libAbortCall(inst: integer): integer;
var
   WSAError: integer;
begin

   with WRec[inst] do
   begin

   WSAError := WSACancelAsyncRequest(hTCP);
   if WSAError = Socket_Error then
   begin
        WSAError := WSAGetLastError;
        CallWait := False;
        CallAbort := True;
        Result := WSAError;
   end;

   CallAbort := True;
   CallWait := False;
   Result := WSAError;

   end;

end; *)    //Removed in P14

function GetTCPError:string;
var
  x: string;
  r: integer;

begin
  r := WSAGetLastError;
  case r of
    WSAEINTR           : x := 'WSAEINTR';
    WSAEBADF           : x := 'WSAEINTR';
    WSAEFAULT          : x := 'WSAEFAULT';
    WSAEINVAL          : x := 'WSAEINVAL';
    WSAEMFILE          : x := 'WSAEMFILE';
    WSAEWOULDBLOCK     : x := 'WSAEWOULDBLOCK';
    WSAEINPROGRESS     : x := 'WSAEINPROGRESS';
    WSAEALREADY        : x := 'WSAEALREADY';
    WSAENOTSOCK        : x := 'WSAENOTSOCK';
    WSAEDESTADDRREQ    : x := 'WSAEDESTADDRREQ';
    WSAEMSGSIZE        : x := 'WSAEMSGSIZE';
    WSAEPROTOTYPE      : x := 'WSAEPROTOTYPE';
    WSAENOPROTOOPT     : x := 'WSAENOPROTOOPT';
    WSAEPROTONOSUPPORT : x := 'WSAEPROTONOSUPPORT';
    WSAESOCKTNOSUPPORT : x := 'WSAESOCKTNOSUPPORT';
    WSAEOPNOTSUPP      : x := 'WSAEOPNOTSUPP';
    WSAEPFNOSUPPORT    : x := 'WSAEPFNOSUPPORT';
    WSAEAFNOSUPPORT    : x := 'WSAEAFNOSUPPORT';
    WSAEADDRINUSE      : x := 'WSAEADDRINUSE';
    WSAEADDRNOTAVAIL   : x := 'WSAEADDRNOTAVAIL';
    WSAENETDOWN        : x := 'WSAENETDOWN';
    WSAENETUNREACH     : x := 'WSAENETUNREACH';
    WSAENETRESET       : x := 'WSAENETRESET';
    WSAECONNABORTED    : x := 'WSAECONNABORTED';
    WSAECONNRESET      : x := 'WSAECONNRESET';
    WSAENOBUFS         : x := 'WSAENOBUFS';
    WSAEISCONN         : x := 'WSAEISCONN';
    WSAENOTCONN        : x := 'WSAENOTCONN';
    WSAESHUTDOWN       : x := 'WSAESHUTDOWN';
    WSAETOOMANYREFS    : x := 'WSAETOOMANYREFS';
    WSAETIMEDOUT       : x := 'WSAETIMEDOUT';
    WSAECONNREFUSED    : x := 'WSAECONNREFUSED';
    WSAELOOP           : x := 'WSAELOOP';
    WSAENAMETOOLONG    : x := 'WSAENAMETOOLONG';
    WSAEHOSTDOWN       : x := 'WSAEHOSTDOWN';
    WSAEHOSTUNREACH    : x := 'WSAEHOSTUNREACH';
    WSAENOTEMPTY       : x := 'WSAENOTEMPTY';
    WSAEPROCLIM        : x := 'WSAEPROCLIM';
    WSAEUSERS          : x := 'WSAEUSERS';
    WSAEDQUOT          : x := 'WSAEDQUOT';
    WSAESTALE          : x := 'WSAESTALE';
    WSAEREMOTE         : x := 'WSAEREMOTE';
    WSASYSNOTREADY     : x := 'WSASYSNOTREADY';
    WSAVERNOTSUPPORTED : x := 'WSAVERNOTSUPPORTED';
    WSANOTINITIALISED  : x := 'WSANOTINITIALISED';
    WSAHOST_NOT_FOUND  : x := 'WSAHOST_NOT_FOUND';
    WSATRY_AGAIN       : x := 'WSATRY_AGAIN';
    WSANO_RECOVERY     : x := 'WSANO_RECOVERY';
    WSANO_DATA         : x := 'WSANO_DATA';
  else 
    x := 'Unknown Error';
  end;
  Result := x + ' (' + IntToStr(r) + ')';
end;

{$WARN UNSAFE_CODE ON}
end.

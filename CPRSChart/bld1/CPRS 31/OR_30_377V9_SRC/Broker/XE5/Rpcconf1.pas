{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Raul Mendoza, Joel Ivey
	Description: Server selection dialog.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
  ************************************************************** }

unit Rpcconf1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Xwbut1,
  WinSock, rpcnet, MFunStr, uNetPlace;

type
  TrpcConfig = class(TForm)
    cboServer: TComboBox;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    btnNew: TButton;
    grd: TGridPanel;
    pnlNameBase: TPanel;
    pnlName: TPanel;
    pnlIPBase: TPanel;
    pnlIP: TPanel;
    pnlPortBase: TPanel;
    pnlPort: TPanel;
    procedure cboServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure butCancelClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
  public
    Chosen: TNetPlace;
    class function GetInstance: TrpcConfig;
    class procedure FreeIt;
  end;

function GetServerInfo(var Server,Port: string): integer;
function GetServerIP(ServerName: String): String;

var
  Instance: integer;
  rServer, rPort: string;
  TaskInstance: integer;
  ServerList: TNetPlaceList;

implementation

uses AnsiStrings,AddServer;

var
  ARPCConfig: TrpcConfig;

{$R *.DFM}


function IsIPAddress(Val: String): Boolean;
var
  I: Integer;
  C: Char;
begin
  Result := True;
  for I := 1 to Length(Val) do    // Iterate
  begin
    C := Val[I];
    if not CharInSet(C, ['0','1','2','3','4','5','6','7','8','9','.']) then
    begin
      Result := False;
      Break;
    end;
  end;    // for
end;

{: Library function to obtain an IP address, given a server name }
function GetServerIP_New(ServerName: String): String;
var
  outcome: string;
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then begin
    GetTheHostIP(ServerName, Outcome);
    Result := outcome;
  end else
    Result := ServerName;
  LibClose(TaskInstance);
end;

function GetServerIP_Old(ServerName: String): String;
var
  host, outcome: PAnsiChar;  // JLI 090804
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then begin
    outcome := PAnsiChar(StrAlloc(256));  // JLI 090804
    host := PAnsiChar(StrAlloc(length(ServerName) + 1));  // JLI 090804
    ServerName := string(host);
    LibGetHostIP1(TaskInstance, host, outcome);
    Result := string(outcome);
    AnsiStrings.StrDispose(outcome);
    AnsiStrings.StrDispose(host);
  end else
    Result := ServerName;
  LibClose(TaskInstance);
end;

function GetServerIP(ServerName: String): String;
var
  outcome: string;
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then begin
    LibGetHostIPStr(TaskInstance, ServerName, outcome);
    Result := string(outcome);
  end else
    Result := ServerName;
  LibClose(TaskInstance);
end;

procedure TrpcConfig.cboServerClick(Sender: TObject);
var
  np: TNetPlace;
begin
  {Based on selction, set port and server variable}
  if assigned(Chosen) then Chosen.Free;
  Chosen := nil;
  np := ServerList[cboServer.ItemIndex];
  if assigned(np) then
    Chosen := np.Clone;
  if assigned(Chosen) then begin
    if Chosen.IP = '' then begin
      Chosen.IP := GetServerIP(Chosen.Title);
    end;
    pnlPort.Caption := IntToStr(Chosen.Port);
    pnlIP.Caption := Chosen.IP;
    pnlName.Caption := Chosen.Title;
    btnOk.Enabled := True;

    {Based on Server, get IP address.}
    pnlIP.Caption := Chosen.IP;
  end else begin
    pnlPort.Caption := '';
    pnlIP.Caption := 'Unknown';
    pnlName.Caption := '';
    btnOk.Enabled := False;
    pnlIP.Caption := '';
  end;
end;

procedure TrpcConfig.FormCreate(Sender: TObject);
var
  i: integer;
  AllServers: TNetPlaceList;
begin
  FormStyle := fsStayOnTop;
  ServerList := TNetPlaceList.Create;
  AllServers := BuildServerList;
  ServerList.PopulateFromBrokerRegistry;
  cboServer.Items.Clear;
  for i := 0 to (ServerList.Count - 1) do begin
    if ServerList[i].IP = '' then ServerList[i].IP := AllServers.ByTitle[ServerList[i].Title].IP;
    cboServer.AddItem(ServerList[i].Display, ServerList[i]);
  end;
  if cboServer.Items.Count > 0 then begin
    cboServer.ItemIndex := 0;
    cboServerClick(sender);
  end;
end;

procedure TrpcConfig.FormDestroy(Sender: TObject);
begin
  if assigned(Chosen) then Chosen.Free;
end;

class procedure TrpcConfig.FreeIt;
begin
  if assigned(ARPCConfig) then ARPCConfig.Free;
  ARPCConfig := nil;
end;

class function TrpcConfig.GetInstance: TrpcConfig;
begin
  if not assigned(ARPCConfig) then
    ARPCConfig := TRPCConfig.Create(nil);
  Result := ARPCConfig;
end;

procedure TrpcConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  cboServer.Clear;
  pnlPort.Caption := '';
  pnlIP.Caption := '';
  pnlName.Caption := '';
  ServerList.Free;
end;

function GetServerInfo(var Server,Port: string): integer;
var
  RPCConfig: TrpcConfig;
begin
  RPCConfig := TrpcConfig.GetInstance;
  try
    Result := RPCConfig.ShowModal;
    if Result = mrOK then begin
      Server := RPCConfig.Chosen.IP;
      Port := IntToStr(RPCConfig.Chosen.Port);
    end;
  finally
    TrpcConfig.FreeIt;
  end;
end;

procedure TrpcConfig.btnOkClick(Sender: TObject);
begin
  rServer := Piece(cboServer.Text,',',1);
  rPort := pnlPort.Caption;
  ModalResult := mrOK;
end;

procedure TrpcConfig.butCancelClick(Sender: TObject);
begin
  rServer := cboServer.Text;
  rPort := pnlPort.Caption;
  ModalResult := mrCancel;
end;

procedure TrpcConfig.btnNewClick(Sender: TObject);
var
  i: integer;
  ServerForm: TfrmAddServer;
  strName: string;
begin
  ServerForm := TfrmAddServer.Create(nil);
  try
    if (ServerForm.ShowModal = mrOK) then begin
      strName := ServerForm.Address + ',' + ServerForm.Port;
      ServerList.Add(TNetPlace.Create(ServerForm.Address, '', '', StrToIntDef(ServerForm.Port, 0)));
      ServerList.WriteToBrokerRegistry;
      strName := ServerList[ServerList.Count - 1].Display;
      cboServer.Items.Add(strName);
      for i := 0 to cboServer.Items.Count-1 do begin   // Iterate
        if cboServer.Items[i] = strName then
          cboServer.ItemIndex := i;
      end;    // for
      cboServerClick(Self);
    end;
  finally
    ServerForm.Free;
  end;
end;

initialization

finalization
  TrpcConfig.FreeIt;

end.


unit uBcmaOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ComObj, ActiveX,
  uConst, rOrders, ORFn, ORNet, uCore, uBcmaConst, OrderComIntf;

type
  EOrderDlgFail = class (Exception);

  TSizeHolder = class(TObject)
  private
    FSizeList,FNameList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSize(AName: String): String;
    procedure SetSize(AName,ASize: String);
    procedure AddSizesToStrList(theList: TStringList);
  end;

{ Ordering environment}
function AuthorizedUser: Boolean;
function AuthorizedToVerify: Boolean;
procedure UnlockIfAble;
function UnLockThePatient(APatientIEN: string): boolean;
function LockedForOrdering: Boolean;

{ Write orders }
function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent): Boolean;
function ActiveOrdering: Boolean;
function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
procedure DestroyingOrderDialog;
function CloseOrdering: Boolean;

// from uODBase
function AddFillerAppID(const AnID: string): Boolean;
procedure ClearFillerAppList;
procedure SetOrderFormIDOnCreate(AFormID: Integer);
function OrderFormIDOnCreate: Integer;
procedure SetOrderEventTypeOnCreate(AType: Char);
function OrderEventTypeOnCreate: Char;
function GetKeyVars: string;
procedure PopKeyVars(NumLevels: Integer = 1);
procedure PushKeyVars(const NewVals: string);

// from rMisc
procedure SaveUserBounds(AControl: TControl);
procedure SetFormPosition(AForm: TForm);

// sign orders
function ToSignChanges(ATimeout: boolean): Boolean;
function SentOrdersToInpatientMeds(AOrderList:TStringList; AECode: widestring): boolean;
var
 SizeHolder : TSizeHolder;
implementation

uses
  fODBase, fODMeds, fODMedIV, fReview, rCore, TRpcb, uOrders;

var
  uOrderDialog: TfrmODBase;
  uLastConfirm: string;
  uOrderSetTime: TFMDateTime;
  uNewMedDialog: Integer;
  uPatientLocked: Boolean;
  uKeepLock: Boolean;
  uOrderEventType: Char;
  uOrderFormID: Integer;
  uFillerAppID: TStringList;
  uKeyVarList:  TStringList;


function CreateOrderDialog(Sender: TComponent; FormID: Integer; AnEventType: Char): TfrmODBase;
{ creates an order dialog based on the FormID and returns a pointer to it }
type
  TDialogClass = class of TfrmODBase;
var
  DialogClass: TDialogClass;
begin
  Result := nil;
  SetOrderEventTypeOnCreate(#0);
  SetOrderFormIDOnCreate(FormID);
  if uNewMedDialog = 0 then
  begin
    if UseNewMedDialogs then uNewMedDialog := 1 else uNewMedDialog := -1;
  end;
  if (uNewMedDialog > 0) and ((FormID = OD_MEDOUTPT) or (FormID = OD_MEDINPT))
    then FormID := OD_MEDS;
  case FormID of
  OD_MEDIV, OD_CLINICINF :     DialogClass := TfrmODMedIV;
  OD_MEDS, OD_CLINICMED:      DialogClass := TfrmODMeds;
  else Exit;
  end;
  if Sender = nil then Sender := Application;
  Result := DialogClass.Create(Sender);
  if Result <> nil then Result.CallOnExit := DestroyingOrderDialog;
  SetOrderEventTypeOnCreate(#0);
  SetOrderFormIDOnCreate(0);
end;

// ordering enviroment
function AuthorizedUser: Boolean;
begin
  Result := True;
  if User.NoOrdering then Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
  if (MOBCallingAPP = 'CPRS') and (User.OrderRole <> OR_PHYSICIAN) then
  begin
    InfoBox('In order to use the One Step Clinic Admin, you must hold the ORES and PROVIDER keys', 'Incorrect Keys', MB_OK);
    Result := False;
  end;
  if (MOBCallingAPP = 'BCMA') and (User.OrderRole <> OR_NURSE) then
  begin
    InfoBox('In order to use the Med Order Button, you must hold the ORELSE key', 'Incorrect Keys', MB_OK);
    Result := False;
  end;
end;

function AuthorizedToVerify: Boolean;
begin
  Result := True;
  if not User.EnableVerify then Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
end;

procedure UnlockIfAble;
begin
  if (BcmaOrderChanges.Orders.Count = 0) and not uKeepLock then
  begin
    UnlockPatient;
    uPatientLocked := False;
  end;
end;

function UnLockThePatient(APatientIEN: string): boolean;
begin
  if MOBCallingApp = 'CPRS' then
    sCallV('ORBCMA5 UNLOCK', [APatientIEN, JobNumber])
  else
    sCallV('ORWDX UNLOCK', [APatientIEN]);
  uPatientLocked := False;
  Result := True;
end;

function LockedForOrdering: Boolean;
var
  ErrMsg: string;
begin
  if uPatientLocked then Result := True else
  begin
    LockPatient(ErrMsg);
    if ErrMsg = '' then
    begin
      Result := True;
      uPatientLocked := True;
    end else
    begin
      Result := False;
      InfoBox(ErrMsg, TC_NO_LOCK, MB_OK);
    end;
  end;
end;

{ writing order }
function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent): Boolean;
const
  TC_IMO_ERROR  = 'Inpatient medication order on outpatient authorization required';
var
  ResolvedDialog: TOrderDialogResolved;
  x, EditedOrder: string;
  IsAnIMOOrder, ForIMO: Boolean;
begin
  Result := False;
  ForIMO := False;

  if not IMOActionValidation(AnID, IsAnIMOOrder, x, AnEvent.EventType) then
  begin
    ShowMsgOn(Length(x) > 0, x, TC_IMO_ERROR);
    Exit;
  end;

  if ( (StrToIntDef(AnId,0)>0) and (AnEvent.EventIFN <= 0) ) then
    ForIMO := IsIMODialog(StrToInt(AnId))
  else if ( (IsAnIMOOrder) and (AnEvent.EventIFN <= 0) ) then
    ForIMO := True;

  if uOrderDialog <> nil then x := uOrderDialog.Name else x := '';
  if ShowMsgOn(uOrderDialog <> nil, TX_DLG_ERR + CRLF + x, TC_DLG_ERR) then Exit;
  ResolvedDialog.InputID := AnID;
  BuildResponses(ResolvedDialog, GetKeyVars, AnEvent);
  if ShowMsgOn(not (ResolvedDialog.FormID > 0), TX_NOFORM, TC_NOFORM) then Exit;
  EditedOrder := '';

  if ((ResolvedDialog.DialogIEN = MedsInDlgIen) or (ResolvedDialog.DialogIEN = MedsIVDlgIen)) and (LocationType(Encounter.Location) = 'C') then
  begin
    if ResolvedDialog.DialogIEN = MedsInDlgIen then
    begin
      ResolvedDialog.InputID := IntToStr(ClinMedsDlgIen);
    end
    else
    begin
      ResolvedDialog.InputID := IntToStr(ClinIVDlgIen);
    end;
    BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
  end;

  uOrderDialog := CreateOrderDialog(nil, ResolvedDialog.FormID, AnEvent.EventType);
  if (uOrderDialog <> nil) and not uOrderDialog.Closing then with uOrderDialog do
  begin
    Responses.LogTime := uOrderSetTime;
    DisplayGroup := ResolvedDialog.DisplayGroup;     // used to pass ORTO
    DialogIEN    := ResolvedDialog.DialogIEN;        // used to pass ORIT
    case ResolvedDialog.DialogType of
    'C': SetupDialog(ORDER_COPY,  ResolvedDialog.ResponseID);
    'D': SetupDialog(ORDER_NEW,   '');
    'X': SetupDialog(ORDER_EDIT,  ResolvedDialog.ResponseID);
    'Q': SetupDialog(ORDER_QUICK, ResolvedDialog.ResponseID);
    end;
    if ResolvedDialog.QuickLevel <> QL_AUTO then
    begin
        Position := poScreenCenter;
        FormStyle := fsNormal;
        ShowModal;
    end;
    Result := Not (uOrderDialog.IsCanceled);
    uOrderDialog.IsCanceled := False;
  end
end;

function ActiveOrdering: Boolean;
begin
  if uOrderDialog = nil then Result := False
  else Result := True;
end;

function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
var
  x: string;
begin
  Result := False;
  { make sure a location and provider are selected before ordering }
  if not AuthorizedUser then Exit;
  { then try to lock the patient (provider & encounter checked first to not leave lock) }
  if not LockedForOrdering then Exit;
  { make sure any current ordering process has completed, but don't drop patient lock }
  uKeepLock := True;
  if not CloseOrdering then Exit;
  uKeepLock := False;
  { get the delay event for this order (if applicable) }
  if CharInSet(AnEvent.EventType, ['A','D','T']) then
  begin
    x := AnEvent.EventType + IntToStr(AnEvent.Specialty);
    if uLastConfirm <> x then
    begin
      uLastConfirm := x;
      case AnEvent.EventType of
      'A': x := 'Admit to ' + ExternalName(AnEvent.Specialty, 45.7);
      'D': x := 'Discharge';
      'T': x := 'Transfer to ' + ExternalName(AnEvent.Specialty, 45.7);
      end;
      InfoBox(TX_DELAY + x + TX_DELAY1, TC_DELAY, MB_OK or MB_ICONWARNING);
    end;
  end
  else uLastConfirm := '';
  Result := True;
end;

function CloseOrdering: Boolean;
begin
  Result := False;
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    Application.ProcessMessages;  // allow close to finish
    if uOrderDialog <> nil then Exit;
  end;
  Result := True;
end;

procedure DestroyingOrderDialog;
begin
  uOrderDialog := nil;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

{ Order Checking }
function AddFillerAppID(const AnID: string): Boolean;
begin
  Result := False;
  if uFillerAppID.IndexOf(AnID) < 0 then
  begin
    Result := True;
    uFillerAppID.Add(AnID);
  end;
end;

procedure ClearFillerAppList;
begin
  uFillerAppID.Clear;
end;

{ Ordering Environment }
procedure SetOrderFormIDOnCreate(AFormID: Integer);
begin
  uOrderFormID := AFormID;
end;

function OrderFormIDOnCreate: Integer;
begin
  Result := uOrderFormID;
end;

procedure SetOrderEventTypeOnCreate(AType: Char);
begin
  uOrderEventType := AType;
end;

function OrderEventTypeOnCreate: Char;
begin
  Result := uOrderEventType;
end;

function GetKeyVars: string;
begin
  Result := '';
  with uKeyVarList do if Count > 0 then Result := Strings[Count - 1];
end;

procedure PopKeyVars(NumLevels: Integer = 1);
begin
  with uKeyVarList do while (NumLevels > 0) and (Count > 0) do
  begin
    Delete(Count - 1);
    Dec(NumLevels);
  end;
end;

procedure PushKeyVars(const NewVals: string);
var
  i: Integer;
  x: string;
begin
  if uKeyVarList.Count > 0 then x := uKeyVarList[uKeyVarList.Count - 1] else x := '';
  for i := 1 to MAX_KEYVARS do
    if Piece(NewVals, U, i) <> '' then SetPiece(x, U, i, Piece(NewVals, U, i));
  uKeyVarList.Add(x);
end;

function UseNewMedDialogs: Boolean;
begin
  Result := sCallV('ORBCMA1 CHK94', [nil]) = '1';
end;

procedure SaveUserBounds(AControl: TControl);
var
  x: string;
begin
  with AControl do
    x := IntToStr(Left) + ',' + IntToStr(Top) + ',' + IntToStr(Width) + ',' + IntToStr(Height);
  CallV('ORWCH SAVESIZ', [AControl.Name, x]);
end;

function ToSignChanges(ATimeout: Boolean): Boolean;
begin
  result := ReviewChanges(ATimeOut);
end;

function SentOrdersToInpatientMeds(AOrderList:TStringList; AECode: widestring): boolean;
const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';
var
  i,j: Integer;
  tmpSignInfo: string;
  PtIen, PdIen, LcIen, Ecode: string;
  OrderList: TStringList;
  tmpOrderList: TStringList;
  TheOrderText: string;
begin
  //Result := False; //make compiler happy
  tmpOrderList := TStringList.Create;
  OrderList    := TStringList.Create;
  tmpSignInfo := '';
  Ecode := AECode;
  for i := 0 to AOrderList.Count - 1 do
  begin
   tmpOrderList.Add(Pieces(AOrderList[i],';',1,2)+ '^' + Piece(AOrderList[i],'~',2)
        + '^' + Piece(AOrderList[i],'~',3) + '^' + Piece(AOrderList[i],'~',4));
   tmpSignInfo := Piece(AOrderList[i],'~',5);
   PtIen := Piece(tmpSignInfo,';',1);
   PdIen := Piece(tmpSignInfo,';',2);
   LcIen := Piece(tmpSignInfo,';',3);
   CallV('ORWDX SEND', [PtIen, PdIen, LcIen, ' ' + ECode, tmpOrderList]);
   with RPCBrokerV do for j := 0 to Results.Count - 1 do
   begin
    if Piece(Results[j], U, 4) = 'This order requires a signature.'
      then Results[j] := Piece(Results[j], U, 1);
    OrderList.Add(RPCBrokerV.Results[j]);
   end;
   try
     RPCBrokerV.ShowErrorMsgs := semQuiet;
     CallV('ORWDXA VERIFY',[Pieces(AOrderList[i],';',1,2),ECODE]);
     RPCBrokerV.ShowErrorMsgs := semRaise;
   except
     //Below line didn't really do anything
     //on E: Exception do a := 0;
   end;
   tmpOrderList.Clear;
  end;
  tmpOrderList.Free;
  with OrderList do for i := 0 to Count - 1 do
  begin
   if Pos('E', Piece(OrderList[i], U, 2)) > 0 then
   begin
     for j := 0 to AOrderList.Count - 1 do
     begin
       if Pos( Piece(OrderList[i], U, 1), AOrderList[j])>0 then
          TheOrderText := Piece(AOrderList[j],';',3);
     end;
     InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) + TX_SAVERR2 + TheOrderText,TC_SAVERR, MB_OK);
   end;
  end;
  OrderList.Free;
  sCallV('ORWDX UNLOCK', [PtIen]);
  uPatientLocked := False;
  Result := True;
end;

procedure SetFormPosition(AForm: TForm);
var
  x: string;
  Rect: TRect;
begin
//  x := sCallV('ORWCH LOADSIZ', [AForm.Name]);
  x := SizeHolder.GetSize(AForm.Name);
  if x = '' then Exit; // allow default bounds to be passed in, else screen center?
  if (x = '0,0,0,0') then
    AForm.WindowState := wsMaximized
  else
  begin
    AForm.SetBounds(StrToIntDef(Piece(x, ',', 1), AForm.Left),
                    StrToIntDef(Piece(x, ',', 2), AForm.Top),
                    StrToIntDef(Piece(x, ',', 3), AForm.Width),
                    StrToIntDef(Piece(x, ',', 4), AForm.Height));
    Rect := AForm.BoundsRect;
    ForceInsideWorkArea(Rect);
    AForm.BoundsRect := Rect;
  end;
end;
constructor TSizeHolder.Create;
begin
  inherited;
  FNameList := TStringList.Create;
  FSizeList := TStringList.Create;
end;


destructor TSizeHolder.Destroy;
begin
  FNameList.Free;
  FSizeList.Free;
  inherited;
end;

function TSizeHolder.GetSize(AName: String): String;
{Fuctions returns a String of the Size(s) Of the Name parameter passed,
 if the Size(s) are already loaded into the object it will return those,
 otherwise it will make the apropriate RPC call to LOADSIZ}
var
  rSizeVal: String; //return Size value
  nameIndex: integer;
begin
  rSizeVal := '';
  nameIndex := FNameList.IndexOf(AName);
  if nameIndex = -1 then //Currently Not in the NameList
  begin
    rSizeVal := sCallV('ORWCH LOADSIZ', [AName]);
    if rSizeVal <> '' then
    begin
      FNameList.Add(AName);
      FSizeList.Add(rSizeVal);
    end;
  end
  else //Currently is in the NameList
    rSizeVal := FSizeList[nameIndex];
  result := rSizeVal;
end;

procedure TSizeHolder.SetSize(AName, ASize: String);
{Store the Size(s) Of the ASize parameter passed, Associate it with the AName
 Parameter. This only stores the sizes in the objects member variables.
 to Store on the MUMPS Database call SendSizesToDB()}
var
  nameIndex: integer;
begin
  nameIndex := FNameList.IndexOf(AName);
  if nameIndex = -1 then //Currently Not in the NameList
  begin
    FNameList.Add(AName);
    FSizeList.Add(ASize);
  end
  else //Currently is in the NameList
    FSizeList[nameIndex] := ASize;
end;

procedure TSizeHolder.AddSizesToStrList(theList: TStringList);
{Adds all the Sizes in the TSizeHolder Object to theList String list parameter}
var
  i: integer;
begin
  for i := 0 to FNameList.Count-1 do
    theList.Add('B' + U + FNameList[i] + U + FSizeList[i]);
end;

initialization
  uLastConfirm   := '';
  uOrderSetTime  := 0;
  uNewMedDialog  := 0;
  uOrderDialog   := nil;
  uPatientLocked := False;
  uKeepLock      := False;
  uOrderEventType := #0;
  uOrderFormID := 0;
  uFillerAppID := TStringList.Create;
  uKeyVarList  := TStringList.Create;

finalization
  uFillerAppID.Free;
  uKeyVarList.Free;
end.

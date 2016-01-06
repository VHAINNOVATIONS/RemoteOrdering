unit OrderComIntf;

interface

uses
  ComObj, ActiveX, AXCtrls, BCMAOrderCom_TLB, StdVcl, uCore, ORFn, ORNet, SysUtils,
   Classes, Dialogs, rOrders, VHA_OBjects, uBCMA, TRPCb, CCOWRPCBroker, Windows;

  procedure InitMOB(aConnectParams: wideString; aRunParams: wideString; var aResult: Boolean);
  function ActivateIVDialog(const DlgIEN, Solutions, Additives: WideString;
    var AnOrderID: WideString; ProviderIEN: Int64; IVType: integer): WordBool; safecall;
  function ActivateUDDialog(DlgIEN: WideString; OIIen: Int64;
    var AnOrderID: WideString; ProviderIEN: Int64): WordBool; safecall;
  function SignOrders(TimeOut: WordBool; var AnOrderList,
    AECode: WideString): WordBool; safecall;
  function SendOrders(const AnOrdersList, AECode: WideString): WordBool;
    safecall;
  function DcOrders(const AnOrderLst: WideString): WordBool; safecall;
  function BcmaUnlockPatient(const APatientIEN: WideString): WordBool;
    safecall;
  function BcmaUnlockOrders(const AnOrderList: WideString): WordBool;
    safecall;
  function SetupBroker(aConnectParams: wideString): Boolean;
  procedure ReleaseBroker;
  function ContinueIFClinicOrder: Boolean;

var
  Event: TOrderDelayEvent;
  OrderCount: Integer = 0;
  BCMA_Broker: TBCMA_Broker;

implementation

uses ComServ, uBcmaOrder, rCore, uOrders, uConst, fEncnt;

function ActivateIVDialog(const DlgIEN, Solutions,
  Additives: WideString; var AnOrderID: WideString; ProviderIEN: Int64; IVType: Integer): WordBool;
begin
  if (Length(Solutions)< 1) then
  begin
    ShowMessage('There is no solution selected, you can not proceed for this IV order.');
    Result := False;
    Exit;
  end;
  Encounter.Provider := ProviderIEN;
  BcmaSolutions := TStringList.Create;
  BcmaAdditives := TStringList.Create;
  PiecesToList(Solutions,'^',BcmaSolutions);
  PiecesToList(Additives,'^',BcmaAdditives);
  BcmaIVType := IVType;
  Result :=  ActivateOrderDialog(DlgIEN, Event);
  if length(BcmaOrderID)> 0 then
    AnOrderID := BcmaOrderID + '~' + IntToStr(Encounter.provider) + ';' + IntToStr(Encounter.Location);
  BcmaOrderID := '';
  BcmaSolutions.Clear;
  BcmaAdditives.Clear;
end;

function ActivateUDDialog(DlgIEN: WideString;
  OIIen: Int64; var AnOrderID: WideString; ProviderIEN: Int64): WordBool;
begin
  if not ReadyForNewOrder(Event) then
    Exit;
  Encounter.Provider := ProviderIEN;
  BcmaDrugIen := OIIen;
  if BcmaDrugIen < 1 then
    Exit;

  Result := ActivateOrderDialog(DlgIEN, Event);
  if length(BcmaOrderID)> 0 then
    AnOrderID := BcmaOrderID + '~' + IntToStr(Encounter.provider) + ';' + IntToStr(Encounter.Location);
  BcmaOrderID := '';
end;

function SignOrders(TimeOut: WordBool; var AnOrderList,
  AECode: WideString): WordBool;
begin
  if (BcmaOrderChanges <> nil) and (BcmaOrderChanges.Orders.Count > 0) then
  begin
    if not ToSignChanges(Timeout) then
    begin
      ANOrderList := '';
      AECode := '';
      BcmaSignedOrder    := '';
      BcmaCanceledOrder  := '';
      BcmaSignInfo       := '';
      Result := False;
    end else
    begin
     if (BcmaSignedOrder = '') and ( BcmaCanceledOrder = '') then
      AnOrderList := ''
     else if (BcmaSignedOrder <> '') and ( BcmaCanceledOrder = '') then
      AnOrderList := BcmaSignedOrder
     else if (BcmaSignedOrder = '') and ( BcmaCanceledOrder <> '') then
      AnOrderList := BcmaCanceledOrder
     else
      AnOrderList := BcmaSignedOrder + '^' + BcmaCanceledOrder;
     AECode := BcmaSignInfo;
     BcmaSignedOrder    := '';
     BcmaCanceledOrder  := '';
     BcmaSignInfo       := '';
     if BcmaOrderChanges.Count > 0 then
       BcmaOrderChanges.Clear;
     Result := True;
    end;
  end;
end;

function SendOrders(const AnOrdersList,
  AECode: WideString): WordBool;
var
  OrderListBeSend: TStringList;
begin
  OrderListBeSend := TStringList.Create;
  PiecesToList(AnOrdersList,'^',OrderListBeSend);
  Result := SentOrdersToInpatientMeds(OrderListBeSend,AECode);
end;

function DcOrders(const AnOrderLst: WideString): WordBool;
var
  TheOrderList: TStringList;
  AOrderID: string;
  AProviderIEN: int64;
  ALocationIEN:  integer;
  idx,count: integer;
begin
  Result := False;
  TheOrderList := TStringList.Create;
  PiecesToList(AnOrderLst,'^',TheOrderList);
  count := TheOrderList.Count;
  if count > 0 then
  begin
    for idx := 0 to count - 1 do
    begin
      AOrderID := Piece(TheOrderList[idx],'~',1);
      AProviderIEN := StrToInt64(Piece(Piece(TheOrderList[idx],'~',2),';',1));
      ALocationIEN  := StrToInt(Piece(Piece(TheOrderList[idx],'~',2),';',2));
      CallV('ORWDXA DC', [AOrderID, AProviderIEN, ALocationIEN, '']);
    end;
    Result := True;
  end;
  UnlockIfAble;
  if Assigned(BcmaOrderChanges) and (BcmaOrderChanges.count > 0 ) then
  begin
    BcmaOrderChanges.Clear;
    UnlockIfAble;
  end;
end;

function BcmaUnlockPatient(
  const APatientIEN: WideString): WordBool;
begin
  result := UnLockThePatient(APatientIEN);
end;

function BcmaUnlockOrders(
  const AnOrderList: WideString): WordBool;

var
  OrderList: TStringList;
  i: integer;
begin
  Result := False;
  OrderList := TStringList.Create;
  PiecesToList(AnOrderList,'^',OrderList);
  for i := 0 to OrderList.Count - 1 do
    UnlockOrder(OrderList[i]);
  Result := True;
end;

procedure InitMOB(aConnectParams: wideString; aRunParams: wideString;
  var aResult: Boolean);
begin

  // AppHandle^Server^Port
  // PatientIEN^CallingAPP^ProviderIEN^InstructorIEN^LocationIEN^UserDivision
  try

    if not SetupBroker(aConnectParams) then
      begin
        aResult := false;
        exit;
      end;

    User := TUser.Create;
    Patient := TPatient.Create;
    Patient.DFN := Piece(aRunParams, '^', 1);
    Encounter := TEncounter.Create;
    MOBCallingApp := Piece(aRunParams, '^', 2);
    Encounter.Provider := StrToInt64Def(Piece(aRunParams, '^', 3), 0);
    MOBInstructor := Piece(aRunParams, '^', 4);
    Encounter.Location := StrToIntDef(Piece(aRunParams, '^', 5), 0);
    JobNumber := Piece(aRunParams, '^', 6);

    if Encounter.Location = 0 then UpdateEncounter(NPF_SUPPRESS);

    //This will be caught before the DLL is called in CPRS, so this will only apply to BCMA
    if Encounter.location = 0 then
      begin
        InfoBox('An enounter location must be selected to use the Med Order Button with an outpaitient', 'Encounter Location Required!', MB_OK);
        aResult := False;
        exit;
      end;

    Encounter.DateTime := FMNow;

    if (MOBCallingApp = 'CPRS') and (JobNumber = '') then
      begin
        InfoBox('The Job Number from CPRS is missing and the One Step Clinic Admin can not be used!', 'Error Job Number Missing', MB_OK);
        aResult := False;
        exit;
      end;

    Event.EventType := 'C';
    Event.Specialty := 0;
    Event.Effective := 0;

    InitialOrderVariables;

    BcmaDrugIen := 0;
    BcmaOrderID := '';
    BcmaSignedOrder := '';
    BcmaCanceledOrder := '';
    BcmaSignInfo := '';
    if BcmaOrderChanges = nil then
      BcmaOrderChanges := TChanges.Create;

    if Changes = nil then
      Changes := TChanges.Create;

    if not AuthorizedUser or not ContinueIfClinicOrder or not LockedForOrdering then
    begin
      aResult := False;
      exit;
    end;

    InitBCMA;
    BeginOrder;
    aResult := True;
  finally
    ReleaseBroker;
  end;
end;

Function SetupBroker(aConnectParams: wideString): Boolean;
begin

  //Yes two different brokers, sort of, in order to temporarily
  //not have to re-write all the bcma code.

  Result := False;
  EnsureBroker;
  With RPCBRokerV Do
  Try
    KernelLogIn := False;
    AccessVerifyCodes := '';
    LogIn.LogInHandle := Piece(aConnectParams, '^', 1);
    Server := Piece(aConnectParams, '^', 2);
    ListenerPort := StrToInt(Piece(aConnectParams, '^', 3));
    Login.Division := Piece(aConnectParams, '^', 4);
    LogIn.Mode := lmAppHandle;
    RPCTimeLimit := 60;
    Connected := True;
    ClearParameters := True;
    ClearResults := True;
    if not CreateContext('OR BCMA ORDER COM') then
    begin
      InfoBox('User does not have access to OR BCMA ORDER COM', 'Error', MB_OK);
      exit;
    end;
    Result := True;
  except
    on E: EBrokerError do
    begin
      InfoBox ('Broker Error: ' + E.Message, 'Broker Error', MB_OK);
      exit;
    end;
  End;

  BCMA_Broker := TBCMA_Broker(RPCBrokerV);
end;

procedure ReleaseBroker;
begin
  RPCBrokerV.Connected := False;
  FreeAndNil(RPCBrokerV);
end;

function ContinueIfClinicOrder: Boolean;
var
  ClinicLocationMsg : string;
begin
  Result := True;
  if Patient.Inpatient and (LocationType(Encounter.Location) = 'C') then
  begin
    ClinicLocationMsg := 'You are about to enter a Clinic ';

    ClinicLocationMsg := ClinicLocationMsg + ' order.  Are you sure this is what you want to do?';
    if (InfoBox(ClinicLocationMsg, 'Clinic Location', MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_NO) then Result := False;
  end;
end;

initialization

end.

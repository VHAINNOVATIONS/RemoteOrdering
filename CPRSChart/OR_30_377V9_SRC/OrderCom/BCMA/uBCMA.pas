unit uBCMA;

interface

uses
  classes, SysUtils;

var
  OMMedOrders: TList;
  OMMedOrdersOrderID, ListInjectionSites: TStringList;
  UNITDOSE_DIALOG, IV_DIALOG: String;

procedure InitBCMA;
procedure FreeBCMA;
procedure BeginOrder;
procedure InitOMMedOrder;
procedure ClearOMMedOrders;
procedure SendOMMedOrders(OrderIDString: WideString);

implementation

uses
  BCMA_OrderMan, BCMA_Objects, VHA_Objects, OrderComIntf, uCore, orfn;


procedure InitBCMA;
begin
    OMMedOrders := TList.Create;
    OMMedOrdersOrderID := TStringList.Create;
    ListInjectionSites := TStringList.create;

    With BCMA_Broker do
      begin
        if CallServer('PSB PARAMETER', ['GETLST', 'ALL', 'PSB LIST INJECTION SITES'], nil) then
          ListInjectionSites.Assign(Results);
          ListInjectionSites.delete(0);
          ListInjectionSites.Sorted := True;
        if CallServer('ORBCMA5 GETUDID', [''], nil, True) then
          UNITDOSE_DIALOG := Results[0];
        if CallServer('ORBCMA5 GETIVID', [''], nil, True) then
          IV_DIALOG := Results[0];
    end;
end;

procedure FreeBCMA;
begin
    OMMedOrders.free;
    OMMedOrdersOrderID.free;
end;

procedure BeginOrder;
begin
  with TfrmCPRSOrderManager.create(nil) do
  try
    showmodal;
  finally
    free;
  end;
end;

procedure InitOMMedOrder();
begin
  with OMMedOrders do
    add(TBCMA_OMMedOrder.Create(nil));
end;

procedure ClearOMMedOrders;
var
  i: integer;
begin
  if OMMedorders <> nil then
    with OMMedorders do
    begin
      for i := count - 1 downto 0 do
      begin
        TBCMA_OMMedOrder(items[i]).ClearScannedMeds;
        TBCMA_OMMedorder(items[i]).free;
      end;
      clear;
    end;
  OMMedOrdersOrderID.Clear;
end;

procedure CancelOMMedOrders();
begin

end;

procedure SendOMMedOrders(OrderIDString: WideString);
var
  x: integer;
  zOrderID: string;
begin
  for x := 0 to OMMedOrders.Count - 2 do
    with TBCMA_OMMedOrder(OMMedOrders[x]) do
    begin
      zOrderID := Piece(OrderIDString, '^', x + 1);
      zOrderID := Piece(zOrderID, ';', 1);
      if zOrderID <> '-1' then
      begin
        SendOrder(zOrderID);
      end;
    end
end;

//procedure SendOrder(OrderIDIn: string);
//var
//  index,
//    x,
//    ddCount,
//    addCOunt,
//    solCount: integer;
//  MultList: TStringList;
//  CmdString,
//    DDString, ADDString, SOLString: string;
//begin
//  MultList := TStringList.Create;
//  ddCount := 0;
//  addCount := 0;
//  solCount := 0;
////  with BCMA_Patient do
//    if OMMedOrdersOrderID.Find(OrderIDIn, Index) then
//    begin
//      with TBCMA_OMMedOrder(OMMedOrders[index]) do
//      begin
//        CmdString := Patient.DFN + '^' + piece(OrderID, ';', 1) +
//          '^' + UpperCase(Schedule);
//        with MultList do
//        begin
//          add(IVType);
//          add(IntSyringe);
//          add(AdminDateTime);
//
//          for x := 0 to ScannedMeds.Count - 1 do
//            with TBCMA_OMScannedMeds(ScannedMeds[x]) do
//            begin
//              if ScannedDrugType = 'DD' then
//              begin
//                ddCount := ddCount + 1;
//                if DDString = '' then
//                  DDString := ScannedDrugIEN + '^' + IntToStr(UnitsPerDose)
//                else
//                  DDString := DDString + '^' + ScannedDrugIEN + '^' + IntToStr(UnitsPerDose);
//              end;
//
//              if ScannedDrugType = 'ADD' then
//              begin
//                addCount := addCount + 1;
//                if ADDString = '' then
//                  ADDString := AdditiveIEN
//                else
//                  ADDString := ADDString + '^' + AdditiveIEN;
//              end;
//              if ScannedDrugType = 'SOL' then
//              begin
//                solCount := solCount + 1;
//                if SOLString = '' then
//                  SOLString := SolutionIEN
//                else
//                  SOLString := SOLString + '^' + SolutionIEN;
//              end;
//            end;
//
//          add(IntToStr(ddCount));
//          add(DDString);
//          add(IntToStr(addCount));
//          add(ADDString);
//          add(IntToStr(solCount));
//          add(SOLString);
//          add(InjectionSite);
//          { TODO : Need From BCMA }
//          //add(BCMA_User.InstructorDUZ);
//          add('');
//        end;
//      end;
//    end;
//  if (BCMA_Broker <> nil) then
//    with BCMA_Broker do
//      if CallServer('PSB CPRS ORDER', [CmdString], MultList) then
//        if Results[0] = '-1' then
//
//end;
//
//procedure GetSolAddStr(var SolutionList, AdditiveList: WideString);
//var
//  Solutions,
//    Additives: WideString;
//  x: integer;
//begin
//  Solutions := '';
//  Additives := '';
//  AdditiveList := '';
//  SolutionList := '';
//  for x := 0 to ScannedMeds.Count - 1 do
//  begin
//    if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'ADD' then
//      if AdditiveList = '' then
//        AdditiveList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
//      else
//        AdditiveList := AdditiveList + '^' + TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
//          //Additives.Add(TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN)
//    else if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'SOL' then
//      if SolutionList = '' then
//        SolutionList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
//          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
//      else
//        SolutionList := SolutionList + '^' + TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
//          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
//          //Solutions.Add(TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN);
//  end;
//end;


end.

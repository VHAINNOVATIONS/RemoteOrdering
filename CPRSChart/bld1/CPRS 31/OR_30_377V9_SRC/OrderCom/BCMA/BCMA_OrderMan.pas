unit BCMA_OrderMan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BCMA_Objects, BCMA_Common, BCMA_Util, OleServer, ORNet,
  {BMOCom_TLB,} ComObj, BcmaOrderCom_TLB, VHA_Objects, ORSystem, VAUtils, System.UITypes;

const
  IVTypeConvert: array[0..2] of string = ('A', 'P', 'S');
  IntSyringeConvert: array[0..1] of string = ('1', '0');
  SHARE_DIR = '\VISTA\Common Files\';
  MOBDLLName = 'BCMAOrderCom.dll';

 type
  TfrmCPRSOrderManager = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbxInjectionSite: TComboBox;
    Label3: TLabel;
    edtActionDateTime: TEdit;
    GroupBox4: TGroupBox;
    lstMedSol: TListBox;
    btnReviewSign: TButton;
    Button2: TButton;
    Button3: TButton;
    pnlTop: TPanel;
    GroupBox3: TGroupBox;
    lblIVType: TLabel;
    lblIntSyringe: TLabel;
    cbxIVType: TComboBox;
    cbxIntSyringe: TComboBox;
    GroupBox1: TGroupBox;
    rbtnUD: TRadioButton;
    rbtnIV: TRadioButton;
    pnlLower: TPanel;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    pnlScannerIndicator: TPanel;
    GroupBox6: TGroupBox;
    edtOMScannerInput: TEdit;
    edtProvider: TEdit;
    cbxSchedule: TComboBox;
    lblSchedule: TLabel;
    procedure edtOMScannerInputKeyPress(Sender: TObject; var Key: Char);
    {
      if a carriage return is received, call method ScanMed
    }

    procedure FormCreate(Sender: TObject);
    {
      assign items to the injection site drop down box and call method
      TBCMA_Patient.InitOMMedOrder
    }

    procedure edtActionDateTimeExit(Sender: TObject);
    {
      Validates the entered date and time
    }

    procedure Button2Click(Sender: TObject);
    {
      Checks to make sure all the required fields are filled in.  If so, calls
      the CPRS Med Order Button com object, passing the required data dependant
      on the type of order created.
      The specifications for the calls made in this procedure is as follows:
      (Provided by CPRS)

      function ActivateIVDialog(const DlgIEN: WideString; const
        Solutions,Additives: IStrings; var AnOrderID: WideString): WordBool; safecall;
        return True:    the order is accepted
        return False:   the order is canceled
        DlgIEN: IV dialog IEN.
        Solutions: a widestring of solutions orderable IENs delimited with "^".
	      1209^1190^1320^..
        Additives: a widestring of additives orderable IENs delimited with "^".
	      1109^1932^1123^..
        AnOrderID: OrderID~ProviderIEN;LocationIEN

      function ActivateUDDialog(const DlgIEN: WideString;
        OIIen: Int64; var AnOrderID: WideString): WordBool; safecall;
        return True:    the order is accepted
        return False:   the order is canceled
        DlgIEN: UD dialog IEN.
        OIIen: orderable item IEN
        AnOrderID: OrderID~ProviderIEN;LocationIEN
      procedure InitObjects(const PatientIEN: WideString;
        ProviderIEN: Int64; LocationIEN: Integer); safecall;
    }

    procedure edtProviderExit(Sender: TObject);
    {
      Providers a list of providers that contain the characters entered into this field
    }

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {
      Calls method BCMA_Patient.ClearOMMedOrders
      Also calls the method aBCMAOrder.BcmaUnlockPatient, and sets aBCMAOrder to nil.
      BcmaUnlockPatient is a method the CPRS Med Order Button Com object.
      The specifications for the calls made in this procedure is as follows:
      (Provided by CPRS)

      function BcmaUnlockPatient(const APatientIEN: WideString):
        wordBool; safecall;
        unlock the patient.
    }

    procedure rbtnIVClick(Sender: TObject);
    {
      Enable/disable other controls based on the state of this control
    }

    procedure FieldChange(Sender: TObject);
    {
      Set FieldChanged = true
    }

    procedure Button3Click(Sender: TObject);
    {
      If an order is in process, prompts to cancel the current order by clear
      all the fields and clearing the current object that stores the data.
      If an order is not in process, asks the user if they want to cancel all
      the orders.  If so, clears all the objects that are storing temporary
      data and calls the CPRS Medorder Button COM object to DC all the orders.

      The specifications for the calls made to the CPRS Med Order Button COM
      object in this procedure is as follows:
      (Provided by CPRS)

      function DcOrders(const AnOrderLst: WideString): WordBool; safecall;
        Before Sign the order, click cancel in Order Manager Dialog need to
        call this function to cancel all of the previous orders.
    }

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
      Sets the variable CanClose = CloseFrm
    }

    procedure btnReviewSignClick(Sender: TObject);
    {
      Allows the user to view and sign the orders that were created.
      Calls methods aBcmaOrder.SignOrders, BCMA_Patient.SendOMMedOrders,
      aBCMAOrder.SendOrders, aBcmaOrder.BcmaUnlockOrders

      The specifications for the calls made to the CPRS Med Order Button COM
      object in this procedure is as follows:
      (Provided by CPRS)


      SignOrders(TimeOut: WordBool; var ALstOrderID: WideString;
        var InfoForSign: WideString): WordBool; safecall;

        ALstOrderID contains all of the orders (Accepted or Canceled in sign order window)

        DataFormat:
        OrderID1;OrderText^OrderID2;OrderText^OrderID3;OrderText...
        Canceled Order:  -1;OrderID1;OrderText
        Signed   Order;  OrderID2;OrderText
        Attention: each OrderID has two part(OrderIEN;ORDA) as follow:
        12345;1
        334522;1

        InfoForSign contains all of the information needed to sign thest orders.
        DataFormat:
        PatientIFN^ProviderIEN^LocationIEN^ESCode

      SendOrders(const AnOrdersList, InfoForSign: WideString):
        WordBool; safecall;

        AnOrdersList: list of orders
        DataFormat: ORDER1^ORDER2^ORDER3
           AS "1232;1^35645;1^5646546;1"

        InfoForSign necessary information for Sign orders, should be same as the one retrieved from SignOrders.
        DataFormat:
        PatientIFN^ProviderIEN^LocationIEN^ESCode

      function BcmaUnlockPatient(const APatientIEN: WideString):
      wordBool; safecall;
      unlock the patient.
    }

    procedure cbxIVTypeChange(Sender: TObject);
    {
      enables/disables controls based on the state of this control
    }

    procedure cbxIntSyringeChange(Sender: TObject);
    {
      enables/disables controls based on the state of this control
    }

    procedure edtOMScannerInputEnter(Sender: TObject);
    {
      Sets pnlScannerIndicator color to lime, and sets Label6.caption = Ready
    }

    procedure edtOMScannerInputExit(Sender: TObject);
    {
      if edtOMScannerInput.Text is not null, then call method ScanMed.
      Otherwise to pnlScannerIndicator color to red, and set label6.capation
      = Not Ready
    }

    procedure pnlScannerIndicatorClick(Sender: TObject);
    {

    }

  private
    { Private declarations }
    fFieldChanged: Boolean;
    fCloseFrm: Boolean;
    procedure ClearForm(Reset: Boolean = True);
    {
      Clears all the text fields, resets all the drop down boxes, radio button,
      etc, to their default values.
    }

    procedure ScanMed;
    {
      Calls method isValidMedSolution to validate the scanned medication based
      on whether they are creating a unit dose order or an IV order, if valid,
      then adds the med to the list of medications scanned.
    }
    function GetGUID: String;
    function GetIVType: Integer;
    procedure SetCaption;
  public
    { Public declarations }
    aBcmaOrder: IBcmaOrder;
    BCMA_OMMedOrder: TBCMA_OMMedOrder;
    BCMA_OMScannedMeds: TBCMA_OMScannedMeds;

    property FieldChanged: Boolean read fFieldChanged write fFieldChanged;
    property CloseFrm: Boolean read fCloseFrm write FCloseFrm;
    property aGUID: String read GetGUID;
  end;

var
  frmCPRSOrderManager: TfrmCPRSOrderManager;
  //BcmaOrder: IBcmaOrder;
implementation

uses
  {BCMA_Startup,
  BCMA_Main, Debug,} StdVcl, OrderComIntf, uBCMA, uCore;

{$R *.DFM}

procedure TfrmCPRSOrderManager.edtOMScannerInputKeyPress(Sender: TObject;
  var Key: Char);
begin
  if edtOMScannerInput.text <> '' then
    if key = chr(VK_RETURN) then
      ScanMed;
end;

procedure TfrmCPRSOrderManager.FormCreate(Sender: TObject);
begin
  cbxInjectionSite.items.Assign(ListInjectionSites);
  SetCaption;
  InitOMMedOrder;
  SetMOBApp(MOBCallingAPP);
  if MOBCallingAPP <> 'CPRS' then
    edtProvider.OnChange := FieldChange;
  ClearForm;
end;

procedure TfrmCPRSOrderManager.edtActionDateTimeExit(Sender: TObject);
var
  ss,
    MActionDateTime, zNow: string;
  NowMDateTime: string;

begin
  if edtActionDateTime.text <> '' then
    begin
      ss := edtActionDateTime.text;
      zNow := 'N';

      MActionDateTime := ValidMDateTime(ss);

      if edtActionDateTime.text <> 'N' then
        NowMDateTime := ValidMDateTime(zNow);

      if NowMDateTime = '' then NowMDateTime := MActionDateTIme;

      if MActionDateTime <> '' then
        begin
          if StrToFloat(MActionDateTime) > StrToFloat(NowMDateTime) then
            begin
              DefMessageDlg('The action date and time can''t be in the future.', mtError,
                [mbOk], 0);
              edtActionDateTime.setFocus;
              exit;
            end;
          edtActionDateTime.text := ss;
          //with BCMA_Patient do
          with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.Count - 1]) do
            AdminDateTime := MActionDateTime;
        end
      else
        edtActionDateTime.setFocus;
    end;
end;

procedure TfrmCPRSOrderManager.Button2Click(Sender: TObject);
var
  RequireText: string;
  zResult: Boolean;
  msgText,
    eMsg: string;
  CPRSState,
    aOrderID: WideString;
  AdditiveList,
    SolutionList: WideString;
  AddSolList: TStringList;
  x: integer;

begin
  RequireText := '';
  aOrderID := '';
  zResult := False;
  if edtProvider.text = '' then
    RequireText := 'Provider' + #13;
  if edtActionDateTime.text = '' then
    RequireText := RequireText + 'Action Date/Time' + #13;

  if rbtnIV.checked then
    begin
      if cbxIVType.ItemIndex = -1 then
        RequireText := RequireText + 'IV Type' + #13;

      if cbxIVType.ItemIndex = 2 then //syringe
        if cbxIntSyringe.ItemIndex = -1 then
          RequireText := RequireText + 'Int Syringe' + #13
        else if cbxIntSyringe.ItemIndex = 0 then //yes
          if cbxSchedule.ItemIndex = -1 then
            RequireText := RequireText + 'Schedule' + #13;

      if cbxInjectionSite.ItemIndex = -1 then
        RequireText := RequireText + 'Injection Site' + #13;

      if cbxIVType.ItemIndex = 1 then //Piggyback
        if cbxSchedule.ItemIndex = -1 then
          RequireText := RequireText + 'Schedule' + #13;
    end;

  if RequireText = '' then
    //with BCMA_Patient do
      with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
        begin
          if rbtnIV.checked then
            begin
              IVType := IVTypeConvert[cbxIVType.ItemIndex];
              if cbxIntSyringe.itemindex <> -1 then
                IntSyringe := IntSyringeConvert[cbxIntSyringe.ItemIndex];
            end;
          InjectionSite := cbxInjectionSite.Text;
          Schedule := cbxSchedule.text;
          if ScannedMeds.Count = 0 then
            begin
              DefMessageDlg('You must first scan a medication.', mtInformation,
                [mbOk], 0);
              exit;
            end;

          if rbtnIV.checked then
            begin
              for x := 0 to ScannedMeds.Count - 1 do
                if TBCMA_OMScannedMeds(ScannedMeds[x]).ScannedDrugType = 'SOL' then
                  begin
                    zResult := True;
                    break;
                  end;
              if zResult = False then
                begin
                  DefMessageDlg('You must scan a Solution.', mtInformation, [mbOk], 0);
                  exit;
                end
            end;

          if BCMA_Broker.DebugMode then
            begin
              msgText := 'Patent IEN: ' + BCMA_Patient.IEN + #13 +
                '  Provider: ' + ProviderIEN + #13 +
                '  Ward IEN: ' + BCMA_Patient.HospitalLocationIEN;
              //frmDebug.Execute('Parameters passed to CPRS InitObject', msgText, nil);
            end;

          try
            CPRSState := 'InitObjects';
            Repaint;
//            InitObjects(BCMA_Patient.IEN, StrToInt64(ProviderIEN), StrToInt(BCMA_Patient.HospitalLocationIEN));
//            aBcmaOrder.InitObjects(BCMA_Patient.IEN, StrToInt64(ProviderIEN), StrToInt(BCMA_Patient.WardIEN));
            //Unit Dose
            if rbtnUD.Checked then
              begin
                CPRSState := 'ActivateUDDialog';

                if BCMA_Broker.DebugMode then
                  begin
                    msgText := '         Dialog ID: ' + UNITDOSE_DIALOG + #13 +
                      'Unit Dose Orderable Item IEN: ' + TBCMA_OMScannedMeds(ScannedMeds[0]).OrderableItemIEN;
                    //frmDebug.Execute('Parameters passed to CPRS ActivateUDDialog', msgText, nil);
                  end;
                Repaint;
                zResult := ActivateUDDialog(UNITDOSE_DIALOG, StrToInt(TBCMA_OMScannedMeds(ScannedMeds[0]).OrderableItemIEN), aOrderID, StrToInt64(ProviderIEN));
                if BCMA_Broker.DebugMode then
                  begin
                    msgText := 'Order Accepted: ' + FalseTrue[zResult] +
                      #13 + 'OrderID String: ' + aOrderID;
                    //frmDebug.Execute('Parameters returned from CPRS ActivateUDDialog', msgText, nil);
                  end;

              end

            //IV
            else
              begin
                CPRSState := 'ActivateIVDialog';
                if BCMA_Broker.DebugMode then
                  begin
                    AddSolList := TStringList.Create;
                    for x := 0 to ScannedMeds.Count - 1 do
                      AddSolList.Add(TBCMA_OMScannedMeds(ScannedMeds[x]).OrderableItemIEN);
                    msgText := 'Dialog ID: ' + IV_DIALOG + #13 +
                      'Additives and Solutions:';
                    //frmDebug.Execute('Parameters passed to CPRS ActivateIVDialog', msgText, AddSolList);
                    AddSolList.Free;
                  end;

                GetSolAddStr(SolutionList, AdditiveList);
                Repaint;
                zResult := ActivateIVDialog(IV_DIALOG, SolutionList, AdditiveList, aOrderID,StrToInt64(ProviderIEN), GetIVType);

                if BCMA_Broker.DebugMode then
                  begin
                    msgText := 'Order Accepted: ' + FalseTrue[zResult] +
                      #13 + 'OrderID String: ' + aOrderID;
                    //frmDebug.Execute('Parameters returned from CPRS ActivateIVDialog', msgText, nil);
                  end;
              end;


            //Order Cancelled
            if not zResult then
              begin
                ClearForm;
                //with BCMA_Patient do
                  with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
                    begin
                      ClearScannedMeds;
                      DefMessageDlg('Order Cancelled', mtInformation, [mbOk], 0);
                    end;
              end

            //Order Accepted
            else
              begin
                OrderID := aOrderID;
                OMMedOrdersOrderID.AddObject(piece(aOrderID, ';', 1), Ptr(OMMedorders.Count - 1));
                InitOMMedOrder;
                ClearForm;
              end;

          except
            on e: EOleException do
              begin
                eMSG := 'An error has occured during the ' + CPRSState + ' CPRS Process' + #13 +
                  'Error: ' + e.message + #13 +
                  'Unable to launch the Order Manager, please check the order in CPRS!';
                DefMessageDlg(eMSG, mtError, [mbOk], 0);
                Close;
              end;
          end;
        end
  else
    begin
      MessageDlg('The following field(s) can not be blank:' + #13 + #13 +
        RequireText, mtInformation, [mbOk], 0);
      exit;
    end;

  if OMMedOrders.Count > 0 then btnReviewSign.enabled := True;
  rbtnUD.SetFocus;
end;

procedure TfrmCPRSOrderManager.edtProviderExit(Sender: TObject);
var
  StringIn,
    zResult: string;
begin
  if edtProvider.text <> '' then
    //with BCMA_Patient do
      with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
        begin
          StringIn := edtProvider.text;
          zResult := isValidProvider(StringIn);
          if zResult = '-1' then
            with edtProvider do
              begin
                Clear;
                SetFocus;
              end
          else
            edtProvider.text := StringIn;
          ProviderIEN := zResult;
        end;
end;

procedure TfrmCPRSOrderManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClearOMMedOrders;
  BcmaUnlockPatient(Patient.DFN);
  //aBCMAOrder := nil;
end;

procedure TfrmCPRSOrderManager.rbtnIVClick(Sender: TObject);
begin

  //with BCMA_Patient do
  with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
    ClearScannedMeds;
  ClearForm(False);

  if Sender = rbtnUD then
    begin
      lblIVType.Enabled := False;
      cbxIVType.Enabled := False;
      cbxInjectionSite.items.Insert(0, '');

      lblIntSyringe.enabled := false;
      cbxIntSyringe.enabled := false;
      cbxIntSyringe.itemindex := -1;

    end
  else
    begin
      lblIVType.Enabled := True;
      cbxIVType.Enabled := True;
      cbxSchedule.visible := True;
      lblSchedule.visible := True;
      cbxSchedule.ItemIndex := -1;
      cbxIVType.ItemIndex := -1;
      cbxIntSyringe.ItemIndex := -1;
      cbxInjectionSite.items.Delete(0);
    end;
end;

procedure TfrmCPRSOrderManager.FieldChange(Sender: TObject);
begin
  FieldChanged := True;
end;

procedure TfrmCPRSOrderManager.Button3Click(Sender: TObject);
var
  x: integer;
  CancelStr: widestring;
begin
  CloseFrm := True;
  if FieldChanged = True then
    if MessageDlg('Do you want to cancel the current order and start over?',
      mtConfirmation, [mbYes, mbNo], 0) = idYes then
      begin
        FieldChanged := False;
        CloseFrm := False;
        //with BCMA_Patient do
          with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
            ClearScannedMeds;
        ClearForm;
      end
    else
      begin
        CloseFrm := False;
      end
  else
    //with BCMA_Patient do
      begin
        CancelStr := '';
        if OMMedOrders.count > 1 then
          if MessageDlg('Orders have been accepted, but not signed.' +
            #13 + 'Are you sure you want to cancel?', mtConfirmation, [mbYes, mbNo], 0) = idYes then
            begin
              for x := 0 to OMMedOrders.Count - 2 do
                with TBCMA_OMMedOrder(OMMedOrders[x]) do
                  if CancelStr = '' then CancelStr := OrderID
                  else
                    CancelStr := CancelStr + '^' + OrderID;
              DcOrders(CancelStr);
              ClearOMMedOrders;
            end
          else
            CloseFrm := False;
      end;
end;

procedure TfrmCPRSOrderManager.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := CloseFrm;
end;

procedure TfrmCPRSOrderManager.ClearForm(Reset: Boolean = True);
begin
  cbxIVType.ItemIndex := -1;
  cbxIntSyringe.ItemIndex := -1;
  if Reset = True then
    rbtnUD.Checked := True;
  edtProvider.Text := '';
  cbxInjectionSite.ItemIndex := -1;
  cbxSchedule.ItemIndex := -1;
  edtActionDateTime.Text := '';
  lstMedSol.Clear;
  FieldChanged := False;
  cbxSchedule.visible := False;
  cbxSchedule.enabled := False;
  lblSchedule.visible := False;
  lblSchedule.enabled := False;

  if MOBCallingAPP = 'CPRS' then
  begin
    edtProvider.Enabled := False;
    edtProvider.Text := Encounter.ProviderName;
    TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]).ProviderIEN := IntToStr(Encounter.Provider);
  end;

end;

procedure TfrmCPRSOrderManager.btnReviewSignClick(Sender: TObject);
var
  Cancelled: Boolean;
  OrderIDList,
    msgText,
    InfoForSign,
    UnlockOrders, OrdersToSend: WideString;
  x: integer;

begin
  Repaint;
  Cancelled := not SignOrders(False, OrderIDList, InfoForSign);

  if BCMA_Broker.DebugMode then
    begin
      msgText := 'Order ID String:' + #13 + OrderIDList + #13;
      msgText := msgText + 'InfoForSign:' + #13 + InfoForSign;
      //frmDebug.Execute('Data returned from CPRS SignOrders', msgText, nil);
    end;

  if not Cancelled and (Length(OrderIDList) > 0) then
    begin
      Repaint;
      SendOMMedOrders(OrderIDList);
      Repaint;


      StripPieceIfContains('^', '-1', OrderIDList, OrdersToSend);

//      aBCMAOrder.SendOrders(OrderIDList, InfoForSign);

      if BCMA_Broker.DebugMode then
        begin
          msgText := 'Order ID String:' + #13 + OrdersToSend + #13;
          msgText := msgText + 'InfoForSign:' + #13 + InfoForSign;
          //frmDebug.Execute('Data Sent to CPRS SendOrders', msgText, nil);
        end;

      SendOrders(OrdersToSend, InfoForSign);

      //with BCMA_Patient do
        for x := 0 to OMMedOrders.Count - 2 do
          with TBCMA_OMMedOrder(OMMedOrders[x]) do
            if UnlockOrders = '' then UnlockOrders := Piece(OrderID, ';', 1)
            else
              UnlockOrders := UnlockOrders + '^' + Piece(OrderID, ';', 1);
      Repaint;
      BcmaUnlockOrders(UnlockOrders);
      CloseFrm := True;
      close;
    end
  else
    begin
    end;
end;

procedure TfrmCPRSOrderManager.cbxIVTypeChange(Sender: TObject);
begin
  if cbxIVType.itemindex = 2 then
    begin
      cbxIntSyringe.enabled := True;
      lblIntSyringe.enabled := True;
      cbxIntSyringe.ItemIndex := -1;
    end
  else
    begin
      cbxIntSyringe.enabled := False;
      lblIntSyringe.enabled := False;
    end;

  if cbxIVType.itemindex = 1 then
    begin
      lblSchedule.enabled := True;
      cbxSchedule.enabled := True;
      cbxSchedule.ItemIndex := -1;
    end
  else
    begin
      lblSchedule.enabled := False;
      cbxSchedule.enabled := False;
    end;

end;

procedure TfrmCPRSOrderManager.cbxIntSyringeChange(Sender: TObject);
begin
  if cbxIntSyringe.itemindex = 0 then
    begin
      lblSchedule.enabled := True;
      cbxSchedule.enabled := True;
    end
  else
    begin
      lblSchedule.enabled := False;
      cbxSchedule.enabled := False;
    end;
end;

procedure TfrmCPRSOrderManager.edtOMScannerInputEnter(Sender: TObject);
begin
  pnlScannerIndicator.Color := clLime;
  Label6.caption := 'Ready'
end;

procedure TfrmCPRSOrderManager.edtOMScannerInputExit(Sender: TObject);
begin
  if edtOMScannerInput.Text <> '' then
    ScanMed
  else
    begin
      pnlScannerIndicator.Color := clRed;
      Label6.caption := 'Not Ready';
    end;

end;

procedure TfrmCPRSOrderManager.ScanMed;
var
  zOrderType: string;
begin

  if rbtnUD.Checked then
    zOrderType := 'UD'
  else
    zOrderType := 'IV';

  //with BCMA_Patient do
    with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
      if isValidMedSolution(edtOMScannerInput.text, zOrderType) then
        lstMedSol.Items.Add(TBCMA_OMScannedMeds(ScannedMeds[ScannedMeds.Count - 1]).ScannedDrugName)
      else
        edtOMScannerInput.SetFocus;

  edtOMScannerInput.Clear;

end;

procedure TfrmCPRSOrderManager.pnlScannerIndicatorClick(Sender: TObject);
begin
  edtOMScannerInput.setFocus;
end;

function TfrmCPRSOrderManager.GetGUID: String;
var aGUID: TGUID;
begin
  CreateGUID(aGUID);
  //since some people worry that the { and } just might break the M world
  //we'll strip em out (even though we know there are no issues)

  Result := GUIDToString(aGUID);
  Result := StringReplace(Result,'{','',[rfReplaceAll]);
  Result := StringReplace(Result,'}','',[rfReplaceAll]);
end;


{The result of this function is what sets the hidden Type in the CPRS diagloue
0 = continuous, 1 = Intermittent}
function TfrmCPRSOrderManager.GetIVType: Integer;
begin
  //Addmixture
  if cbxIVType.itemindex = 0 then
    result := 0
  //piggyback
  else if cbxIVType.itemindex = 1 then
    result := 1
  else
    if cbxIntSyringe.ItemIndex = 0 then
      result := 1
    else result := 0;
end;

procedure TfrmCPRSOrderManager.SetCaption;
var
  MOBDLLPath, DLLVersion: String;
begin
  MOBDLLPath := ExcludeTrailingPathDelimiter(GetProgramFilesPath) + SHARE_DIR + MOBDLLName;
  DLLVersion := ClientVersion(MOBDLLPath);
  Caption := 'Order Manager - v' + DLLVersion
end;

end.


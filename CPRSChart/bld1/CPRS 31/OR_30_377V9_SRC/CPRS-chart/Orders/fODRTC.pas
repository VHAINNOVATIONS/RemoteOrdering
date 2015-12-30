unit fODRTC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, Grids, Buttons, uConst, ORDtTm,
  Menus, XUDIGSIGSC_TLB, rMisc, uOrders, StrUtils, oRFn, contnrs,
  VA508AccessibilityManager;

const
  UM_DELAYCLICK = 11037;  // temporary for listview click event
//  NVA_CR = #13;
//  NVA_LF = #10;
  NO_CLINIC = 'No Clinic selected';
  BAD_DATE = 'Clinically Indicated Date cannot be in the past';
  NO_DATE = 'No Clinically Indicated Date Defined';
  NO_INTERVAL = 'Interval not defined';
  CANNOT_DEFINE_INTERVAL = 'Interval cannot be defined if appointment number is 1';
  NO_APPT_DEFINED = 'Number of appointments not defined';
  NUM_APPT_EXCEED = 'Number of appointments cannot exceed ';

type
  TfrmODRTC = class(TfrmODBase)
    pnlRequired: TPanel;
    lblClinic: TLabel;
    cboRTCClinic: TORComboBox;
    Label1: TLabel;
    cboProvider: TORComboBox;
    lblClinicallyIndicated: TStaticText;
    dateCIDC: TORDateBox;
    lblNumberAppts: TStaticText;
    txtNumAppts: TCaptionEdit;
    SpinNumAppt: TUpDown;
    lblFrequency: TStaticText;
    cboInterval: TORComboBox;
    cboPreReq: TORComboBox;
    lblPReReq: TStaticText;
    memComments: TCaptionMemo;
    lblComments: TStaticText;
    cboPerQO: TORComboBox;
    lblQO: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure pnlMessageEnter(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure memMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbStatementsClickCheck(Sender: TObject; Index: Integer);
    procedure txtNumApptsChange(Sender: TObject);
    procedure cboRTCClinicMouseClick(Sender: TObject);
    procedure cboProviderMouseClick(Sender: TObject);
    procedure dateCIDCChange(Sender: TObject);
    procedure cboIntervalChange(Sender: TObject);
    procedure cboPreReqChange(Sender: TObject);
    procedure cboRTCClinicKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboProviderKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboRTCClinicNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboPerQOKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboPerQOMouseClick(Sender: TObject);


  private
    OffSet: integer;

    {edit}

  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    procedure SetValuesFromResponses;
    procedure resetAllPrompts;
    procedure ClearAllPrompts;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;

  end;

var
  frmODRTC: TfrmODRTC;
  crypto: IXuDigSigS;

implementation

{$R *.DFM}

uses rCore, uCore, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  fFrame, ORNet, VAUtils;

const
  TX_CIDC_DATE_INVALID = 'CIDC date must be after the encounter date.';

{ procedures inherited from fODBase --------------------------------------------------------- }

procedure TfrmODRTC.InitDialog;
{ Executed each time dialog is reset after pressing accept.  Clears controls & responses }
var
tmp: string;
begin
  inherited;
  //  ClearAllFields;
  //FIVTypeDefined := false;
  with CtrlInits do
    begin
      SetControl(cboPerQO, 'ShortList');
      if cboPerQO.Items.Count < 1 then cboPerQO.Enabled := false;
      SetControl(cboRTCClinic, 'Clinic');
      SetControl(cboProvider, 'Provider');
      SetControl(cboInterval, 'Interval');
      SetControl(cboPreReq, 'PreReq');
      if cboPreReq.Items.Count < 1 then cboPreReq.Enabled := false;
    end;
    tmp := Piece(CtrlInits.TextOf('Offset'), U, 1);
    self.OffSet := StrToIntDef(tmp,0);
    if self.OffSet = 0 then self.OffSet := 30;

    txtNumAppts.Text := '1';
    cboInterval.Enabled := false;
//  memorder.text := '';
//  memOrder.Lines.Clear;
end;

procedure TfrmODRTC.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  try
    changing := false;
    if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
    begin
      changing := true;
      SetValuesFromResponses;
    end;
    changing := false;
    ControlChange(Self);
  finally
    changing := false;
  end;
end;

procedure TfrmODRTC.SetValuesFromResponses;
var
  AnInstance, idx: integer;
  int, ext: String;
  AResponse: TResponse;
begin
  with Responses do
  begin
    //clinic
    AResponse := FindResponseByName('CLINIC', 1);
    if AResponse <> nil then
      begin
        int := AResponse.IValue;
        ext := AResponse.EValue;
        idx := self.cboRTCClinic.Items.IndexOf(ext);
        if idx > -1 then self.cboRTCClinic.ItemIndex := idx;
      end;

    //provider
    AResponse := FindResponseByName('PROVIDER', 1);
    if AResponse <> nil then
    begin
      int := AResponse.IValue;
      ext := MixedCase(AResponse.EValue);
      idx := self.cboProvider.Items.IndexOf(ext);
      if idx > -1 then self.cboProvider.ItemIndex := idx
      else
        begin
          self.cboProvider.Items.Add(int + U + ext);
          idx := self.cboProvider.Items.IndexOf(ext);
          if idx > -1 then self.cboProvider.ItemIndex := idx;

        end;

//      if idx = -1 then
//        begin
//          for idx := 0 to self.cboProvider.Items.Count - 1 do
//            begin
//              if Piece(self.cboProvider.Items[idx], U, 1) = int then break;
//
//            end;
//         if idx > -1  then self.cboProvider.ItemIndex := idx;
////         else self.cboProvider.Items.Add(int + U + ext);
//        end;
    end;
    //CIDC
    AResponse := FindResponseByName('CLINICALLY', 1);
    if AResponse <> nil then
      begin
        ext := AResponse.Evalue;
        if ext <> '' then self.dateCIDC.text := ext;
      end;
    //Number of Appts
    AResponse := FindResponseByName('SDNUM', 1);
    if AResponse <> nil then
      begin
        ext := AResponse.Evalue;
        if ext <> '' then
          begin
            self.txtNumAppts.text := ext;
            self.SpinNumAppt.Position := StrToIntDef(ext,0);
          end;
      end;
    if StrToIntDef(self.txtNumAppts.text, 0) > 1 then
      begin
        AResponse := FindResponseByName('SDINT', 1);
        if AResponse <> nil then
          begin
            ext := AResponse.EValue;
            idx := self.cboInterval.Items.IndexOf(ext);
            self.cboInterval.Enabled := true;
            if idx > -1 then self.cboInterval.ItemIndex := idx;
          end;
      end
      else self.cboInterval.Enabled := false;
    //prereq
    AnInstance := NextInstance('PREREQ', 0);
    while AnInstance > 0 do
      begin
        AResponse := FindResponseByName('PREREQ', AnInstance);
        if (AResponse <> nil) and (cboPreReq.Enabled = true) then
          begin
            ext := AResponse.EValue;
            idx := self.cboPreReq.Items.IndexOf(ext);
            if idx > -1 then self.cboPreReq.Checked[idx] := true;
          end;
          AnInstance := NextInstance('PREREQ', AnInstance);
      end;
    //comments
    SetControl(memComments, 'COMMENT', 1);
  end;
end;

procedure TfrmODRTC.txtNumApptsChange(Sender: TObject);
begin
  inherited;
  if StrToIntDef(self.txtNumAppts.Text, 0) > 1 then
    self.cboInterval.Enabled := true
  else
    begin
      self.cboInterval.ItemIndex := -1;
      self.cboInterval.Text := '';
      self.cboInterval.Enabled := false;
    end;
  ControlChange(Sender);
end;

procedure TfrmODRTC.Validate(var AnErrMsg: string);
var
  idx, i: Integer;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;

//    NO_CLINIC = 'No Clinic selected';
//  BAD_DATE = 'Clinically Indicated Date cannot be in the past';
//  NO_DATE = 'No Clinically Indicated Date Defined';
//  NO_INTERVAL = 'Interval not defined';
//  CANNOT_DEFINE_INTERVAL = 'Interval cannot be defined if appointment number is 1
//  NO_APPT_DEFINED = 'Number of appointments not defined';
  idx := self.cboRTCClinic.ItemIndex;
  if idx < 0 then SetError(NO_CLINIC);
  if (length(self.dateCIDC.Text) <1) then SetError(NO_DATE)
  else
    begin
      if self.dateCIDC.FMDateTime < FMToday then SetError(BAD_DATE);
    end;
  idx := self.cboInterval.ItemIndex;
  if Length(self.txtNumAppts.Text) < 1 then SetError(NO_APPT_DEFINED)
  else
    begin
       i := StrToIntDef(self.txtNumAppts.Text, 0);
       if (i < 2) and (idx > -1) then SetError(CANNOT_DEFINE_INTERVAL);
       if i > self.SpinNumAppt.Max then SetError(NUM_APPT_EXCEED + IntToStr(self.SpinNumAppt.Max));
    end;
end;



procedure TfrmODRTC.cboIntervalChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboPerQOKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPerQO.Text = '') then cboPerQO.ItemIndex := -1;
end;

procedure TfrmODRTC.cboPreReqChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboPerQOMouseClick(Sender: TObject);
var
idx: integer;
begin
  inherited;
  try
    idx := cboPerQO.ItemIndex;
    if idx = -1 then exit;
    if CharAt(cboPerQO.ItemID, 1) <> 'Q' then exit;
    ResetAllPrompts;

    Responses.QuickOrder := ExtractInteger(cboPerQO.ItemID);
    changing := true;
    SetValuesFromResponses;
    changing := false;
    ControlChange(self);
  finally
    changing := false;
  end;
end;

procedure TfrmODRTC.cboProviderKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboProvider.Text = '') then cboProvider.ItemIndex := -1;
end;

procedure TfrmODRTC.cboProviderMouseClick(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboProviderNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cboProvider.ForDataUse(SubSetOfProviders(StartFrom, Direction));
end;

procedure TfrmODRTC.ClearAllPrompts;
begin
  ClearControl(self.cboRTCClinic);
  ClearControl(self.cboProvider);
  ClearControl(self.dateCIDC);
  ClearControl(self.txtNumAppts);
  ClearControl(self.cboInterval);
  ClearControl(self.cboPreReq);
  ClearControl(self.memComments);
end;

procedure TfrmODRTC.ControlChange(Sender: TObject);
var
cnt,idx: integer;
str, stop: string;
CIDC: TFMDateTime;
begin
  inherited;
  if csLoading in ComponentState then Exit;       // to prevent error caused by txtRefills
  if Changing then Exit;
  Responses.clear;
  //Clinic
  idx := self.cboRTCClinic.ItemIndex;
  if idx > -1 then
    begin
      str := self.cboRTCClinic.Items[idx];
      Responses.Update('CLINIC', 1, Piece(str, u, 1), Piece(str, u, 2));
    end;
  //Provider
  idx := self.cboProvider.ItemIndex;
  if idx > -1 then
    begin
      str := self.cboProvider.Items[idx];
      Responses.Update('PROVIDER', 1, Piece(str, u, 1), Piece(str, u, 2));
    end;
  //CIDC
  str := self.dateCIDC.Text;
  if Length(str)> 0 then
    begin
      Responses.Update('CLINICALLY', 1, str, str);
        CIDC := self.dateCIDC.FMDateTime;
        if CIDC <> -1 then
          begin
            stop := FloatToStr(FMDateTimeOffsetBy(CIDC,self.OffSet));
            Responses.Update('STOP', 1, stop, stop);
          end;
    end;
  //Number of Appt
  str := self.txtNumAppts.Text;
  if length(str)>0 then
    begin
      Responses.Update('SDNUM', 1, str, str);
      if StrToIntDef(str, 0)>1 then
        begin
          //Interval
          idx := self.cboInterval.ItemIndex;
          if idx > -1 then
            begin
              str := self.cboInterval.Items[idx];
              Responses.Update('SDINT', 1, Piece(str, U, 2), Piece(str, U, 2));
            end;
        end;
    end;
    cnt := 0;
  //PreReq
  for idx := 0 to self.cboPreReq.Items.Count -1 do
    begin
      if self.cboPreReq.Checked[idx] = false then continue;
      inc(cnt);
      str := self.cboPreReq.Items[idx];
      Responses.Update('PREREQ', cnt, Piece(str, U, 2), Piece(str, u, 2));
    end;
  with memComments do if GetTextLen > 0     then Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODRTC.dateCIDCChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;



procedure TfrmODRTC.cboRTCClinicKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboRTCClinic.Text = '') then cboRTCClinic.ItemIndex := -1;
end;

procedure TfrmODRTC.cboRTCClinicMouseClick(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODRTC.cboRTCClinicNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  cboRTCClinic.ForDataUse(SubSetOfNewLocs(StartFrom, Direction));
end;

procedure TfrmODRTC.pnlMessageEnter(Sender: TObject);
begin
  inherited;
//  DisableDefaultButton(self);
//  DisableCancelButton(self);
end;

procedure TfrmODRTC.pnlMessageExit(Sender: TObject);
begin
  inherited;
//  RestoreDefaultButton;
//  RestoreCancelButton;
end;

procedure TfrmODRTC.resetAllPrompts;
begin
  ResetControl(self.cboRTCClinic);
  ResetControl(self.cboProvider);
  ResetControl(self.dateCIDC);
  ResetControl(self.txtNumAppts);
  ResetControl(self.cboInterval);
  ResetControl(self.cboPreReq);
  ResetControl(self.memComments);
  ControlChange(self);
end;

procedure TfrmODRTC.memMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;
end;

procedure TfrmODRTC.FormCreate(Sender: TObject);
begin
 inherited;

    AllowQuickOrder := True;
    Responses.Dialog := 'SD RTC';
    CtrlInits.LoadDefaults(ODForSD);
    initDialog;

end;

procedure TfrmODRTC.lbStatementsClickCheck(Sender: TObject;
  Index: Integer);
begin
  inherited;
   ControlChange(self);
end;



end.

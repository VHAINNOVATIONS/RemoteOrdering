unit fReview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, checklst, uConst, ExtCtrls, uCore, System.Types;

type
  TfrmReview = class(TForm)
    cmdOK: TButton;
    cmdCancel: TButton;
    lstReview: TCheckListBox;
    pnlOrderAction: TPanel;
    grpRelease: TGroupBox;
    radVerbal: TRadioButton;
    radPhone: TRadioButton;
    radRelease: TRadioButton;
    lblSig: TLabel;
    pnlSignature: TPanel;
    lblESCode: TLabel;
    txtESCode: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure lstReviewDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstReviewClickCheck(Sender: TObject);
    procedure radReleaseClick(Sender: TObject);
    procedure txtESCodeChange(Sender: TObject);
    procedure lstReviewMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure lstReviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    FOKPressed: Boolean;
    FShowPanel: Integer;
    FSilent: Boolean;
    FCouldSign: Boolean;
    FLastHintItem: integer;
    FOldHintPause: integer;
    FOldHintHidePause: integer;
    procedure AddHeader(s: string);
    function AddItem(ChangeItem: TChangeItem): integer;
    procedure BuildFullList;
    procedure BuildSignList;
    procedure CleanupChangesList(Sender: TObject; ChangeItem: TChangeItem);
    function ItemsAreChecked: Boolean;
    function SignRequiredForAny: Boolean;
    procedure DCUncheckedOrder(AnOrderId: string; AReason: integer);
  public
    { Public declarations }
  end;

function ReviewChanges(TimedOut: Boolean): Boolean;

implementation

{$R *.DFM}

uses ORFn, ORNet, rCore, rOrders, Hash, fSignItem, fOCSession, uBcmaOrder;

const
  SP_NONE  = 0;
  SP_CLERK = 1;
  SP_NURSE = 2;
  SP_SIGN  = 3;
  TXT_ENCNT     = 'Outpatient Encounter';
  TXT_NOVISIT   = 'Visit Type: < None Selected >';
  TXT_NODIAG    = 'Diagnosis: < None Selected >';
  TXT_NOPROC    = 'Procedures: none';
  TXT_DOCS      = 'Documents';
  TXT_ORDERS    = 'Orders';
  TXT_BLANK     = ' ';
  TX_INVAL_MSG  = 'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP  = 'Unrecognized Signature Code';
  TX_ES_REQ     = 'Enter your electronic signature to release these orders.';
  TC_ES_REQ     = 'Electronic Signature';
  TX_NO_REL     = CRLF + CRLF + '- cannot be released to the service(s).' + CRLF + CRLF + 'Reason: ';
  TC_NO_REL     = 'Unable to Release Orders';

function ReviewChanges(TimedOut: Boolean): Boolean;
{ display changes made to chart for this encounter, allow changes to be saved, signed, etc. }
var
  frmReview: TfrmReview;
  i: integer;
begin
  Result := True;
  if BcmaOrderChanges = nil then Exit;
  if BcmaOrderChanges.Count = 0 then Exit;

  frmReview := TfrmReview.Create(Application);
  try
    BcmaOrderChanges.OnRemove := frmReview.CleanupChangesList;
    frmReview.lstReview.ItemHeight := MainFontHeight + 5;
    if TimedOut and (BcmaOrderChanges.Count > 0) then
    begin
      frmReview.FSilent := True;
      frmReview.BuildFullList;
      with frmReview.lstReview do for i := 0 to Items.Count - 1 do
        Checked[i] := False;
      frmReview.cmdOKClick(frmReview);
      Result := True;
    end
    else
    begin
//MOB - Modified Code
      if ((User.OrderRole = OR_NURSE) or (User.OrderRole = OR_CLERK)) and BcmaOrderChanges.CanSign then
      begin
        frmReview.FCouldSign := True;
        frmReview.BuildSignList;
        frmReview.ShowModal;
        Result := frmReview.FOKPressed;
      end;
      if Result and (BcmaOrderChanges.Count > 0) and ((User.OrderRole = OR_NURSE) or (User.OrderRole = OR_PHYSICIAN)) then
      begin
        frmReview.FCouldSign := BcmaOrderChanges.CanSign;
        frmReview.BuildFullList;
        frmReview.ShowModal;
        Result := frmReview.FOKPressed;
      end;
    end;
  finally
    BcmaOrderChanges.OnRemove := nil;
    frmReview.Release;
  end;
end;

procedure TfrmReview.FormCreate(Sender: TObject);
begin
  FOKPressed := False;
  FSilent := False;
  FLastHintItem := -1;
  FOldHintPause := Application.HintPause;
  Application.HintPause := 250;
  FOldHintHidePause := Application.HintHidePause;
  Application.HintHidePause := 30000;
end;

procedure TfrmReview.AddHeader(s: string);
{ add header to review list, object is left nil }
begin
  lstReview.Items.AddObject(s, nil);
end;

function TfrmReview.AddItem(ChangeItem: TChangeItem): integer;
{ add a single review item to the list with its associated TChangeItem object }
begin
  Result := lstReview.Items.AddObject(ChangeItem.Text, ChangeItem);
  //MOB - Modified Code
  lstReview.Checked[Result] := True;
  //  case ChangeItem.SignState of
//  CH_SIGN_NO:  lstReview.Checked[Result] := False;
//  CH_SIGN_NA:  lstReview.Checked[Result] := True;
//  end;
end;

procedure TfrmReview.BuildFullList;
var
  GrpIndex, ChgIndex: Integer;
  ChangeItem: TChangeItem;
begin
  if lstReview.items.Count > 0 then
    lstReview.Clear;
  with BcmaOrderChanges do if Orders.Count > 0 then
  begin
    for GrpIndex := 0 to OrderGrp.Count - 1 do
    begin
      AddHeader('Orders - ' + OrderGrp[GrpIndex]);
      for ChgIndex := 0 to Orders.Count - 1 do
      begin
        ChangeItem := Orders[ChgIndex];
        if ChangeItem.GroupName = OrderGrp[GrpIndex] then
          AddItem(ChangeItem);
      end;
      AddHeader('   ');
    end;
  end;
  case User.OrderRole of
      OR_NURSE: FShowPanel := SP_NURSE;
  else          FShowPanel := SP_NONE;
  end;
  case FShowPanel of
  SP_NURSE: begin
              pnlSignature.Visible := False;
              radRelease.Visible := True;
              grpRelease.Visible := True;
              pnlOrderAction.Visible := SignRequiredForAny;
            end;
  else      begin
              pnlOrderAction.Visible := False;
              //MOB - N/A Code
              //pnlSignature.Visible := False;
              pnlSignature.Visible := True;
            end;
  end;
  if pnlOrderAction.Visible then
  begin
    lblSig.Caption := 'Orders';
    if FShowPanel = SP_NURSE then
      radRelease.Checked   := True;
    if radRelease.Checked then radReleaseClick(Self);
  end;

  if lstReview.items.count > 1 then
  begin
    lstReview.Selected[1] := True;
  end;

end;

procedure TfrmReview.BuildSignList;
begin
  lstReview.Clear;
  FShowPanel := SP_SIGN;
  pnlSignature.Visible := ItemsAreChecked;
  txtESCodeChange(Self);
  pnlOrderAction.Visible := False;
end;

function TfrmReview.ItemsAreChecked: Boolean;
var
  i: Integer;
begin
  Result := False;
  with lstReview do for i := 0 to Items.Count - 1 do if Checked[i] then
  begin
    Result := True;
    break;
  end;
end;

function TfrmReview.SignRequiredForAny: Boolean;
var
  i: Integer;
  tmpOrders: TStringList;
  ChangeItem: TChangeItem;
begin
  tmpOrders := TStringList.Create;
  try
    Result := True;
    for i := 0 to Pred(BcmaOrderChanges.Orders.Count) do
    begin
      ChangeItem := BcmaOrderChanges.Orders[i];
      tmpOrders.Add(ChangeItem.ID);
    end;
    Result := AnyOrdersRequireSignature(tmpOrders);
  finally
    tmpOrders.Free;
  end;
end;

procedure TfrmReview.lstReviewClickCheck(Sender: TObject);
{ prevent grayed checkboxes from being changed to anything else }
begin
  pnlSignature.Visible := ItemsAreChecked;
end;

procedure TfrmReview.lstReviewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
{ outdent the header items (thus hiding the checkbox) }
begin
  with lstReview do
  begin
    if Items.Objects[Index] = nil then Rect.Left := 0;
    Canvas.FillRect(Rect);
    if Index < Items.Count then Canvas.TextOut(Rect.Left + 2, Rect.Top, FilteredString(Items[Index]));
  end;
end;

procedure TfrmReview.radReleaseClick(Sender: TObject);
begin
  if not grpRelease.Visible then Exit;
  if radRelease.Checked then
  begin
    radVerbal.Enabled := True;
    radPhone.Enabled  := True;
    radVerbal.Checked := True;
  end else
  begin
    radVerbal.Enabled := False;
    radPhone.Enabled  := False;
    radVerbal.Checked := False;
    radPhone.Checked  := False;
  end;
end;

procedure TfrmReview.txtESCodeChange(Sender: TObject);
begin
  if Length(txtESCode.Text) > 0 then cmdOK.Caption := 'Sign' else
  begin
    if FCouldSign then cmdOK.Caption := 'Don''t Sign' else cmdOK.Caption := 'OK';
  end;
end;

procedure TfrmReview.cmdOKClick(Sender: TObject);
{ validate the electronic signature & call SaveSignItem for the encounter }
const
  TX_WARNDELORDER = 'Unchecked orders will be deleted, are you sure?';
  TX_NOSIGN  = 'Save items without signing?';
  TC_NOSIGN  = 'No Signature Entered';
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';
var
  i,j,jdx: Integer;
  SigSts, RelSts, Nature: Char;
  ESCode, AnErrMsg, AnID, OrdersDeleted: string;
  ChangeItem: TChangeItem;
  OrderList,CanceledOrderList,TempOrderList: TStringList;

  function OrdersSignedOrReleased: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(OrderList.Count) do
    begin
      if Pos('R', Piece(OrderList[i], U, 2)) > 0 then Result := True;
      if Pos('S', Piece(OrderList[i], U, 2)) > 0 then Result := True;
      if Result then Break;
    end;
  end;

  function OrdersToBeSignedOrReleased: Boolean;
  var
    i: Integer;
    s: string;
  begin
    Result := False;
    for i := 0 to Pred(OrderList.Count) do
    begin
      s := Piece(OrderList[i], U, 2);
      if ((s <> '') and (CharInSet(s[1], [SS_ONCHART, SS_ESIGNED, SS_NOTREQD]))) or
         (Piece(OrderList[i], U, 3) = RS_RELEASE) then
      begin
        Result := TRUE;
        break;
      end;
    end;
  end;

begin
  ESCode := '';
  if pnlSignature.Visible then
  begin
    ESCode := txtESCode.Text;
    //MOB - Modified Code
    if ItemsAreChecked and (not ValidESCode(ESCode)) then
    //if ItemsAreChecked and (Length(ESCode) > 0) and (not ValidESCode(ESCode)) then
    begin
      InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
      txtESCode.SetFocus;
      txtESCode.SelectAll;
      Exit;
    end;
    if Length(ESCode) > 0 then ESCode := Encrypt(ESCode);
  end;
  OrderList := TStringList.Create;
  CanceledOrderList := TStringList.Create;
  TempOrderList := TStringList.Create;
  try
    case User.OrderRole of
    //MOB - Modified Code
    OR_NOKEY, OR_CLERK, OR_NURSE, OR_STUDENT, OR_PHYSICIAN:
      begin
        SigSts := SS_UNSIGNED;
        RelSts := RS_HOLD;
        Nature := NO_WRITTEN;
        //MOB - Modified Code
        if User.OrderRole in [OR_CLERK, OR_NURSE, OR_PHYSICIAN] then
        begin
          if radRelease.Checked then RelSts := RS_RELEASE
            else RelSts := RS_HOLD;
          if radVerbal.Checked then Nature := NO_VERBAL
          else if radPhone.Checked  then Nature := NO_PHONE
          else Nature := NO_WRITTEN;
          if not pnlOrderAction.Visible then
          begin
            RelSts := RS_RELEASE;
            Nature := NO_PROVIDER;
            //SigSts := SS_NOTREQD;
            SigSts := SS_ESIGNED;
          end;
          if RelSts = RS_RELEASE then
          begin
            StatusText('Validating Release...');
            AnErrMsg := '';
            for i := 0 to lstReview.Items.Count - 1 do
            begin
              ChangeItem := TChangeItem(lstReview.Items.Objects[i]);
              if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and (lstReview.State[i] = cbChecked) then
              begin
                ValidateOrderActionNature(ChangeItem.ID, OA_RELEASE, Nature, AnErrMsg);
                if Length(AnErrMsg) > 0 then
                begin
                  InfoBox(ChangeItem.Text + TX_NO_REL + AnErrMsg, TC_NO_REL, MB_OK);
                  Break;
                end;
              end;
            end;
            StatusText('');
            if Length(AnErrMsg) > 0 then Exit;
          end;
          if (RelSts = RS_RELEASE) and pnlOrderAction.Visible then
          begin
            SignatureForItem(Font.Size, TX_ES_REQ, TC_ES_REQ, ESCode);
            if ESCode = '' then Exit;
            if Nature = NO_POLICY then SigSts := SS_ESIGNED;
          end;
        end;

        with lstReview do for i := 0 to Items.Count - 1 do
        begin
          ChangeItem := TChangeItem(Items.Objects[i]);
          if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and (State[i] = cbUnchecked) then
          begin
            CanceledOrderList.Add(ChangeItem.ID + ';' + ChangeItem.Text);
            if BcmaCanceledOrder = '' then
              BcmaCanceledOrder := '-1;'+ ChangeItem.ID + ';' + ChangeItem.Text
            else
              BcmaCanceledOrder := BcmaCanceledOrder + U + '-1;' + ChangeItem.ID + ';' + ChangeItem.Text;
          end;

          if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and (State[i] = cbChecked) then
          begin
            OrderList.Add(ChangeItem.ID + ';' + ChangeItem.Text + '~' + SigSts
               + '~' + RelSts + '~' + Nature + '~' + ChangeItem.signInfo);
            TempOrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature);
          end;
        end;

        //MOB - Modified Code
        for j := 0 to CanceledOrderList.Count - 1 do
          DCUncheckedOrder(CanceledOrderList[j],14);


        {for i := 0 to OrderList.Count - 1 do
        begin
          if BcmaSignedOrder = '' then
            BcmaSignedOrder := OrderList[i]
          else
            BcmaSignedOrder := BcmaSignedOrder + U + OrderList[i];
        end;}
     end;
    end;

    if (User.OrderRole in [OR_NOKEY..OR_STUDENT]) and (OrderList.Count > 0) and LockedForOrdering then
    begin
      ExecuteSessionOrderChecks(TempOrderList ,OrdersDeleted);
      for i := 0 to TempOrderList.Count - 1 do
      begin
        for jdx := 0 to OrderList.Count - 1 do
        begin
          if Pieces(OrderList[jdx],';',1,2)=Piece(TempOrderList[i],'^',1) then
          begin
            if BcmaSignedOrder = '' then
              BcmaSignedOrder := OrderList[jdx]
            else
              BcmaSignedOrder := BcmaSignedOrder + U + OrderList[jdx];
          end;
        end;
      end;

      for j := 0 to CanceledOrderList.Count - 1 do
        DCUncheckedOrder(CanceledOrderList[j],14);

      if Length(OrdersDeleted) > 0 then
      begin
        i := 1;
        while Length(Piece(OrdersDeleted,'^',i))>0 do
        begin
          for jdx := 0 to OrderList.Count - 1 do
          begin
            if Pieces(OrderList[jdx],';',1,2)= Piece(OrdersDeleted,'^',i)  then
            begin
              if BcmaCanceledOrder = '' then
                BcmaCanceledOrder := '-1;' + Piece(OrderList[jdx],'~',1)
              else
                BcmaCanceledOrder := BcmaCanceledOrder + U + '-1;' + Piece(OrderList[jdx],'~',1);
            end;
          end;
          i := i + 1;
        end;
      end;
     BcmaSignInfo := ESCode;
     StatusText('Sending Orders to Service(s)...');
    end;
  finally
    OrderList.Free;
  end;

  with lstReview do for i := Items.Count - 1 downto 0  do
  begin
    if (not Assigned(Items.Objects[i])) then continue;   {**RV**}
    ChangeItem := TChangeItem(Items.Objects[i]);
    if ChangeItem <> nil then
    begin
      AnID := ChangeItem.ID;
      UnlockOrder(AnID);
    end;
  end;

  UnLockThePatient( Patient.DFN);
  FOKPressed := True;
  Close;
end;

procedure TfrmReview.CleanupChangesList(Sender: TObject; ChangeItem: TChangeItem);
var
  i: integer;
begin
  with lstReview do
    begin
      i := Items.IndexOfObject(ChangeItem);
      if i > -1 then
        begin
          TChangeItem(Items.Objects[i]).Free;
          Items.Objects[i] := nil;
        end;
    end;
end;

procedure TfrmReview.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReview.lstReviewMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
//  Height := SigItemHeight;
end;

procedure TfrmReview.FormDestroy(Sender: TObject);
begin
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;

procedure TfrmReview.lstReviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Itm: integer;
begin
  inherited;
  Itm := lstReview.ItemAtPos(Point(X, Y), TRUE);
  if (Itm >= 0) then
  begin
    if (Itm <> FLastHintItem) then
    begin
      Application.CancelHint;
      lstReview.Hint := TrimRight(lstReview.Items[Itm]);
      FLastHintItem := Itm;
      Application.ActivateHint(Point(X, Y));
    end;
  end
  else
  begin
    lstReview.Hint := '';
    FLastHintItem := -1;
    Application.CancelHint;
  end;
end;

procedure TfrmReview.DCUncheckedOrder(AnOrderId: string; AReason: integer);
begin
  CallV('ORWDXA DC', [AnOrderId, Encounter.Provider, Encounter.Location, AReason]);
end;

end.

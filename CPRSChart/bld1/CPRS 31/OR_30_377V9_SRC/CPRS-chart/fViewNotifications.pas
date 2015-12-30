unit fViewNotifications;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ActnList,
  ORCtrls;

type
  TfrmViewNotifications = class(TForm)
    acList: TActionList;
    acClose: TAction;
    acFirst: TAction;
    acPrev: TAction;
    acNext: TAction;
    acLast: TAction;
    acProcess: TAction;
    acDefer: TAction;
    acClearList: TAction;

    btnClose: TButton;
    btnDefer: TButton;
    btnProcess: TButton;
    btnFirst: TButton;
    btnPrevious: TButton;
    btnNext: TButton;
    btnLast: TButton;

    clvNotifications: TCaptionListView;

    pnlNavigator: TPanel;

    lblCurrentPage: TLabel;

    procedure FormResize(Sender: TObject);
    procedure acFirstExecute(Sender: TObject);
    procedure acPrevExecute(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure acLastExecute(Sender: TObject);
    procedure acProcessExecute(Sender: TObject);
    procedure acDeferExecute(Sender: TObject);
    procedure acListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acCloseExecute(Sender: TObject);
    procedure acClearListExecute(Sender: TObject);
  private
    FPageCount: integer;
    FCurrentPage: integer;

    procedure configureColumns;
    procedure loadPage(aPageNumber: integer);
    procedure loadItems(aItems: TStringList);
  public
    { Public declarations }
  end;

var
  frmViewNotifications: TfrmViewNotifications;

procedure ShowPatientNotifications(aProcessingEvent: TNotifyEvent);

implementation

{$R *.dfm}

uses
  MFunStr,
  ORFn,
  ORNet,
  uCore,
  rCore,
  fDeferDialog;

type
  TSMARTAlert = class(TObject)
  private
    FIsOwner: Boolean;
    FForwardedBy: string;
    FAlertDateTime: TDateTime;
    FUrgency: string;
    FAlertID: string;
    FPatientName: string;
    FInfoOnly: string;
    FAlertMsg: string;
    FLocation: string;
    procedure SetAlertID(const Value: string);
    procedure SetAlertDateTime(const Value: TDateTime);
    procedure SetAlertDateTimeFromFM(const Value: string);
    procedure SetAlertMsg(const Value: string);
    procedure SetForwardedBy(const Value: string);
    procedure SetInfoOnly(const Value: string);
    procedure SetIsOwner(const Value: Boolean);
    procedure SetPatientName(const Value: string);
    procedure SetUrgency(const Value: string);
    procedure SetLocation(const Value: string);

    function getAsText: string;
    function getIsOwnerAsString: string;
    function getIsInfoOnly: boolean;
    function getAlertDateTimeAsString: string;
    function getRecordID: string;
  public
    constructor Create(aDelimitedText: string);
    destructor Destroy; override;

    class function GetListViewColumns(aListViewWidth: integer): string;

    property IsInfoOnly: Boolean read getIsInfoOnly;
    property InfoOnly: string read FInfoOnly write SetInfoOnly;
    property PatientName: string read FPatientName write SetPatientName;
    property Urgency: string read FUrgency write SetUrgency;
    property AlertDateTime: TDateTime read FAlertDateTime write SetAlertDateTime;
    property AlertDateTimeAsString: string read getAlertDateTimeAsString;
    property AlertMsg: string read FAlertMsg write SetAlertMsg;
    property ForwardedBy: string read FForwardedBy write SetForwardedBy;
    property AlertID: string read FAlertID write SetAlertID;
    property IsOwner: Boolean read FIsOwner write SetIsOwner;
    property IsOwnerAsString: string read getIsOwnerAsString;
    property AsText: string read getAsText;
    property Location: string read FLocation write SetLocation;
    property RecordID: string read getRecordID;
  end;

procedure ShowPatientNotifications(aProcessingEvent: TNotifyEvent);
begin
  with TfrmViewNotifications.Create(Application) do
    try
      Caption := Format('%s - Patient: %s (%s)', [Caption, Patient.Name, Copy(Patient.SSN, 8, 4)]);
      configureColumns;
      FormResize(nil);
      loadPage(1);
      Notifications.Clear; // We're gonna load up the selected ones
      ShowModal;
      if Notifications.Active then // Now we know if we added any
        aProcessingEvent(nil);
    finally
      Free;
    end;
end;

{ TfrmViewNotifications }

procedure TfrmViewNotifications.FormResize(Sender: TObject);
begin
  pnlNavigator.Left := (btnProcess.Left - pnlNavigator.Width) div 2;
end;

procedure TfrmViewNotifications.acClearListExecute(Sender: TObject);
begin
  while clvNotifications.Items.Count > 0 do
    try
      if clvNotifications.Items[0].Data <> nil then
        TObject(clvNotifications.Items[0].Data).Free;
    finally
      clvNotifications.Items.Delete(0);
    end;
end;

procedure TfrmViewNotifications.acCloseExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmViewNotifications.acDeferExecute(Sender: TObject);
var
  aAlert: TSMARTAlert;
  aResult: string;
begin
  with TfrmDeferDialog.Create(Self) do
    try
      aAlert := TSMARTAlert(clvNotifications.Selected.Data);
      Title := 'Defer Patient Notification';
      Description := aAlert.AsText;
      if Execute then
        try
          aResult := sCallV('ORB3UTL DEFER', [User.DUZ, aAlert.AlertID, DeferUntilFM]);
          if aResult <> '1' then
            raise Exception.Create(Copy(aResult, Pos(aResult, '^') + 1, Length(aResult)));
        except
          on e: Exception do
            MessageDlg(e.Message, mtError, [mbOk], 0);
        end
      else
        MessageDlg('Deferral cancelled', mtInformation, [mbOk], 0);
    finally
      Free;
    end;
end;

procedure TfrmViewNotifications.acProcessExecute(Sender: TObject);
var
  aFollowUp, i: integer;
  aDFN, X: string;
  aSmartAlert: TSMARTAlert;
begin
  with clvNotifications do
    begin
      if SelCount < 1 then
        Exit;

      for i := 0 to Items.Count - 1 do
        if Items[i].Selected then
          begin
            aSmartAlert := TSMARTAlert(clvNotifications.Items[i].Data);

            if aSmartAlert.IsInfoOnly then
              DeleteAlert(aSmartAlert.AlertID)

            else if Piece(aSmartAlert.AlertID, ',', 1) = 'OR' then // OR,16,50;1311;2980626.100756 // Add to Object as ORAlert: bool;
              begin
                aDFN := Piece(aSmartAlert.AlertID, ',', 2); // *DFN*
                aFollowUp := StrToIntDef(Piece(Piece(aSmartAlert.AlertID, ';', 1), ',', 3), 0);
                Notifications.Add(aDFN, aFollowUp, aSmartAlert.RecordID, aSmartAlert.AlertDateTimeAsString);
              end

            else if Copy(aSmartAlert.AlertID,1,6) = 'TIUERR' then
              InfoBox(Piece(aSmartAlert.RecordID, U, 1) + #13#10#13#10 +
              'The CPRS GUI cannot yet process this type of alert.  Please use List Manager.',
              'Unable to Process Alert', MB_OK)

            else if Copy(aSmartAlert.AlertID, 1, 3) = 'TIU' then // TIU6028;1423;3021203.09
              begin
                X := GetTIUAlertInfo(aSmartAlert.AlertID);
                if Piece(X, U, 2) <> '' then
                  begin
                    aDFN := Piece(X, U, 2); // *DFN*
                    aFollowUp := StrToIntDef(Piece(Piece(X, U, 3), ';', 1), 0);
                    Notifications.Add(aDFN, aFollowUp, aSmartAlert.RecordID + '^^' + Piece(X, U, 3));
                  end
                else
                  DeleteAlert(aSmartAlert.AlertID);
              end
            else // other alerts cannot be processed
              InfoBox('This alert cannot be processed by the CPRS GUI.',
              aSmartAlert.PatientName + ': ' + aSmartAlert.AlertMsg,
              MB_OK);
          end;
    end;

    // This will close the form and if Notifications were added,
    // then the callback method will be fired immediately after the
    // ShowModal command in ShowPatientNotifications
    ModalResult := mrOK;
end;

procedure TfrmViewNotifications.acFirstExecute(Sender: TObject);
begin
  loadPage(1);
end;

procedure TfrmViewNotifications.acPrevExecute(Sender: TObject);
begin
  loadPage(FCurrentPage - 1);
end;

procedure TfrmViewNotifications.acNextExecute(Sender: TObject);
begin
  loadPage(FCurrentPage + 1);
end;

procedure TfrmViewNotifications.acLastExecute(Sender: TObject);
begin
  loadPage(FPageCount);
end;

procedure TfrmViewNotifications.acListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  aAlert: TSMARTAlert;
begin
  if clvNotifications.SelCount = 1 then
    begin
      aAlert := TSMARTAlert(clvNotifications.Selected.Data);
      acDefer.Enabled := aAlert.IsOwner;
      acProcess.Enabled := aAlert.IsOwner;
    end
  else
    begin
      acDefer.Enabled := False;
      acProcess.Enabled := False;
    end;

  acFirst.Enabled := (FCurrentPage > 1);
  acPrev.Enabled := (FCurrentPage > 1);
  acNext.Enabled := (FCurrentPage < FPageCount);
  acLast.Enabled := (FCurrentPage < FPageCount);
end;

procedure TfrmViewNotifications.configureColumns;
var
  aColSpec: string;
  aColSpecs: TStringList;
begin
  clvNotifications.Columns.BeginUpdate;
  aColSpecs := TStringList.Create;

  try
    clvNotifications.Columns.Clear;

    aColSpecs.StrictDelimiter := True;
    aColSpecs.DelimitedText := TSMARTAlert.GetListViewColumns(clvNotifications.Width);

    for aColSpec in aColSpecs do
      with clvNotifications.Columns.Add do
        begin
          Width := StrToIntDef(Copy(aColSpec, 1, Pos(':', aColSpec) - 1), 50);
          Caption := Copy(aColSpec, Pos(':', aColSpec) + 1, Length(aColSpec));
        end;
  finally
    FreeAndNil(aColSpecs);
  end;

  clvNotifications.Columns.EndUpdate;
end;

procedure TfrmViewNotifications.loadItems(aItems: TStringList);
var
  aAlert: TSMARTAlert;
  aItem: string;
begin
  clvNotifications.Items.BeginUpdate;

  try
    acClearList.Execute;
    for aItem in aItems do
      begin
        aAlert := TSMARTAlert.Create(aItem);
        with clvNotifications.Items.Add do
          begin
            Caption := aAlert.InfoOnly;
            SubItems.Add(aAlert.Location);
            SubItems.Add(aAlert.Urgency);
            SubItems.Add(aAlert.AlertDateTimeAsString);
            SubItems.Add(aAlert.AlertMsg);
            SubItems.Add(aAlert.ForwardedBy);
            SubItems.Add(aAlert.IsOwnerAsString);
            SubItems.Add(aAlert.AlertID);
            Data := aAlert;
          end;
      end;
  except
    on e: Exception do
      begin
        acClearList.Execute;
        MessageDlg('Error loading item list: ' + e.Message, mtError, [mbOk], 0);
      end;
  end;

  clvNotifications.Items.EndUpdate;
end;

procedure TfrmViewNotifications.loadPage(aPageNumber: integer);
var
  aItems: TStringList;
begin
  clvNotifications.Items.Clear;
  aItems := TStringList.Create;
  try
    tCallV(aItems, 'ORB3UTL NOTIFPG', [Patient.DFN, aPageNumber]);
    FCurrentPage := aPageNumber;
    FPageCount := StrToIntDef(Copy(aItems[0], Pos('^', aItems[0]) + 1, Length(aItems[0])), FCurrentPage);
    aItems.Delete(0);
    if aItems.Count > 0 then
      loadItems(aItems);
  except
    on e: Exception do
      MessageDlg('Error getting notifications: ' + e.Message, mtError, [mbOk], 0);
  end;

  FreeAndNil(aItems);
  lblCurrentPage.Caption := Format('Page %d of %d', [FCurrentPage, FPageCount]);
end;

{ TSMARTAlert }

constructor TSMARTAlert.Create(aDelimitedText: string);
begin
  inherited Create;
  with TStringList.Create do
    try
      Delimiter := '^';
      StrictDelimiter := True;
      DelimitedText := aDelimitedText;

      // Temp patch to make sure we have a complete record
      while Count < 11 do
        Add('');

      FInfoOnly := Strings[0];
      FPatientName := Strings[1];
      FLocation := Strings[2];
      FUrgency := Strings[3];
      SetAlertDateTimeFromFM(Strings[4]);
      FAlertMsg := Strings[5];
      FForwardedBy := Strings[6];
      FAlertID := Strings[7];
      FIsOwner := Strings[10] = '1';
    finally
      Free;
    end;
end;

destructor TSMARTAlert.Destroy;
begin
  inherited;
end;

function TSMARTAlert.getAlertDateTimeAsString: string;
begin
  Result := FormatDateTime('MM/DD/YYYY@hh:mm', FAlertDateTime);
end;

function TSMARTAlert.getAsText: string;
begin
  Result :=
  'Patient: ' + FPatientName + #13#10 +
  'Info: ' + FInfoOnly + #13#10 +
  'Location: ' + FLocation + #13#10 +
  'Urgency: ' + FUrgency + #13#10 +
  'Alert Date/Time: ' + FormatDateTime('MM/DD/YYYY@hh:mm', FAlertDateTime) + #13#10 +
  'Message: ' + FAlertMsg + #13#10 +
  'Forwarded By: ' + FForwardedBy;
end;

function TSMARTAlert.getIsInfoOnly: boolean;
begin
  Result := (FInfoOnly = 'I');
end;

function TSMARTAlert.getIsOwnerAsString: string;
begin
  case FIsOwner of
    True:
      Result := 'Yes';
    False:
      Result := 'No';
  end;
end;

class function TSMARTAlert.GetListViewColumns(aListViewWidth: integer): string;
begin
  Result :=
  '40:Info,100:Location,75:Urgency,120:Alert Date/Time,' +
  IntToStr(aListViewWidth - 540) +
  ':Message,150:Forwarded By,50:Mine';
end;

function TSMARTAlert.getRecordID: string;
begin
  // RecordID := Items[i].SubItems[0] + ': ' + Items[i].SubItems[4] + '^' + XQAID;
  Result := FPatientName + ': ' + FAlertMsg + '^' + FAlertID;
end;

procedure TSMARTAlert.SetAlertID(const Value: string);
begin
  FAlertID := Value;
end;

procedure TSMARTAlert.SetAlertDateTime(const Value: TDateTime);
begin
  FAlertDateTime := Value;
end;

procedure TSMARTAlert.SetAlertDateTimeFromFM(const Value: string);
var
  Y, M, D: Word;
  hh, mm: Word;
begin
  M := StrToInt(Copy(Value, 1, 2));
  D := StrToInt(Copy(Value, 4, 2));
  Y := StrToInt(Copy(Value, 7, 4));
  hh := StrToInt(Copy(Value, 12, 2));
  mm := StrToInt(Copy(Value, 15, 2));
  FAlertDateTime := EncodeDate(Y, M, D) + EncodeTime(hh, mm, 0, 0);
end;

procedure TSMARTAlert.SetAlertMsg(const Value: string);
begin
  FAlertMsg := Value;
end;

procedure TSMARTAlert.SetForwardedBy(const Value: string);
begin
  FForwardedBy := Value;
end;

procedure TSMARTAlert.SetInfoOnly(const Value: string);
begin
  FInfoOnly := Value;
end;

procedure TSMARTAlert.SetIsOwner(const Value: Boolean);
begin
  FIsOwner := Value;
end;

procedure TSMARTAlert.SetLocation(const Value: string);
begin
  FLocation := Value;
end;

procedure TSMARTAlert.SetPatientName(const Value: string);
begin
  FPatientName := Value;
end;

procedure TSMARTAlert.SetUrgency(const Value: string);
begin
  FUrgency := Value;
end;

end.

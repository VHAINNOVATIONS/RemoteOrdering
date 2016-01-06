unit fNotificationProcessor;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Actions,
  Vcl.ActnList;

type
  TNotificationAction = (naCancel, naNewNote, naAddendum);

  TfrmNotificationProcessor = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;

    bvlBottom: TBevel;

    lbxCurrentNotesAvailable: TListBox;

    memNotificationSpecifications: TMemo;

    rbtnNewNote: TRadioButton;
    rbtnAddendOneOfTheFollowing: TRadioButton;

    stxtNotificationName: TStaticText;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NewOrAddendClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fAlert: string;
    fDFN: string;
    fNotificationAction: TNotificationAction;
    fNotificationName: string;
    fNotificationIEN: integer;
    fNoteTitleIEN: integer;
    fNoteTitle: string;
    fNoteAllowAddendum: boolean;
    fNoteDescription: TStringList;
    fNoteList: TStringList;
    fParams: TStringList;
    fNoteIndex: integer;

    procedure Setup;
  public
    class function Execute(aParams: TStringList): TNotificationAction;
  end;

var
  NotificationProcessor: TfrmNotificationProcessor;

implementation

uses
  mFunStr,
  uCore,
  ORNet;

{$R *.dfm}

type
  TAvailableNote = class(TObject)
  private
    FIEN: integer;
    FTitle: string;
    FDate: string;
  end;

const
  STXT_CAPTION = 'Notification - %s';
  NOTE_CAPTION = 'Create New Note [Title: %s]';
  RBTN_CAPTION = '%d Notes available to addend';

procedure TfrmNotificationProcessor.btnOKClick(Sender: TObject);
var
  aNoteToAddend: TAvailableNote;
begin
  if rbtnNewNote.Checked then
    fNotificationAction := naNewNote
  else if rbtnAddendOneOfTheFollowing.Checked then
    begin
      fNoteIndex := lbxCurrentNotesAvailable.ItemIndex;
      fNotificationAction := naAddendum;
      aNoteToAddend := TAvailableNote(lbxCurrentNotesAvailable.Items.Objects[fNoteIndex]);
      fParams.Values['ADDEND NOTE IEN'] := IntToStr(aNoteToAddend.FIEN);
      fParams.Values['ADDEND NOTE TITLE'] := aNoteToAddend.FTitle;
    end
  else
    fNotificationAction := naCancel;
end;

class function TfrmNotificationProcessor.Execute(aParams: TStringList): TNotificationAction;
begin
  with TfrmNotificationProcessor.Create(Application) do
    try
      fParams := aParams;

      Setup;

      if lbxCurrentNotesAvailable.Count < 1 then // No existing notes to addend, just create a new one with zero user interaction
        Result := naNewNote
      else
        case ShowModal of
          mrOk: Result := fNotificationAction;
          mrCancel: Result := naCancel;
        else
          Result := naCancel;
        end;

    finally
      Free;
    end;
end;

procedure TfrmNotificationProcessor.FormCreate(Sender: TObject);
begin
  Font := Application.MainForm.Font;
  fNoteDescription := TStringList.Create;
  fNoteList := TStringList.Create;
  fNoteIndex := -1;
end;

procedure TfrmNotificationProcessor.FormDestroy(Sender: TObject);
begin
  while lbxCurrentNotesAvailable.Count > 0 do
    begin
      lbxCurrentNotesAvailable.Items.Objects[0].Free;
      lbxCurrentNotesAvailable.Items.Delete(0);
    end;
  FreeAndNil(fNoteDescription);
  FreeAndNil(fNoteList);
end;

procedure TfrmNotificationProcessor.NewOrAddendClick(Sender: TObject);
begin
  if not rbtnAddendOneOfTheFollowing.Checked then
    begin
      lbxCurrentNotesAvailable.ItemIndex := -1;
      lbxCurrentNotesAvailable.Enabled := False;
    end
  else
    begin
      lbxCurrentNotesAvailable.Enabled := True;
    end;

  if fNoteAllowAddendum and rbtnAddendOneOfTheFollowing.Checked then
    btnOK.Enabled := lbxCurrentNotesAvailable.ItemIndex > -1
  else
    btnOK.Enabled := rbtnNewNote.Checked;
end;

procedure TfrmNotificationProcessor.Setup;
var
  aAvailableNote: TAvailableNote;
begin
  fNotificationAction := naCancel; // Just to make sure ;-)

  fAlert := fParams.Values['ALERT'];

  fNotificationIEN := StrToIntDef(fParams.Values['NOTIFICATION IEN'], -1);
  fNotificationName := fParams.Values['NOTIFICATION NAME'];

  fNoteTitle := fParams.Values['NOTE TITLE'];
  fNoteTitleIEN := StrToIntDef(fParams.Values['NOTE TITLE IEN'], -1);
  fNoteAllowAddendum := fParams.Values['ALLOW ADDENDUM'] = '1';
  fDFN := fParams.Values['DFN'];

  tCallV(fNoteDescription, 'ORB3UTL GET DESCRIPTION', [fAlert]);

  if fNoteAllowAddendum then
    begin
      tCallV(fNoteList, 'ORB3UTL GET EXISTING NOTES', [fNoteTitleIEN, fDFN]);
      lbxCurrentNotesAvailable.Items.Clear;
      while fNoteList.Count > 1 do
        begin
          aAvailableNote := TAvailableNote.Create;
          aAvailableNote.FIEN := StrToIntDef(Piece(fNoteList[1], '^', 1), -1);
          aAvailableNote.FTitle := Piece(fNoteList[1], '^', 2);
          aAvailableNote.FDate := Piece(fNoteList[1], '^', 3);
          lbxCurrentNotesAvailable.Items.AddObject(aAvailableNote.FTitle + ' ' + aAvailableNote.FDate, aAvailableNote);
          fNoteList.Delete(1);
        end;

      if lbxCurrentNotesAvailable.Count > 0 then
        rbtnAddendOneOfTheFollowing.Caption := Format(RBTN_CAPTION, [lbxCurrentNotesAvailable.Count])
      else
        rbtnAddendOneOfTheFollowing.Caption := 'No notes available to addend';

      rbtnAddendOneOfTheFollowing.Enabled := (lbxCurrentNotesAvailable.Count > 0);
      lbxCurrentNotesAvailable.Enabled := False;
    end
  else
    begin
      rbtnAddendOneOfTheFollowing.Caption := 'Addendums not allowed for this notification';
      rbtnAddendOneOfTheFollowing.Enabled := False;
      lbxCurrentNotesAvailable.Enabled := False;
    end;

  stxtNotificationName.Caption := Format(STXT_CAPTION, [fNotificationName]);

  rbtnNewNote.Caption := Format(NOTE_CAPTION, [fNoteTitle]);
  rbtnNewNote.Checked := True; // Default to new note

  memNotificationSpecifications.Text := fNoteDescription.Text;

  lbxCurrentNotesAvailable.ItemIndex := -1;
end;

end.

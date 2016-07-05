unit fSignItem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, rCore, Hash;

type
  TfrmSignItem = class(TForm)
    txtESCode: TEdit;
    lblESCode: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblText: TLabel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FESCode: string;
  public
    { Public declarations }
  end;

procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);

implementation

{$R *.DFM}

const
  TX_INVAL_MSG = 'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP = 'Unrecognized Signature Code';

procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);
var
  frmSignItem: TfrmSignItem;
begin
  frmSignItem := TfrmSignItem.Create(Application);
  try
    with frmSignItem do
    begin
      FESCode := '';
      Caption := ACaption;
      lblText.Caption := AText;
      ShowModal;
      ESCode := FESCode;
    end;
  finally
    frmSignItem.Release;
  end;
end;

procedure TfrmSignItem.cmdOKClick(Sender: TObject);
begin
  if not ValidESCode(txtESCode.Text) then
  begin
    InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
    txtESCode.SetFocus;
    txtESCode.SelectAll;
    Exit;
  end;
  FESCode := Encrypt(txtESCode.Text);
  Close;
end;

procedure TfrmSignItem.cmdCancelClick(Sender: TObject);
begin
  FESCode := '';
  Close;
end;

end.

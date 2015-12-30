unit ORRadioCheck;

interface

uses Windows, Classes, SysUtils, ComCtrls, ExtCtrls, StdCtrls, Controls, Graphics, Messages, ORStaticText;

const
  OR_DEFAULT_SPACING = 3;
type
  TORRadioCheck = class(TCustomControl)
  private
    fCheck: TCheckbox;
    fRadio: TRadioButton;
    fStatic: TORStaticText;

    fSingleLine: boolean;
    fBoxHeight: integer;
    fFocusOnBox: boolean;
    fGrayedToChecked: boolean;
    fAllowAllUnchecked: boolean;
    fAssociate: TControl;
    fSpacing: integer;
    fPanel: TPanel;
    fUseRadioStyle: boolean;
    fPreDelimiter: TSysCharSet;
    fPostDelimiter: TSysCharSet;
    function GetGroupIndex: integer;
    procedure SetAssociate(const Value: TControl);
    procedure SetGroupIndex(const Value: integer);
    procedure SetUseRadioStyle(const Value: boolean);
    procedure SetSpacing(const Value: integer);
    procedure SetPanel(const Value: TPanel);
    function GetSingleLine: boolean;

    procedure SyncAllowAllUnchecked;
    function GetLines: TStringList;
    procedure SetLines(const Value: TStringList);
    procedure SetPostDelimiter(const Value: TSysCharSet);
    procedure SetPreDelimiter(const Value: TSysCharSet);
    function GetChecked: boolean;
    procedure SetChecked(const Value: boolean);
    function GetWordWrap: boolean;
    function GetAutoSize: boolean;

(*    procedure SetFocusOnBox(value: boolean);
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure BMSetCheck(var Message: TMessage); message BM_SETCHECK;
    procedure BMGetCheck(var Message: TMessage); message BM_GETCHECK;
    procedure BMGetState(var Message: TMessage); message BM_GETSTATE;
    procedure SyncAllowAllUnchecked;
    procedure SetGroupIndex(const Value: integer);
    procedure SetRadioStyle(const Value: boolean);
    procedure SetAssociate(const Value: TControl);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer); *)


  protected
    procedure SetAutoSize(Value: boolean); override;
    procedure SetWordWrap(const Value: boolean);
    function GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    procedure SetAllowAllUnchecked(const Value: boolean);
    procedure UpdateAssociate;

(*    procedure SetAutoSize(Value: boolean); override;
    procedure GetDrawData(CanvasHandle: HDC; var Bitmap: TBitmap; var FocRect, Rect: TRect; var DrawOptions: UINT; var TempBitMap: boolean);
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct); dynamic;
    procedure Toggle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    constructor ListViewCreate(AOwner: TComponent; ACustomImages: TORCBImageIndexes);
    procedure CreateCommon(AOwner: TComponent);
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override; *)

    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SingleLine: boolean read GetSingleLine;
    property BoxHeight: integer read fBoxHeight;
    property PreDelimiters: TSysCharSet read fPreDelimiter write SetPreDelimiter;
    property PostDelimiters: TSysCharSet read fPostDelimiter write SetPostDelimiter;

    property Checkbox: TCheckbox read fCheck write fCheck;
    property RadioButton: TRadioButton read fRadio write fRadio;
    property StaticText: TORStaticText read fStatic write fStatic;
    property Panel: TPanel read fPanel write SetPanel;
  published
//    property FocusOnBox: boolean read FFocusOnBox write FFocusOnBox default False;
//    property GrayedToChecked: boolean read FGrayedToChecked write FGrayedToChecked default True;
    property AllowAllUnchecked: boolean read FAllowAllUnchecked write SetAllowAllUnchecked default True;
    property Associate: TControl read FAssociate write SetAssociate;
    property AutoSize: boolean read GetAutoSize write SetAutoSize default False;
    property Caption: TCaption read GetCaption write SetCaption;
    property GroupIndex: integer read GetGroupIndex write SetGroupIndex default 0;
    property Lines: TStringList read GetLines write SetLines;
    property Spacing: integer read fSpacing write SetSpacing default OR_DEFAULT_SPACING;
    property UseRadioStyle: boolean read fUseRadioStyle write SetUseRadioStyle default False;
    property WordWrap: boolean read GetWordWrap write SetWordWrap default False;
    property Checked: boolean read GetChecked write SetChecked;

    property OnEnter;
    property OnExit;

  end;

implementation

{ TORRadioCheck }

constructor TORRadioCheck.Create(AOwner: TComponent);
begin
  inherited;

  fPanel := TPanel.Create(Self);
  fPanel.Parent := Self;
  fPanel.Align := alClient;
  fPanel.BevelInner := bvNone;
  fPanel.BevelOuter := bvNone;
  fPanel.ShowCaption := False;
  fPanel.AutoSize := True;
  fPanel.ParentFont := True;

  fCheck := TCheckbox.Create(fPanel);
  fCheck.Parent := fPanel;
  fCheck.Left := 0;
  fCheck.Top := 0;
  fCheck.Caption := '';
  fCheck.Width := fCheck.Height;
  fCheck.ParentFont := True;
  fCheck.Visible := True;

  fRadio := TRadioButton.Create(fPanel);
  fRadio.Parent := fPanel;
  fRadio.Left := 0;
  fRadio.Top := 0;
  fRadio.Width := fRadio.Height;
  fRadio.Caption := '';
  fRadio.Visible := False;
  fRadio.ParentFont := True;

  fStatic := TORStaticText.Create(fPanel);
  fStatic.Parent := fPanel;
  fStatic.Left := fCheck.Width + fSpacing;
  fStatic.Caption := Self.Caption;
  fStatic.AutoSize := False;
  fStatic.WordWrap := False;
  fStatic.Align := alRight;
  fStatic.ParentFont := True;

  fUseRadioStyle := False;
  fSingleLine := True;
  fFocusOnBox := False;
  fGrayedToChecked := True;
  fAllowAllUnchecked := True;
  fAssociate := nil;
  fSpacing := OR_DEFAULT_SPACING;
end;

destructor TORRadioCheck.Destroy;
begin
(*  if assigned(fCheck) then begin
    fCheck.Parent := nil;
    fCheck.Free;
  end;
  if assigned(fRadio) then begin
    fRadio.Parent := nil;
    fRadio.Free;
  end;
  if assigned(fStatic) then begin
    fStatic.Parent := nil;
    fStatic.Free;
  end;
  if assigned(fPanel) then begin
    fPanel.Parent := nil;
    fPanel.Free;
  end;
  *)
  inherited;
end;

function TORRadioCheck.GetAutoSize: boolean;
begin
  Result := fStatic.AutoSize;
end;

function TORRadioCheck.GetCaption: TCaption;
begin
  Result := fStatic.Caption;
end;

function TORRadioCheck.GetChecked: boolean;
begin
  Result := fCheck.Checked;
end;

function TORRadioCheck.GetGroupIndex: integer;
begin
  Result := fRadio.Tag;
end;

function TORRadioCheck.GetLines: TStringList;
begin
  Result := fStatic.Lines;
end;

function TORRadioCheck.GetSingleLine: boolean;
begin
  Result := (fStatic.Lines.Count = 1); // assumption: this may need to be < 2
end;

function TORRadioCheck.GetWordWrap: boolean;
begin
  Result := fStatic.WordWrap;
end;

procedure TORRadioCheck.Paint;
begin
  inherited;
  fCheck.Repaint;
  fRadio.Repaint;
  fStatic.Repaint;
end;

procedure TORRadioCheck.Resize;
begin
  inherited;
  fStatic.Refresh;
end;

procedure TORRadioCheck.SetAllowAllUnchecked(const Value: boolean);
begin
  FAllowAllUnchecked := Value;
  SyncAllowAllUnchecked;
end;

procedure TORRadioCheck.SetAssociate(const Value: TControl);
begin
  if (FAssociate <> Value) then
  begin
    if (assigned(FAssociate)) then
      FAssociate.RemoveFreeNotification(Self);
    FAssociate := Value;
    if (assigned(FAssociate)) then
    begin
      FAssociate.FreeNotification(Self);
      UpdateAssociate;
    end;
  end;
end;

procedure TORRadioCheck.UpdateAssociate;

  procedure EnableCtrl(Ctrl: TControl; DoCtrl: boolean);
  var
    i: integer;
    DoIt: boolean;

  begin
    if DoCtrl then
      Ctrl.Enabled := Checked;

    // added (csAcceptsControls in Ctrl.ControlStyle) below to prevent disabling of
    // child sub controls, like the TBitBtn in the TORComboBox.  If the combo box is
    // already disabled, we don't want to disable the button as well - when we do, we
    // lose the disabled glyph that is stored on that button for the combo box.

    if (Ctrl is TWinControl) and (csAcceptsControls in Ctrl.ControlStyle) then
    begin
      for i := 0 to TWinControl(Ctrl).ControlCount - 1 do
      begin
        if DoCtrl then
          DoIt := TRUE
        else
          DoIt := (TWinControl(Ctrl).Controls[i] is TWinControl);
        if DoIt then
          EnableCtrl(TWinControl(Ctrl).Controls[i], TRUE);
      end;
    end;
  end;

begin
  if (assigned(FAssociate)) then
    EnableCtrl(FAssociate, FALSE);
end;

procedure TORRadioCheck.SetAutoSize(Value: boolean);
begin
  inherited;

end;

procedure TORRadioCheck.SetCaption(const Value: TCaption);
begin
  fStatic.Caption := Value;
  invalidate;
end;

procedure TORRadioCheck.SetChecked(const Value: boolean);
begin
  if (Value <> fCheck.Checked) or (Value <> fRadio.Checked) then begin
    fCheck.Checked := Value;
    fRadio.Checked := Value;
  end;
  invalidate;
end;

procedure TORRadioCheck.SetGroupIndex(const Value: integer);
begin
  fRadio.Tag := Value;
end;

procedure TORRadioCheck.SetLines(const Value: TStringList);
begin
  fStatic.Lines := Value;
  invalidate;
end;

procedure TORRadioCheck.SetPanel(const Value: TPanel);
begin
  fPanel := Value;
  invalidate;
end;

procedure TORRadioCheck.SetPostDelimiter(const Value: TSysCharSet);
begin
  fPostDelimiter := Value;
  invalidate;
end;

procedure TORRadioCheck.SetPreDelimiter(const Value: TSysCharSet);
begin
  fPreDelimiter := Value;
  invalidate;
end;

procedure TORRadioCheck.SetUseRadioStyle(const Value: boolean);
begin
  if (Value <> fUseRadioStyle) then begin
    fUseRadioStyle := Value;
    fCheck.Visible := (not fUseRadioStyle);
    fCheck.Repaint;
    fRadio.Visible := fUseRadioStyle;
    fRadio.Repaint;
  end;
  Repaint;
end;

procedure TORRadioCheck.SetSpacing(const Value: integer);
begin
  fSpacing := Value;
  invalidate;
end;

procedure TORRadioCheck.SetWordWrap(const Value: boolean);
begin
  fStatic.WordWrap := Value;
  invalidate;
end;

procedure TORRadioCheck.SyncAllowAllUnchecked;
var
  i: integer;
  cb: TORRadioCheck;

begin
  if (assigned(Parent) and (GroupIndex <> 0)) then
  begin
    for i := 0 to Parent.ControlCount - 1 do
    begin
      if (Parent.Controls[i] is TORRadioCheck) then
      begin
        cb := TORRadioCheck(Parent.Controls[i]);
        if ((cb <> Self) and (cb.GroupIndex = GroupIndex)) then
          cb.FAllowAllUnchecked := FAllowAllUnchecked;
      end;
    end;
  end;
end;

end.

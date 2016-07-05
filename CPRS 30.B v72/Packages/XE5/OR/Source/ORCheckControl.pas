unit ORCheckControl;

interface

uses Windows, Classes, SysUtils, ComCtrls, ExtCtrls, StdCtrls, Controls, Graphics, Messages, ORStaticText;

type
  TORCheckControl = class(TWinControl)
  private
    fCheckbox: TCheckbox;
    fStaticText: TORStaticText;

    FStringData: string;
    FSingleLine: boolean;
    fBoxHeight: integer;
    FFocusOnBox: boolean;
    FGrayedToChecked: boolean;
    FAutoSize: boolean;
    FWordWrap: boolean;
    FAllowAllUnchecked: boolean;
    FAssociate: TControl;
    fSpacing: integer;
    fPanel: TPanel;
    function GetGroupIndex: integer;
    function GetRadioStyle: boolean;
    procedure SetAssociate(const Value: TControl);
    procedure SetGroupIndex(const Value: integer);
    procedure SetRadioStyle(const Value: boolean);
    procedure SetSpacing(const Value: integer);
    procedure SetPanel(const Value: TPanel);
    function GetSingleLine: boolean;

    procedure SyncAllowAllUnchecked;
(*    FStringData: string;
    FCanvas: TCanvas;
    FCustomImagesOwned: boolean;
    FWordWrap: boolean;
    FAutoSize: boolean;
    FSingleLine: boolean;
    FSizable: boolean;
    FGroupIndex: integer;
    FRadioStyle: boolean;
    FAssociate: TControl;
    fBoxHeight: integer;*)
(*    procedure SetFocusOnBox(value: boolean);
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AutoAdjustSize;
    property SingleLine: boolean read GetSingleLine;
    property StringData: string read FStringData write FStringData;
    property BoxHeight: integer read fBoxHeight;
    property Checkbox: TCheckbox read fCheckbox write fCheckbox;
    property StaticText: TORStaticText read fStaticText write fStaticText;
    property Panel: TPanel read fPanel write SetPanel;
  published
//    property FocusOnBox: boolean read FFocusOnBox write FFocusOnBox default False;
//    property GrayedToChecked: boolean read FGrayedToChecked write FGrayedToChecked default True;
    property WordWrap: boolean read FWordWrap write SetWordWrap default False;
    property AutoSize: boolean read FAutoSize write SetAutoSize default False;
    property Caption: TCaption read GetCaption write SetCaption;
    property AllowAllUnchecked: boolean read FAllowAllUnchecked write SetAllowAllUnchecked default True;
    property GroupIndex: integer read GetGroupIndex write SetGroupIndex default 0;
    property RadioStyle: boolean read GetRadioStyle write SetRadioStyle default False;
    property Associate: TControl read FAssociate write SetAssociate;
    property OnEnter;
    property OnExit;
    property Spacing: integer read fSpacing write SetSpacing;
  end;

implementation

{ TORCheckControl }

procedure TORCheckControl.AutoAdjustSize;
begin
end;

constructor TORCheckControl.Create(AOwner: TComponent);
begin
  inherited;

  fPanel := TPanel.Create(nil);
  fPanel.Parent := Self;
  fPanel.Alignment := alClient;

  fCheckbox := TCheckbox.Create(nil);
  fCheckbox.Parent := fPanel;
  fCheckbox.Left := 0;
  fCheckbox.Top := 0;
  fCheckbox.Caption := '';

  fStaticText := TORStaticText.Create(nil);
  fStaticText.Parent := fPanel;
  fStaticText.Left := fCheckbox.Width + fSpacing;
  fStaticText.Caption := Self.Caption;

end;

destructor TORCheckControl.Destroy;
begin
  if assigned(fCheckbox) then begin
    fCheckbox.Parent := nil;
    fCheckbox.Free;
  end;
  if assigned(fStaticText) then begin
    fStaticText.Parent := nil;
    fStaticText.Free;
  end;
  if assigned(fPanel) then begin
    fPanel.Parent := nil;
    fPanel.Free;
  end;

  inherited;
end;

function TORCheckControl.GetCaption: TCaption;
begin

end;

function TORCheckControl.GetGroupIndex: integer;
begin

end;

function TORCheckControl.GetRadioStyle: boolean;
begin

end;

function TORCheckControl.GetSingleLine: boolean;
begin
  Result := (fStaticText.Lines.Count = 1); // assumption: this may need to be < 2
end;

procedure TORCheckControl.SetAllowAllUnchecked(const Value: boolean);
begin
  FAllowAllUnchecked := Value;
  SyncAllowAllUnchecked;
end;

procedure TORCheckControl.SetAssociate(const Value: TControl);
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

procedure TORCheckControl.UpdateAssociate;

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

procedure TORCheckControl.SetAutoSize(Value: boolean);
begin
  inherited;

end;

procedure TORCheckControl.SetCaption(const Value: TCaption);
begin

end;

procedure TORCheckControl.SetGroupIndex(const Value: integer);
begin

end;

procedure TORCheckControl.SetPanel(const Value: TPanel);
begin
  fPanel := Value;
end;

procedure TORCheckControl.SetRadioStyle(const Value: boolean);
begin

end;

procedure TORCheckControl.SetSpacing(const Value: integer);
begin
  fSpacing := Value;
end;

procedure TORCheckControl.SetWordWrap(const Value: boolean);
begin

end;

procedure TORCheckControl.SyncAllowAllUnchecked;
var
  i: integer;
  cb: TORCheckControl;

begin
  if (assigned(Parent) and (GroupIndex <> 0)) then
  begin
    for i := 0 to Parent.ControlCount - 1 do
    begin
      if (Parent.Controls[i] is TORCheckControl) then
      begin
        cb := TORCheckControl(Parent.Controls[i]);
        if ((cb <> Self) and (cb.GroupIndex = GroupIndex)) then
          cb.FAllowAllUnchecked := FAllowAllUnchecked;
      end;
    end;
  end;
end;

end.

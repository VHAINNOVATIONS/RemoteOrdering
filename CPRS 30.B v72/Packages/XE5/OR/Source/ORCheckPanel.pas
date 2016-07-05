unit ORCheckPanel;

interface

uses
  StdCtrls, ExtCtrls, Controls, Classes;

type
  TORCheckPanel = class(TPanel)
  private
    fCheckbox: TCheckbox;
    fRadioButton: TRadioButton;
    fPanel: TPanel;
    fDroppedDown: boolean;
    fPanelHeight: integer;
    fRadioStyle: boolean;
    fChecked: boolean;
    fOnCheckClick: TNotifyEvent;
    fStringData: string;
    fFocusOnBox: boolean;
    function GetChecked: boolean;
    procedure SetChecked(const Value: boolean);
    function GetAllowGrayed: boolean;
    function GetState: TCheckboxState;
    function GetGroupIndex: integer;
    procedure SetAllowGrayed(const Value: boolean);
    procedure SetState(const Value: TCheckboxState);
    procedure SetDroppedDown(const Value: boolean);
    procedure SetPanelHeight(const Value: integer);
    procedure SetOnCheckClick(const Value: TNotifyEvent);
    procedure SetRadioStyle(const Value: boolean);
    procedure SetGroupIndex(const Value: integer);
    procedure SetFocusOnBox(const Value: boolean);
  protected
  public
    property Checkbox: TCheckbox read fCheckbox write fCheckbox;
    property RadioButton: TRadioButton read fRadioButton write fRadioButton;
    procedure Reposition;
    procedure Resize; override;
    property StringData: string read fStringData write fStringData;
    property FocusOnBox: boolean read fFocusOnBox write SetFocusOnBox;
  published
    property Panel: TPanel read fPanel write fPanel;
    property Checked: boolean read GetChecked write SetChecked;
    property State: TCheckboxState read GetState write SetState;
    property AllowGrayed: boolean read GetAllowGrayed write SetAllowGrayed;
    property DroppedDown: boolean read fDroppedDown write SetDroppedDown;
    property PanelHeight: integer read fPanelHeight write SetPanelHeight;
    property OnCheckClick: TNotifyEvent read fOnCheckClick write SetOnCheckClick;

    property RadioStyle: boolean read fRadioStyle write SetRadioStyle default False;
    property GroupIndex: integer read GetGroupIndex write SetGroupIndex default 0;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  UITypes, Graphics, Forms;

const
  CHECK_PANEL_GAP = 2;
  CHECK_PANEL_HEIGHT = 17;

{ TORCheckPanel }

constructor TORCheckPanel.Create(AOwner: TComponent);
begin
  fDroppedDown := False;
  fPanelHeight := CHECK_PANEL_HEIGHT;

  inherited Create(AOwner);
  fCheckbox := TCheckbox.Create(nil);
  fCheckbox.Parent := Self;
  fCheckbox.Caption := '';
  fCheckbox.Left := Margins.Top;
  fCheckbox.Top := Margins.Left;
  fCheckbox.Width := fCheckbox.Height;
  fCheckbox.Anchors := [akLeft, akTop];
  fCheckbox.Font.Assign(Font);
  fCheckbox.Color := Color;
  fCheckbox.Visible := True;

  fRadioButton := TRadioButton.Create(nil);
  fRadioButton.Parent := Self;
  fRadioButton.Caption := '';
  fRadioButton.Left := Margins.Top;
  fRadioButton.Top := Margins.Left;
  fRadioButton.Width := fRadioButton.Height;
  fRadioButton.Anchors := [akLeft, akTop];
  fRadioButton.Font.Assign(Font);
  fRadioButton.Color := Color;
  fRadioButton.Visible := False;

  fRadioStyle := False;

  Height := fCheckbox.Height + Margins.Top + Margins.Bottom;

  fPanel := TPanel.Create(nil);
  fPanel.Parent := Self;
  fPanel.Caption := '';
  fPanel.Font.Assign(Font);
  fPanel.BorderStyle := bsNone;
  fPanel.BevelInner := bvNone;
  fPanel.BevelOuter := bvNone;
  fPanel.Left := Margins.Left + fCheckbox.Width + CHECK_PANEL_GAP;
  fPanel.Top := Margins.Top;
  fPanel.Height := fCheckbox.Height;
  fPanel.Width := Width - fPanel.Left - Margins.Right;
  fPanel.Anchors := [akLeft, akTop, akRight, akBottom];

  DragMode := dmAutomatic;
end;

destructor TORCheckPanel.Destroy;
begin
  fPanel.Free;
  fCheckbox.Free;
  fRadioButton.Free;
  inherited;
end;

function TORCheckPanel.GetAllowGrayed: boolean;
begin
  Result := fCheckbox.AllowGrayed;
end;

function TORCheckPanel.GetChecked: boolean;
begin
  Result := fChecked;
end;

function TORCheckPanel.GetGroupIndex: integer;
begin
  Result := fRadioButton.Tag;
end;

function TORCheckPanel.GetState: TCheckboxState;
begin
  Result := fCheckbox.State;
end;

procedure TORCheckPanel.Reposition;
var
  NewHeight: integer;
begin
  NewHeight := Margins.Top + Margins.Bottom + fCheckbox.Height;
  if fDroppedDown then begin
    Height := NewHeight + PanelHeight;
    fPanel.Height := fCheckbox.Height + PanelHeight
  end else begin
    Height := NewHeight;
    fPanel.Height := fCheckbox.Height;
  end;
end;

procedure TORCheckPanel.Resize;
begin
  inherited;
  Reposition;
end;

procedure TORCheckPanel.SetAllowGrayed(const Value: boolean);
begin
  fCheckbox.AllowGrayed := Value;
end;

procedure TORCheckPanel.SetChecked(const Value: boolean);
begin
  fCheckbox.Checked := Value;
  fRadioButton.Checked := Value;
end;

procedure TORCheckPanel.SetDroppedDown(const Value: boolean);
begin
  fDroppedDown := Value;
  Reposition;
end;

procedure TORCheckPanel.SetFocusOnBox(const Value: boolean);
begin
  fFocusOnBox := Value;
end;

procedure TORCheckPanel.SetGroupIndex(const Value: integer);
begin
  fRadioButton.Tag := Value;
end;

procedure TORCheckPanel.SetOnCheckClick(const Value: TNotifyEvent);
begin
  fOnCheckClick := Value;
  fCheckbox.OnClick := Value;
  fRadioButton.OnClick := Value;
end;

procedure TORCheckPanel.SetPanelHeight(const Value: integer);
begin
  fPanelHeight := Value;
end;

procedure TORCheckPanel.SetRadioStyle(const Value: boolean);
begin
  FRadioStyle := Value;
  fCheckbox.Visible := (not Value);
  fRadioButton.Visible := Value;
end;

procedure TORCheckPanel.SetState(const Value: TCheckboxState);
begin
  fCheckbox.State := Value;
end;

end.

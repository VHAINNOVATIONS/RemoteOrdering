unit ORExtensions;

interface

uses
  ORCtrls,
  System.Classes,
  Vcl.Clipbrd,
  Vcl.ComCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TMemo = class(Vcl.StdCtrls.TMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TRichEdit = class(Vcl.ComCtrls.TRichEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
  end;

  TCaptionEdit = class(ORCtrls.TCaptionEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TCaptionMemo = class(ORCtrls.TCaptionMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

procedure ScrubTheClipboard;

implementation

procedure ScrubTheClipboard;
var
  i: integer;
  aAnsiValue: integer;
  aAnsiString: AnsiString;
begin
  aAnsiString := AnsiString(Clipboard.AsText);

  i := 1;
  while aAnsiString[i] <> #0 do
    try
      aAnsiValue := Ord(aAnsiString[i]);
      if (aAnsiValue < 32) or (aAnsiValue > 126) then
        case aAnsiValue of
          9: aAnsiString[i] := #32;
          10: aAnsiString[i] := #10;
          13: aAnsiString[i] := #13;
          145, 146: aAnsiString[i] := '''';
          147, 148: aAnsiString[i] := '"';
          149: aAnsiString[i] := '*';
        else
          aAnsiString[i] := '?';
        end;
    finally
      inc(i);
    end;

  Clipboard.AsText := String(aAnsiString);
end;

{ TEdit }

procedure TEdit.WMPaste(var Message: TMessage);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      ScrubTheClipboard;
      inherited;
    end;
end;

{ TMemo }

procedure TMemo.WMPaste(var Message: TMessage);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      ScrubTheClipboard;
      inherited;
    end;
end;

{ TRichEdit }

procedure TRichEdit.WMKeyDown(var Message: TMessage);
var
  aShiftState: TShiftState;
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      aShiftState := KeyDataToShiftState(message.WParam);
      if (ssCtrl in aShiftState) and (message.WParam = Ord('V')) then
          ScrubTheClipboard;
      if (ssShift in aShiftState) and (message.WParam = VK_INSERT) then
          ScrubTheClipboard;
      inherited;
    end;
end;

procedure TRichEdit.WMPaste(var Message: TMessage);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      ScrubTheClipboard;
      inherited;
    end;
end;

{ TCaptionEdit }

procedure TCaptionEdit.WMPaste(var Message: TMessage);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      ScrubTheClipboard;
      inherited;
    end;
end;

{ TCaptionMemo }

procedure TCaptionMemo.WMPaste(var Message: TMessage);
begin
  if Clipboard.HasFormat(CF_TEXT) then
    begin
      ScrubTheClipboard;
      inherited;
    end;
end;

end.

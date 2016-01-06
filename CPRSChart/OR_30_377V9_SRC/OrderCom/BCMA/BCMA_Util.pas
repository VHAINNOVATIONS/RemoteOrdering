Unit BCMA_Util;

{$OPTIMIZATION OFF}

interface // --------------------------------------------------------------------------------

uses SysUtils, Windows, Messages, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Forms,
  Graphics, Menus, Dialogs, {BCMA_Startup, Splash,} StrUtils, ShellAPI;

const
  U = '^';
  CRLF = #13#10;
  BOOLCHAR: array[Boolean] of Char = ('0', '1');
  UM_STATUSTEXT = (WM_USER + 302); // used to send update status msg to main form
  COLOR_CREAM = $F0FBFF;
  ErrIncompleteData = 'Incomplete data returned from VistA';
type
  TFMDateTime = Double;

  { Date/Time functions }
function DateTimeToFMDateTime(ADateTime: TDateTime): TFMDateTime;
function FMDateTimeToDateTime(ADateTime: TFMDateTime): TDateTime;
function FMDateTimeOffsetBy(ADateTime: TFMDateTime; DaysDiff: Integer): TFMDateTime;
function FormatFMDateTime(AFormat: string; ADateTime: TFMDateTime): string;
function FormatFMDateTimeStr(const AFormat, ADateTime: string): string;
function IsFMDateTime(x: string): Boolean;
function MakeFMDateTime(const AString: string): TFMDateTime;
procedure SetListFMDateTime(AFormat: string; AList: TStringList; ADelim: Char; PieceNum: Integer);

{ Numeric functions }
function HigherOf(i, j: Integer): Integer;
function LowerOf(i, j: Integer): Integer;

{ String functions }
function CharAt(const x: string; APos: Integer): Char;
function ContainsAlpha(const x: string): Boolean;
function ContainsVisibleChar(const x: string): Boolean;
function CRCForFile(AFileName: string): DWORD;
function CRCForStrings(AStringList: TStrings): DWORD;
procedure ExpandTabsFilter(AList: TStrings; ATabWidth: Integer);
function ExtractInteger(x: string): Integer;
function ExtractDefault(Src: TStrings; const Section: string): string;
procedure ExtractItems(Dest, Src: TStrings; const Section: string);
procedure ExtractText(Dest, Src: TStrings; const Section: string);
procedure InvertStringList(AList: TStringList);
procedure LimitStringLength(var AList: TStringList; MaxLength: Integer);
function MixedCase(const x: string): string;
procedure MixedCaseList(AList: TStrings);
procedure MixedCaseByPiece(AList: TStrings; ADelim: Char; PieceNum: Integer);
function Piece(const S: string; Delim: char; PieceNum: Integer): string;
function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;
procedure PiecesToList(x: string; ADelim: Char; AList: TStrings);
function ReverseStr(const x: string): string;
procedure SetPiece(var x: string; Delim: Char; PieceNum: Integer; const NewPiece: string);
procedure SortByPiece(AList: TStringList; ADelim: Char; PieceNum: Integer);
procedure StripPieceIfContains(ADelim: Char; StrToFind: string; var AString, DestStr: widestring);
function padr(s: string; n: integer): string;

{ Display functions }
//procedure ClearControl(AControl: TControl);
function InfoBox(const Text, Caption: string; Flags: Word): Integer;
procedure LimitEditWidth(AControl: TWinControl; NumChars: Integer);
function MainFontSize: Integer;
function MainFontWidth: Integer;
function MainFontHeight: Integer;
procedure RedrawSuspend(AHandle: HWnd);
procedure RedrawActivate(AHandle: HWnd);
//procedure ResetControl(AControl: TControl);
procedure ResetSelectedForList(AListBox: TListBox);
procedure ResizeFormToFont(var AForm: TForm);
procedure ResizeToFont(FontSize: Integer; var W, H: Integer);
procedure StatusText(const S: string);
function ShowMsgOn(AnExpression: Boolean; const AMsg, ACaption: string): Boolean;
function TextWidthByFont(AFontHandle: THandle; const x: string): Integer;
function PopupComponent(Sender: TObject; PopupMenu: TPopupMenu): TComponent;

{ ListBox Grid functions }
procedure ListGridDrawCell(AListBox: TListBox; AHeader: THeaderControl; ARow, AColumn: Integer;
  const x: string; WordWrap: Boolean);
procedure ListGridDrawLines(AListBox: TListBox; AHeader: THeaderControl; Index: Integer;
  State: TOwnerDrawState);
function ListGridRowHeight(AListBox: TListBox; AHeader: THeaderControl; ARow, AColumn: Integer;
  const x: string): Integer;

function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  HelpCtx: Longint; const aCaption: string = ''): Integer;

function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;

function ForceForegroundWindow(hwnd: THandle): Boolean;

function GetComputer: string;
function IconToBitmap (Icon: TIcon): TBitmap;

function StripString(StringIn: string; DisplayMsg: Boolean = True): string;
{Strips out characters that cause errors on the M side when filing the data}

function LaunchApplication(FullAppPath: String): Boolean;

implementation // ---------------------------------------------------------------------------

const
  { names of months used by FormatFMDateTime }
  MONTH_NAMES_SHORT: array[1..12] of string[3] =
  ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  MONTH_NAMES_LONG: array[1..12] of string[9] =
  ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December');

  { table for calculating CRC values (DWORD is Integer in Delphi 3, Cardinal in Delphi 4}
  CRC32_TABLE: array[0..255] of DWORD =
  ($0, $77073096, $EE0E612C, $990951BA, $76DC419, $706AF48F, $E963A535, $9E6495A3,
    $EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $9B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $1DB7106, $98D220BC, $EFD5102A, $71B18589, $6B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $86D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $3B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $4DB2615, $73DC1683,
    $E3630B12, $94643B84, $D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $26D930A, $9C0906A9, $EB0E363F, $72076785, $5005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7, $BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);


type
  EFMDateTimeError = class(Exception);

  { Date/Time functions }

function DateTimeToFMDateTime(ADateTime: TDateTime): TFMDateTime;
{ converts a Delphi date/time type to a Fileman date/time (type double) }
var
  y, m, d, h, n, s, l: Word;
  DatePart, TimePart: Integer;
begin
  DecodeDate(ADateTime, y, m, d);
  DecodeTime(ADateTime, h, n, s, l);
  DatePart := ((y - 1700) * 10000) + (m * 100) + d;
  TimePart := (h * 10000) + (n * 100) + s;
  Result := DatePart + (TimePart / 1000000);
end;

function FMDateTimeToDateTime(ADateTime: TFMDateTime): TDateTime;
{ converts a Fileman date/time (type double) to a Delphi date/time }
var
  ADate, ATime: TDateTime;
  DatePart, TimePart: string;
begin
  DatePart := Piece(FloatToStrF(ADateTime, ffFixed, 14, 6), '.', 1);
  TimePart := Piece(FloatToStrF(ADateTime, ffFixed, 14, 6), '.', 2) + '000000';
  if Length(DatePart) <> 7 then raise EFMDateTimeError.Create('Invalid Fileman Date');
  if Copy(TimePart, 1, 2) = '24' then TimePart := '23595959';
  ADate := EncodeDate(StrToInt(Copy(DatePart, 1, 3)) + 1700,
    StrToInt(Copy(DatePart, 4, 2)),
    StrToInt(Copy(DatePart, 6, 2)));
  ATime := EncodeTime(StrToInt(Copy(TimePart, 1, 2)),
    StrToInt(Copy(TimePart, 3, 2)),
    StrToInt(Copy(TimePart, 5, 2)), 0);
  Result := ADate + ATime;
end;

function FMDateTimeOffsetBy(ADateTime: TFMDateTime; DaysDiff: Integer): TFMDateTime;
{ adds / subtracts days from a Fileman date/time and returns the offset Fileman date/time }
var
  Julian: TDateTime;
begin
  Julian := FMDateTimeToDateTime(ADateTime);
  Result := DateTimeToFMDateTime(Julian + DaysDiff);
end;

function FormatFMDateTime(AFormat: string; ADateTime: TFMDateTime): string;
{ formats a Fileman Date/Time using (mostly) the same format string as Delphi FormatDateTime }
var
  x: string;
  y, m, d, h, n, s: Integer;

  function TrimFormatCount: Integer;
    { delete repeating characters and count how many were deleted }
  var
    c: Char;
  begin
    Result := 0;
    c := AFormat[1];
    repeat
      Delete(AFormat, 1, 1);
      Inc(Result);
    until CharAt(AFormat, 1) <> c;
  end;

begin {FormatFMDateTime}
  Result := '';
  if not (ADateTime > 0) then Exit;
  x := FloatToStrF(ADateTime, ffFixed, 15, 6) + '0000000';
  y := StrToIntDef(Copy(x, 1, 3), 0) + 1700;
  m := StrToIntDef(Copy(x, 4, 2), 0);
  d := StrToIntDef(Copy(x, 6, 2), 0);
  h := StrToIntDef(Copy(x, 9, 2), 0);
  n := StrToIntDef(Copy(x, 11, 2), 0);
  s := StrToIntDef(Copy(x, 13, 2), 0);
  while Length(AFormat) > 0 do
    case UpCase(AFormat[1]) of
      '"':
        begin // literal
          Delete(AFormat, 1, 1);
          while not (CharInSet(CharAt(AFormat, 1), [#0, '"'])) do
          begin
            Result := Result + AFormat[1];
            Delete(AFormat, 1, 1);
          end;
          if CharAt(AFormat, 1) = '"' then Delete(AFormat, 1, 1);
        end;
      'D': case TrimFormatCount of // day/date
          //1: if d > 0 then Result := Result + IntToStr(d);
          //2: if d > 0 then Result := Result + FormatFloat('00', d);
          1: if d >= 0 then Result := Result + FormatFloat('0', d);
          2: if d >= 0 then Result := Result + FormatFloat('00', d);
          //jcs 11/23 modified the above code to display zero(s) if we
          //don't have a valid day/date (which is possible), this is to match the display in
          //the pharmacy package
        end;
      'H': case TrimFormatCount of // hour
          1: Result := Result + IntToStr(h);
          2: Result := Result + FormatFloat('00', h);
        end;
      'M': case TrimFormatCount of // month
          //1: if m > 0 then Result := Result + IntToStr(m);
          //2: if m > 0 then Result := Result + FormatFloat('00', m);
          1: if m >= 0 then Result := Result + FormatFloat('0', m);
          2: if m >= 0 then Result := Result + FormatFloat('00', m);
          //jcs 11/23 modified the above code to display zero(s) if we
          //don't have a valid month (which is possible), this is to match the display in
          //the pharmacy package
          3: //if m in [1..12] then Result := Result + MONTH_NAMES_SHORT[m];
            begin
              if m in [1..12] then Result := Result + String(MONTH_NAMES_SHORT[m]);
              if m = 0 then Result := Result + '???';
            end;
          //jcs 11/23 modified above code to display ??? if we have a null
          //month, which is possible

          4: if m in [1..12] then Result := Result + String(MONTH_NAMES_LONG[m]);
        end;
      'N': case TrimFormatCount of // minute
          1: Result := Result + IntToStr(n);
          2: Result := Result + FormatFloat('00', n);
        end;
      'S': case TrimFormatCount of // second
          1: Result := Result + IntToStr(s);
          2: Result := Result + FormatFloat('00', s);
        end;
      'Y': case TrimFormatCount of // year
          2: if y > 0 then Result := Result + Copy(IntToStr(y), 3, 2);
          4: if y > 0 then Result := Result + IntToStr(y);
        end;
    else
      begin // other
        Result := Result + AFormat[1];
        Delete(AFormat, 1, 1);
      end;
    end; {case}
end; {FormatFMDateTime}

function FormatFMDateTimeStr(const AFormat, ADateTime: string): string;
var
  FMDateTime: TFMDateTime;
begin
  Result := ADateTime;
  if IsFMDateTime(ADateTime) then
  begin
    FMDateTime := MakeFMDateTime(ADateTime);
    Result := FormatFMDateTime(AFormat, FMDateTime);
  end;
end;

function IsFMDateTime(x: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Length(x) < 7 then Exit;
  for i := 1 to 7 do if not (CharInset(x[i], ['0'..'9'])) then Exit;
  if (Length(x) > 7) and (x[8] <> '.') then Exit;
  if (Length(x) > 8) and not (CharInSet(x[9], ['0'..'9'])) then Exit;
  Result := True;
end;

function MakeFMDateTime(const AString: string): TFMDateTime;
begin
  Result := -1;
  if (Length(AString) > 0) and IsFMDateTime(AString) then Result := StrToFloat(AString);
end;

procedure SetListFMDateTime(AFormat: string; AList: TStringList; ADelim: Char; PieceNum: Integer);
var
  i: Integer;
  s, x: string;
begin
  for i := 0 to AList.Count - 1 do
  begin
    s := AList[i];
    x := Piece(s, ADelim, PieceNum);
    if Length(x) > 0 then x := FormatFMDateTime(AFormat, MakeFMDateTime(x));
    SetPiece(s, ADelim, PieceNum, x);
    AList[i] := s;
  end;
end;

{ Numeric functions }

function HigherOf(i, j: Integer): Integer;
{ returns the greater of two integers }
begin
  Result := i;
  if j > i then Result := j;
end;

function LowerOf(i, j: Integer): Integer;
{ returns the lesser of two integers }
begin
  Result := i;
  if j < i then Result := j;
end;

{ String functions }

function CharAt(const x: string; APos: Integer): Char;
{ returns a character at a given position in a string or the null character if past the end }
begin
  if Length(x) < APos then Result := #0 else Result := x[APos];
end;

function ContainsAlpha(const x: string): Boolean;
{ returns true if the string contains any alpha characters }
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(x) do if CharInSet(x[i], ['A'..'Z', 'a'..'z']) then
    begin
      Result := True;
      break;
    end;
end;

function ContainsVisibleChar(const x: string): Boolean;
{ returns true if the string contains any printable characters }
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(x) do if CharInSet(x[i], ['!'..'~']) then // ordinal values 33..126
    begin
      Result := True;
      break;
    end;
end;

function UpdateCrc32(Value: DWORD; var Buffer: array of Byte; Count: Integer): DWORD;
var
  i: integer;
begin
  Result := Value;
  for i := 0 to Pred(Count) do
    Result := ((Result shr 8) and $00FFFFFF) xor
      CRC32_TABLE[(Result xor Buffer[i]) and $000000FF];
end;

function CRCForFile(AFileName: string): DWORD;
const
  BUF_SIZE = 16383;
type
  TBuffer = array[0..BUF_SIZE] of Byte;
var
  Buffer: Pointer;
  AHandle, BytesRead: Integer;
begin
  Result := $FFFFFFFF;
  GetMem(Buffer, BUF_SIZE);
  AHandle := FileOpen(AFileName, fmShareDenyWrite);
  repeat
    BytesRead := FileRead(AHandle, Buffer^, BUF_SIZE);
    Result := UpdateCrc32(Result, TBuffer(Buffer^), BytesRead);
  until BytesRead <> BUF_SIZE;
  FileClose(AHandle);
  FreeMem(Buffer);
  Result := not Result;
end;

function CRCForStrings(AStringList: TStrings): DWORD;
{ returns a cyclic redundancy check for a list of strings }
var
  i, j: Integer;
begin
  Result := $FFFFFFFF;
  for i := 0 to AStringList.Count - 1 do
    for j := 1 to Length(AStringList[i]) do
      Result := ((Result shr 8) and $00FFFFFF) xor
        CRC32_TABLE[(Result xor Ord(AStringList[i][j])) and $000000FF];
end;

procedure ExpandTabsFilter(AList: TStrings; ATabWidth: Integer);
var
  i, j, k: Integer;
  x, y: string;
  xc: AnsiChar;
begin
  with AList do for i := 0 to Count - 1 do
  begin
    x := Strings[i];
    y := '';
    for j := 1 to Length(x) do
    begin
      xc := AnsiChar(x[j]);
      case xc of
                #9: for k := 1 to (ATabWidth - (Length(y) mod ATabWidth)) do y := y + ' ';
         #32..#127: y := y + x[j];
        #128..#159: y := y + '?';
              #160: y := y + ' ';
        #161..#255: y := y + x[j];
      end;
    end;
    if Copy(y, Length(y), 1) = ' ' then y := TrimRight(y) + ' ';
    Strings[i] := y;
    //Strings[i] := TrimRight(y) + ' ';
  end;
end;

function ExtractInteger(x: string): Integer;
{ strips leading & trailing alphas to return an integer }
var
  i: Integer;
begin
  while (Length(x) > 0) and not (CharInSet(x[1], ['0'..'9'])) do Delete(x, 1, 1);
  for i := 1 to Length(x) do if not (CharInSet(x[i], ['0'..'9'])) then break;
  Result := StrToIntDef(Copy(x, 1, i - 1), 0);
end;

function ExtractDefault(Src: TStrings; const Section: string): string;
var
  i: Integer;
begin
  Result := '';
  i := -1;
  repeat Inc(i)until (i = Src.Count) or (Src[i] = '~' + Section);
  Inc(i);
  if (i < Src.Count) and (Src[i][1] <> '~') then repeat
      if Src[i][1] = 'd' then Result := Copy(Src[i], 2, 255);
      Inc(i);
    until (i = Src.Count) or (Src[i][1] = '~') or (Length(Result) > 0);
end;

procedure ExtractItems(Dest, Src: TStrings; const Section: string);
var
  i: Integer;
begin
  i := -1;
  repeat Inc(i)until (i = Src.Count) or (Src[i] = '~' + Section);
  Inc(i);
  if (i < Src.Count) and (Src[i][1] <> '~') then repeat
      if Src[i][1] = 'i' then Dest.Add(Copy(Src[i], 2, 255));
      Inc(i);
    until (i = Src.Count) or (Src[i][1] = '~');
end;

procedure ExtractText(Dest, Src: TStrings; const Section: string);
var
  i: Integer;
begin
  i := -1;
  repeat Inc(i)until (i = Src.Count) or (Src[i] = '~' + Section);
  Inc(i);
  if (i < Src.Count) and (Src[i][1] <> '~') then repeat
      if Src[i][1] = 't' then Dest.Add(Copy(Src[i], 2, 255));
      Inc(i);
    until (i = Src.Count) or (Src[i][1] = '~');
end;

procedure InvertStringList(AList: TStringList);
var
  i: Integer;
begin
  with AList do for i := 0 to ((Count div 2) - 1) do Exchange(i, Count - i - 1);
end;

function MixedCase(const x: string): string;
var
  i: integer;
begin
  Result := x;
  for i := 2 to Length(x) do
    if (not (CharInSet(x[i - 1], [' ', '''', ',', '-', '.', '/', '^']))) and (CharInSet(x[i], ['A'..'Z'])) then Result[i] := Chr(Ord(x[i]) + 32);
end;

procedure MixedCaseList(AList: TStrings);
var
  i: integer;
begin
  for i := 0 to (AList.Count - 1) do AList[i] := MixedCase(AList[i]);
end;

procedure MixedCaseByPiece(AList: TStrings; ADelim: Char; PieceNum: Integer);
var
  i: Integer;
  x, p: string;
begin
  for i := 0 to (AList.Count - 1) do
  begin
    x := AList[i];
    p := MixedCase(Piece(x, ADelim, PieceNum));
    SetPiece(x, ADelim, PieceNum, p);
    AList[i] := x;
  end;
end;

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns the Nth piece (PieceNum) of a string delimited by Delim }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
end;

function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;
{ returns several contiguous pieces }
var
  PieceNum: Integer;
begin
  Result := '';
  for PieceNum := FirstNum to LastNum do Result := Result + Piece(S, Delim, PieceNum) + Delim;
  if Length(Result) > 0 then Delete(Result, Length(Result), 1);
end;

procedure PiecesToList(x: string; ADelim: Char; AList: TStrings);
{ adds each piece to a TStrings list, the list is cleared first }
var
  APiece: string;
begin
  AList.Clear;
  while Length(x) > 0 do
  begin
    APiece := Piece(x, ADelim, 1);
    AList.Add(APiece);
    Delete(x, 1, Length(APiece) + 1);
  end;
end;

function ReverseStr(const x: string): string;
var
  i, j: Integer;
begin
  SetString(Result, PChar(x), Length(x));
  i := 0;
  for j := Length(x) downto 1 do
  begin
    Inc(i);
    Result[i] := x[j];
  end;
end;

procedure SetPiece(var x: string; Delim: Char; PieceNum: Integer; const NewPiece: string);
{ sets the Nth piece (PieceNum) of a string to NewPiece, adding delimiters as necessary }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(x);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then x := x + StringOfChar(Delim, PieceNum - i) + NewPiece
  else x := Copy(x, 1, Strt - PChar(x)) + NewPiece + StrPas(Next);
end;

procedure SortByPiece(AList: TStringList; ADelim: Char; PieceNum: Integer);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    AList[i] := Piece(AList[i], ADelim, PieceNum) + ADelim + AList[i];
  AList.Sort;
  for i := 0 to AList.Count - 1 do
    AList[i] := Copy(AList[i], Pos(ADelim, AList[i]) + 1, 255);
end;

procedure LimitStringLength(var AList: TStringList; MaxLength: Integer);
{ change a TStringList so that all strings in the list are shorter than MaxLength }
var
  i, SpacePos: Integer;
  x: string;
  NewList: TStringList;
begin
  NewList := TStringList.Create;
  try
    for i := 0 to AList.Count - 1 do
    begin
      if Length(AList[i]) > MaxLength then
      begin
        x := AList[i];
        while Length(x) > MaxLength do
        begin
          SpacePos := MaxLength;
          //          while SpacePos > 0 do                                              {**REV**}  removed after v11b
          //            if (x[SpacePos] <> ' ') then Dec(SpacePos);                      {**REV**}  removed after v11b
          while (x[SpacePos] <> ' ') and (SpacePos > 1) do Dec(SpacePos); {**REV**} {changed 0 to 1}
          if SpacePos = 1 then SpacePos := MaxLength; {**REV**} {changed 0 to 1}
          NewList.Add(Copy(x, 1, SpacePos - 1));
          Delete(x, 1, SpacePos);
        end; {while Length(x)}
        if Length(x) > 0 then NewList.Add(x);
      end {then}
      else NewList.Add(AList[i]);
    end; {for i}
    AList.Clear;
    AList.Assign(NewList);
  finally
    NewList.Free;
  end;
end;

{ Display functions }

(*
procedure ClearControl(AControl: TControl);
{ clears a control, removes text and listbox items }
begin
  if AControl is TLabel then with TLabel(AControl) do Caption := ''
  else if AControl is TButton then with TButton(AControl) do Caption := ''
  else if AControl is TEdit then with TEdit(AControl) do Text := ''
  else if AControl is TMemo then with TMemo(AControl) do Clear
  else if AControl is TListBox then with TListBox(AControl) do Clear
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    Items.Clear;
    Text := '';
  end
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    Clear;
    Text := '';
  end;
end;

procedure ResetControl(AControl: TControl);
{ clears text, deselects items, does not remove listbox or combobox items }
begin
  if AControl is TLabel then with TLabel(AControl) do Caption := ''
  else if AControl is TButton then with TButton(AControl) do Caption := ''
  else if AControl is TEdit then with TEdit(AControl) do Text := ''
  else if AControl is TMemo then with TMemo(AControl) do Clear
  else if AControl is TListBox then with TListBox(AControl) do ItemIndex := -1
  else if AControl is TORComboBox then with TORComboBox(AControl) do
  begin
    Text := '';
    ItemIndex := -1;
  end
  else if AControl is TComboBox then with TComboBox(AControl) do
  begin
    Text := '';
    ItemIndex := -1;
  end;
end;
*)

function InfoBox(const Text, Caption: string; Flags: Word): Integer;
{ wrap the messagebox object in case we want to modify it later }
begin
  Result := Application.MessageBox(PChar(Text), PChar(Caption), Flags or MB_TOPMOST);
end;

procedure LimitEditWidth(AControl: TWinControl; NumChars: Integer);
{ limits the editing area to be no more than N characters (also sets small left margin) }
const
  LEFT_MARGIN = 4;
var
  ARect: TRect;
  AHandle: DWORD;
  AWidth, i: Integer;
  x: string;
begin
  Inc(NumChars);
  SetString(x, nil, NumChars);
  for i := 1 to NumChars do x[i] := 'X';
  with AControl do
  begin
    AHandle := 0;
    if AControl is TEdit then AHandle := TEdit(AControl).Font.Handle;
    if AControl is TMemo then AHandle := TMemo(AControl).Font.Handle;
    if AControl is TRichEdit then AHandle := TRichEdit(AControl).Font.Handle;
    if AHandle = 0 then Exit;
    AWidth := TextWidthByFont(AHandle, x);
    ARect := Rect(LEFT_MARGIN, 0, LowerOf(ClientWidth, AWidth + LEFT_MARGIN), ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@ARect));
  end;
end;

function MainFontSize: Integer;
{ return font size of the Main Form in the application }
begin
  if Application.MainForm <> nil then Result := Application.MainForm.Font.Size
  else Result := 8;
end;

function MainFontWidth: Integer;
{ hard code to MS Sans Serif since that's the only one allowed for now - can fix later }
begin
  case MainFontSize of
    8: Result := 6;
    10: Result := 7;
    12: Result := 9;
    14: Result := 10;
    18: Result := 13;
  else Result := 6;
  end;
end;

function MainFontHeight: Integer;
{ hard code to MS Sans Serif since that's the only one allowed for now - can fix later }
begin
  case MainFontSize of
    8: Result := 13;
    10: Result := 16;
    12: Result := 20;
    14: Result := 24;
    18: Result := 29;
  else Result := 13;
  end;
end;

procedure RedrawSuspend(AHandle: HWnd);
begin
  SendMessage(AHandle, WM_SETREDRAW, 0, 0);
end;

procedure RedrawActivate(AHandle: HWnd);
begin
  SendMessage(AHandle, WM_SETREDRAW, 1, 0);
  InvalidateRect(AHandle, nil, True);
end;

procedure ResetSelectedForList(AListBox: TListBox);
var
  i: Integer;
begin
  with AListBox do for i := 0 to Items.Count - 1 do Selected[i] := False;
end;

procedure ResizeToFont(FontSize: Integer; var W, H: Integer);
{ resizes form relative to the font size, assumes form designed with >MS Sans Serif 8pt< }
begin
  case FontSize of
    8: { no need to change, 8pt is the designed size };
    10:
      begin
        W := Round(W * (7 / 6) + 1);
        H := Round(H * (16 / 13) + 1);
      end;
    12:
      begin
        W := Round(W * (9 / 6) + 1);
        H := Round(H * (20 / 13) + 1);
      end;
    14:
      begin
        W := Round(W * (10 / 6) + 1);
        H := Round(H * (24 / 13) + 1);
      end;
    18:
      begin
        W := Round(W * (13 / 6) + 1);
        H := Round(H * (29 / 13) + 1);
      end;
  end;
end;

procedure ResizeFormToFont(var AForm: TForm);
var
  FontSize, W, H: Integer;
begin
  if Application.MainForm <> nil then FontSize := Application.MainForm.Font.Size
  else FontSize := 8;
  AForm.Font.Size := FontSize;
  W := AForm.ClientWidth;
  H := AForm.ClientHeight;
  case FontSize of
    8: { no need to change, 8pt is the designed size };
    10:
      begin
        W := Round(W * (7 / 6) + 1);
        H := Round(H * (16 / 13) + 1);
      end;
    12:
      begin
        W := Round(W * (9 / 6) + 1);
        H := Round(H * (20 / 13) + 1);
      end;
    14:
      begin
        W := Round(W * (10 / 6) + 1);
        H := Round(H * (24 / 13) + 1);
      end;
    18:
      begin
        W := Round(W * (13 / 6) + 1);
        H := Round(H * (29 / 13) + 1);
      end;
  end;
  AForm.ClientWidth := W;
  AForm.ClientHeight := H;
end;

procedure StatusText(const S: string);
{ sends a user defined message to the main window of an application to display the text
  found in lParam.  Only useful if the main window has message event for this message }
begin
  SendMessage(Application.MainForm.Handle, UM_STATUSTEXT, 0, Integer(PChar(S)));
end;

function ShowMsgOn(AnExpression: Boolean; const AMsg, ACaption: string): Boolean;
begin
  Result := AnExpression;
  if Result then InfoBox(AMsg, ACaption, MB_OK);
end;

function TextWidthByFont(AFontHandle: THandle; const x: string): Integer;
{ returns the width of a string in pixels, given a FONT handle and string }
var
  DC: HDC;
  SaveFont: HFont;
  TextSize: TSize;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, AFontHandle);
  GetTextExtentPoint32(DC, PChar(x), Length(x), TextSize);
  Result := TextSize.cx;
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

function PopupComponent(Sender: TObject; PopupMenu: TPopupMenu): TComponent;
begin
  if (assigned(PopupMenu) and assigned(Sender) and (Sender is TPopupMenu) and
    assigned(PopupMenu.PopupComponent)) then
    Result := PopupMenu.PopupComponent
  else
    Result := Screen.ActiveControl;
end;
{ ListBox Grid functions }

procedure ListGridDrawCell(AListBox: TListBox; AHeader: THeaderControl; ARow, AColumn: Integer;
  const x: string; WordWrap: Boolean);
var
  i, Format: Integer;
  ARect: TRect;
begin
  ARect := AListBox.ItemRect(ARow);
  ARect.Left := 0;
  for i := 0 to AColumn - 1 do ARect.Left := ARect.Left + AHeader.Sections[i].Width;
  Inc(ARect.Left, 2);
  ARect.Right := ARect.Left + AHeader.Sections[AColumn].Width - 6;
  if WordWrap then Format := (DT_LEFT or DT_NOPREFIX or DT_WORDBREAK)
  else Format := (DT_LEFT or DT_NOPREFIX);
  DrawText(AListBox.Canvas.Handle, PChar(x), Length(x), ARect, Format);
end;

procedure ListGridDrawLines(AListBox: TListBox; AHeader: THeaderControl; Index: Integer;
  State: TOwnerDrawState);
var
  i, RightSide: Integer;
  ARect: TRect;
begin
  with AListBox do
  begin
    ARect := ItemRect(Index);
    if odSelected in State then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := clSilver;
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    RightSide := -2;
    for i := 0 to AHeader.Sections.Count - 1 do
    begin
      RightSide := RightSide + AHeader.Sections[i].Width;
      Canvas.MoveTo(RightSide, ARect.Bottom - 1);
      Canvas.LineTo(RightSide, ARect.Top);
    end;
  end;
end;

function ListGridRowHeight(AListBox: TListBox; AHeader: THeaderControl; ARow, AColumn: Integer;
  const x: string): Integer;
var
  ARect: TRect;
begin
  ARect := AListBox.ItemRect(ARow);
  ARect.Right := AHeader.Sections[AColumn].Width - 6;
  Result := DrawText(AListBox.Canvas.Handle, PChar(x), Length(x), ARect,
    DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_WORDBREAK) + 2;
end;

(*
procedure SetEditWidth(AMemo: TMemo; AWidth: Integer);
begin
  //SetString(x, nil, AWidth);
  //for i := 1 to AWidth do x[i] := 'X';
end;
*)

procedure StripPieceIfContains(ADelim: Char; StrToFind: string; var AString, DestStr: widestring);
var
  APiece: string;
begin
  while Length(AString) > 0 do
  begin
    APiece := Piece(AString, ADelim, 1);
    if Pos(StrToFind, APiece) = 0 then
    begin
      if Length(DestStr) > 0 then
        DestStr := DestStr + '^' + APiece
      else DestStr := APiece;
    end;
    Delete(AString, 1, Length(APiece) + 1);
  end;
end;

function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  HelpCtx: Longint; const aCaption: string = ''): Integer;
var
  Dlg: TForm;
  i: integer;
  btn: TButton;
  zPnl: TPanel;
  newMsg: string;
begin

  newMsg := StringReplace(Msg, '&', '&&', [rfReplaceAll]);

  if newMsg = '' then newMsg := 'Error: A blank message was sent to display in this pop-up. ' + #13 +
    'Please report the steps taken prior to the display of this message to your BCMA Coordinator or IRM staff.';

  Dlg := CreateMessageDialog(newMsg, DlgType, Buttons);

  //This will cover that hopefully rare scenario that the message box receives so
  //much text that is tries to expand right off the screen.
  with Dlg do
    if Height > Screen.WorkAreaHeight then
    begin
      AutoScroll := True;
      Top := Screen.WorkAreaTop;
      Height := Screen.WorkAreaHeight;
      Width := TLabel(FindComponent('Message')).Width +
        TImage(FindComponent('Image')).Width + 60;
    end;

  if aCaption = '' then
    case DlgType of
      mtWarning:
        Dlg.Caption := 'Warning';
      mtError:
        Dlg.Caption := 'Error';
      mtInformation:
        Dlg.Caption := 'Information';
      mtConfirmation:
        Dlg.Caption := 'Confirmation';
    end
  else
    Dlg.Caption := aCaption;

  TButton(Dlg.FindComponent('OK')).Caption := '&OK';
  for i := 0 to Dlg.ComponentCount - 1 do
    if Dlg.Components[i] is TButton then
    begin
      btn := TButton(Dlg.Components[i]);
      btn.default := false;
    end;

  zPnl := TPanel.Create(Application);
  with zPnl do
  begin
    Caption := msg;
    Left := -5;
    Parent := Dlg;
    Height := 1;
    Width := 1;
  end;

  dlg.ActiveControl := zPnl;
  Result := Dlg.ShowModal;
end;

function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;
var
  j: integer;
  Stat2: set of (sWinVisForm, sWinVisApp, sIconized);
  hFGWnd: THandle;
begin
  Stat2 := []; {sWinVisForm,sWinVisApp,sIconized}

  if IsWindowVisible(anApplication.MainForm.Handle) then Stat2 := Stat2 + [sWinVisForm];

  if IsWindowVisible(anApplication.Handle) then Stat2 := Stat2 + [sWinVisApp];

  if IsIconic(anApplication.Handle) then Stat2 := Stat2 + [sIconized];

  Result := true;
  if sIconized in Stat2 then
  begin {A}
    j := SendMessage(anApplication.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
    Result := j <> 0;
  end;
  if Stat2 * [sWinVisForm, sIconized] = [] then
  begin {S}
    anApplication.MainForm.Show;
  end;
  if (Stat2 * [sWinVisForm, sIconized] <> []) or
    (sWinVisApp in Stat2) then
  begin {G}
    hFGWnd := GetForegroundWindow;
    try
      AttachThreadInput(
        GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, True);
      Result := SetForegroundWindow(anApplication.Handle);
    finally
      AttachThreadInput(
        GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, False);
    end;
  end;
end;

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID :=
        GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0,
          TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

function GetComputer: string;
var
  Size: cardinal;
  CN: array[0..MAX_PATH] of char;
begin
  Size := MAX_PATH;
  GetComputerName(CN, Size);
  Result := StrPas(CN);
end;

function StripString(StringIn: string; DisplayMsg: Boolean = True): string;
var
  msg: string;
  x: integer;
begin
  StringIn := Trim(StringIn);
  Result := StringIn;

  while Pos('?', Result) = 1 do
    Result := StringReplace(Result, '?', '', []);
  Result := StringReplace(Result, '^', ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '|', ' ', [rfReplaceAll]);
  Result := TrimLeft(Result);

  for x := 1 to length(Result) do
    if  (ord(Result[x]) > 126) or (ord(Result[x]) < 32) then
      Result := StuffString(Result, x, 1, ' ');

  if (Result <> StringIn) and DisplayMsg then
  begin
    Msg := 'An invalid character was detected in the text entered.' + #13#13;
    Msg := Msg + 'Text can not start with a question Mark.' + #13;
    MSG := Msg + 'Text can not contain the "^" or "|" character.' + #13#13;
    MSG := Msg + 'Text can not contain non-printable characters.' + #13#13;
    Msg := Msg + 'The invalid character(s) will be removed from the text.';
    DefMessageDlg(Msg, mtInformation, [mbOK], 0);
  end;
end;

function padr(s: string; n: integer): string;
{Pads a string to the right with spaces up to length n.  If the string is greater then n, then
truncates and concatenates a elipsis.}
var
  Len: integer;
begin
  Result := s;
  Len := Length(s);
  if Len < n then
  begin
    SetLength(Result, n);
    FillChar(Result[Len + 1], n - Len, ' ');
  end;
  if Len > n then
  begin
    Result := LeftStr(Result, n - 3);
    Result := Result + '...';
  end;
end;

function IconToBitmap (Icon: TIcon): TBitmap;
begin
  Result:= TBitmap.Create;
  try
    with Result do begin
      Width:= Icon.Width;
      Height:= Icon.Height;
      Transparent := True;
      //TransparentColor := Result.canvas.pixels[0,0];
      with Canvas do begin
        FillRect(Rect(0,0,Width,Height));
        Draw(0,0,Icon);
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;
function LaunchApplication(FullAppPath: String): Boolean;
var
  x, AFile, Param: string;
begin
  Result := false;

  x := FullAppPath;
  if CharAt(x, 1) = '"' then
  begin
    x     := Copy(x, 2, Length(x));
    AFile := Copy(x, 1, Pos('"',x)-1);
    Param := Copy(x, Pos('"',x)+1, Length(x));
  end else
  begin
    AFile := Piece(x, ' ', 1);
    Param := Copy(x, Length(AFile)+1, Length(x));
  end;

  if ShellExecute(Application.ActiveFormHandle, 'OPEN', PChar(AFile), PChar(Param), '', 1) > 32 then
      Result := True
  else
      DefMessageDlg('An error occured launching:' + #13 + #13 +
      FullAppPath, mtInformation, [mbOK], 0);
end;
end.


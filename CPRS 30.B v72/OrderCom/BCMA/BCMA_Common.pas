unit BCMA_Common;
{
================================================================================
*	File:  BCMA_Common.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 56 $  $Modtime: 5/06/02 10:35a $
*
*	Description:  This unit contains global constants, variables, objects and
*               methods for the application.
*
*
================================================================================
}

interface

uses
  SysUtils,
  Classes,
  Graphics,
  Forms,
  comctrls,
  BCMA_Objects,
  Windows,
  messages,
  Dialogs,
  Registry,
  //uCCOW,
  ExtCtrls;
  //oReport;

const
  DTFORMAT = 'YYYYMMDD.HHNN';
  CCOWErrorMessage = 'BCMA was unable to communicate with the CCOW due to an error.  CCOW patient' +
    ' synchronization will be unavailable for the remainder of this session.';

  KeyBoardTimerInterval = 250;

  ReportCaptions: array[TReportTypes] of string = ('Patient Due List',
    'Patient Medication Log',
    'Medication Admin History',
    'Patient Ward Administration Times',
    'Patient Missed Medications',
    'PRN Effectiveness List',
    'Medication Variance Log',
    'Vitals Cumulative',
    'Medication History',
    'Unknown Actions',
    'BCMA Unable to Scan (Detailed)',
    'BCMA Unable to Scan (Summary)',

    'Medication Overview',
    'PRN Overview',
    'IV Overview',
    'Expired/DC''d/Expiring Orders',
    'Medication Therapy',
    'IV Bag Status',

    'Patient Inquiry',
    'Patient Allergy List',
    'BCMA - Display Order',
    'Patient Flags');

  ReportTypeCodes: array[TReportTypes] of string = ('DL',
    'ML',
    'MH',
    'WA',
    'MM',
    'PE',
    'MV',
    'VT',
    'PM',
    'XA',
    'SF',
    'ST',

    'CM',
    'CP',
    'CI',
    'CE',
    'MT',
    'IV',


    'PI',
    'AL',
    'DO',
    'PF');

  ScanStatusCodes: array[TScanStatus] of string = ('I',
    'S',
    'C',
    'H',
    'R',
    'M',
    'RM',
    'A',
    'N',
    'G',
    'U');

  ScanStatusText: array[TScanStatus] of string = ('Infusing',
    'Stopped',
    'Completed',
    'Held',
    'Refused',
    'Missing',
    'Removed',
    'Available',
    'Not Given',
    'Given',
    '*Unknown*');

  VDLColumnTitles: array[TVDLColumnTypes] of string =
  ('Status', 'Ver', 'Hsm', 'Type', 'Active Medication',
    'Dosage', 'Route', 'Admin Time', 'Last Action'
    //											, 'Special Instructions'
    );

  VDLColumnWidths: array[TVDLColumnTypes] of integer =
  (40, 28, 33, 35, 245,
    120, 50, 70, 160
    //											, 999
    );
  sgMOColumnTitles: array[sgMOColumnTypes] of string =
  ('Type', 'Active Medication', 'Dosage', 'Schedule', 'Route',
    'Admin Time', 'Last Action', 'Start D/T');

  sgMoColumnWidths: array[sgMOColumnTypes] of integer =
  (35, 240, 50, 70, 40, 70, 70, 70);

  lstPBColumnTitles: array[lstPBColumnTypes] of string =
  ('Status', 'Ver', 'Type', 'Medication/Solutions', 'Infusion Rate', 'Route',
    'Admin Time', 'Last Action');

  lstPBColumnWidths: array[lstPBColumnTypes] of integer =
  (40, 35, 30, 240, 150, 60, 70, 160);

  lstIVColumnTitles: array[lstIVColumnTypes] of string =
  ('Status', 'Ver', 'Type', 'Medication/Solutions', 'Infusion Rate', 'Route',
    'Bag Information');

  lstIVColumnWidths: array[lstIVColumnTypes] of integer =
  (50, 35, 60, 240, 140, 70, 170);

  lstBagDetailColumnTitles: array[lstBagDetailColumnTypes] of string =
  ('Date/Time', 'Nurse', 'Action', 'Comments');

  lstBagDetailColumnWidths: array[lstBagDetailColumnTypes] of integer =
  (105, 50, 60, 225);

  //Converts columns to tag values for linking the Sort BY column menu options
  //to the actual column on the VDL
  lstValidUDSortColumns: array[TVDLColumnTypes] of integer =
  (0, 1, 2, 3, 4, 5, 6, 7, 8);

  lstValidPBSortColumns: array[lstPBColumnTypes] of integer =
  (0, 1, 3, 9, 10, 6, 7, 8);

  lstValidIVSortColumns: array[lstIVColumnTypes] of integer =
  (0, 1, 3, 9, 10, 6, 11);

  CloseableForms: array[0..7] of string = ('frmPtSelect', 'frmReport', 'frmReportRequest', 'frmPrint',
    'frmPtConfirmation', 'frmEditMedLogAdminSelect', 'frmInstructor', 'frmScanWristband');
  CloseableFormsByCaption: array[0..0] of string = (
    'Patient Lookup');
  IconArray: array [0..5] of PChar = (
    IDI_APPLICATION,
    IDI_ASTERISK,
    IDI_EXCLAMATION,
    IDI_HAND,
    IDI_QUESTION,
    IDI_WINLOGO);
  UnableToScanSortParameters: array[0..6] of string = (
    'Patient''s Name',
    'Event Dt/Tm',
    'Location Ward/RmBd',
    'Type',
    'Drug item (ID)',
    'User''s Name',
    'Reason Unable to Scan');

var
  BCMA_Patient: TBCMA_Patient;
  BCMA_UserParameters: TBCMA_UserParameters;
  BCMA_SiteParameters: TBCMA_SiteParameters;
  BCMA_ScannedDrug: TBCMA_DispensedDrug;
  //BCMA_Report: TBCMA_Report;
  BCMA_OMScannedMeds: TBCMA_OMScannedMeds;
  BCMA_OMMedOrder: TBCMA_OMMedOrder;
  //BCMA_CCOW: TVACCOW;
  BCMA_EditMedLog: TBCMA_EditMedLog;

  VisibleMedList: TList;
  IVHistoryDates: TList;
  ForceRefresh: Boolean;
  EditedAdministration: Boolean; //if admin edited via EditMedLog, set to true, will refresh VDL
  cmtUserComments,
    cmtReasonGivenPRN: string;
  //IVHistCurrentNode: TTreeNode;
  IVHistClearing: Boolean;
  WardList: TStringList;
  UnableToScan: Boolean; //Did the user select the 'unable to scan' menu option?
  KeyBoardTimer: TTimer;
  KeyBoardTimerHandler: TBCMA_TimerHandler;
  KeyedBarCode: Boolean; //Did they manually type a bar code?

function DisplayVADate(MDateTime: string): string;
(*
 Formats an M DateTime value for display.
*)

function DisplayVADateYearTime(MDateTime: string): string;
{*
  Same as DisplayVADate but adds a four digit year.
*}

function DisplayVADateYear(MDateTime: string): string;
{*
  Same as DisplayVADate but adds a four digit year, no time.
*}

function ValidMDateTime(var DateTimeText: string): string;
(*
  Uses RPC 'PSB FMDATE' to validate a Date/Time text string.  If the string is
  a valid M DateTime value, the function result returns the value in M
  DateTime format and the argument returns a formated, displayable string.
*)

function DateTimeToMDateTime(vDateTime: TDateTime): string;
(*
  Converts a TDateTime value into an M DateTime value.
*)

function getTextWidth(nChars: integer; curFont: TFont): integer;
(*
  Returns the width, in pixels, of a text string filled with 'X' characters in
  curFont.
*)

function getTextHeight(curFont: TFont): integer;
(*
  Returns the height, in pixels, of an 'X' character in curFont.
*)

function rPos(sub, str: string): integer;
(*
  Finds the position of a substring, searching from the right.
*)
function GetLastActivityStatus(StringIn: string): string;

function GetIVType(StringIn: string): string;

function GetOrderStatus(StringIn: string): string;

function getScanStatusID(StringIn: string): TScanStatus;

function SendVitals(Value: string; MDateTime: string = ''): Boolean;

function CloseForms(CloseForm: Boolean): Boolean;

function SameDateTime (const DT1, DT2: TDateTime): Boolean;

function TimeApartInMins (const DT1, DT2: TDateTime): Extended;

function CheckForUnknowns(aMedOrder: TBCMA_MedOrder): Boolean;

procedure StartKeyboardTimer;

procedure StopKeyboardTimer;

function DaysHoursMinutesPast(FMDateTimeIn: String): String;

implementation

uses
  Controls,
  StdCtrls,
  MFunStr,
//  BCMA_Startup,
//  BCMA_Main,
  BCMA_Util,
//  Splash,
  VHA_Objects,
  OrderComIntf;
//  fPrint;

function rPos(sub, str: string): integer;
(* Find the position of a substring, searching from the right. *)
var
  ii,
    ls: integer;
begin
  ls := length(sub);
  ii := length(str) - ls + 1;
  while (copy(str, ii, ls) <> sub) and (ii > 0) do
    dec(ii);
  result := ii;
end;

function getTextWidth(nChars: integer; curFont: TFont): integer;
begin
  with TLabel.create(Application) do
  try
    font.assign(curFont);
    while length(caption) < nChars do
      caption := caption + 'X';
    result := width;
  finally
    free;
  end;
end;

function getTextHeight(curFont: TFont): integer;
begin
  with TLabel.create(Application) do
  try
    font.assign(curFont);
    caption := 'X';
    result := height;
  finally
    free;
  end;
end;

function ValidMDateTime(var DateTimeText: string): string;
var
  TempMDateTime: string;
begin
  result := '';
  with BCMA_Broker do
    if CallServer('PSB FMDATE', [DateTimeText], nil) then
      if piece(results[0], '^', 1) = '-1' then
        DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
      else
      begin
        DateTimeText := piece(results[0], '^', 2);
        //jcs 04/06/04 strip seconds off.  If seconds are someone returned via this call, then the
        //human readable text with the seconds passes through here a second time to be validated
        //seconds are not valid, ie MAR 29, 2004@11:21:37
        DateTimeText := piece(DateTimeText, '@', 1) + '@' + pieces(piece(DateTimeText, '@', 2), ':', 1, 2);
        TempMDateTime := piece(results[0], '^', 1);
        result := piece(TempMDateTime, '.', 1) + '.' + copy(piece(TempMDateTime + '0000', '.', 2), 1, 4)
      end;
end;

function DisplayVADate(MDateTime: string): string;
var
  ss: string;
begin
  result := '';
  if MDateTime <> '' then
  begin
    ss := MDateTime;
    result := copy(ss, rPos('.', ss) - 4, 2) + '/' +
      copy(ss, rPos('.', ss) - 2, 2) + '@' +
      copy(ss, pos('.', ss) + 1, 99) + '00000';
    result := copy(result, 1, 10);
  end;
end;

function DateTimeToMDateTime(vDateTime: TDateTime): string;
var
  ii: integer;
  h, n, s, l: Word;
begin
  //  result := formatDateTime('YYYYMMDD.HHNN', aDateTime);

  DecodeTime(vDateTime, h, n, s, l);
  if (h = 0) and (n = 0) then
    vDateTime := vDateTime - 1;
  result := formatDateTime(DTFORMAT, vDateTime);
  if (h = 0) and (n = 0) then
    Result := StringReplace(Result, '.0000', '.2400', []);
  ii := strToInt(copy(result, 1, 2)) - 17;
  result := intToStr(ii) + copy(result, 3, 999);
end;

function DisplayVADateYearTime(MDateTime: string): string;
var
  ss,
    tt: string;
  dd: TDate;
  d, m, y: Integer;
begin
  result := '';
  if MDateTime <> '' then
  begin
    ss := MDateTime + '0000';
    m := StrToInt(copy(ss, rPos('.', ss) - 4, 2));
    d := StrToInt(copy(ss, rPos('.', ss) - 2, 2));
    y := (StrToInt(copy(ss, rPos('.', ss) - 7, 3)) + 1700);

    if copy(ss, pos('.', ss) + 1, 4) = '' then
      tt := '2400'
    else
      tt := copy(ss, pos('.', ss + '0000') + 1, 4);

    try
      begin
        dd := EncodeDate(y, m, d);
        Result := DateToStr(dd) + '@' + tt;
      end;
    except
      Result := 'Error' + '@' + tt;
    end
  end;
end;

function DisplayVADateYear(MDateTime: string): string;
var
  ss: string;
  dd: TDate;
  d, m, y: Integer;
begin
  result := '';
  try
    if MDateTime <> '' then
    begin
      ss := MDateTime;
      m := StrToInt(copy(ss, rPos('.', ss) - 4, 2));
      d := StrToInt(copy(ss, rPos('.', ss) - 2, 2));
      y := (StrToInt(copy(ss, rPos('.', ss) - 7, 3)) + 1700);

      dd := EncodeDate(y, m, d);
      Result := DateToStr(dd);
    end
    else
      result := 'Error';
  except
    Result := 'Error';
  end;
end;

function GetLastActivityStatus(StringIn: string): string;
begin
  if StringIn = 'G' then
    Result := 'GIVEN'
  else if StringIn = 'H' then
    Result := 'HELD'
  else if StringIn = 'R' then
    Result := 'REFUSED'
  else if StringIn = 'RM' then
    Result := 'REMOVED'
  else if StringIn = 'M' then
    Result := 'MISSING DOSE'
  else if StringIn = 'I' then
    Result := 'INFUSING'
  else if StringIn = 'S' then
    Result := 'STOPPED'
  else if stringIn = 'C' then
    Result := 'COMPLETED'
  else if stringIn = 'A' then
    Result := 'AVAILABLE'
  else if stringIn = 'N' then
    Result := 'NOT GIVEN'
  else if stringIn = 'U' then
    Result := '*UNKNOWN*'
  else
    Result := StringIn;
end;

function GetIVType(StringIn: string): string;
begin
  if StringIn = 'A' then
    Result := 'Admixture'
  else if StringIn = 'H' then
    Result := 'Hyperal'
  else if StringIn = 'C' then
    Result := 'Chemotherapy'
  else if StringIn = 'S' then
    Result := 'Syringe'
  else
    Result := StringIn;
end;

function GetOrderStatus(StringIn: string): string;
begin
  if StringIn = 'A' then
    Result := 'Active'
  else if
    StringIn = 'D' then
    Result := 'Discontinued'
  else if
    StringIn = 'E' then
    Result := 'Expired'
  else if
    StringIn = 'H' then
    Result := 'Hold'
  else if
    StringIn = 'R' then
    Result := 'Renewed'
  else if
    StringIn = 'RE' then
    Result := 'Reinstated'
  else if
    StringIn = 'DE' then
    Result := 'Discontinued (Edit)'
  else if
    StringIn = 'DR' then
    Result := 'Discontinued (Renewal)'
  else if
    StringIn = 'P' then
    Result := 'Purge'
  else if
    StringIn = 'O' then
    Result := 'On Call'
  else if
    StringIn = 'N' then
    Result := 'Non Verified'
  else if
    StringIn = 'I' then
    Result := 'Incomplete'
  else if
    Stringin = 'U' then
    Result := 'Unreleased'
  else
    Result := StringIn;
end;

function getScanStatusID(StringIn: string): TScanStatus;
var
  id: TScanStatus;
begin
  result := ssUnknown;
  for id := low(ScanStatusCodes) to high(ScanStatusCodes) do
    if ScanStatusCodes[id] = StringIn then
    begin
      result := id;
      break;
    end;
end;

function SendVitals(Value: string; MDateTime: string = ''): Boolean;
begin
  result := false;
  if (BCMA_Broker <> nil) and
    (BCMA_Patient.MedOrders <> nil) then
    with BCMA_Broker do
      if CallServer('PSB VITAL MEAS FILE', [BCMA_Patient.IEN,
        Value, 'PN', MDateTime], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
        begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
        end
        else if (results.Count > 1) and
          (piece(Results[1], '^', 1) = '-1') then
        begin
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0);
        end
        else
          Result := True;
end;

function CloseForms(CloseForm: Boolean): Boolean;
{This procedure will close a certain number of Modal forms that we allow to be
closed.  Not all forms can be close forcibly if a transaction is in progress,
as we can't guess as to the current state of the transaction.  This procedure will
be used by CCOW and possibly the automatic timeout feature, any forms left open,
including the main form, will be handled outside of this procedure

However, the forms will only be closed if 'CloseForm' = true.  The procedure doubles
as utility to simply return back whether or not any other modal forms would be
left open.  If some other Modal form would be left open, Result := true
}
var
  x, i: integer;
  CantClose: Boolean;
begin
  Result := False;
  CantClose := True;
  i := 0;
  Repeat
    if fsModal in Screen.Forms[i].FormState then
    begin
      for x := 0 to Length(CloseableForms) - 1 do
        if Screen.Forms[i].Name = CloseableForms[x] then
        begin
          CantClose := false;
          if CloseForm then
          begin
            //PostMessage(Screen.Forms[i].Handle, WM_CLOSE, 0, 0);
            //SendMessage(Screen.Forms[i].handle, WM_CLOSE, 0, 0);
            Screen.Forms[i].ModalResult := mrCancel;
            //PostMessage(Screen.Forms[i].handle, WM_SYSCOMMAND, SC_CLOSE, 0 );
            //Screen.Forms[i].ModalResult := mrCancel;
            //Screen.Forms[i].free;
          end;
        end;


      for x := 0 to Length(CloseableFormsByCaption) - 1 do
        if Screen.Forms[i].Caption = CloseableFormsByCaption[x] then
        begin
          CantClose := false;
          if CloseForm then
            Screen.Forms[i].ModalResult := mrCancel;
        end;

      if CantClose = True then
      begin
        Result := True;
        Break;
      end;
    end;
  Inc(i);
  until (i = Screen.FormCount);
end;

function SameDateTime (const DT1, DT2: TDateTime): Boolean;
const OneDTMillisecond = 1 / (24 * 60 * 60 * 1000);
begin
  Result := abs (DT1 - DT2) < OneDTMillisecond;
end;

function TimeApartInMins (const DT1, DT2: TDateTime): Extended;
begin
  if SameDateTime (DT1, DT2) then
    Result := 0
  else
      Result := (DT2 - DT1) * 24 * 60;
end;

function CheckForUnknowns(aMedOrder: TBCMA_MedOrder): Boolean;
//result = if the user selected cancel
var
  msg: String;
begin
  Result := false;
  if (BCMA_Broker <> nil) and (aMedOrder <> nil) then
    with BCMA_Broker do
      if CallServer('PSB UTL XSTATUS SRCH', [BCMA_Patient.IEN + '^' + aMedOrder.OrderNumber + '^^FREQ'], nil) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0], -1)) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 0) and (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else if (results.Count > 0) and (piece(Results[1], '^', 1) = '0') then exit
        else
          with aMedOrder do
          begin
            msg := 'This order contains an administration with an UNKNOWN status as described below:' + #13#13;
            msg := msg + 'Patient Name: ' + BCMA_Patient.Name + #13;
            msg := msg + 'Location: ' + piece(Results[1], '^', 1) + #13;
            msg := msg + 'Medication: ' + piece(Results[2], '^', 1)  +  #13;
            msg := msg + 'Order Number: ' + piece(Results[2], '^', 2) + #13;
            msg := msg + 'Unknown entry created at: ' + DisplayVADateYearTime(piece(Results[3], '^', 1)) + #13;

            if piece(Results[4], '^', 1) <> '' then
              msg := msg + 'Scheduled Admin Time: ' + DisplayVADateYearTime(piece(Results[4], '^', 1)) + #13;

            msg := msg + #13 + 'Contact your BCMA Coordinator if you do not know your site''s policy regarding administrations with an UNKNOWN status.' + #13#13;

            if aMedOrder.ScanStatus = 'U' then
            begin
              msg := msg + #13 + 'Administrations with an UKNOWN status need to be edited via Edit Med Log. ' + #13;
              msg := msg + 'This action will be canceled' + #13;

              DefMessageDlg(msg, mtInformation, [mbOK], 0);
              Result := True;
            end
            else
            begin
              msg := msg + 'Click OK to continue with the administration or Cancel to exit the administration without saving any data.';
              Result := (DefMessageDlg(msg, mtInformation, [mbOK, mbCancel], 0) = idCancel);
            end;
            aMedOrder.UnknownMessageDisplayed := True;
          end;
end;

procedure StartKeyboardTimer;
begin
  if KeyBoardTimer <> nil then exit;
  KeyboardTimerHandler:= TBCMA_TimerHandler.Create;
  KeyboardTimer := TTimer.Create( Nil );
  With KeyboardTimer Do Begin
    Interval := KeyBoardTimerInterval;
    OnTimer := KeyboardTimerHandler.TimerEvent;
    Enabled := True;
  End;
end;

procedure StopKeyboardTimer;
begin
  if Keyboardtimer <> nil then
  begin
    KeyboardTimer.Enabled:= False;
    KeyboardTimer.Free;
    KeyboardTimer := nil;
    KeyboardTimerhandler.free;
  end;
end;

function DaysHoursMinutesPast(FMDateTimeIn: String): String;
var
  ActionDateTime: TDateTime;
  SinceMinutes, zDays, zHours, zMinutes: Extended;
begin
  if FMDateTimeIn = '' then exit;
  ActionDateTime := FMDateTimeToDateTime(StrToFloat(FMDateTimeIn));
  SinceMinutes := TimeApartInMins(ActionDateTime, Now + BCMA_SiteParameters.ServerClockVariance);

  zDays := int(SinceMinutes / 1440);
  SinceMinutes := SinceMinutes - zDays * 1440;

  if (SinceMinutes >= 60) then
    zHours := int(SinceMinutes / 60)
  else
    zHours := 0;

  if SinceMinutes > 60 then
    zMinutes := Round(60*frac(SinceMinutes / 60))
  else
    zMinutes := Round(SinceMinutes);

  Result := FloatToStr(zDays) + 'd ' + FloatToStr(zHours) + 'h ' + FloatToStr(zMinutes) + 'm';
end;


end.


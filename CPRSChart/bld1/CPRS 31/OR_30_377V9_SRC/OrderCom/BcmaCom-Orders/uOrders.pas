unit uOrders;
interface
uses
Windows, Messages, SysUtils, Classes, Controls, Forms, ORfn, Dialogs, System.UITypes;

function IMOActionValidation(AnId: string; var IsIMOOD: boolean; var x: string; AnEventType: char): boolean;
function AllowActionOnIMO(AnEvtTyp: char): boolean;
function RetrieveOrderText(AnOrderID: string): string;
function IMOTimeFrame: TFMDateTime;
function IsIMODialog(DlgID: integer): boolean; //IMO
procedure InitialOrderVariables;

var
  ClinDisp : Integer; //IMO
  ClinIVDisp : Integer;
  MedsInDlgIen  : Integer;
  MedsIVDlgIen: Integer;
  ClinMedsDlgIen: Integer;
  MedsInDlgFormId  : Integer;
  ClinIVDlgIen : Integer;
implementation

uses
  rOrders, uCore, rCore, rODBase;

const
  TX_IMO_WARNING1 = 'You are ';
  TX_IMO_WARNING2 = ' Clinic Orders. The New orders will be saved as Clinic Orders and MAY NOT be available in BCMA';

function IMOActionValidation(AnId: string; var IsIMOOD: boolean; var x: string; AnEventType: char): boolean;
var
  actName: string;
begin
  // jd imo change
  Result := True;
  if CharInSet(CharAt(AnID, 1), ['X','C']) then  // transfer IMO order doesn't need check
  begin
    IsIMOOD := IsIMOOrder(Copy(AnID, 2, Length(AnID)));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        if CharAt(AnID,1) = 'X' then actName := 'change';
        if CharAt(AnID,1) = 'C' then actName := 'copy';
        x := 'You cannot ' + actName + ' the clinical medication order.';
        x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#13#10 + x;
        UnlockOrder(Copy(AnID, 2, Length(AnID)));
        result := False;
      end
      else
      begin
        if patient.Inpatient then
        begin
          if CharAt(AnID,1) = 'X' then actName := 'changing';
          if CharAt(AnID,1) = 'C' then actName := 'copying';
          if MessageDlg(TX_IMO_WARNING1 + actName +  TX_IMO_WARNING2 + #13#13#10 + x, mtWarning,[mbOK,mbCancel],0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            result := False;
          end;
        end;
      end;
    end;
  end;
  if Piece(AnId,'^',1)='RENEW' then
  begin
    IsIMOOD := IsIMOOrder(Piece(AnID,'^',2));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        x := 'You cannot renew the clinical medication order.';
        x := RetrieveOrderText(Piece(AnID,'^',2)) + #13#13#10 + x;
        UnlockOrder(Piece(AnID,'^',2));
        result := False;
      end
      else
      begin
        if Patient.Inpatient then
        begin
          if MessageDlg(TX_IMO_WARNING1 + 'renewing' + TX_IMO_WARNING2, mtWarning,[mbOK,mbCancel],0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            result := False;
          end;
        end;
      end;
    end;
  end;
end;

function AllowActionOnIMO(AnEvtTyp: char): boolean;
var
  Td: TFMDateTime;
begin
  Result := False;
  if (Patient.Inpatient) then
  begin
    Td := FMToday;
    if IsValidIMOLoc(Encounter.Location,Patient.DFN) and (Encounter.DateTime > Td) then
      Result := True;
  end
  else
  begin
    //CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
    //Td := FMToday;
    Td := IMOTimeFrame;
    if IsValidIMOLoc(Encounter.Location,Patient.DFN) and (Encounter.DateTime > Td) then
      Result := True
    else if CharInSet(AnEvtTyp, ['A','T']) then
      Result := True;
  end;
end;

function RetrieveOrderText(AnOrderID: string): string;
var
  OrdList: TList;
  theOrder: TOrder;
begin
  OrdList := TList.Create;
  theOrder := TOrder.Create;
  theOrder.ID := AnOrderID;
  OrdList.Add(theOrder);
  RetrieveOrderFields(OrdList, 0, 0);
  Result := TOrder(OrdList.Items[0]).Text;
  if Assigned(OrdList) then OrdList.Free; //CQ:7554
end;

function IMOTimeFrame: TFMDateTime;
begin
  Result := DateTimeToFMDateTime(FMDateTimeToDateTime(FMNow) - (23/24));
end;

function IsIMODialog(DlgID: integer): boolean; //IMO
var
  IsInptDlg, IsIMOLocation: boolean;
  Td: TFMDateTime;
begin
  result := False;
  IsInptDlg := False;
  //CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
  //Td := FMToday;
  Td := IMOTimeFrame;
  if ( (DlgID = MedsInDlgIen) or (DlgID = MedsIVDlgIen) or (IsInptQO(dlgId)) or (IsIVQO(dlgId))) then IsInptDlg := TRUE;
  IsIMOLocation := IsValidIMOLoc(Encounter.Location,Patient.DFN);
  if (IsInptDlg or IsInptQO(DlgID)) and {(not Patient.Inpatient) and} IsIMOLocation and (Encounter.DateTime > Td) then
    result := True;
end;


procedure InitialOrderVariables;
begin
  ClinDisp := DisplayGroupByName('C RX');     //62
  ClinIVDisp := DisplayGroupByName('CI RX');  //67
  MedsInDlgIen  := DlgIENForName('PSJ OR PAT OE');
  MedsIVDlgIen := DlgIENForName('PSJI OR PAT FLUID OE');
  ClinMedsDlgIen := DlgIENForName('PSJ OR CLINIC OE');
  ClinIVDlgIen :=  DlgIENForName('CLINIC OR PAT FLUID OE');
  MedsInDlgFormId  := FormIDForDialog(MedsInDlgIen);
end;
end.

library OrderCom;

uses
  ComServ,
  OrderComIntf in 'OrderComIntf.pas' {BcmaOrder: CoClass},
  uBcmaOrder in 'BcmaCom-Orders\uBcmaOrder.pas',
  fOCAccept in 'BcmaCom-Orders\fOCAccept.pas',
  fAutoSz in 'BcmaCom-Orders\fAutoSz.pas' {frmAutoSz},
  fODMedFA in 'BcmaCom-Orders\fODMedFA.pas',
  fODMedIV in 'BcmaCom-Orders\fODMedIV.pas',
  fODMedOIFA in 'BcmaCom-Orders\fODMedOIFA.pas',
  fODMeds in 'BcmaCom-Orders\fODMeds.pas' {lst},
  rCore in 'BcmaCom-Orders\rCore.pas',
  rODBase in 'BcmaCom-Orders\rODBase.pas',
  rODMeds in 'BcmaCom-Orders\rODMeds.pas',
  rOrders in 'BcmaCom-Orders\rOrders.pas',
  uBcmaConst in 'BcmaCom-Orders\uBcmaConst.pas',
  uConst in 'BcmaCom-Orders\uConst.pas',
  fSignItem in 'BcmaCom-Orders\fSignItem.pas' {frmSignItem},
  fOCSession in 'BcmaCom-Orders\fOCSession.pas' {frmOCSession},
  fODBase in 'BcmaCom-Orders\fODBase.pas' {frmODBase},
  fReview in 'BcmaCom-Orders\fReview.pas' {frmReview},
  ORNet in 'BcmaCom-Lib\ORNet.pas',
  uODBase in 'BcmaCom-Orders\uODBase.pas',
  fBase508Form in 'BcmaCom-Orders\fBase508Form.pas' {frmBase508Form},
  fHSplit in 'BcmaCom-Orders\fHSplit.pas',
  fPage in 'BcmaCom-Orders\fPage.pas' {frmPage},
  fODMessage in 'BcmaCom-Orders\fODMessage.pas' {frmODMessage},
  fIVRoutes in 'BcmaCom-Orders\fIVRoutes.pas' {frmIVRoutes},
  fOtherSchedule in 'BcmaCom-Orders\fOtherSchedule.pas' {frmOtherSchedule},
  BCMA_OrderMan in 'BCMA\BCMA_OrderMan.pas' {frmCPRSOrderManager},
  BCMA_Objects in 'BCMA\BCMA_Objects.pas',
  VHA_Objects in 'BCMA\VHA_Objects.pas',
  BCMA_Common in 'BCMA\BCMA_Common.pas',
  BCMA_Util in 'BCMA\BCMA_Util.pas',
  uBCMA in 'BCMA\uBCMA.pas',
  MultipleOrderedDrugs in 'BCMA\MultipleOrderedDrugs.pas' {frmMultipleOrderedDrugs},
  fEncnt in 'fEncnt.pas' {frmEncounter},
  uCore in 'BcmaCom-Orders\uCore.pas',
  uOrders in 'BcmaCom-Orders\uOrders.pas',
  XuDigSigSC_TLB in 'XuDigSigSC_TLB.pas',
  fOCMonograph in 'BcmaCom-Orders\fOCMonograph.pas' {frmOCMonograph};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  InitMOB       name 'LaunchMOB';

{$R BCMAOrderCom.TLB}

{$R OrderCom.RES}

begin
end.

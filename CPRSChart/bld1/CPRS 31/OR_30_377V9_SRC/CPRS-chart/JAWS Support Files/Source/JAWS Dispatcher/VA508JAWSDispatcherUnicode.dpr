program VA508JAWSDispatcherUnicode;

uses
  Forms,
  fVA508DispatcherHiddenWindow in 'fVA508DispatcherHiddenWindow.pas' {frmVA508JawsDispatcherHiddenWindow},
  VAUtils in '..\..\..\..\..\Packages\VA\Source\VAUtils.pas',
  VAClasses in '..\..\..\..\..\Packages\VA\Source\VAClasses.pas',
  JAWSCommon in 'JAWSCommon.pas',
  VA508AccessibilityConst in '..\VA508AccessibilityConst.pas';

{$R *.res}

begin
  if AnotherInstanceRunning then exit;
  Application.ShowMainForm := FALSE;
  Application.Initialize;
  Application.CreateForm(TfrmVA508JawsDispatcherHiddenWindow, frmVA508JawsDispatcherHiddenWindow);
  Application.Run;
end.

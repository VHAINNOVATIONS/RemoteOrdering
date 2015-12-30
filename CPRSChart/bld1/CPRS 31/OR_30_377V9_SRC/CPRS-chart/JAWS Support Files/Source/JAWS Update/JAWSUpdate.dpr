program JAWSUpdate;

uses
  Forms,
  Message in 'Message.pas' {frmMessage},
  VAClasses in '..\..\..\..\..\Packages\VA\Source\VAClasses.pas',
  FSAPILib_TLB in '..\JAWS Dll\FSAPILib_TLB.pas',
  VAUtils in '..\..\..\..\..\Packages\VA\Source\VAUtils.pas',
  VA508AccessibilityConst in '..\VA508AccessibilityConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMessage, frmMessage);
  Application.Run;
end.

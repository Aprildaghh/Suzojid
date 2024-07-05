program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {mainForm},
  SkeletonUnit in 'SkeletonUnit.pas',
  StudentUnit in 'StudentUnit.pas',
  LectureUnit in 'LectureUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.

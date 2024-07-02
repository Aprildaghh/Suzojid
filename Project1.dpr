program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {mainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.

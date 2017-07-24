program Projeto;

uses
  Vcl.Forms,
  unit1 in 'unit1.pas' {Form5},
  MARS.http.Server.Indy in '..\..\Source\MARS.http.Server.Indy.pas',
  resources in 'resources.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.

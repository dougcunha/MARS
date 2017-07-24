program MARS.Indy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  MARS.http.Server.Indy in '..\..\Source\MARS.http.Server.Indy.pas';

begin
  try
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

unit unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  MARS.Core.Registry,
  MARS.Core.Attributes,
  MARS.Core.MediaType,
  MARS.Core.Engine,
  MARS.Core.JSON,
  MARS.Core.MessageBodyWriters;

type
  TForm5 = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FEngine: TMARSEngine;
  public
  end;

var
  Form5: TForm5;

implementation

uses
  MARS.http.Server.Indy;

{$R *.dfm}

procedure TForm5.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEngine);
end;

procedure TForm5.FormCreate(Sender: TObject);
var
  FServer: TMARShttpServerIndy;
begin
  FEngine := TMARSEngine.Create;
  try
    FEngine.Port := 7000;
    Fengine.BasePath := '';
    FEngine.AddApplication('DefaultApp', 'v1', ['resources.*']);

    FServer := TMARShttpServerIndy.Create(FEngine);
    try
      FServer.DefaultPort := FEngine.Port;
      FServer.Active := True;
    except
      FServer.Free;
      raise;
    end;

  except
    FreeAndNil(FEngine);
    raise;
  end;
end;


end.

unit resources;

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
  MARS.Core.JSON,
  MARS.Core.MessageBodyWriters,
  superobject;

type
  [Path('opa'), Produces(TMediaType.APPLICATION_JSON_UTF8)]
  THelloWorldResource = class
  private
  public
    [GET]
    function HelloWorld(): string;
    [POST]
    function Opa([BodyParam] Data: string; [QueryParam] nome: string; [QueryParam] idade: Integer; [HeaderParam] Host: string): string;
  end;

implementation


{ THelloWorldResource }

function THelloWorldResource.HelloWorld: string;
begin
  Result := SO('{"mensagem": "Opa so alegria"}').AsJson();
end;

function THelloWorldResource.Opa([BodyParam] Data: string; [QueryParam] nome: string; [QueryParam] idade: Integer; [HeaderParam] Host: string): string;
var
  json: ISuperObject;
begin
  json := SO(data);
  json.S['nome'] := nome;
  json.I['idade'] := idade;
  json.S['host'] := Host;
  Result := json.AsJSon(True);
end;

initialization
  TMARSResourceRegistry.Instance.RegisterResource<THelloWorldResource>;

end.

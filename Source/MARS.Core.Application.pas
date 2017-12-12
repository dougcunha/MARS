(*
  Copyright 2016, MARS-Curiosity library

  Home: https://github.com/andrea-magni/MARS
*)
unit MARS.Core.Application;

{$I MARS.inc}

interface

uses
    SysUtils, Classes, Rtti, Generics.Collections
  , MARS.Core.Classes
  , MARS.Core.URL
  , MARS.Core.Registry
  , MARS.Core.Exceptions
  , MARS.Utils.Parameters
  ;

type
  EMARSApplicationException = class(EMARSHttpException);
  EMARSAuthenticationException = class(EMARSApplicationException);
  EMARSAuthorizationException = class(EMARSApplicationException);

  TMARSApplication = class
  private
    FRttiContext: TRttiContext;
    FResourceRegistry: TObjectDictionary<string, TMARSConstructorInfo>;
    FBasePath: string;
    FName: string;
    FSystem: Boolean;
    FParameters: TMARSParameters;
  protected
  public
    constructor Create(const AName: string); virtual;
    destructor Destroy; override;

    function AddResource(AResource: string): Boolean;
    procedure EnumerateResources(const ADoSomething: TProc<string, TMARSConstructorInfo>);

    property Name: string read FName;
    property BasePath: string read FBasePath write FBasePath;
    property System: Boolean read FSystem write FSystem;
    property Resources: TObjectDictionary<string, TMARSConstructorInfo> read FResourceRegistry;
    property Parameters: TMARSParameters read FParameters;
  end;

  TMARSApplicationDictionary = class(TObjectDictionary<string, TMARSApplication>)
  end;

implementation

uses
    StrUtils
  , MARS.Core.Utils, MARS.Rtti.Utils
  , MARS.Core.Attributes
;

{ TMARSApplication }

function TMARSApplication.AddResource(AResource: string): Boolean;

  function AddResourceToApplicationRegistry(const AInfo: TMARSConstructorInfo): Boolean;
  var
    LClass: TClass;
    LResult: Boolean;
  begin
    LResult := False;
    LClass := AInfo.TypeTClass;
    FRttiContext.GetType(LClass).HasAttribute<PathAttribute>(
      procedure (AAttribute: PathAttribute)
      var
        LURL: TMARSURL;
      begin
        LURL := TMARSURL.CreateDummy(AAttribute.Value);
        try
          if LURL.HasPathTokens and not FResourceRegistry.ContainsKey(LURL.PathTokens[0]) then
          begin
            FResourceRegistry.Add(LURL.PathTokens[0], AInfo.Clone);
            LResult := True;
          end;
        finally
          LURL.Free;
        end;
      end
    );
    Result := LResult;
  end;

var
  LRegistry: TMARSResourceRegistry;
  LInfo: TMARSConstructorInfo;
  LKey: string;
begin
  Result := False;
  LRegistry := TMARSResourceRegistry.Instance;

  if IsMask(AResource) then // has wildcards and so on...
  begin
    for LKey in LRegistry.Keys.ToArray do
    begin
      if MatchesMask(LKey, AResource) then
      begin
        if LRegistry.TryGetValue(LKey, LInfo) and AddResourceToApplicationRegistry(LInfo) then
          Result := True;
      end;
    end;
  end
  else // exact match
    if LRegistry.TryGetValue(AResource, LInfo) then
      Result := AddResourceToApplicationRegistry(LInfo);
end;

constructor TMARSApplication.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FRttiContext := TRttiContext.Create;
  FResourceRegistry := TObjectDictionary<string, TMARSConstructorInfo>.Create([doOwnsValues]);
  FParameters := TMARSParameters.Create(AName);
end;

destructor TMARSApplication.Destroy;
begin
  FParameters.Free;
  FResourceRegistry.Free;
  FRttiContext.Free;
  inherited;
end;

procedure TMARSApplication.EnumerateResources(
  const ADoSomething: TProc<string, TMARSConstructorInfo>);
var
  LPair: TPair<string, TMARSConstructorInfo>;
begin
  if Assigned(ADoSomething) then
    for LPair in FResourceRegistry do
      ADoSomething(LPair.Key, LPair.Value);
end;

end.

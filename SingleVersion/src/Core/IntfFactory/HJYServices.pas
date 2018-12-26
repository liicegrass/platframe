unit HJYServices;

interface

uses SysUtils, Classes, Windows, HJYFactoryIntfs;

type
  THJYService = Class(TObject, IInterface)
  private
    FRefCount: Integer;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public

  end;

function HJYService: IInterface;

implementation

uses HJYFactoryManagers;

var
  FHJYService: IInterface;

function HJYService: IInterface;
begin
  if not Assigned(FHJYService) then
    FHJYService := THJYService.Create;
  Result := FHJYService;
end;

{ THJYService }

function THJYService._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function THJYService._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

function THJYService.QueryInterface(const IID: TGUID; out Obj): HResult;
var
  lvFactory: THJYFactory;
begin
  Result := E_NOINTERFACE;
  if Self.GetInterface(IID, Obj) then
    Result := S_OK
  else
  begin
    lvFactory := FactoryManager.FindFactory(IID);
    if Assigned(lvFactory) then
    begin
      lvFactory.CreateInstance(IID, Obj);
      Result := S_OK;
    end;
  end;
end;

initialization
  FHJYService := nil;

finalization
  FHJYService := nil;

end.

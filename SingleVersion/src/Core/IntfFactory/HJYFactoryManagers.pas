unit HJYFactoryManagers;

interface

uses SysUtils, Classes, HJYFactoryIntfs, HJYIntfObjs, HJYHashLists;

type
  TFactoryList = class(TObject)
  private
    FList: TList;
    function GetItems(Index: Integer): THJYFactory;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AFactory: THJYFactory): Integer;
    function IndexOfIID(const IID: TGUID): Integer;
    function GetFactory(const IID: TGUID): THJYFactory;
    function FindFactory(const IID: TGUID): THJYFactory;
    function Remove(AFactory: THJYFactory): Integer;
    property Items[Index: Integer]: THJYFactory read GetItems; default;
    property Count: Integer Read GetCount;
  end;

  TFactoryManager = class(THJYIntfObj, IEnumKey)
  private
    FFactoryList: TFactoryList;
    FIndexList: THashList;
    FKeyList: TStrings;
  protected
    { IEnumKey }
    procedure EnumKey(const IIDStr: String);
  public
    procedure RegisterFactory(AIntfFactory: THJYFactory);
    procedure UnRegisterFactory(AFactory: THJYFactory); overload;
    function FindFactory(const IID: TGUID): THJYFactory;
    property FactoryList: TFactoryList Read FFactoryList;
    function Exists(const IID: TGUID): Boolean;
    procedure ReleaseInstances;
    Constructor Create;
    Destructor Destroy; override;
  end;

  function FactoryManager: TFactoryManager;

implementation

uses HJYMessages;

var
  FFactoryManager: TFactoryManager;

function FactoryManager: TFactoryManager;
begin
  if FFactoryManager = nil then
    FFactoryManager := TFactoryManager.Create;
  Result := FFactoryManager;
end;

{ TFactoryList }

function TFactoryList.Add(AFactory: THJYFactory): Integer;
begin
  Result := FList.Add(AFactory);
end;

constructor TFactoryList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TFactoryList.Destroy;
var
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
    TObject(FList[I]).Free;
  FList.Free;
  inherited Destroy;
end;

function TFactoryList.FindFactory(const IID: TGUID): THJYFactory;
var
  Idx: Integer;
begin
  Result := nil;
  Idx := Self.IndexOfIID(IID);
  if Idx <> -1 then
    Result := THJYFactory(FList[Idx]);
end;

function TFactoryList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TFactoryList.GetFactory(const IID: TGUID): THJYFactory;
begin
  Result := FindFactory(IID);
  if not Assigned(Result) then
    Raise Exception.CreateFmt(Err_IntfNotFound, [GUIDToString(IID)]);
end;

function TFactoryList.GetItems(Index: Integer): THJYFactory;
begin
  Result := THJYFactory(FList[Index]);
end;

function TFactoryList.IndexOfIID(const IID: TGUID): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to (FList.Count - 1) do
  begin
    if THJYFactory(FList[I]).Supports(IID) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TFactoryList.Remove(AFactory: THJYFactory): Integer;
begin
  Result := FList.Remove(AFactory);
end;

{ TSysFactoryManager }

constructor TFactoryManager.Create;
begin
  FFactoryList := TFactoryList.Create;
  FIndexList := THashList.Create(256);
  FKeyList := TStringList.Create;
end;

destructor TFactoryManager.Destroy;
begin
  FFactoryList.Free;
  FIndexList.Free;
  FKeyList.Free;
  inherited;
end;

function TFactoryManager.Exists(const IID: TGUID): Boolean;
begin
  Result := FFactoryList.IndexOfIID(IID) <> -1;
end;

function TFactoryManager.FindFactory(const IID: TGUID): THJYFactory;
var
  IIDStr: string;
  PFactory: Pointer;
begin
  Result := nil;
  IIDStr := GUIDToString(IID);
  PFactory := FIndexList.ValueOf(IIDStr);
  if PFactory <> nil then
    Result := THJYFactory(PFactory)
  else
  begin
    if FKeyList.IndexOf(IIDStr) = -1 then
    begin
      Result := FFactoryList.FindFactory(IID);
      if Result = nil then
        FKeyList.Add(IIDStr)
      else
        FIndexList.Add(IIDStr, Result);
    end;
  end;
end;

procedure TFactoryManager.RegisterFactory(AIntfFactory: THJYFactory);
var
  I: Integer;
  IIDStr: String;
  IID: TGUID;
begin
  FFactoryList.Add(AIntfFactory);
  for I := FKeyList.Count - 1 downto 0 do
  begin
    IIDStr := FKeyList[I];
    IID := StringToGUID(IIDStr);
    if AIntfFactory.Supports(IID) then
    begin
      FIndexList.Add(IIDStr, Pointer(AIntfFactory));
      FKeyList.Delete(I);
    end;
  end;
end;

procedure TFactoryManager.ReleaseInstances;
var
  I: Integer;
begin
  for I := 0 to Self.FFactoryList.Count - 1 do
    Self.FFactoryList.Items[I].ReleaseInstance;
end;

procedure TFactoryManager.EnumKey(const IIDStr: String);
begin
  Self.FIndexList.Remove(IIDStr);
end;

procedure TFactoryManager.UnRegisterFactory(AFactory: THJYFactory);
begin
  if Assigned(AFactory) then
  begin
    AFactory.EnumKeys(Self);
    AFactory.ReleaseInstance;
    FFactoryList.Remove(AFactory);
  end;
end;

initialization
  FFactoryManager := nil;

finalization
  FFactoryManager.Free;

end.

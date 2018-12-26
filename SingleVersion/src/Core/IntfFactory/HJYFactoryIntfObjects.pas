unit HJYFactoryIntfObjects;

interface

Uses Classes, SysUtils, HJYFactoryIntfs;

Type
  TIntfCreatorFunc = procedure(out anInstance: IInterface);

  // 工厂基类
  TBaseFactory = Class(THJYFactory)
  private
    FIntfGUID: TGUID;
  public
    constructor Create(const IID: TGUID);
    destructor Destroy; override;
    function Supports(IID: TGUID): Boolean; override;
    procedure EnumKeys(Intf: IEnumKey); override;
  end;

  // 接口工厂
  TInterfaceFactory = Class(TBaseFactory)
  private
    FIntfCreatorFunc: TIntfCreatorFunc;
  public
    constructor Create(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc); virtual;
    destructor Destroy; override;
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  end;

  // 单例工厂
  TSingletonFactory = Class(TInterfaceFactory)
  private
    FInstance: IInterface;
  public
    constructor Create(IID: TGUID; IntfCreatorFunc: TIntfCreatorFunc); override;
    destructor Destroy; override;
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  end;

  // 实例工厂
  TObjectFactory = Class(TBaseFactory)
  private
    FOwnsObj: Boolean;
    FInstance: TObject;
    FRefIntf: IInterface;
  public
    constructor Create(IID: TGUID; Instance: TObject; OwnsObj: Boolean = False);
    destructor Destroy; override;
    procedure CreateInstance(const IID: TGUID; out Obj); override;
    procedure ReleaseInstance; override;
  end;

implementation

uses HJYFactoryManagers, HJYMessages;

{ TBaseFactory }

constructor TBaseFactory.Create(const IID: TGUID);
begin
  if FactoryManager.Exists(IID) then
    raise Exception.CreateFmt(Err_IntfExists, [GUIDToString(IID)]);
  FIntfGUID := IID;
  FactoryManager.RegisterFactory(Self);
end;

destructor TBaseFactory.Destroy;
begin
  FactoryManager.UnRegisterFactory(Self);
  inherited;
end;

procedure TBaseFactory.EnumKeys(Intf: IEnumKey);
begin
  if Assigned(Intf) then
    Intf.EnumKey(GUIDToString(FIntfGUID));
end;

function TBaseFactory.Supports(IID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IID, FIntfGUID);
end;

{ TIntfaceFactory }

constructor TInterfaceFactory.Create(IID: TGUID;
  IntfCreatorFunc: TIntfCreatorFunc);
begin
  Self.FIntfCreatorFunc := IntfCreatorFunc;
  Inherited Create(IID);
end;

procedure TInterfaceFactory.CreateInstance(const IID: TGUID; out Obj);
var
  tmpIntf: IInterface;
begin
  Self.FIntfCreatorFunc(tmpIntf);
  tmpIntf.QueryInterface(IID, Obj);
end;

destructor TInterfaceFactory.Destroy;
begin

  inherited;
end;

procedure TInterfaceFactory.ReleaseInstance;
begin

end;

{ TSingletonFactory }

constructor TSingletonFactory.Create(IID: TGUID;
  IntfCreatorFunc: TIntfCreatorFunc);
begin
  FInstance := nil;
  inherited Create(IID, IntfCreatorFunc);
end;

procedure TSingletonFactory.CreateInstance(const IID: TGUID; out Obj);
begin
  if FInstance = nil then
    inherited CreateInstance(IID, FInstance);
  if FInstance.QueryInterface(IID, Obj) <> S_OK then
    raise Exception.CreateFmt(Err_IntfNotSupport, [GUIDToString(IID)]);
end;

destructor TSingletonFactory.Destroy;
begin

  inherited;
end;

procedure TSingletonFactory.ReleaseInstance;
var
  Obj: TComponent;
  RefIntf: IInterfaceComponentReference;
begin
  if FInstance <> nil then
  begin
    if FInstance.QueryInterface(IInterfaceComponentReference, RefIntf) = S_OK then
    begin
      Obj := RefIntf.GetComponent;
      Obj.Free;
    end;
    FInstance := nil;
  end;
end;

{ TObjectFactory }

constructor TObjectFactory.Create(IID: TGUID; Instance: TObject; OwnsObj: Boolean);
begin
  if not Instance.GetInterface(IID, FRefIntf) then
    raise Exception.CreateFmt(Err_ObjNotImpIntf, [Instance.ClassName, GUIDToString(IID)]);
  if (Instance is TInterfacedObject) then
    raise Exception.Create(Err_DontUseTInterfacedObject);
  FOwnsObj := OwnsObj;
  FInstance := Instance;
  inherited Create(IID);
end;

procedure TObjectFactory.CreateInstance(const IID: TGUID; out Obj);
begin
  IInterface(Obj) := FRefIntf;
end;

destructor TObjectFactory.Destroy;
begin

  inherited;
end;

procedure TObjectFactory.ReleaseInstance;
begin
  inherited;
  FRefIntf := nil;
  if FOwnsObj then
    FreeAndNil(FInstance);
end;

end.

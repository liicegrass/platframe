unit HJYIntfObjs;

interface

type
  //实现IInterface接口，但不同于TInterfacedObject，引用计数为0不会自动释放
  THJYIntfObj = Class(TObject, IInterface)
  protected
    {IInterface}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

implementation

{ THJYIntfObj }

function THJYIntfObj.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function THJYIntfObj._AddRef: Integer;
begin
   Result := -1;
end;

function THJYIntfObj._Release: Integer;
begin
  Result := -1;
end;

end.

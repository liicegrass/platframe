unit HJYIntfObjs;

interface

type
  //ʵ��IInterface�ӿڣ�����ͬ��TInterfacedObject�����ü���Ϊ0�����Զ��ͷ�
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

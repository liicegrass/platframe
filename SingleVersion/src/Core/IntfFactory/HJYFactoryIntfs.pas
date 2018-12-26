unit HJYFactoryIntfs;

interface

uses HJYIntfObjs;

type
  IEnumKey=Interface
    ['{A1A5EC95-ABAE-43C9-98CC-9C0795B9C632}']
    procedure EnumKey(const IIDStr:String);
  End;

  THJYFactory = class(THJYIntfObj)
  private

  public
    procedure CreateInstance(const IID: TGUID; out Obj); virtual; abstract;
    procedure ReleaseInstance; virtual; abstract;
    function Supports(IID: TGUID): Boolean; virtual; abstract;
    procedure EnumKeys(Intf: IEnumKey); virtual; abstract;
  end;

implementation

end.

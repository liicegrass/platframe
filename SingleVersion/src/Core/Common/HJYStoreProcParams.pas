unit HJYStoreProcParams;

interface

uses DB;

type
  THJYStoreProcParam = class(TParam)
  private
    FParamId: Integer;
    FDataTypeStr: string;
  public
    property ParamId: Integer read FParamId write FParamId;
    property DataTypeStr: string read FDataTypeStr write FDataTypeStr;
  end;

  THJYStoreProcParams = class(TParams)
  private
    function GetItem(Index: Integer): THJYStoreProcParam;
    procedure SetItem(Index: Integer; const Value: THJYStoreProcParam);
  protected
    function GetParamClass: TParamClass; override;
  published
  public
    function AddNew: THJYStoreProcParam; overload;
    function AddNew(FldType: TFieldType; ParamName: string;
      ParamType: TParamType; ParamId: Integer; DataTypeStr: string;
      Value: Variant): THJYStoreProcParam; overload;
    function FindParam(const Value: string): THJYStoreProcParam;
    property Items[Index: Integer]: THJYStoreProcParam read GetItem write SetItem; default;
  end;

implementation

{ THJYStoreProcParams }

function THJYStoreProcParams.AddNew: THJYStoreProcParam;
begin
  Result := Add as THJYStoreProcParam;
end;

function THJYStoreProcParams.AddNew(FldType: TFieldType; ParamName: string;
  ParamType: TParamType; ParamId: Integer; DataTypeStr: string;
  Value: Variant): THJYStoreProcParam;
begin
  Result := AddNew;
  Result.DataType := FldType;
  Result.Name := ParamName;
  Result.ParamType := ParamType;
  Result.DataTypeStr := DataTypeStr;
  Result.ParamId := ParamId;
  Result.Value := Value;
end;

function THJYStoreProcParams.FindParam(const Value: string): THJYStoreProcParam;
begin
  Result := THJYStoreProcParam(inherited FindParam(Value));
end;

function THJYStoreProcParams.GetItem(Index: Integer): THJYStoreProcParam;
begin
  Result := THJYStoreProcParam(inherited Items[Index]);
end;

function THJYStoreProcParams.GetParamClass: TParamClass;
begin
  Result := THJYStoreProcParam;
end;

procedure THJYStoreProcParams.SetItem(Index: Integer;
  const Value: THJYStoreProcParam);
begin
  inherited SetItem(Index, TParam(Value));
end;

end.

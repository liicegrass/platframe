unit HJYDataRecords;

interface

uses SysUtils, Classes, Variants, DB;

type
  THJYDataItem = class(TObject)
  private
    FData: Variant;
  public
    property Data: Variant read FData write FData;
    function AsString: string;
    function AsInteger: Integer;
    function AsBoolean: Boolean;
    function AsCurrency: Currency;
    function AsDateTime: TDateTime;
    function AsFloat: Double;
  end;

  THJYDataRecord = class
  private
    FList: TStrings;
    procedure Clear;
    function GetFieldValue(const FieldName: string): Variant;
    procedure SetFieldValue(const FieldName: string; Value: Variant);
    function GetCount: Integer;
    function GetFieldName(const Index: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromDataSet(DataSet: TDataSet);
    procedure CloneFrom(ADataRec: THJYDataRecord);
    function FindField(const AFieldName: string): THJYDataItem;
    property FieldValues[const FieldName: string]
      : Variant read GetFieldValue write SetFieldValue;
    property Count: Integer read GetCount;
    property FieldNames[const Index: Integer]: string read GetFieldName;
  end;

  THJYDataRecords = class
  public
    class procedure WriteToList(ADataSet: TDataSet; AFieldName: string;
      AList: TStrings);
    class procedure ClearList(AList: TStrings);
    class procedure Delete(AList: TStrings; const Index: Integer);
    class function IndexOf(AList: TStrings;
      AFieldName, AValue: string): Integer;
    class function GetDataRecord(AList: TStrings;
      Index: Integer): THJYDataRecord;
  end;

  // procedure WriteRecordToList(ADataSet: TDataSet;
  // AFieldName: string; AList: TStrings);
  // procedure ClearRecordList(AList: TStrings);
  // procedure DeleteRecord(AList: TStrings; const Index: Integer);
  // function IndexOfRecord(AList: TStrings; AFieldName, AValue: string): Integer;
  // function GetListRecord(AList: TStrings; Index: Integer): THJYDataRecord;

implementation

{ THJYDataItem }

function THJYDataItem.AsBoolean: Boolean;
begin
  if VarIsNull(FData) then
    Result := False
  else
    Result := FData;
end;

function THJYDataItem.AsCurrency: Currency;
begin
  if VarIsNull(FData) then
    Result := 0
  else
    Result := FData;
end;

function THJYDataItem.AsDateTime: TDateTime;
begin
  Result := VarToDateTime(FData);
end;

function THJYDataItem.AsFloat: Double;
begin
  if VarIsNull(FData) then
    Result := 0.0
  else
    Result := FData;
end;

function THJYDataItem.AsInteger: Integer;
begin
  if VarIsNull(FData) then
    Result := 0
  else
    Result := FData;
end;

function THJYDataItem.AsString: string;
begin
  Result := VarToStr(FData);
end;

{ THJYDataRecord }

procedure THJYDataRecord.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    FList.Objects[I].Free;
  FList.Clear;
end;

constructor THJYDataRecord.Create;
begin
  FList := TStringList.Create;
end;

destructor THJYDataRecord.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function THJYDataRecord.GetFieldValue(const FieldName: string): Variant;
var
  lItem: THJYDataItem;
begin
  lItem := FindField(FieldName);
  Result := lItem.Data;
end;

procedure THJYDataRecord.LoadFromDataSet(DataSet: TDataSet);
var
  lItem: THJYDataItem;
  I: Integer;
begin
  Clear;
  if DataSet = nil then
    Exit;
  for I := 0 to DataSet.FieldCount - 1 do
  begin
    lItem := THJYDataItem.Create;
    lItem.Data := DataSet.Fields[I].Value;
    FList.AddObject(DataSet.Fields[I].FieldName, lItem);
  end;
end;

procedure THJYDataRecord.SetFieldValue(const FieldName: string; Value: Variant);
var
  lItem: THJYDataItem;
begin
  lItem := Self.FindField(FieldName);
  if lItem <> nil then
  begin
    lItem.Data := Value;
  end
  else
  begin
    lItem := THJYDataItem.Create;
    lItem.Data := Value;
    FList.AddObject(FieldName, lItem);
  end;
end;

function THJYDataRecord.GetCount: Integer;
begin
  Result := FList.Count;
end;

function THJYDataRecord.GetFieldName(const Index: Integer): string;
begin
  Result := FList[Index];
end;

function THJYDataRecord.FindField(const AFieldName: string): THJYDataItem;
var
  Idx: Integer;
begin
  Idx := FList.IndexOf(AFieldName);
  if Idx <> -1 then
  begin
    Result := THJYDataItem(FList.Objects[Idx]);
    Exit;
  end;
  Result := nil;
  {if Result = nil then
    raise Exception.CreateFmt('×Ö¶Î[%s]²»´æÔÚ£¡', [AFieldName]);}
end;

procedure THJYDataRecord.CloneFrom(ADataRec: THJYDataRecord);
var
  I: Integer;
  LFieldName: string;
begin
  if ADataRec = nil then
    Exit;
  Clear;
  for I := 0 to ADataRec.Count - 1 do
  begin
    LFieldName := ADataRec.FieldNames[I];
    Self.FieldValues[LFieldName] := ADataRec.FieldValues[LFieldName];
  end;
end;

{ THJYDataRecords }

class procedure THJYDataRecords.WriteToList(ADataSet: TDataSet;
  AFieldName: string; AList: TStrings);
var
  LDataRec: THJYDataRecord;
  LField: TField;
  bm: TBookmark;
begin
  AList.Clear;
  if ADataSet = nil then
    Exit;
  if AFieldName = '' then
    Exit;
  if not ADataSet.Active or ADataSet.IsEmpty then
    Exit;
  LField := ADataSet.FindField(AFieldName);
  if not Assigned(LField) then
    Exit;
  bm := ADataSet.GetBookmark;
  ADataSet.DisableControls;
  AList.BeginUpdate;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      LDataRec := THJYDataRecord.Create;
      LDataRec.LoadFromDataSet(ADataSet);
      AList.AddObject(LField.AsString, TObject(LDataRec));
      ADataSet.Next;
    end;
  finally
    ADataSet.EnableControls;
    AList.EndUpdate;
    ADataSet.GotoBookmark(bm);
    ADataSet.FreeBookmark(bm);
  end;
end;

class procedure THJYDataRecords.ClearList(AList: TStrings);
var
  I: Integer;
begin
  for I := AList.Count - 1 downto 0 do
    THJYDataRecord(AList.Objects[I]).Free;
  AList.Clear;
end;

class procedure THJYDataRecords.Delete(AList: TStrings; const Index: Integer);
begin
  THJYDataRecord(AList.Objects[Index]).Free;
  AList.Delete(Index);
end;

class function THJYDataRecords.IndexOf(AList: TStrings;
  AFieldName, AValue: string): Integer;
var
  LDataRec: THJYDataRecord;
begin
  for Result := 0 to AList.Count - 1 do
  begin
    LDataRec := THJYDataRecord(AList.Objects[Result]);
    if SameText(AValue, LDataRec.FindField(AFieldName).AsString) then
      Exit;
  end;
  Result := -1;
end;

class function THJYDataRecords.GetDataRecord(AList: TStrings;
  Index: Integer): THJYDataRecord;
begin
  Result := THJYDataRecord(AList.Objects[Index]);
end;

end.

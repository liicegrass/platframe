unit HJYDBUtils;

interface

uses SysUtils, DB, superobject, DBClient, Classes, Variants, IniFiles, TypInfo;

function LoadJsonFromDataSet(ADataSet: TDataSet): ISuperObject;
function LoadJsonString(ADataSet: TDataSet): string;
function JsonToClientDataSet(ACds: TClientDataSet; AJson: ISuperObject): Boolean;
procedure GenerateClientDataSetSQLs(ACds: TClientDataSet;
  ATablename, AKeyField: string; AList: TStrings);

implementation

uses HJYUtils, HJYDataProviders;

function LoadJsonFromDataSet(ADataSet: TDataSet): ISuperObject;
var
  I: Integer;
  lName: string;
  V: Variant;
  lField: TField;
begin
  Result := SO();
  with ADataSet do
  begin
    for I := 0 to FieldCount - 1 do
    begin
      lField := Fields[I];
      lName := lField.FieldName;
      V := lField.Value;
      if not VarIsEmptyValue(V) then
        Result.O[lName] := SO(V);
    end;
  end;
end;

function LoadJsonString(ADataSet: TDataSet): string;
begin
  Result := LoadJsonFromDataSet(ADataSet).AsJSon;
end;

function JsonToClientDataSet(ACds: TClientDataSet; AJson: ISuperObject): Boolean;
var
  lIni: TIniFile;

  function GetFieldType(const Value: string): TFieldType;
  var
    lStr: string;
  begin
    lStr := Trim(lIni.ReadString('datatype', Value, ''));
    if lStr <> '' then
      Result := TFieldType(GetEnumValue(TypeInfo(TFieldType), lStr))
    else
      Result := ftUnknown;
  end;

  procedure FixFieldDefs;
  var
    I: Integer;
    lFieldDef: TFieldDef;
  begin
    for I := 0 to ACds.FieldDefs.Count - 1 do
    begin
      lFieldDef := ACds.FieldDefs[I];
      lFieldDef.Attributes := lFieldDef.Attributes - [DB.faReadonly, DB.faRequired];
    end;
  end;

  function CreateFieldDefs: Boolean;
  var
    I: Integer;
    js, jsField: ISuperObject;
    lFieldType: TFieldType;
    lSize: Integer;
  begin
    Result := False;
    ACds.Close;
    ACds.Fields.Clear;
    ACds.FieldDefs.Clear;
    ACds.FieldDefs.BeginUpdate;
    try
      js := AJson.O['ColumnList'];
      if js = nil then Exit;
      for I := 0 to js.AsArray.Length - 1 do
      begin
        jsField := js.AsArray[I].O['Original'];
        lFieldType := GetFieldType(LowerCase(jsField.S['DataType']));
        if lFieldType in [ftDateTime, ftDate, ftTime, ftTimeStamp,
          ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftLongWord,
          ftFloat, ftCurrency, ftBCD, TFieldtype.ftSingle] then
          lSize := 0
        else begin
          lSize := jsField.I['Size'];
          if lSize > 21845 then
            lSize := 21845;
        end;
        ACds.FieldDefs.Add(jsField.S['Name'], lFieldType, lSize, False);
      end;
      FixFieldDefs;
    finally
      ACds.FieldDefs.EndUpdate;
    end;
    ACds.CreateDataSet;
    if not ACds.Active then
      ACds.Active := True;
    Result := True;
  end;

  function AppendClientDataSet: Boolean;
  var
    js, jsRecord, jsField: ISuperObject;
    iRow, iCol: Integer;
    lField: TField;
  begin
    Result := False;
    js := AJson.O['RowList'];
    if js = nil then Exit;
    ACds.DisableControls;
    try
      for iRow := 0 to js.AsArray.Length - 1 do
      begin
        jsRecord := js.AsArray[iRow].O['Original'];
        ACds.Append;
        for iCol := 0 to ACds.FieldCount - 1 do
        begin
          lField := ACds.Fields[iCol];
          jsField := jsRecord.O[lField.FieldName];
          if jsField <> nil then
            lField.Text := jsField.AsString;
        end;
        ACds.Post;
      end;
      if not ACds.IsEmpty then
        ACds.First;
      Result := True;
    finally
      ACds.EnableControls;
    end;
  end;

begin
  lIni := TIniFile.Create(DataProvider.ConfigPath + 'mb.ini');
  try
    Result := False;
    if (AJson = nil) or (ACds = nil) then Exit;
    if not CreateFieldDefs then Exit;
    if not AppendClientDataSet then Exit;
    ACds.MergeChangeLog;
    Result := True;
  finally
    lIni.Free;
  end;
end;

function VarToSql(Value: Variant): string;
var
  tmp: string;
begin
  if (VarIsNull(Value)) or (VarIsEmpty(Value)) then
    Result := 'NULL'
  else
  begin
    case VarType(Value) of
      varDate:
        begin
          tmp := FormatDateTime('yyyy-mm-dd hh:mm:ss', VarToDatetime(Value));
          Result := Quotedstr(tmp);
        end;
      varString, varOleStr:
        Result := Quotedstr(Trim(VarToStr(Value)));
      varBoolean:
        begin
          if Value then
            Result := '1'
          else
            Result := '0';
        end;
      varSmallint, varInteger, varDouble, varShortInt, varInt64, varLongWord, varCurrency:
      begin
        Result := Trim(VarToStr(Value));
      end;
    else
      Result := QuotedStr(Trim(VartoStr(Value)));
    end;
  end;
end;

procedure GenerateClientDataSetSQLs(ACds: TClientDataSet;
  ATablename, AKeyField: string; AList: TStrings);
var
  lCds: TClientDataSet;
  lKeyField, lField: TField;
  lStrSql, lKeyValue, s1, s2: string;
  I: Integer;
begin
  if ACds.State in [dsInsert, dsEdit] then
    ACds.Post;
  if ACds.ChangeCount = 0 then
    Exit;
  lCds := TClientDataSet.Create(nil);
  AList.BeginUpdate;
  try
    lCds.Data := ACds.Delta;
    lCds.DisableControls;
    try
      lKeyField := lCds.FieldByName(AKeyField);
      lCds.First;
      while not lCds.Eof do
      begin
        lStrSql := '';
        case lCds.UpdateStatus of
          usUnmodified:
            lKeyValue := VarToSql(lKeyField.Value);
          usModified:
            begin
              s1 := '';
              for I := 0 to lCds.FieldCount - 1 do
              begin
                lField := lCds.Fields[I];
                //if (lField.NewValue <> Unassigned) then
                if not VarIsEmpty(lField.NewValue) then
                begin
                  if s1 = '' then
                    s1 := Trim(lField.FieldName) + '=' + VarToSql(lField.Value)
                  else
                    s1 := s1 + ', ' + Trim(lField.FieldName) + '=' + VarToSql(lField.Value);
                end;
              end;
              if s1 <> '' then
                lStrSql := Format('update %s set %s where %s=%s', [ATableName, s1, AKeyField, lKeyValue]);
            end;
          usInserted:
            begin
              s1 := '';
              s2 := '';
              for I := 0 to lCds.FieldCount -1 do
              begin
                lField := lCds.Fields[I];
                if (not lField.IsNull) then
                begin
                  if s1 = '' then
                  begin
                    s1 := Trim(lField.FieldName);
                    s2 := VarToSql(lField.Value);
                  end
                  else
                  begin
                    s1 := s1 + ', ' + Trim(lField.FieldName);
                    s2 := s2 + ', ' + VarToSql(lField.Value);
                  end;
                end;
              end;
              if s1 <> '' then
                lStrSql := 'insert into ' + ATableName + '(' + s1 + ') values (' + s2 + ')';
            end;
          usDeleted:
            begin
              lKeyValue := VarToSql(lKeyField.Value);
              lStrSql := Format('delete from %s where %s=%s', [ATableName, AKeyField, lKeyValue]);
            end;
        end;
        if lStrSql <> '' then
          AList.Add(lStrSql);
        lCds.Next;
      end;
    finally
      AList.EndUpdate;
      lCds.EnableControls;
    end;
  finally
    lCds.Free;
  end;
end;

end.

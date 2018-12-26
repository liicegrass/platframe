unit UniDBAccessesImpl;

interface

uses Windows, SysUtils, Classes, DB, Uni, HJYDBAccesses, HJYStoreProcParams,
  UniProvider, Provider, DBClient, MySQLUniProvider, SQLiteUniProvider, HJYSyncObjs;

const
  sSQLiteProvide = 'SQLite';
  sMySQLProvide = 'MySQL';

type
  TConnectionProp = record
    Provider: string;
    Server: string;
    UserName: string;
    Password: string;
    Database: string;
    Port: Integer;
    UseUnicode: Boolean;
  end;

  THJYUniDBAccess = class(TInterfacedObject, IHJYDBAccess)
  private
    FConnectionProp: TConnectionProp;
    FConnection: TUniConnection;
    FCommand: TUniQuery;
    FDspPublic: TDataSetProvider;
    FQueryPublic: TUniQuery;
    FRetMsg: string;

    FExecCS: THJYCriticalSection;
    FQueryCS: THJYCriticalSection;

    procedure SetConnectionProp(AConnProp: TConnectionProp);
    procedure DoExecSQL(AQuery: TUniQuery; ASQL: string);
    procedure DoQuery(AQuery: TUniQuery; ASQL: string);
  public
    constructor Create(AConnProp: TConnectionProp);
    destructor Destroy; override;
    procedure BeginTrans;
    procedure CommitTrans;
    procedure RollbackTrans;

    { IHJYDBAccess }
    function GetRetMsg: string;
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);

    //function Query(ACds: TClientDataSet; ASQL: string): Boolean;
    function Query(ACds: TClientDataSet; ASQL: string): Boolean; overload;
    function Query(ACdsArr: array of TClientDataSet; AList: TStrings): Boolean; overload;
    function ExecSQL(ASQL: string): Boolean;
    function ExecSQLs(AList: TStrings): Boolean;
    function ApplyUpdates(ACds: TClientDataSet; ATableName, AKeyField: string): Boolean;

    function GetSQLIntegerValue(ASQL: string; var Value: Integer): Boolean;
    function GetSQLFloatValue(ASQL: string; var Value: Double): Boolean;
    function GetSQLStringValue(ASQL: string; var Value: string): Boolean;

    procedure WriteToList(ACds: TClientDataSet; AList: TStrings);

    function ExecuteStoredProc(AStoredProcName: string;
      AParams: THJYStoreProcParams): Boolean;
    function QueryStoredProc(ACds: TClientDataSet;
      AStoredProcName: string; AParams: THJYStoreProcParams): Boolean;

    procedure ExecSQLEx(ASQL: string);
    procedure QueryEx(ACds: TClientDataSet; ASQL: string);
  end;

implementation

uses HJYLoggers, HJYDBUtils;

{ THJYUniDBAccess }

procedure THJYUniDBAccess.SetConnectionProp(AConnProp: TConnectionProp);
begin
  FConnectionProp := AConnProp;
  with FConnection do
  begin
    if Connected then
      Connected := False;
    LoginPrompt := False;
    SpecificOptions.Clear;
    ProviderName := AConnProp.Provider;
    Database := AConnProp.Database;
    // 如果数据库字符集为utf8，不设置UseUnicode属性会显示乱码
    if AConnProp.UseUnicode then
      SpecificOptions.Add(AConnProp.Provider + '.UseUnicode=True');
    if SameText(AConnProp.Provider, sSQLiteProvide) then
    begin
      // SQLite数据库加密需要通过 SQLite.EncryptionKey 属性传入密码
      SpecificOptions.Add(AConnProp.Provider + '.EncryptionKey=' + AConnProp.Password);
    end
    else
    begin
      Server := AConnProp.Server;
      Username := AConnProp.UserName;
      Password := AConnProp.Password;
      Port := AConnProp.Port;
    end;
  end;
end;

procedure THJYUniDBAccess.WriteToList(ACds: TClientDataSet; AList: TStrings);
var
  Bm: TBookmark;
begin
  AList.Clear;
  if not ACds.Active or ACds.IsEmpty then
    Exit;
  with ACds do
  begin
    Bm := GetBookmark;
    DisableControls;
    AList.BeginUpdate;
    try
      First;
      while not Eof do
      begin
        AList.Add(Fields[0].AsString);
        Next;
      end;
    finally
      AList.EndUpdate;
      EnableControls;
      GotoBookmark(Bm);
      FreeBookmark(Bm);
    end;
  end;
end;

constructor THJYUniDBAccess.Create(AConnProp: TConnectionProp);
begin
  FConnection := TUniConnection.Create(nil);

  FCommand := TUniQuery.Create(nil);
  FCommand.Connection := FConnection;

  FQueryPublic := TUniQuery.Create(nil);
  FQueryPublic.Connection := FConnection;

  FDspPublic := TDataSetProvider.Create(nil);
  FDspPublic.DataSet := FQueryPublic;

  FExecCS := THJYCriticalSection.Create;
  FQueryCS := THJYCriticalSection.Create;

  SetConnectionProp(AConnProp);
end;

destructor THJYUniDBAccess.Destroy;
begin
  FExecCS.Free;
  FQueryCS.Free;
  FDspPublic.Free;
  FCommand.Free;
  if FConnection.Connected then
    FConnection.Connected := False;
  FConnection.Free;
  inherited;
end;

procedure THJYUniDBAccess.DoExecSQL(AQuery: TUniQuery; ASQL: string);
begin
  AQuery.Close;
  AQuery.Connection := FConnection;
  AQuery.SQL.Text := ASQL;
  AQuery.ExecSQL;
end;

procedure THJYUniDBAccess.DoQuery(AQuery: TUniQuery; ASQL: string);
begin
  if AQuery.Active then
    AQuery.Close;
  AQuery.Connection := FConnection;
  AQuery.SQL.Text := ASQL;
  AQuery.Open;
end;

procedure THJYUniDBAccess.SetConnected(const Value: Boolean);
begin
  if FConnection.Connected <> Value then
    FConnection.Connected := Value;
end;

function THJYUniDBAccess.ApplyUpdates(ACds: TClientDataSet;
  ATableName, AKeyField: string): Boolean;
var
  lList: TStrings;
begin
  lList := TStringList.Create;
  try
    GenerateClientDataSetSQLs(ACds, ATableName, AKeyField, lList);
    Result := ExecSQLs(lList);
  finally
    lList.Free;
  end;
end;

procedure THJYUniDBAccess.BeginTrans;
begin
  FConnection.StartTransaction;
end;

procedure THJYUniDBAccess.CommitTrans;
begin
  FConnection.Commit;
end;

procedure THJYUniDBAccess.RollbackTrans;
begin
  FConnection.Rollback;
end;

function THJYUniDBAccess.ExecSQL(ASQL: string): Boolean;
begin
  FExecCS.Enter;
  try
    try
      DoExecSQL(FCommand, ASQL);
      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        FRetMsg := E.Message;
        RealtimeLog('ExecSQL Exception：' + E.Message);
      end;
    end;
  finally
    FExecCS.Leave;
  end;
end;

procedure THJYUniDBAccess.ExecSQLEx(ASQL: string);
var
  lvQuery: TUniQuery;
begin
  lvQuery := TUniQuery.Create(nil);
  try
    DoExecSQL(lvQuery, ASQL);
  finally
    FreeAndNil(lvQuery);
  end;
end;

function THJYUniDBAccess.ExecSQLs(AList: TStrings): Boolean;
var
  I: Integer;
begin
  FExecCS.Enter;
  try
    BeginTrans;
    try
      for I := 0 to AList.Count - 1 do
        DoExecSQL(FCommand, AList[I]);
      CommitTrans;
      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        RollbackTrans;
        FRetMsg := E.Message;
        RealtimeLog('ExecSQLs Exception：' + E.Message);
      end;
    end;
  finally
    FExecCS.Leave;
  end;
end;

function THJYUniDBAccess.ExecuteStoredProc(AStoredProcName: string;
  AParams: THJYStoreProcParams): Boolean;
begin
  Result := True;
end;

function THJYUniDBAccess.GetConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

function THJYUniDBAccess.GetRetMsg: string;
begin
  Result := FRetMsg;
end;

function THJYUniDBAccess.GetSQLFloatValue(ASQL: string; var Value: Double): Boolean;
begin
  try
    with TUniQuery.Create(nil) do
    try
      Connection := FConnection;
      SQL.Text := ASQL;
      Open;
      Value := Fields[0].AsFloat;
      Result := True;
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      FRetMsg := E.Message;
      RealtimeLog('GetSQLFloatValue Exception：' + E.Message);
    end;
  end;
end;

function THJYUniDBAccess.GetSQLIntegerValue(ASQL: string; var Value: Integer): Boolean;
begin
  try
    with TUniQuery.Create(nil) do
    try
      Connection := FConnection;
      SQL.Text := ASQL;
      Open;
      Value := Fields[0].AsInteger;
      Result := True;
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      FRetMsg := E.Message;
      RealtimeLog('GetSQLIntegerValue Exception：' + E.Message);
    end;
  end;
end;

function THJYUniDBAccess.GetSQLStringValue(ASQL: string; var Value: string): Boolean;
begin
  try
    with TUniQuery.Create(nil) do
    try
      Connection := FConnection;
      SQL.Text := ASQL;
      Open;
      Value := Fields[0].AsString;
      Result := True;
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      FRetMsg := E.Message;
      RealtimeLog('GetSQLStringValue Exception：' + E.Message);
    end;
  end;
end;

function THJYUniDBAccess.Query(ACds: TClientDataSet; ASQL: string): Boolean;
begin
  FQueryCS.Enter;
  try
    try
      if ACds.Active then
        ACds.Close;
      DoQuery(FQueryPublic, ASQL);
      ACds.Data := FDspPublic.Data;
      FQueryPublic.Close;
      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        FRetMsg := E.Message;
        RealtimeLog('Query Exception：' + E.Message);
      end;
    end;
  finally
    FQueryCS.Leave;
  end;
end;

function THJYUniDBAccess.Query(ACdsArr: array of TClientDataSet;
  AList: TStrings): Boolean;
var
  I: Integer;
begin
  Result := False;
  if AList.Count = 0 then Exit;
  if AList.Count <> (Length(ACdsArr)) then Exit;
  for I := 0 to Length(ACdsArr) - 1 do
    ACdsArr[I].Active := False;
  for I := 0 to Length(ACdsArr) - 1 do
    if Query(ACdsArr[I], AList[I]) then
      Exit;
  Result := True;
end;

procedure THJYUniDBAccess.QueryEx(ACds: TClientDataSet; ASQL: string);
var
  lvDsp: TDataSetProvider;
  lvQry: TUniQuery;
begin
  if ACds.Active then
    ACds.Close;
  lvQry := TUniQuery.Create(nil);
  lvDsp := TDataSetProvider.Create(nil);
  try
    lvDsp.DataSet := lvQry;
    DoQuery(lvQry, ASQL);
    ACds.Data := lvDsp.Data;
  finally
    FreeAndNil(lvDsp);
    FreeAndNil(lvQry);
  end;
end;

function THJYUniDBAccess.QueryStoredProc(ACds: TClientDataSet;
  AStoredProcName: string; AParams: THJYStoreProcParams): Boolean;
begin
  Result := True;
end;

end.

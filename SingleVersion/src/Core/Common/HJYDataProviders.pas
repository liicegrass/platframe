unit HJYDataProviders;

interface

uses Classes, SysUtils, HJYUserInfos, HJYDBAccesses, UniDBAccessesImpl, IniFiles;

type
  THJYDataProvider = class
  private
    FAppPath: string;          // 系统运行路径
    FConfigPath: string;       // 配置文件存放路径
    FTemplatePath: string;     // 模板文件存放路径
    FTempPath: string;         // 临时文件夹路径

    FUserInfo: THJYUserInfo;
    FConfig: TMemIniFile;

    FDBAccess: IHJYDBAccess;
    procedure CreateConnection;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Developer: Boolean;

    property AppPath: string read FAppPath;
    property ConfigPath: string read FConfigPath;
    property TemplatePath: string read FTemplatePath;
    property TempPath: string read FTempPath;

    property UserInfo: THJYUserInfo read FUserInfo;
    property Config: TMemIniFile read FConfig;
    function DBAccess: IHJYDBAccess;
  end;

var
  DataProvider: THJYDataProvider;

implementation

{ THJYDataProvider }

procedure THJYDataProvider.CreateConnection;
var
  lConnProp: TConnectionProp;
begin
  lConnProp.Provider := 'SQLite';
  lConnProp.Database := FAppPath + 'data\data.db';
  lConnProp.Password := '';
  lConnProp.UseUnicode := True;
  FDBAccess := THJYUniDBAccess.Create(lConnProp);
  FDBAccess.Connected := True;
end;

constructor THJYDataProvider.Create;
begin
  FAppPath := ExtractFilePath(ParamStr(0));
  FConfigPath := FAppPath + 'config\';
  FUserInfo := THJYUserInfo.Create;
  FConfig := TMemIniFile.Create(FConfigPath + 'config.ini');
  FTemplatePath := FAppPath + 'templates\';
  FTempPath := FAppPath + 'temp\';
  if not DirectoryExists(FTempPath) then
    ForceDirectories(FTempPath);
  CreateConnection;
end;

function THJYDataProvider.DBAccess: IHJYDBAccess;
begin
  Result := FDBAccess;
end;

destructor THJYDataProvider.Destroy;
begin
  FreeAndNil(FConfig);
  FreeAndNil(FUserInfo);
  FDBAccess := nil;
  inherited;
end;

function THJYDataProvider.Developer: Boolean;
begin
  Result := UserInfo.IsAdmin
    and (FConfig.ReadInteger('developer', 'Enabled', 0) = 1);
end;

initialization

finalization
  if Assigned(DataProvider) then
    FreeAndNil(DataProvider);

end.

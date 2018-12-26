unit HJYUpgrade;

interface

uses Windows, SysUtils, Forms;

const
  UpgradeExeName = 'upgrade.exe';
  UpdcheckDLL = 'updcheck.dll';

function CheckNewVersion: Boolean;
procedure StartUpgrade(AStartKind: string = 'A');

implementation

uses HJYUtils, HJYDataProviders;

function CheckNewVersion: Boolean;
type
  TCheckNewVersion = function: Integer; stdcall;
var
  lNewVer: TCheckNewVersion;
  DLL: Cardinal;
  lFileName: string;
begin
  Result := False;
  lFileName := DataProvider.AppPath + UpdcheckDLL;
  DLL := LoadLibrary(PChar(lFileName));
  if DLL = 0 then Exit;
  try
    lNewVer := GetProcAddress(DLL, 'CheckNewVersion');
    if Assigned(lNewVer) then
      Result := lNewVer = 1;
  finally
    FreeLibrary(DLL);
  end;
end;

procedure StartUpgrade(AStartKind: string);
const
  cParamStr = '"exe=%s;sk=%s;name=%s"';
var
  lFileName: string;
  lMainApp: string;
  lParamStr: string;
begin
  lFileName := DataProvider.AppPath + UpgradeExeName;
  if IsRunning(lFileName) then
    CloseExe(lFileName);
  lMainApp := ExtractFileName(Application.ExeName);
  (*
    调用方式：exe=DataSub.exe;sk=A;name=财务数据实时在线报送系统
    AStartKind参数描述：
        A：升级完成后自动启动主程序，一般主程序启动发现需要升级时使用
        C：启动完成后手动启动主程序，一般用在升级检测
  *)
  lParamStr := Format(cParamStr, [lMainApp, AStartKind, Application.Title]);
  RunExe(lFileName, [lParamStr]);
end;

end.

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
    ���÷�ʽ��exe=DataSub.exe;sk=A;name=��������ʵʱ���߱���ϵͳ
    AStartKind����������
        A��������ɺ��Զ�����������һ������������������Ҫ����ʱʹ��
        C��������ɺ��ֶ�����������һ�������������
  *)
  lParamStr := Format(cParamStr, [lMainApp, AStartKind, Application.Title]);
  RunExe(lFileName, [lParamStr]);
end;

end.

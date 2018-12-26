unit HJYSysInit;

interface

uses SysUtils, HJYDataProviders, Registry, Windows, Forms, Messages;

implementation

uses UDmMain, UDmImage, HJYUtils;

procedure RegisterLibs;
var
  lCmdLine: string;
  lLibName: string;
begin
  lLibName := ExtractFilePath(Application.ExeName) + 'midas.dll';
  if FileExists(lLibName) then
  begin
    lCmdLine := Format('regsvr32.exe "%s" /s', [lLibName]);
    WinExec(PAnsiChar(AnsiString(lCmdLine)), SW_HIDE);
  end;
end;

procedure InitSystemDateFormat;
var
  lReg: TRegistry;
  lpdwResult: DWORD;
begin
  lReg := TRegistry.Create;
  try
    lReg.RootKey := HKEY_CURRENT_USER;
    if lReg.OpenKey('\Control Panel\International', True) then
    begin
      lReg.WriteString('sShortDate', 'yyyy-MM-dd');
      //lReg.WriteString('sLongDate', 'yyyy''Äê''M''ÔÂ ''d''ÈÕ''');
      lReg.WriteString('sNegativeSign', '-');
      lReg.WriteString('sDate', '-');
      lReg.WriteString('sTimeFormat', 'HH:mm:ss');
      lReg.WriteString('sShortTime', 'HH:mm');
      lReg.WriteString('iTLZero', '1');
      lReg.WriteString('sTime', ':');
    end;
  finally
    lReg.Free;
  end;
  SendMessageTimeOut(HWND_BROADCAST, WM_SETTINGCHANGE, 0, 0,
    SMTO_ABORTIFHUNG, 10, lpdwResult);
end;

procedure DoInitialization;
begin
  InitSystemDateFormat;
  RegisterLibs;
  DataProvider := THJYDataProvider.Create;
  DmMain := TDmMain.Create(nil);
  DmImage := TDmImage.Create(nil);
  DmMain.LoadLocalizer(DataProvider.ConfigPath + 'DevLocal.ini');
  DmMain.LoadSysSkin(DataProvider.AppPath + 'skin\Office2013White.skinres');
end;

procedure DoFinalization;
begin
  FreeAndNil(DmImage);
  FreeAndNil(DmMain);
  FreeAndNil(DataProvider);
end;

initialization
  DoInitialization;

finalization
  DoFinalization;

end.

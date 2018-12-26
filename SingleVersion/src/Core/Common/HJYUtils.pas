unit HJYUtils;

interface

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses Windows, SysUtils, Variants, ComObj, ActiveX, ShlObj, Registry, StrUtils,
  Classes, WinSock, ShellAPI, TlHelp32, ComCtrls, DB, DBClient, Dialogs,
  cxGrid, cxGridExportLink, PsAPI;

function CreateGuidStr: string;
function GetPYM(AValue: string): string;
function AddZero(AStr: string; ALength: Integer): string;
function IsZero(const Value: Double): Boolean;
function VarToFloat(const V: Variant): Double;
function VarToFloatDef(const V: Variant; const ADefault: Double): Double;
function DateTimeStr(const Format: string = 'yyyy-mm-dd hh:mm:ss'): string;
// 获取系统特殊路径
function SysSpecialPath(CSIDL: Integer): string;
function WindowsPath: string;
function SystemPath: string;
function ProgramFilesPath: string;
function TemplatesPath: string;
function AppDataPath: string;
function DesktopPath: string;
function MyDocPath: string;
procedure OpenWinFireWall(FileNameOrPort: string; AType: string = 'exe');
procedure OpenWinFireWall_MSSQL;
function GetFileCreateTime(FileName: string): TDateTime;
function IsValidIPAddress(AStr: string): Boolean;
function GetSubCharCount(AText: string; ASubChar: Char): Integer;
function VarIsEmptyValue(const V: Variant): Boolean;
function ReplaceInvalidChar(AStr: string): string;
function TrimAll(AStr: string): string;
function Q(const S: string): string;
function GetFileSize(FileName: string): Int64;
function SplitString(const AStr, AChar: string): TStrings;
function HostToIP(Name: string; var IP: string): Boolean;
function IsChineseChar(Source: string): Boolean;
function GetBigDate(ADate: TDateTime): string;
function AddBackslash(const S: string): string;
function RemoveBackslash(S: string): string;
function DeleteDir(ADir: string): Boolean;
function IsEmptyDir(ADir: String): Boolean;
procedure GetDirFileList(ADir: string; AList: TStringList;
  const AExt: string = '*.*'; const ASubDir: Boolean = False);
function IsFileInUse(AFileName: string): Boolean;
procedure SetTreeNodeImageIndex(Node: TTreeNode);
procedure SetTreeNodeSelectedIndex(Node: TTreeNode);
function DataSetIsEmpty(DataSet: TDataSet): Boolean;
function DataSetEditing(DataSet: TDataSet): Boolean;
function ClientDataSetEdited(ACds: TClientDataSet): Boolean;
function HJYCopyFile(lpExistingFileName, lpNewFileName: string;
  bFailIfExists: Boolean): Boolean;
function ForceDir(Dir: string): Boolean;
procedure ExportToExcel(const AFileName: string; AGrid: TcxGrid);

function IsRunning(sExe: string): Boolean;
function CloseExe(sExe: string): Boolean;
function RunExe(sExe: string; arrParams:array of string): Boolean;

implementation

uses HJYDialogs;

function CreateGuidStr: string;
var
  LTep: TGUID;
begin
  CoCreateGuid(LTep);
  Result := GUIDToString(LTep);
  Result := Copy(Result, 2, Length(Result) - 2);
  Result := LowerCase(ReplaceStr(Result, '-', ''));
end;

function GetPYM(AValue: string): string;
var
  iLen, I, iAsc: Integer;
  LText: AnsiString;
  LPym, LP: string;
begin
  I := 1;
  LText := AnsiString(AValue);
  iLen := Length(LText);
  while I <= iLen do
  begin
    if Ord(LText[I]) < 122 then
    begin
      LPym := LPym + AnsiUpperCase(string(LText[I]));
      I := I + 1;
    end
    else
    begin
      iAsc := (Ord(LText[I]) - 161 + 1) * 100 + Ord(LText[I + 1]) - 161 + 1;
      case iAsc of
        1601 .. 1636: LP := 'A';
        1637 .. 1832: LP := 'B';
        1833 .. 2078: LP := 'C';
        2079 .. 2273: LP := 'D';
        2274 .. 2301: LP := 'E';
        2302 .. 2432: LP := 'F';
        2433 .. 2593: LP := 'G';
        2594 .. 2786: LP := 'H';
        2787 .. 3105: LP := 'J';
        3106 .. 3211: LP := 'K';
        3212 .. 3471: LP := 'L';
        3472 .. 3634: LP := 'M';
        3635 .. 3721: LP := 'N';
        3722 .. 3729: LP := 'O';
        3730 .. 3857: LP := 'P';
        3858 .. 4026: LP := 'Q';
        4027 .. 4085: LP := 'R';
        4086 .. 4389: LP := 'S';
        4390 .. 4557: LP := 'T';
        4558 .. 4683: LP := 'W';
        4684 .. 4924: LP := 'X';
        4925 .. 5248: LP := 'Y';
        5249 .. 5589: LP := 'Z';
      else
        LP := '';
      end;
      LPym := LPym + LP;
      I := I + 2
    end;
  end;
  Result := LPym;
end;

function AddZero(AStr: string; ALength: Integer): string;
var
  lLength, I: Integer;
begin
  Result := AStr;
  lLength := Length(Result);
  if lLength >= ALength then Exit;
  for I := 1 to ALength - lLength do
    Result := '0' + Result;
end;

function IsZero(const Value: Double): Boolean;
begin
  Result := Abs(Value) < 0.00000000001;
end;

function VarToFloatDef(const V: Variant; const ADefault: Double): Double;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := ADefault;
end;

function VarToFloat(const V: Variant): Double;
begin
  Result := VarToFloatDef(V, 0);
end;

function DateTimeStr(const Format: string = 'yyyy-mm-dd hh:mm:ss'): string;
begin
  Result := FormatDateTime(Format, Now);
end;

function SysSpecialPath(CSIDL: Integer): string;
var
  RecPath: PWideChar;
begin
  RecPath := StrAlloc(MAX_PATH);
  try
    FillChar(RecPath^, MAX_PATH, 0);
    if SHGetSpecialFolderPath(0, RecPath, CSIDL, False) then
    begin
      Result := RecPath;
      if RightStr(Result, 1) <> PathDelim then
        Result := Result + PathDelim;
    end
    else
      Result := '';
  finally
    StrDispose(RecPath);
  end;
end;

function WindowsPath: string;
begin
  Result := SysSpecialPath(CSIDL_WINDOWS);
end;

function SystemPath: string;
begin
  Result := SysSpecialPath(CSIDL_SYSTEMX86);
end;

function ProgramFilesPath: string;
begin
  Result := SysSpecialPath(CSIDL_PROGRAM_FILES);
end;

function TemplatesPath: string;
begin
  Result := SysSpecialPath(CSIDL_COMMON_TEMPLATES);
end;

function AppDataPath: string;
begin
  Result := SysSpecialPath(CSIDL_APPDATA);
end;

function DesktopPath: string;
begin
  Result := SysSpecialPath(CSIDL_DESKTOP);
end;

function MyDocPath: string;
begin
  Result := SysSpecialPath(CSIDL_PERSONAL);
end;

procedure OpenWinFireWall(FileNameOrPort: string; AType: string = 'exe' {app/port});
var
  KeyDir, KeyName, KeyValue: string;
begin
  if AType = 'exe' then
  begin
    KeyDir := 'SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List';
    KeyName := FileNameOrPort;
    KeyValue := FileNameOrPort + ':*:Enabled: ' + ChangeFileExt(ExtractFileName(FileNameOrPort), '');
  end
  else if AType = 'port' then
  begin
    KeyDir := 'SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List';
    if Pos(':', FileNameOrPort) = 0 then
      KeyName := FileNameOrPort + ':TCP'
    else
      KeyName := FileNameOrPort;
    KeyValue := KeyName + ':*:Enabled: ' + StringReplace(KeyName, ':', '_', []);
  end;
  with TRegistry.Create do
  try
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(KeyDir, True) then
        WriteString(KeyName, KeyValue);
      CloseKey;
    except
    end;
  finally
    Free;
  end;
end;

procedure OpenWinFireWall_MSSQL;
begin
  try
    OpenWinFireWall('1433:TCP', 'port');
    OpenWinFireWall('1434:TCP', 'port');
    OpenWinFireWall(ParamStr(0), 'exe');
    OpenWinFireWall('C:\Program Files\MSDE\MSSQLManager.exe', 'exe');
    OpenWinFireWall('C:\Program Files\MSDE\MSSQLManager.exe', 'exe');
    OpenWinFireWall('C:\Program Files\MSDE\MSSQL\Binn\sqlservr.exe', 'exe');
  except
  end;
end;

function GetFileCreateTime(FileName: string): TDateTime;
var
  SR: TSearchRec;
  ST: TSystemTime;
begin
  Result:=0;
  if FindFirst(FileName, faAnyfile, SR) = 0 Then
  try
    FileTimeToSystemTime(SR.FindData.ftCreationTime, ST);
    Result := SystemTimeToDateTime(ST);
  finally
    FindClose(SR);
  end
end;

function IsValidIPAddress(AStr: string): Boolean;
var
  I, iCount, iLen, iPos, iValue: Integer;
begin
  Result := False;
  iLen := Length(AStr);
  iCount := 0;
  for I := 1 to iLen do
    if AStr[I] = '.' then
      Inc(iCount);
  if iCount <> 3 then
    Exit;
  AStr := AStr + '.';
  for I := 3 downto 0 do
  begin
    iPos := Pos('.', AStr);
    iValue := StrToIntDef(Copy(AStr, 1, iPos - 1), -1);
    if not iValue in [0..255] then
      Exit;
    AStr := Copy(AStr, iPos + 1, iLen);
  end;
  Result := True;
end;

function GetSubCharCount(AText: string; ASubChar: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AText) do
    if AText[I]= ASubChar then
      Inc(Result);
end;

function VarIsEmptyValue(const V: Variant): Boolean;
begin
   Result := VarIsEmpty(V) or VarIsNull(V);
end;

function ReplaceInvalidChar(AStr: string): string;
begin
  Result := AStr;
  Result := StringReplace(Result, '\', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ':', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '*', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '?', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '"', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '>', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '|', '_', [rfReplaceAll, rfIgnoreCase]);
end;

function TrimAll(AStr: string): string;
begin
  Result := StringReplace(AStr, ' ', '', [rfReplaceAll]);
end;

function Q(const S: string): string;
begin
  Result := QuotedStr(S);
end;

function GetFileSize(FileName: string): Int64;
var
  F: file of Byte;
  Size: Longint;
begin
  AssignFile(F, FileName);
  Reset(F);
  Size := System.FileSize(F);
  Result := Size ;
  CloseFile(f);
end;

function SplitString(const AStr, AChar: string): TStrings;
var
  temp, t2: string;
  I: Integer;
begin
  Result := TStringList.Create;
  temp := AStr;
  I := Pos(AChar, AStr);
  while I <> 0 do
  begin
    t2 := copy(temp, 0, I - 1);
    if (t2 <> '') then
      Result.Add(t2);
    Delete(temp, 1, I - 1 + Length(AChar));
    I := Pos(AChar, temp);
  end;
  if temp <> '' then
    Result.Add(temp);
end;

function HostToIP(Name: string; var IP: string): Boolean;
var
  wsdata : TWSAData;
  hostName: array [0..255] of AnsiChar;
  hostEnt: PHostEnt;
  addr: PAnsiChar;
begin
  WSAStartup($0101, wsdata);
  try
    gethostname(hostName, SizeOf(hostName));
    StrPCopy(hostName, AnsiString(Name));
    hostEnt := gethostbyname(hostName);
    if Assigned(hostEnt) then
    begin
      if Assigned(hostEnt^.h_addr_list) then
      begin
        addr := hostEnt^.h_addr_list^;
        if Assigned(addr) then
        begin
          IP := Format('%d.%d.%d.%d', [Byte(addr[0]),
            Byte(addr[1]), Byte(addr[2]), Byte(addr[3])]);
          Result := True;
        end
        else
          Result := False;
      end
      else
        Result := False
    end else begin
      Result := False;
    end;
  finally
    WSACleanup;
  end
end;

function IsChineseChar(Source: string): Boolean;
begin
  Result:= ((Word(Source[1]) shl 8 + Word(Source[2])) >= $B0A1) and
    ((Word(Source[1]) shl 8 + Word(Source[2])) <= $D7F9);
end;

function GetBigDate(ADate: TDateTime): string;
const
  ArrBigDate: array[0..10] of string = ('〇', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十');
var
  tmpStr: string;
begin
  tmpStr := FormatDateTime('yyyymmdd', ADate);
  Result := ArrBigDate[StrToInt(tmpStr[1])];
  Result := Result + ArrBigDate[StrToInt(tmpStr[2])];
  Result := Result + ArrBigDate[StrToInt(tmpStr[3])];
  Result := Result + ArrBigDate[StrToInt(tmpStr[4])];
  Result := Result + '年';

  if StrToInt(tmpStr[5]) > 0 then
  begin
    if StrToInt(tmpStr[5]) > 1 then
      Result := Result + ArrBigDate[StrToInt(tmpStr[5])];
    Result := Result + ArrBigDate[10];
  end;
  if StrToInt(tmpStr[6]) > 0 then
    Result := Result + ArrBigDate[StrToInt(tmpStr[6])];
  Result := Result + '月';

  if StrToInt(tmpStr[7]) > 0 then
  begin
    if StrToInt(tmpStr[7]) > 1 then
      Result := Result + ArrBigDate[StrToInt(tmpStr[7])];
    Result := Result + ArrBigDate[10];
  end;
  if StrToInt(tmpStr[8]) > 0 then
    Result := Result + ArrBigDate[StrToInt(tmpStr[8])];
  Result := Result + '日';
end;

function AddBackslash(const S: string): string;
begin
  if (Length(S) >= 1) and (S[Length(S)] <> PathDelim) then
    Result := S + PathDelim
  else
    Result := S;
end;

function RemoveBackslash(S: string): string;
begin
  S := AddBackslash(S);
  if (Length(S) > 3) and (S[2] = ':') then
    Delete(S, Length(S), 1)
  else
    S := S + '.';
  Result := S
end;

function DeleteDir(ADir: string): Boolean;
var
  shFS: TSHFileOpStruct;
begin
  // 必须要先将最后一个“\”删除，否则xp系统出错
  ADir := RemoveBackslash(ADir);
  if not DirectoryExists(ADir) then
  begin
    Result := True;
    Exit;
  end;
  ZeroMemory(@shFS, SizeOf(shFS));
  with shFS do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    // 这里最后必须要 + #0  否则不能正常删除
    pFrom := PChar(ADir + #0);
    pTo := nil;
    fFlags := FOF_NOCONFIRMATION + FOF_SILENT + FOF_NOERRORUI;
    hNameMappings := nil;
    lpszProgressTitle := '';
    fAnyOperationsAborted := False;
  end;
  Result := SHFileOperation(shFS) = 0;
end;

function IsEmptyDir(ADir: String): Boolean;
var
  sr: TSearchRec;
begin
  Result := True;
  ADir := AddBackslash(ADir);
  if FindFirst(ADir + '*.*', faAnyFile, sr) = 0 then
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        Result := False;
        Break;
      end;
    until FindNext(sr) <> 0;
  SysUtils.FindClose(sr);
end;

procedure GetDirFileList(ADir: string; AList: TStringList;
  const AExt: string = '*.*'; const ASubDir: Boolean = False);
var
  sr: TSearchRec;
begin
  ADir := AddBackslash(ADir);
  if FindFirst(ADir + AExt, faAnyFile, sr) = 0 then
    repeat
      if (sr.Attr = faDirectory) then
      begin
        if (sr.Name <> '.') and (sr.Name <> '..') then
          if ASubDir then
            GetDirFileList(ADir + sr.Name, AList, AExt, ASubDir);
      end else begin
        AList.Add(sr.Name);
      end;
    until FindNext(sr) <> 0;
  SysUtils.FindClose(sr);
end;

function KillTask(AExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(AExeFileName))
      or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(AExeFileName))) then
    Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE,
      BOOL(0), FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function IsFileInUse(AFileName: string): Boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(AFileName) then
    Exit;
  HFileRes := CreateFile(PChar(AFileName),
    GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;

procedure SetTreeNodeImageIndex(Node: TTreeNode);
begin
  if Node.HasChildren then
  begin
    if Node.Expanded then
      Node.ImageIndex := 1
    else
      Node.ImageIndex := 0;
  end else begin
    if Node.Selected then
      Node.ImageIndex := 3
    else
      Node.ImageIndex := 2;
  end;
end;

procedure SetTreeNodeSelectedIndex(Node: TTreeNode);
begin
  if Node.HasChildren then
  begin
    if Node.Expanded then
      Node.SelectedIndex := 1
    else
      Node.SelectedIndex := 0;
  end else begin
    Node.SelectedIndex := 3;
  end;
end;

function DataSetIsEmpty(DataSet: TDataSet): Boolean;
begin
  Result := not DataSet.Active or DataSet.IsEmpty;
end;

function DataSetEditing(DataSet: TDataSet): Boolean;
begin
  Result := DataSet.State in dsEditModes;
end;

function ClientDataSetEdited(ACds: TClientDataSet): Boolean;
begin
  Result := ACds.ChangeCount > 0;
end;

function HJYCopyFile(lpExistingFileName, lpNewFileName: string;
  bFailIfExists: Boolean): Boolean;
begin
  Result := Windows.CopyFile(PWideChar(lpExistingFileName),
    PWideChar(lpNewFileName), bFailIfExists);
end;

function ForceDir(Dir: string): Boolean;
begin
  Result := ForceDirectories(Dir);
end;

procedure ExportToExcel(const AFileName: string; AGrid: TcxGrid);
var
  Dlg: TSaveDialog;
begin
  Dlg := TSaveDialog.Create(nil);
  try
    Dlg.Title := '导出Excel';
    Dlg.Filter := 'Excel文件|(*.xls)';
    Dlg.DefaultExt := 'xls';
    Dlg.Options := Dlg.Options + [ofOverwritePrompt];
    Dlg.FileName := AFileName;
    if not Dlg.Execute then Exit;
    ExportGridToExcel(Dlg.FileName, AGrid, True, True, True);
    ShowMsg('“' + Dlg.FileName + '”导出完成！');
  finally
    Dlg.Free;
  end;
end;

function IsRunning(sExe: string): Boolean;
var
  hSnapshot: THandle;
  lppe     : TProcessEntry32;
  bFound   : Boolean;
begin
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    lppe.dwSize := SizeOf(TProcessEntry32);
    bFound := Process32First(hSnapshot, lppe);
    while bFound do
    begin
      if SameText(ExtractFileName(lppe.szExeFile), ExtractFileName(sExe))
        or SameText(lppe.szExeFile, sExe) then
      begin
        Result := True;
        Exit;
      end;
      bFound := Process32Next(hSnapshot, lppe);
    end;
    Result := False;
  finally
    CloseHandle(hSnapshot);
  end;
end;

function CloseExe(sExe: string): Boolean;
var
  pidArray: array[0..$3FFF-1] of DWORD;
  nCount: DWORD;
  pList: array of DWORD;
  iProNum: Integer;
  proFilename: array[0..MAX_PATH] of char;
  iIndex: Integer;
  ProcHand: THandle;
  sPath: string;
  iClosed: Integer;
begin
  Result := False;
  iClosed := 0;
  if not EnumProcesses(@pidArray, SizeOf(pidArray), nCount) then
    Exit;
  iProNum := nCount Div SizeOf(DWORD);
  SetLength(pList, iProNum);
  Move(pidArray, pList[0], nCount);
  for iIndex := Low(pList) to High(pList) do
  begin
    ProcHand := OpenProcess(PROCESS_QUERY_INFORMATION
      or PROCESS_VM_READ, False, pList[iIndex]);
    if ProcHand > 0 then
    begin
      GetModuleFileNameEx(ProcHand, Cardinal(nil),
        proFilename, SizeOf(proFilename));
      sPath := StrPas(proFilename);
      if SameText(ExtractFileName(sPath), sExe) or
        SameText(sPath, UpperCase(sExe)) then
      begin
        procHand := OpenProcess(PROCESS_TERMINATE, BOOL(0), pList[iIndex]);
        iClosed := Integer(TerminateProcess(procHand, 0));
        Break;
      end;
    end;
  end;
  if iClosed = 0 then
    Result := False
  else
    Result := True;
end;

function RunExe(sExe: string; arrParams:array of string): Boolean;
var
  recTsi : TStartupInfo;
  recTpi : TProcessInformation;
  sParam : string;
  nInteger : Integer;
begin
  Result := False;
  if not FileExists(sExe) then
    Exit;
  sParam := '';
  for nInteger := 0 to Length(arrParams) - 1 do
    sParam := sParam + ' ' + arrParams[nInteger];
  FillChar(recTsi, SizeOf(TStartupInfo), 0);
  recTsi.cb := SizeOf(TStartupInfo);
  recTsi.wShowWindow := SW_SHOW;
  recTsi.dwFlags := STARTF_USESHOWWINDOW;
  if CreateProcess(PChar(sExe), PChar('"' + sExe + '"' + sParam),
    nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, recTsi, recTpi) then
    Result := True;
  CloseHandle(recTpi.hProcess);
  CloseHandle(recTpi.hThread);
end;

end.

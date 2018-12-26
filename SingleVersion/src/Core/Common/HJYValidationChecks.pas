unit HJYValidationChecks;

interface

uses Windows, SysUtils, Classes, IniFiles, DateUtils;

type
  TTrialVersionCheck = class
  private
    FSystemPath: string;
    FTimeFileA: string;        // 保存的第一个时间文件
    FTimeFileB: string;        // 保存的第二个时间文件
    FScyxDateA: TDateTime;
    FScyxDateB: TDateTime;
    procedure SaveFirstRunFile;
    procedure WriteScyxDate(AFileName: string; AValue: TDateTime);
    function GetScyxDate(AFileName: string): TDateTime;
    function IsFirstRun: Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Execute: Boolean;
  end;

  function TrialVersionCheck: Boolean;

implementation

uses HJYUtils;

function TrialVersionCheck: Boolean;
var
  lCheck: TTrialVersionCheck;
begin
  lCheck := TTrialVersionCheck.Create;
  try
    Result := lCheck.Execute;
  finally
    lCheck.Free;
  end;
end;

const
  CJXC_VER_SECTION = 'yscmb';
  CJXC_VER_IdentName = 'scyx';
  CJXC_Trial_DayCount = 45;

{ TTrialVersionCheck }

constructor TTrialVersionCheck.Create;
begin
  FSystemPath := SystemPath;
  FTimeFileA := FSystemPath + 'jha.dll';
  FTimeFileB := FSystemPath + 'wjhb.dll';
end;

function TTrialVersionCheck.IsFirstRun: Boolean;
begin
  Result := not FileExists(FTimeFileA) and not FileExists(FTimeFileB);
end;

function TTrialVersionCheck.GetScyxDate(AFileName: string): TDateTime;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(AFileName);
  try
    Result :=  lIni.ReadDate(CJXC_VER_SECTION, CJXC_VER_IdentName, 0);
  finally
    lIni.Free;
  end;
end;

procedure TTrialVersionCheck.WriteScyxDate(AFileName: string;
  AValue: TDateTime);
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(AFileName);
  try
    lIni.WriteDate(CJXC_VER_SECTION, CJXC_VER_IdentName, AValue);
  finally
    lIni.Free;
  end;
end;

procedure TTrialVersionCheck.SaveFirstRunFile;
begin
  WriteScyxDate(FTimeFileA, Date);
  WriteScyxDate(FTimeFileB, Date);
end;

destructor TTrialVersionCheck.Destroy;
begin

  inherited;
end;

function TTrialVersionCheck.Execute: Boolean;
begin
  Result := False;

  // 如果是首次运行，则需要创建两个文件，并记录当前日期
  if IsFirstRun then
  begin
    SaveFirstRunFile;
    Result := True;
    Exit;
  end;

  // 如果两个文件有一个不存在，则需要复制一份
  if not FileExists(FTimeFileA) and FileExists(FTimeFileB) then
    CopyFile(PWideChar(FTimeFileB), PWideChar(FTimeFileA), False);

  if FileExists(FTimeFileA) and not FileExists(FTimeFileB) then
    CopyFile(PWideChar(FTimeFileA), PWideChar(FTimeFileB), False);

  // 分别获取两个文件记录的日期，如果日期不一致则统一更新为较小的那个日期
  FScyxDateA := GetScyxDate(FTimeFileA);
  FScyxDateB := GetScyxDate(FTimeFileB);
  if FScyxDateA > FScyxDateB then
  begin
    WriteScyxDate(FTimeFileA, FScyxDateB);
    FScyxDateA := FScyxDateB;
  end else if FScyxDateA < FScyxDateB then
  begin
    WriteScyxDate(FTimeFileB, FScyxDateA);
    FScyxDateB := FScyxDateA;
  end;

  // 如果记录的首次运行日期大于当前系统日期，认为已经超出试用期
  if FScyxDateA > Date then
    Exit;

  // 计算首次运行的日期跟当前日期天数差额，如果大于允许的试用期，已经超出试用期
  if DaysBetween(FScyxDateA, Date) > CJXC_Trial_DayCount then
    Exit;

  Result := True;
end;

end.

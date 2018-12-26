unit HJYValidationChecks;

interface

uses Windows, SysUtils, Classes, IniFiles, DateUtils;

type
  TTrialVersionCheck = class
  private
    FSystemPath: string;
    FTimeFileA: string;        // ����ĵ�һ��ʱ���ļ�
    FTimeFileB: string;        // ����ĵڶ���ʱ���ļ�
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

  // ������״����У�����Ҫ���������ļ�������¼��ǰ����
  if IsFirstRun then
  begin
    SaveFirstRunFile;
    Result := True;
    Exit;
  end;

  // ��������ļ���һ�������ڣ�����Ҫ����һ��
  if not FileExists(FTimeFileA) and FileExists(FTimeFileB) then
    CopyFile(PWideChar(FTimeFileB), PWideChar(FTimeFileA), False);

  if FileExists(FTimeFileA) and not FileExists(FTimeFileB) then
    CopyFile(PWideChar(FTimeFileA), PWideChar(FTimeFileB), False);

  // �ֱ��ȡ�����ļ���¼�����ڣ�������ڲ�һ����ͳһ����Ϊ��С���Ǹ�����
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

  // �����¼���״��������ڴ��ڵ�ǰϵͳ���ڣ���Ϊ�Ѿ�����������
  if FScyxDateA > Date then
    Exit;

  // �����״����е����ڸ���ǰ���������������������������ڣ��Ѿ�����������
  if DaysBetween(FScyxDateA, Date) > CJXC_Trial_DayCount then
    Exit;

  Result := True;
end;

end.

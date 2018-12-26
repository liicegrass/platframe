unit HJYVersionInfos;

interface

uses Windows, Classes, SysUtils;

type
  THJYVersionInfoField = (vifCompanyName, vifFileDescription, vifFileVersion,
    vifInternalName, vifCopyright, vifTrademarks, vifOriginalFilename,
    vifProductName, vifProductVersion, vifComments);

  THJYVersionInfo = class(TObject)
  private
    FFilePath: string;
    FVersionInfo: TStringList;
    FVersionInfoAvailable: Boolean;
    FStatusList: TList;
    FVersionNumbers: array [1 .. 4] of Word;
    FModuleAttributes: array [1 .. 4] of Boolean;
  protected
    procedure GetVersionInfo;
    function GetField(Index: Integer): string;
    function GetVerField(Index: THJYVersionInfoField): string;
    function GetVersionNumber(Index: Integer): Word;
    function GetModuleAttribute(Index: Integer): Boolean;
    function GetFileDateTime: TDateTime;
    procedure SetFilePath(const Value: string); virtual;
    property Fields[Index: THJYVersionInfoField]: string read GetVerField; default;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetCustomKeyValue(const Key: string): string;
    property VersionInfoAvailable: Boolean read FVersionInfoAvailable;
    // vifCompanyName
    property CompanyName: string index 0 read GetField;
    // vifFileDescription
    property FileDescription: string index 1 read GetField;
    // vifFileVersion
    property FileVersion: string index 2 read GetField;
    // vifInternalName
    property InternalName: string index 3 read GetField;
    // vifCopyright
    property Copyright: string index 4 read GetField;
    // vifTrademarks
    property Trademarks: string index 5 read GetField;
    // vifOriginalFilename
    property OriginalFilename: string index 6 read GetField;
    // vifProductName
    property ProductName: string index 7 read GetField;
    // vifProductVersion
    property ProductVersion: string index 8 read GetField;
    // vifComments
    property Comments: string index 9 read GetField;
    // Version Numbers
    property MajorVersion: Word index 1 read GetVersionNumber;
    property MinorVersion: Word index 2 read GetVersionNumber;
    property Release: Word index 3 read GetVersionNumber;
    property Build: Word index 4 read GetVersionNumber;
    // Module Attributes
    property DebugBuild: Boolean index 1 read GetModuleAttribute;
    property PreRelease: Boolean index 2 read GetModuleAttribute;
    property PrivateBuild: Boolean index 3 read GetModuleAttribute;
    property SpecialBuild: Boolean index 4 read GetModuleAttribute;
    property FileDateTime: TDateTime read GetFileDateTime;

    property FilePath: string read FFilePath write SetFilePath;
  end;

implementation

constructor THJYVersionInfo.Create;
begin
  FFilePath := '';
  FVersionInfo := TStringList.Create;
  GetVersionInfo;
end;

destructor THJYVersionInfo.Destroy;
begin
  FVersionInfo.Free;
  if FStatusList <> nil then
  begin
    FStatusList.Free;
    FStatusList := nil;
  end;
  inherited;
end;

procedure THJYVersionInfo.GetVersionInfo;
const
  SNotAvailable = 'Value Not Available';
var
  LanguageID: string;
  CodePage: string;
  TranslationLength: Cardinal;
  TranslationTable: Pointer;
  InfoSize, Temp, Len: DWord;
  InfoBuf: Pointer;
  CompanyName, FileDescription, FileVersion, InternalName, LegalCopyright: string;
  LegalTradeMarks, OriginalFilename, ProductName, ProductVersion, Comments: string;
  MajorVersion, MinorVersion, Release, Build: Word;
  DebugBuild, PreRelease, PrivateBuild, SpecialBuild: Boolean;
  Value: PChar;
  FileInfo: PVSFixedFileInfo;
  LookupString: string;
  PathStz: array [0 .. MAX_PATH] of Char;
begin
  if FFilePath = '' then
  begin
    GetModuleFileName(HInstance, PathStz, SizeOf(PathStz));
    FFilePath := PathStz;
  end;
  MajorVersion := 0;
  MinorVersion := 0;
  Release := 0;
  Build := 0;
  DebugBuild := False;
  PreRelease := False;
  PrivateBuild := False;
  SpecialBuild := False;
  InfoSize := GetFileVersionInfoSize(PChar(FFilePath), Temp);
  FVersionInfoAvailable := InfoSize > 0;
  if FVersionInfoAvailable then
  begin
    InfoBuf := AllocMem(InfoSize);
    try
      GetFileVersionInfo(PChar(FFilePath), 0, InfoSize, InfoBuf);
      if VerQueryValue(InfoBuf, '\VarFileInfo\Translation', TranslationTable, TranslationLength) then
      begin
        CodePage := Format('%.4x', [HiWord(PLongInt(TranslationTable)^)]);
        LanguageID := Format('%.4x', [LoWord(PLongInt(TranslationTable)^)]);
      end;
      LookupString := 'StringFileInfo\' + LanguageID + CodePage + '\';
      if VerQueryValue(InfoBuf, PChar(LookupString + 'CompanyName'), Pointer(Value), Len) then
        CompanyName := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'FileDescription'), Pointer(Value), Len) then
        FileDescription := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'FileVersion'), Pointer(Value), Len) then
        FileVersion := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'InternalName'), Pointer(Value), Len) then
        InternalName := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'LegalCopyright'), Pointer(Value), Len) then
        LegalCopyright := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'LegalTrademarks'), Pointer(Value), Len) then
        LegalTradeMarks := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'OriginalFilename'), Pointer(Value), Len) then
        OriginalFilename := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'ProductName'), Pointer(Value), Len) then
        ProductName := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'ProductVersion'), Pointer(Value), Len) then
        ProductVersion := Value;
      if VerQueryValue(InfoBuf, PChar(LookupString + 'Comments'), Pointer(Value), Len) then
        Comments := Value;
      // Get File Info: Version Numbers and Module Attributes
      if VerQueryValue(InfoBuf, '\', Pointer(FileInfo), Len) then
      begin
        MajorVersion := FileInfo^.dwFileVersionMS shr 16;
        MinorVersion := FileInfo^.dwFileVersionMS and $FFFF;
        Release := FileInfo^.dwFileVersionLS shr 16;
        Build := FileInfo^.dwFileVersionLS and $FFFF;
        DebugBuild := (FileInfo^.dwFileFlags and VS_FF_DEBUG) <> 0;
        PreRelease := (FileInfo^.dwFileFlags and VS_FF_PRERELEASE) <> 0;
        PrivateBuild := (FileInfo^.dwFileFlags and VS_FF_PRIVATEBUILD) <> 0;
        SpecialBuild := (FileInfo^.dwFileFlags and VS_FF_SPECIALBUILD) <> 0;
      end;
    finally
      FreeMem(InfoBuf, InfoSize);
    end;
  end
  else
  begin
    CompanyName := SNotAvailable;
    FileDescription := SNotAvailable;
    FileVersion := SNotAvailable;
    InternalName := SNotAvailable;
    LegalCopyright := SNotAvailable;
    LegalTradeMarks := SNotAvailable;
    OriginalFilename := SNotAvailable;
    ProductName := SNotAvailable;
    ProductVersion := SNotAvailable;
    Comments := SNotAvailable;
  end;
  FVersionInfo.Clear;
  FVersionInfo.Add(CompanyName);
  FVersionInfo.Add(FileDescription);
  FVersionInfo.Add(FileVersion);
  FVersionInfo.Add(InternalName);
  FVersionInfo.Add(LegalCopyright);
  FVersionInfo.Add(LegalTradeMarks);
  FVersionInfo.Add(OriginalFilename);
  FVersionInfo.Add(ProductName);
  FVersionInfo.Add(ProductVersion);
  FVersionInfo.Add(Comments);
  FVersionNumbers[1] := MajorVersion;
  FVersionNumbers[2] := MinorVersion;
  FVersionNumbers[3] := Release;
  FVersionNumbers[4] := Build;
  FModuleAttributes[1] := DebugBuild;
  FModuleAttributes[2] := PreRelease;
  FModuleAttributes[3] := PrivateBuild;
  FModuleAttributes[4] := SpecialBuild;
end;

function THJYVersionInfo.GetCustomKeyValue(const Key: string): string;
const
  SNotAvailable = 'Value Not Available';
var
  LanguageID: string;
  CodePage: string;
  TranslationLength: Cardinal;
  TranslationTable: Pointer;
  InfoSize, Temp, Len: DWord;
  InfoBuf: Pointer;
  Value: PChar;
  LookupString: string;
  PathStz: array [0 .. MAX_PATH] of Char;
begin
  // Get File Version Information
  if FFilePath = '' then
  begin
    GetModuleFileName(HInstance, PathStz, SizeOf(PathStz));
    FFilePath := PathStz;
  end;
  InfoSize := GetFileVersionInfoSize(PChar(FFilePath), Temp);
  FVersionInfoAvailable := InfoSize > 0;
  if FVersionInfoAvailable then
  begin
    InfoBuf := AllocMem(InfoSize);
    try
      GetFileVersionInfo(PChar(FFilePath), 0, InfoSize, InfoBuf);
      if VerQueryValue(InfoBuf, '\VarFileInfo\Translation', TranslationTable, TranslationLength) then
      begin
        CodePage := Format('%.4x', [HiWord(PLongInt(TranslationTable)^)]);
        LanguageID := Format('%.4x', [LoWord(PLongInt(TranslationTable)^)]);
      end;
      LookupString := 'StringFileInfo\' + LanguageID + CodePage + '\';
      if VerQueryValue(InfoBuf, PChar(LookupString + Key), Pointer(Value), Len) then
        Result := Value
      else
        Result := SNotAvailable;
    finally
      FreeMem(InfoBuf, InfoSize);
    end;
  end
  else
    Result := SNotAvailable;
end;

function THJYVersionInfo.GetField(Index: Integer): string;
begin
  Result := FVersionInfo[Index]
end;

function THJYVersionInfo.GetVerField(Index: THJYVersionInfoField): string;
begin
  Result := GetField(Ord(Index));
end;

function THJYVersionInfo.GetVersionNumber(Index: Integer): Word;
begin
  Result := FVersionNumbers[Index];
end;

function THJYVersionInfo.GetModuleAttribute(Index: Integer): Boolean;
begin
  Result := FModuleAttributes[Index];
end;

function THJYVersionInfo.GetFileDateTime: TDateTime;
var
  DT: TDateTime;
begin
  if FileAge(ParamStr(0), DT) then
    Result := DT
  else
    Result := 0;
end;

procedure THJYVersionInfo.SetFilePath(const Value: string);
begin
  if FFilePath <> Value then
  begin
    FFilePath := Value;
    GetVersionInfo;
  end;
end;

end.

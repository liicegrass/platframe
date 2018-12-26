unit HJYLoggers;

interface

uses Windows, SysUtils, Classes, HJYSyncObjs;

type
  TSilentFileStream = class(TFileStream)
  private
    FHandleValid: Boolean;
  public
    constructor Create(const FileName: string; Mode: Word); overload;
    constructor Create(const FileName: string); overload;
    property HandleValid: Boolean read FHandleValid;
  end;

  THJYCustomLogger = class(TObject)
  private
    FCS: THJYCriticalSection;
    FMaxSize: Int64;
  protected
    FFileName: string;
    procedure DoLog(const Text: string); virtual; abstract;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    procedure Log(const Msg: string; const Name: string = ''; const Sep: string = '');
    property MaxSize: Int64 read FMaxSize write FMaxSize;
  end;

  THJYRealtimeLogger = class(THJYCustomLogger)
  protected
    procedure DoLog(const Text: string); override;
  end;

  THJYBufferedLogger = class(THJYCustomLogger)
  private
    FBuffer: string;
    FLoaded: Boolean;
    procedure LoadFromFile;
    procedure SaveToFile;
  protected
    procedure DoLog(const Text: string); override;
    function BufferDecode(const Raw: RawByteString): UTF8String; virtual;
    function BufferEncode(const Buffer: UTF8String): RawByteString; virtual;
  public
    destructor Destroy; override;
    procedure UpdateFile;
  end;

procedure RealtimeLog(const AMsg: string;
  const AName: string = ''; const ASep: string = '');
procedure BufferedLog(const AMsg: string;
  const AName: string = ''; const ASep: string = '');

implementation

const
  soFromBeginning = 0;
  soFromCurrent = 1;
  soFromEnd = 2;

  CDefaultSep = '==========================================';
  CHeaderWithNameFmt = '[%s] %s';
  CBodyFmt = '%s'#13#10'%s'#13#10'%s'#13#10;

function GetLogFileName(APrefix: string = ''): string;
var
  lvPath: string;
begin
  lvPath := ExtractFilePath(ParamStr(0)) + 'Logs\';
  if not DirectoryExists(lvPath) then
    ForceDirectories(lvPath);
  Result := lvPath + APrefix + FormatDateTime('YYYYMM', Now) + '.log';
end;

procedure RealtimeLog(const AMsg: string;
  const AName: string = ''; const ASep: string = '');
var
  lLogger: THJYRealtimeLogger;
  lvFileName: string;
begin
  lvFileName := GetLogFileName('RealtimeLog');
  lLogger := THJYRealtimeLogger.Create(lvFileName);
  try
    lLogger.Log(AMsg, AName, ASep);
  finally
    lLogger.Free;
  end;
end;

procedure BufferedLog(const AMsg: string;
  const AName: string = ''; const ASep: string = '');
var
  lLogger: THJYBufferedLogger;
  lvFileName: string;
begin
  lvFileName := GetLogFileName('BufferedLog');
  lLogger := THJYBufferedLogger.Create(lvFileName);
  try
    lLogger.Log(AMsg, AName, ASep);
  finally
    lLogger.Free;
  end;
end;

{ TSilentFileStream }

constructor TSilentFileStream.Create(const FileName: string; Mode: Word);
begin
  if Mode = fmCreate then
    PInteger(@Handle)^ := FileCreate(FileName)
  else
    PInteger(@Handle)^ := FileOpen(FileName, Mode);
  FHandleValid := Cardinal(Handle) <> INVALID_HANDLE_VALUE;
end;

constructor TSilentFileStream.Create(const FileName: string);
begin
  if FileExists(FileName) then
    Create(FileName, fmOpenReadWrite)
  else
    Create(FileName, fmCreate);
end;

{ THJYCustomLogger }

constructor THJYCustomLogger.Create(const AFileName: string);
begin
  FCS := THJYCriticalSection.Create;
  FFileName := AFileName;
end;

destructor THJYCustomLogger.Destroy;
begin
  FCS.Free;
  inherited;
end;

procedure THJYCustomLogger.Log(const Msg: string; const Name: string = ''; const Sep: string = '');
var
  Text: string;
begin
  Text := DateTimeToStr(Now);
  if Name <> '' then
    Text := Format(CHeaderWithNameFmt, [Name, Text]);
  if Sep = '' then
    Text := Format(CBodyFmt, [Text, Msg, CDefaultSep])
  else
    Text := Format(CBodyFmt, [Text, Msg, Sep]);
  FCS.Enter;
  try
    DoLog(Text);
  finally
    FCS.Leave;
  end;
end;

{ THJYRealtimeLogger }

procedure THJYRealtimeLogger.DoLog(const Text: string);
var
  LText: UTF8String;
begin
  with TSilentFileStream.Create(FFileName) do
  begin
    try
      if HandleValid then
      begin
        if (Seek(0, soFromEnd) > MaxSize) and (MaxSize > 0) then
          Size := 0;
        LText := UTF8Encode(Text);
        Write(Pointer(LText)^, Length(LText));
      end;
    finally
      Free;
    end;
  end;
end;

{ THJYBufferedLogger }

destructor THJYBufferedLogger.Destroy;
begin
  if FLoaded then
    SaveToFile;
  inherited;
end;

function THJYBufferedLogger.BufferDecode(const Raw: RawByteString): UTF8String;
begin
  Result := UTF8String(Raw);
end;

function THJYBufferedLogger.BufferEncode(const Buffer: UTF8String): RawByteString;
begin
  Result := RawByteString(Buffer);
end;

procedure THJYBufferedLogger.DoLog(const Text: string);
begin
  if not FLoaded then
    LoadFromFile;
  if (MaxSize > 0) and (Length(FBuffer) > MaxSize) then
    FBuffer := '';
  FBuffer := FBuffer + Text;
end;

procedure THJYBufferedLogger.LoadFromFile;
var
  LText: RawByteString;
begin
  with TSilentFileStream.Create(FFileName) do
  begin
    try
      if HandleValid then
      begin
        SetLength(LText, Size);
        Read(Pointer(LText)^, Length(LText));
      end
      else
        LText := '';
    finally
      Free;
    end;
  end;
  FBuffer := UTF8ToString(BufferDecode(LText));
  FLoaded := True;
end;

procedure THJYBufferedLogger.SaveToFile;
var
  LText: RawByteString;
begin
  LText := BufferEncode(UTF8Encode(FBuffer));
  with TSilentFileStream.Create(FFileName) do
  begin
    try
      if HandleValid then
      begin
        Size := Length(LText);
        Seek(0, soFromBeginning);
        Write(Pointer(LText)^, Length(LText));
      end;
    finally
      Free;
    end;
  end;
end;

procedure THJYBufferedLogger.UpdateFile;
begin
  FCS.Enter;
  try
    if not FLoaded then
      LoadFromFile;
    SaveToFile;
  finally
    FCS.Leave;
  end;
end;

end.

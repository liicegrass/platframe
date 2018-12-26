unit HJYCryptors;

interface

uses Windows, Classes, SysUtils, IdGlobal, IdCoderMIME;

function AESEcbEncrypt(const Value, AKey: string): string;
function AESEcbDecrypt(const Value, AKey: string): string;
function AESCbcEncrypt(const Value, AKey: string): string;
function AESCbcDecrypt(const Value, AKey: string): string;
function MD5(const Value: string): string;

function Base64Encode(const Value: string): string; overload;
function Base64Encode(const Bytes: TBytes): string; overload;
function Base64Decode(const Value: string): string; overload;
function Base64DecodeBytes(const Value: string): TBytes;
function AESCbcEncryptBase64(const Value, AKey: string): string;
function AESCbcDecryptBase64(const Value, AKey: string): string;

implementation

uses CnMD5, CnAES;

const
  cInitVector = '1234567890123456';

function AESEcbEncrypt(const Value, AKey: string): string;
begin
  Result := string(AESEncryptEcbStrToHex(AnsiString(Value), AnsiString(AKey)));
  Result := LowerCase(Result);
end;

function AESEcbDecrypt(const Value, AKey: string): string;
begin
  Result := string(AESDecryptEcbStrFromHex(AnsiString(Value), AnsiString(AKey)));
end;

function AESCbcEncrypt(const Value, AKey: string): string;
var
  InitVector: TAESBuffer;
begin
  FillChar(InitVector, SizeOf(InitVector), 0);
  Move(PAnsiChar(cInitVector)^, InitVector, Length(cInitVector));
  Result := string(AESEncryptCbcStrToHex(AnsiString(Value),
    AnsiString(AKey), InitVector));
  Result := LowerCase(Result);
end;

function AESCbcDecrypt(const Value, AKey: string): string;
var
  InitVector: TAESBuffer;
begin
  FillChar(InitVector, SizeOf(InitVector), 0);
  Move(PAnsiChar(cInitVector)^, InitVector, Length(cInitVector));
  Result := string(AESDecryptCbcStrFromHex(AnsiString(Value),
    AnsiString(AKey), InitVector));
end;

function MD5(const Value: string): string;
var
  lStr: AnsiString;
begin
  lStr := AnsiString(Value);
  Result := CnMD5.MD5Print(CnMD5.MD5StringA(lStr));
  Result := LowerCase(Result);
end;

function Base64Encode(const Value: string): string;
var
  base64: TIdEncoderMIME;
  tmpBytes: TBytes;
begin
  base64 := TIdEncoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    tmpBytes := TEncoding.UTF8.GetBytes(Value);
    Result := base64.EncodeBytes(TIdBytes(tmpBytes));
  finally
    base64.Free;
  end;
end;

function Base64Encode(const Bytes: TBytes): string;
var
  base64: TIdEncoderMIME;
begin
  base64 := TIdEncoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    Result := base64.EncodeBytes(TIdBytes(Bytes));
  finally
    base64.Free;
  end;
end;

function Base64Decode(const Value: string): string;
var
  base64: TIdDeCoderMIME;
  tmpBytes: TBytes;
begin
  Result := Value;
  base64 := TIdDecoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    tmpBytes := TBytes(base64.DecodeBytes(Value));
    Result := TEncoding.UTF8.GetString(tmpBytes);
  finally
    base64.Free;
  end;
end;

function Base64DecodeBytes(const Value: string): TBytes;
var
  base64: TIdDeCoderMIME;
begin
  base64 := TIdDecoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    Result := TBytes(base64.DecodeBytes(Value));
  finally
    base64.Free;
  end;
end;

function AESCbcEncryptBase64(const Value, AKey: string): string;
var
  SS, DS: TMemoryStream;
  AESKey128: TAESKey128;
  ByteContent: TArrayByte;
  Base64ByteContent: TBytes;
  Key: AnsiString;
  InitVector: TAESBuffer;
begin
  Result := '';
  SS := TMemoryStream.Create;
  DS := TMemoryStream.Create;
  try
    PKCS5_Padding(AnsiString(Value), ByteContent);
    SS.WriteBuffer(ByteContent[0], Length(ByteContent));
    SS.Position := 0;

    Key := AnsiString(AKey);
    FillChar(InitVector, SizeOf(InitVector), 0);
    Move(PAnsiChar(cInitVector)^, InitVector, Length(cInitVector));

    FillChar(AESKey128, SizeOf(AESKey128), 0);
    Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
    EncryptAESStreamCBC(SS, 0, AESKey128, InitVector, DS);

    DS.Position := 0;
    SetLength(Base64ByteContent, DS.size);
    DS.ReadBuffer(Base64ByteContent[0], DS.Size);
    Result := Base64Encode(Base64ByteContent);
  finally
    SS.Free;
    DS.Free;
  end;
end;

function AESCbcDecryptBase64(const Value, AKey: string): string;
var
  SS, DS: TMemoryStream;
  AESKey128: TAESKey128;
  Base64ByteContent, ByteContent: TBytes;
  Key: AnsiString;
  InitVector: TAESBuffer;
begin
  Result := '';
  SS := TStringStream.Create;
  DS := TStringStream.Create;
  try
    Base64ByteContent := Base64DecodeBytes(Value);
    SS.WriteBuffer(Base64ByteContent[0], Length(Base64ByteContent));
    SS.Position := 0;

    Key := AnsiString(AKey);
    FillChar(InitVector, SizeOf(InitVector), 0);
    Move(PAnsiChar(cInitVector)^, InitVector, Length(cInitVector));

    FillChar(AESKey128, SizeOf(AESKey128), 0 );
    Move(PAnsiChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
    DecryptAESStreamCBC(SS, SS.Size - SS.Position, AESKey128, InitVector, DS);

    DS.Position := 0;
    SetLength(ByteContent, DS.size);
    DS.ReadBuffer(ByteContent[0], DS.size);
    Result := string(PKCS5_DePadding(ByteContent));
  finally
    SS.Free;
    DS.Free;
  end;
end;

end.

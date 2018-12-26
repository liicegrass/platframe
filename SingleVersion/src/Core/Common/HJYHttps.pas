unit HJYHttps;

interface

uses Classes, SysUtils, IdHTTP, superobject, IdURI;

function HttpSend(AUrl, ARequest: string): string;
//function SendPacket(SID: Integer; AParameter: string;
//  var AResponse: string): Boolean;

implementation

uses HJYDataProviders, HJYLogs, HJYDialogs, HJYConsts, HJYCryptors, UFrmHttpSend;

const
  cJavaHttpPassWord = 'xbx_java_cs_2017';

function HttpSend(AUrl, ARequest: string): string;
begin
  Result := UFrmHttpSend.HttpSend(AUrl, ARequest);
end;

//function HttpSend(AUrl, ARequest: string): string;
//var
//  idhtp1: TIdHTTP;
//  lRequestStr: string;
//  lRequestStream, lResponseStream: TStringStream;
//begin
//  idhtp1 := TIdHTTP.Create(nil);
//  try
//    try
//      idhtp1.Request.ContentType := 'application/x-www-form-urlencoded';
//      idhtp1.HandleRedirects := True;
//      idhtp1.AllowCookies := True;
//      idhtp1.Request.Accept := '*/*';
//      idhtp1.ConnectTimeout := 1000 * 30;
//      idhtp1.ReadTimeout := 1000 * 30;
//      lRequestStr := AESCbcEncrypt(ARequest, cJavaHttpPassWord);
//      //lRequestStr := AESCbcEncryptBase64(ARequest, cJavaHttpPassWord);
//      lRequestStr := 'data=' + TIdURI.ParamsEncode(lRequestStr);
//      lRequestStream := TStringStream.Create(lRequestStr, TEncoding.UTF8);
//      lResponseStream := TStringStream.Create('', TEncoding.UTF8);
//      try
//        lRequestStream.Position := 0;
//        idhtp1.Post(AUrl, lRequestStream, lResponseStream);
//        lResponseStream.Position := 0;
//        Result := AESCbcDecrypt(lResponseStream.DataString, cJavaHttpPassWord);
//        //Result := AESCbcDecryptBase64(lResponseStream.DataString, cJavaHttpPassWord);
//      finally
//        lRequestStream.Free;
//        lResponseStream.Free;
//      end;
//    except
//      on E: Exception do
//      begin
//        Result := '{"code": "-1", "msg": "' + E.Message + '"}';
//        RealtimeLog('服务器接口调用失败：' + E.Message);
//        Exit;
//      end;
//    end;
//  finally
//    FreeAndNil(idhtp1);
//  end;
//end;

//function SendPacket(SID: Integer; AParameter: string;
//  var AResponse: string): Boolean;
//var
//  json: ISuperObject;
//begin
//  json := SO();
//  json.I['sid'] := SID;
//  json.O['parameter'] := SO(AParameter);
//  AResponse := HttpSend(DataProvider.Url, json.AsString);
//  json := SO(AResponse);
//  Result := json.S['code'] = '0';
//end;

end.

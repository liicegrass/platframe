unit UDmImage;

interface

uses SysUtils, Classes, ImgList, Controls, cxGraphics, cxImageList,
  cxLocalization, cxClasses, cxLookAndFeels, dxSkinsForm, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter, dxSkinsdxStatusBarPainter;

type
  TDmImage = class(TDataModule)
    imgCheckTree: TcxImageList;
    imgLarge: TcxImageList;
    imgTree: TcxImageList;
    imgNavBar: TcxImageList;
    dxskncntrlrSkinSys: TdxSkinController;
    cxLocalizer1: TcxLocalizer;
  private

  public
    procedure LoadSysSkin(SkinFile: string);
    procedure LoadLocalizer(AFileName: string);
  end;

var
  DmImage: TDmImage;

implementation

{$R *.dfm}

procedure TDmImage.LoadLocalizer(AFileName: string);
begin
  cxLocalizer1.StorageType := lstIni;
  cxLocalizer1.FileName := AFileName;
  cxLocalizer1.Active := True;
  cxLocalizer1.Locale := 2052;
end;

procedure TDmImage.LoadSysSkin(SkinFile: string);
begin
  if not FileExists(SkinFile) then
    Exit;
  with Self.dxskncntrlrSkinSys do
  begin
    SkinName := 'UserSkin';
    dxSkinsUserSkinLoadFromFile(SkinFile);
    NativeStyle := False;
    UseSkins := True;
  end;
end;

end.

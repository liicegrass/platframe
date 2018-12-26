unit UDmMain;

interface

uses
  SysUtils, Classes, dxSkinsCore, dxSkinsDefaultPainters, cxLookAndFeels,
  dxSkinsForm, dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter, cxClasses, cxLocalization;

type
  TDmMain = class(TDataModule)
    dxskncntrlrSkinSys: TdxSkinController;
    cxLocalizer1: TcxLocalizer;
  private

  public
    procedure LoadSysSkin(SkinFile: string);
    procedure LoadLocalizer(AFileName: string);
  end;

var
  DmMain: TDmMain;

implementation

{$R *.dfm}

{ TDmMain }

procedure TDmMain.LoadLocalizer(AFileName: string);
begin
  cxLocalizer1.StorageType := lstIni;
  cxLocalizer1.FileName := AFileName;
  cxLocalizer1.Active := True;
  cxLocalizer1.Locale := 2052;
end;

procedure TDmMain.LoadSysSkin(SkinFile: string);
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

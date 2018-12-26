unit UFrmDiaog;

interface

uses
  Windows, Controls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  ImgList, StdCtrls, cxButtons, ExtCtrls, Classes, Forms, HJYDialogs, Clipbrd,
  ActnList;

type
  TMessageKind = (mkSuccess, mkInformation, mkWarning,
    mkConfirm, mkYesOrNo, mkError);

  TFrmDiaog = class(TForm)
    pnlClient: TPanel;
    imgIcon: TImage;
    lblText: TLabel;
    pnlBottom: TPanel;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    bvl1: TBevel;
    ilIcon: TcxImageList;
    actlst1: TActionList;
    actCopy: TAction;
    procedure actCopyExecute(Sender: TObject);
  private
    procedure LoadIcon(AMessageKind: TMessageKind);
    procedure InitMsgForm(const ACaption, AText: string;
      AMessageKind: TMessageKind);
  public
    class function ShowDialogForm(const ACaption, AText: string;
      AMessageKind: TMessageKind): Boolean;
  end;

  THJYDialog = class(TInterfacedObject, IHJYDialog)
  public
    procedure ShowSuccess(const ACaption, AText: string);
    procedure ShowMsg(const ACaption, AText: string);
    procedure ShowWarning(const ACaption, AText: string);
    function ShowConfirm(const ACaption, AText: string): Boolean;
    function ShowYesOrNo(const ACaption, AText: string): Boolean;
    procedure ShowError(const ACaption, AText: string);
  end;

var
  FrmDiaog: TFrmDiaog;

implementation

{$R *.dfm}

{ TFrmDiaog }

procedure TFrmDiaog.LoadIcon(AMessageKind: TMessageKind);
begin
  case AMessageKind of
    mkSuccess:            ilIcon.GetIcon(0, imgIcon.Picture.Icon);
    mkInformation:        ilIcon.GetIcon(1, imgIcon.Picture.Icon);
    mkWarning:            ilIcon.GetIcon(2, imgIcon.Picture.Icon);
    mkConfirm, mkYesOrNo: ilIcon.GetIcon(3, imgIcon.Picture.Icon);
    mkError:              ilIcon.GetIcon(4, imgIcon.Picture.Icon);
  end;
end;

procedure TFrmDiaog.actCopyExecute(Sender: TObject);
begin
  Clipboard.AsText := lblText.Caption;
end;

procedure TFrmDiaog.InitMsgForm(const ACaption, AText: string;
  AMessageKind: TMessageKind);
begin
  Self.Caption := ACaption;
  lblText.Caption := AText;
  case AMessageKind of
    mkSuccess, mkInformation, mkWarning, mkError:
      begin
        btnCancel.Visible := False;
        btnOk.Left := btnCancel.Left;
      end;
    mkYesOrNo:
      begin
        btnOk.Caption := 'ÊÇ';
        btnCancel.Caption := '·ñ';
      end;
  end;
  LoadIcon(AMessageKind);
end;

class function TFrmDiaog.ShowDialogForm(const ACaption, AText: string;
  AMessageKind: TMessageKind): Boolean;
var
  lForm: TFrmDiaog;
  lMsgEvent: TMessageEvent;
begin
  lForm := TFrmDiaog.Create(nil);
  lMsgEvent := Application.OnMessage;
  try
    Application.OnMessage := nil;
    lForm.InitMsgForm(ACaption, AText, AMessageKind);
    Result := lForm.ShowModal = mrOk;
  finally
    Application.OnMessage := lMsgEvent;
    lForm.Free;
  end;
end;

{ THJYDialog }

procedure THJYDialog.ShowSuccess(const ACaption, AText: string);
begin
  TFrmDiaog.ShowDialogForm(ACaption, AText, mkSuccess);
end;

procedure THJYDialog.ShowMsg(const ACaption, AText: string);
begin
  TFrmDiaog.ShowDialogForm(ACaption, AText, mkInformation);
end;

procedure THJYDialog.ShowWarning(const ACaption, AText: string);
begin
  TFrmDiaog.ShowDialogForm(ACaption, AText, mkWarning);
end;

function THJYDialog.ShowConfirm(const ACaption, AText: string): Boolean;
begin
  Result := TFrmDiaog.ShowDialogForm(ACaption, AText, mkConfirm);
end;

function THJYDialog.ShowYesOrNo(const ACaption, AText: string): Boolean;
begin
  Result := TFrmDiaog.ShowDialogForm(ACaption, AText, mkYesOrNo);
end;

procedure THJYDialog.ShowError(const ACaption, AText: string);
begin
  TFrmDiaog.ShowDialogForm(ACaption, AText, mkError);
end;

initialization
  HJYDialog := THJYDialog.Create;

finalization
  HJYDialog := nil;

end.

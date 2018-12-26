unit UFrmPassEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  ActnList, StdCtrls, cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit, cxCheckBox;

type
  TFrmPassEdit = class(TFrmModal)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtPass: TcxTextEdit;
    edtNewPass: TcxTextEdit;
    edtNewPass2: TcxTextEdit;
    procedure btnOkClick(Sender: TObject);
  private
    function BeforeExecute: Boolean;
    function Execute: Boolean;
  public
    class function ShowPassEdit: Boolean;
  end;

var
  FrmPassEdit: TFrmPassEdit;

implementation

uses HJYDialogs, HJYDataProviders, HJYCryptors, HJYConsts;

{$R *.dfm}

{ TFrmPassEdit }

function TFrmPassEdit.BeforeExecute: Boolean;
begin
  Result := False;

  if Trim(edtPass.Text) = '' then
  begin
    edtPass.SetFocus;
    ShowMsg('ԭ���벻��Ϊ�գ�');
    Exit;
  end;

  if Trim(edtNewPass.Text) = '' then
  begin
    edtNewPass.SetFocus;
    ShowMsg('�����벻��Ϊ�գ�');
    Exit;
  end;

  if Trim(edtNewPass2.Text) = '' then
  begin
    edtNewPass2.SetFocus;
    ShowMsg('ȷ�������벻��Ϊ�գ�');
    Exit;
  end;

  if DataProvider.UserInfo.UserPass <> MD5(Trim(edtPass.Text)) then
  begin
    edtNewPass.SetFocus;
    ShowMsg('ԭ���벻��ȷ��');
    Exit;
  end;

  if Trim(edtNewPass.Text) <> Trim(edtNewPass2.Text) then
  begin
    edtNewPass.SetFocus;
    ShowMsg('��������������벻һ�£�');
    Exit;
  end;

  Result := True;
end;

function TFrmPassEdit.Execute: Boolean;
var
  lStrSql, lNewPass: string;
begin
  Result := False;
  lNewPass := MD5(Trim(edtNewPass.Text));
  if DataProvider.UserInfo.UserPass = lNewPass then
  begin
    Result := True;
    Exit;
  end;
  lStrSql := Format('update UserInfo set UserPass=''%s'' where Guid=''%s''',
    [lNewPass, DataProvider.UserInfo.Guid]);
  if not DataProvider.DBAccess.ExecSQL(lStrSql) then
  begin
    ShowWarning('�޸�����ʧ�ܣ�');
    Exit;
  end;
  DataProvider.UserInfo.UserPass := lNewPass;
  Result := True;
end;

procedure TFrmPassEdit.btnOkClick(Sender: TObject);
begin
  if not BeforeExecute then Exit;
  if not Execute then Exit;
  ModalResult := mrOk;
end;

class function TFrmPassEdit.ShowPassEdit: Boolean;
begin
  with TFrmPassEdit.Create(nil) do
  begin
    try
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
  end;
end;

end.

unit UFrmMemoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, cxControls,
  cxContainer, cxEdit, ActnList, cxCheckBox, StdCtrls, cxButtons, ExtCtrls, cxTextEdit, cxMemo;

type
  TFrmMemoEdit = class(TFrmModal)
    cxmMemo: TcxMemo;
    procedure btnOkClick(Sender: TObject);
  private

  public
    class function ShowMemoEdit(ACaption: string; var AValue: string): Boolean;
  end;

var
  FrmMemoEdit: TFrmMemoEdit;

implementation

{$R *.dfm}

{ TFrmMemoEdit }

procedure TFrmMemoEdit.btnOkClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

class function TFrmMemoEdit.ShowMemoEdit(ACaption: string; var AValue: string): Boolean;
begin
  Result := False;
  FrmMemoEdit := TFrmMemoEdit.Create(nil);
  try
    FrmMemoEdit.Caption := ACaption;
    FrmMemoEdit.cxmMemo.Text := AValue;
    if FrmMemoEdit.ShowModal = mrOk then
    begin
      AValue := Trim(FrmMemoEdit.cxmMemo.Text);
      Result := True;
    end;
  finally
    FreeAndNil(FrmMemoEdit);
  end;
end;

end.

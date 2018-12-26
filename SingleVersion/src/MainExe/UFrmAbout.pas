unit UFrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  StdCtrls, ActnList, cxButtons, ExtCtrls, jpeg, dxGDIPlusClasses, cxControls,
  cxContainer, cxEdit, cxCheckBox;

type
  TFrmAbout = class(TFrmModal)
    lbl1: TLabel;
    img1: TImage;
    procedure btnOkClick(Sender: TObject);
  private

  public
    class procedure ShowAbout;
  end;

var
  FrmAbout: TFrmAbout;

implementation

{$R *.dfm}

{ TFrmAbout }

procedure TFrmAbout.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

class procedure TFrmAbout.ShowAbout;
begin
  with TFrmAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

end.

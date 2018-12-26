unit uFrmRoot;

interface

uses Messages, HJYForms;

type
  TFrmRoot = class(THJYForm)
    procedure DoKeyPress(Sender: TObject; var Key: Char);
  private

  public

  end;

var
  FrmRoot: TFrmRoot;

implementation

{$R *.dfm}

procedure TFrmRoot.DoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

end.

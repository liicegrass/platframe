unit HJYDialogs;

interface

type
  IHJYDialog = interface
    procedure ShowSuccess(const ACaption, AText: string);
    procedure ShowMsg(const ACaption, AText: string);
    procedure ShowWarning(const ACaption, AText: string);
    function ShowConfirm(const ACaption, AText: string): Boolean;
    function ShowYesOrNo(const ACaption, AText: string): Boolean;
    procedure ShowError(const ACaption, AText: string);
  end;

var
  HJYDialog: IHJYDialog = nil;

procedure ShowSuccess(const AText: string);
procedure ShowMsg(const AText: string);
procedure ShowWarning(const AText: string);
function ShowConfirm(const AText: string): Boolean;
function ShowYesOrNo(const AText: string): Boolean;
procedure ShowError(const AText: string);

implementation

const
  SInformation = '信息';
  SConfirm = '确认';
  SQuestion = '询问';
  SWarning = '警告';
  SError = '错误';

procedure ShowSuccess(const AText: string);
begin
  HJYDialog.ShowSuccess(SInformation, AText);
end;

procedure ShowMsg(const AText: string);
begin
  HJYDialog.ShowMsg(SInformation, AText);
end;

procedure ShowWarning(const AText: string);
begin
  HJYDialog.ShowWarning(SWarning, AText);
end;

function ShowConfirm(const AText: string): Boolean;
begin
  Result := HJYDialog.ShowConfirm(SConfirm, AText);
end;

function ShowYesOrNo(const AText: string): Boolean;
begin
  Result := HJYDialog.ShowYesOrNo(SQuestion, AText);
end;

procedure ShowError(const AText: string);
begin
  HJYDialog.ShowError(SError, AText);
end;

end.

unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBClient, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, DB, StdCtrls, cxButtons,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, dxGDIPlusClasses;

type
  TFrmLogin = class(TForm)
    imgLogin: TImage;
    lbl2: TLabel;
    edtPass: TcxTextEdit;
    cbbWorker: TcxComboBox;
    btnOk: TcxButton;
    lbl3: TLabel;
    cdsLogin: TClientDataSet;
    Label1: TLabel;
    btnInitAdmin: TcxButton;
    procedure btnOkClick(Sender: TObject);
    procedure cbbWorkerKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edtPassKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnInitAdminClick(Sender: TObject);
  private
    FLoginListFile: string;
    function BeforeExecute: Boolean;
    function DoLogin: Boolean;
    procedure LoadImage(Img: TImage; AFileName: string);
  public

  end;

function ShowLogin: Boolean;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses HJYDataProviders, HJYDialogs, HJYValidationChecks, HJYCryptors, HJYConsts, HJYUtils;

{ TFrmLogin }

function ShowLogin: Boolean;
begin
  Application.CreateForm(TFrmLogin, FrmLogin);
  try
    Result := FrmLogin.ShowModal = mrOk;
  finally
    FrmLogin.Free;
  end;
end;

procedure TFrmLogin.cbbWorkerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Perform(WM_NEXTDLGCTL, 0, 0);
end;

function TFrmLogin.DoLogin: Boolean;
const
  cGetUserInfoSQL = 'select a.*, b.DeptCode, b.DeptName, '+
    ' c.RoleCode, c.RoleName from UserInfo a '+
    ' left join UserDept b on b.Guid=a.DeptGuid '+
    ' left join UserRole c on c.Guid=a.RoleGuid '+
    ' where a.UserCode=''%s''';
var
  lStrSql: string;
  lPassWD: string;
begin
  Result := False;
  lStrSql := Format(cGetUserInfoSQL, [Trim(cbbWorker.Text)]);
  if not DataProvider.DBAccess.Query(cdsLogin, lStrSql) then
  begin
    ShowMsg('查询用户信息失败！');
    Exit;
  end;

  if cdsLogin.IsEmpty then
  begin
    cbbWorker.SetFocus;
    ShowMsg('用户名不存在！');
    Exit;
  end;

  lPassWD := cdsLogin.FindField('UserPass').AsString;
  if lPassWD <> MD5(Trim(edtPass.Text)) then
  begin
    edtPass.SetFocus;
    ShowMsg('密码不正确！');
    Exit;
  end;

  if cdsLogin.FindField('IsStop').AsInteger = 1 then
  begin
    edtPass.SetFocus;
    ShowMsg('当前用户已停用，请联系管理员！');
    Exit;
  end;

  with DataProvider.UserInfo, cdsLogin do
  begin
    Guid := FindField('Guid').AsString;
    UserCode := FindField('UserCode').AsString;
    UserName := FindField('UserName').AsString;
    UserPass := lPassWD;
    //Phone := FindField('Phone').AsString;
    //Address := FindField('Address').AsString;
    IsStop := FindField('IsStop').AsInteger;
    Remark := FindField('Remark').AsString;
    DeptGuid := FindField('DeptGuid').AsString;
    DeptCode := FindField('DeptCode').AsString;
    DeptName := FindField('DeptName').AsString;
    RoleGuid := FindField('RoleGuid').AsString;
    RoleCode := FindField('RoleCode').AsString;
    RoleName := FindField('RoleName').AsString;
  end;
  cdsLogin.Close;
  Result := True;
end;

procedure TFrmLogin.edtPassKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnOk.Click;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  with DataProvider do
  begin
    FLoginListFile := AppPath + 'config\login.lst';
    if FileExists(FLoginListFile) then
      cbbWorker.Properties.Items.LoadFromFile(FLoginListFile);
    LoadImage(imgLogin, AppPath + 'images\login.png');
  end;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  if cbbWorker.Properties.Items.Count > 0 then
  begin
    cbbWorker.ItemIndex := 0;
    edtPass.SetFocus;
  end;
end;

function TFrmLogin.BeforeExecute: Boolean;
begin
  Result := False;

  if Trim(cbbWorker.Text) = '' then
  begin
    cbbWorker.SetFocus;
    ShowMsg('用户名不能为空！');
    Exit;
  end;

  if Trim(edtPass.Text) = '' then
  begin
    edtPass.SetFocus;
    ShowMsg('密码不能为空！');
    Exit;
  end;

  Result := True;
end;

procedure TFrmLogin.btnOkClick(Sender: TObject);
var
  lWorkerID: string;
begin
  if not BeforeExecute then
    Exit;
  if DoLogin then
  begin
    lWorkerID := Trim(cbbWorker.Text);
    if cbbWorker.Properties.Items.IndexOf(lWorkerID) <> -1 then
      cbbWorker.Properties.Items.Delete(cbbWorker.Properties.Items.IndexOf(lWorkerID));
    cbbWorker.Properties.Items.Insert(0, lWorkerID);
    cbbWorker.Properties.Items.SaveToFile(FLoginListFile);
    ModalResult := mrOk;
  end;
end;

procedure TFrmLogin.LoadImage(Img: TImage; AFileName: string);
begin
  if FileExists(AFileName) then
    Img.Picture.LoadFromFile(AFileName);
end;

procedure TFrmLogin.btnInitAdminClick(Sender: TObject);
const
  cInsertDeptSQL = 'insert into UserDept(Guid, DeptCode, DeptName) '+
    ' values(''%s'', ''%s'', ''%s'')';
  cInsertRoleSQL = 'insert into UserRole(Guid, RoleCode, RoleName) '+
    ' values(''%s'', ''%s'', ''%s'')';
  cInsertUserSQL = 'insert into UserInfo(Guid, UserCode, UserName, '+
    ' UserPass, RoleGuid, DeptGuid, IsStop, CreateTime) '+
    ' values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %d, ''%s'')';
var
  lvList: TStrings;
  lvDeptGuid, lvRoleGuid: string;
  lvSql: string;
  lvValue: Integer;
begin
  lvSql := 'select count(*) from UserInfo';
  if not DataProvider.DBAccess.GetSQLIntegerValue(lvSql, lvValue) then
  begin
    ShowMsg('admin用户初始化状态获取失败！');
    Exit;
  end;
  if lvValue > 0 then
  begin
    ShowMsg('已经初始化过admin用户！');
    Exit;
  end;
  lvList := TStringList.Create;
  try
    lvDeptGuid := CreateGuidStr;
    lvSql := Format(cInsertDeptSQL, [lvDeptGuid, 'BJXBXKJYXGS', '北京新波讯科技有限公司']);
    lvList.Add(lvSql);

    lvRoleGuid := CreateGuidStr;
    lvSql := Format(cInsertRoleSQL, [lvRoleGuid, 'XTGLY', '系统管理员']);
    lvList.Add(lvSql);

    lvSql := Format(cInsertUserSQL, [CreateGuidStr, 'admin', '系统管理员',
      MD5('admin'), lvRoleGuid, lvDeptGuid, 0, FormatDateTime('yyyy-mm-dd hh:mm:ss', Now)]);
    lvList.Add(lvSql);

    if DataProvider.DBAccess.ExecSQLs(lvList) then
      ShowMsg('admin用户初始化成功！')
    else
      ShowMsg('admin用户初始化失败！');
  finally
    lvList.Free;
  end;
end;

end.

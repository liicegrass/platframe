unit UFrmWorkerInfoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DateUtils, uFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  cxControls, cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters,
  cxCheckBox, cxDropDownEdit, cxMaskEdit, cxCalendar, cxTextEdit, StdCtrls,
  ActnList, cxButtons, ExtCtrls, ComCtrls, dxCore, cxDateUtils;

type
  TFrmWorkerInfoEdit = class(TFrmModal)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    edtWorkerID: TcxTextEdit;
    edtWorkerName: TcxTextEdit;
    edtBeginTime: TcxDateEdit;
    edtEndTime: TcxDateEdit;
    chkAlwaysNew: TcxCheckBox;
    edtWorkerGuid: TcxTextEdit;
    cbbWorkerClass: TcxComboBox;
    Label1: TLabel;
    cbbIsStop: TcxComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkAlwaysNewClick(Sender: TObject);
  private
    FOperAction: string;
    FOnRefreshAfterPost: TRefreshAfterSave;

    procedure ClearControls;
    function BeforeExecute: Boolean;
    function DoExecute: Boolean;
  public
    property OnRefreshAfterPost: TRefreshAfterSave read FOnRefreshAfterPost write FOnRefreshAfterPost;
    property OperAction: string read FOperAction write FOperAction;
  end;

var
  FrmWorkerInfoEdit: TFrmWorkerInfoEdit;

implementation

uses UMsgBox, UPubFunLib, uSysObj, UHJYDataRecord, HJYCryptors, uConst;

{$R *.dfm}

{ TFrmWorkerInfoEdit }

function TFrmWorkerInfoEdit.BeforeExecute: Boolean;
const
  cCheckIDExistsSQL = 'select * from WorkerInfo where WorkerID=''%s''';
var
  lStrSql: string;
  iResult: Integer;
begin
  Result := False;

  if Trim(edtWorkerID.Text) = '' then
  begin
    edtWorkerID.SetFocus;
    ShowMsg('用户编码不能为空，请输入！');
    Exit;
  end;

  if Trim(edtWorkerName.Text) = '' then
  begin
    edtWorkerName.SetFocus;
    ShowMsg('用户名称不能为空，请输入！');
    Exit;
  end;

  if cbbWorkerClass.ItemIndex = -1 then
  begin
    cbbWorkerClass.SetFocus;
    ShowMsg('所属角色不能为空，请选择！');
    Exit;
  end;

  // 判断用户编码是否重复
  if FOperAction = 'Append' then
    lStrSql := Format(cCheckIDExistsSQL, [Trim(edtWorkerID.Text)])
  else
    lStrSql := Format(cCheckIDExistsSQL + ' and Guid <> ''%s''',
      [Trim(edtWorkerID.Text), Trim(edtWorkerGuid.Text)]);
  iResult := DBAccess.DataSetIsEmpty(lStrSql);
  if iResult = -1 then
  begin
    ShowMsg('获取用户编码是否重复失败！');
    Exit;
  end;
  if iResult = 0 then
  begin
    ShowMsg('当前用户编码已经存在，请重新输入！');
    Exit;
  end;

  Result := True;
end;

procedure TFrmWorkerInfoEdit.btnOkClick(Sender: TObject);
begin
  if not BeforeExecute then Exit;
  if not DoExecute then Exit;
  if (FOperAction = 'Append') and chkAlwaysNew.Checked then
  begin
    if Assigned(FOnRefreshAfterPost) then
      FOnRefreshAfterPost(True, Trim(edtWorkerID.Text));
    ClearControls;
    edtWorkerID.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

procedure TFrmWorkerInfoEdit.chkAlwaysNewClick(Sender: TObject);
begin
  Sys.SetAlwaysNew(Self.ClassName, chkAlwaysNew.Checked);
end;

procedure TFrmWorkerInfoEdit.ClearControls;
begin
  edtWorkerGuid.Text := '';
  edtWorkerID.Text := '';
  edtWorkerName.Text := '';
  cbbWorkerClass.ItemIndex := -1;
  cbbWorkerClass.Text := '';
  cbbIsStop.ItemIndex := 1;
  edtBeginTime.Date := Date;
  edtEndTime.Date := IncYear(Date, 1);
end;

function TFrmWorkerInfoEdit.DoExecute: Boolean;
const
  InsertWorkerClassSQL = 'insert into WorkerInfo(Guid, WorkerID, WorkerName, '+
    ' WorkerPass, ClassGuid, BeginTime, EndTime, CreateMan, CreateTime, '+
    ' IsDelete, Remark, EditTime, IsStop, SyncState) '+
    ' values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %s, %s, ''%s'', %s, '+
    ' 0, ''%s'', %s, 0, 0)';

  UpdateWorkerClassSQL = 'update WorkerInfo set WorkerID=''%s'', '+
    ' WorkerName=''%s'', ClassGuid=''%s'', BeginTime=%s, EndTime=%s, '+
    ' Remark=''%s'', EditTime=%s, IsStop=%s, SyncState=0 where Guid=''%s''';
var
  lWorkerGuid, lWorkerID, lWorkerName, lClassGuid,
  lBeginTime, lEndTime, lRemark, lIsStop: string;
  lDataRec: TDataRecord;
  lStrSql: string;
begin
  lWorkerID := edtWorkerID.Text;
  lWorkerName := edtWorkerName.Text;
  lIsStop := IntToStr(cbbIsStop.ItemIndex);
  lDataRec := GetDataRecord(cbbWorkerClass.ItemIndex, cbbWorkerClass.Properties.Items);
  lClassGuid := lDataRec.FieldValueAsString('Guid');
  if edtBeginTime.Text <> '' then
    lBeginTime := QuotedStr(FormatDateTime('yyyy-mm-dd', edtBeginTime.Date))
  else
    lBeginTime := 'null';
  if edtEndTime.Text <> '' then
    lEndTime := QuotedStr(FormatDateTime('yyyy-mm-dd', edtEndTime.Date))
  else
    lEndTime := 'null';
  if FOperAction = 'Append' then
  begin
    lWorkerGuid := CreateGuidStr;
    lStrSql := Format(InsertWorkerClassSQL, [lWorkerGuid, lWorkerID, lWorkerName,
      MD5(cDefWorkerPass), lClassGuid, lBeginTime, lEndTime, Sys.WorkerInfo.WorkerID,
      Sys.DateStr, lRemark, Sys.DateStr]);
  end else begin
    lWorkerGuid := Trim(edtWorkerGuid.Text);
    lStrSql := Format(UpdateWorkerClassSQL, [lWorkerID, lWorkerName, lClassGuid,
      lBeginTime, lEndTime, lRemark, Sys.DateStr, lIsStop, lWorkerGuid]);
  end;
  Result := DBAccess.ExecuteSQL(lStrSql);
  if not Result then
  begin
    ShowMsg('用户信息保存失败，请重新操作！');
    Exit;
  end;
end;

procedure TFrmWorkerInfoEdit.FormCreate(Sender: TObject);
begin
  inherited;
  ClearControls;
end;

procedure TFrmWorkerInfoEdit.FormShow(Sender: TObject);
begin
  inherited;
  if FOperAction = 'Append' then
  begin
    chkAlwaysNew.Visible := True;
    chkAlwaysNew.Checked := Sys.GetAlwaysNew(Self.ClassName);
  end;
end;

end.

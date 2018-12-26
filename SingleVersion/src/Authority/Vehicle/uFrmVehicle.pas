unit uFrmVehicle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  ActnList, StdCtrls, cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxDropDownEdit, cxMaskEdit, cxCalendar,
  cxTextEdit, cxCheckBox;

type
  TFrmVehicle = class(TFrmModal)
    Label1: TLabel;
    Label2: TLabel;
    edtDriverName: TcxTextEdit;
    Label3: TLabel;
    edtCarNo: TcxTextEdit;
    Label4: TLabel;
    edtPhone: TcxTextEdit;
    Label5: TLabel;
    cbbIsStop: TcxComboBox;
    Label6: TLabel;
    edtRemark: TcxTextEdit;
    edtCarKind: TcxTextEdit;
    chkAlwaysNew: TcxCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure chkAlwaysNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGuid: string;
    FOperAction: string;
    FOnRefreshAfterPost: TRefreshAfterSave;

    function BeforeExecute: Boolean;
    function Execute: Boolean;
    procedure ClearControls;
  public
    property OperAction: string read FOperAction write FOperAction;
    property Guid: string read FGuid write FGuid;
    property OnRefreshAfterPost: TRefreshAfterSave read FOnRefreshAfterPost write FOnRefreshAfterPost;
  end;

var
  FrmVehicle: TFrmVehicle;

implementation

uses uSysObj, UMsgBox, uPubFunLib;

{$R *.dfm}

function TFrmVehicle.BeforeExecute: Boolean;
begin
  Result := False;

  if Trim(edtDriverName.Text) = '' then
  begin
    edtDriverName.SetFocus;
    ShowMsg('司机姓名不能为空！');
    Exit;
  end;

  if Trim(edtCarNo.Text) = '' then
  begin
    edtCarNo.SetFocus;
    ShowMsg('车牌号不能为空！');
    Exit;
  end;

  if cbbIsStop.ItemIndex = -1 then
  begin
    cbbIsStop.SetFocus;
    ShowMsg('使用状态不能为空！');
    Exit;
  end;

  Result := True;
end;

procedure TFrmVehicle.btnOkClick(Sender: TObject);
begin
  inherited;
  if not BeforeExecute then Exit;
  if not Execute then Exit;
  if (FOperAction = 'Append') and chkAlwaysNew.Checked then
  begin
    if Assigned(FOnRefreshAfterPost) then
      FOnRefreshAfterPost(True, FGuid);
    ClearControls;
    edtDriverName.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

procedure TFrmVehicle.chkAlwaysNewClick(Sender: TObject);
begin
  inherited;
  Sys.SetAlwaysNew(Self.ClassName, chkAlwaysNew.Checked);
end;

function TFrmVehicle.Execute: Boolean;
const
  cInsertSQL = 'insert into CarInfo(Guid, DriverName, CarNo, Phone, CarKind, '+
    ' IsStop, Remark, SyncState, EditTime) '+
    ' values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %d, ''%s'', 0, %s)';
  cUpdateSQL = 'update CarInfo set DriverName=''%s'', CarNo=''%s'', '+
    ' Phone=''%s'', CarKind=''%s'', IsStop=%d, Remark=''%s'', '+
    ' SyncState=0, EditTime=%s where Guid=''%s''';
var
  lDriverName, lCarNo, lPhone, lCarKind, lRemark: string;
  lIsStop: Integer;
  lStrSql: string;
begin
  lDriverName := Trim(edtDriverName.Text);
  lCarNo := Trim(edtCarNo.Text);
  lPhone := Trim(edtPhone.Text);
  lCarKind := Trim(edtCarKind.Text);
  lIsStop := cbbIsStop.ItemIndex;
  lRemark := Trim(edtRemark.Text);
  if FOperAction = 'Append' then
  begin
    FGuid := CreateGuidStr;
    lStrSql := Format(cInsertSQL, [FGuid, lDriverName, lCarNo, lPhone,
      lCarKind, lIsStop, lRemark, Sys.DateStr]);
  end else
    lStrSql := Format(cUpdateSQL, [lDriverName, lCarNo, lPhone,
      lCarKind, lIsStop, lRemark, Sys.DateStr, FGuid]);
  Result := DBAccess.ExecuteSQL(lStrSql);
  if not Result then
  begin
    ShowMsg('司机及车辆信息保存失败！');
    Exit;
  end;
end;

procedure TFrmVehicle.FormCreate(Sender: TObject);
begin
  inherited;
  ClearControls;
end;

procedure TFrmVehicle.FormShow(Sender: TObject);
begin
  inherited;
  if FOperAction = 'Append' then
  begin
    chkAlwaysNew.Visible := True;
    chkAlwaysNew.Checked := Sys.GetAlwaysNew(Self.ClassName);
  end;
end;

procedure TFrmVehicle.ClearControls;
begin
  edtDriverName.Text := '';
  edtCarNo.Text := '';
  edtPhone.Text := '';
  edtCarKind.Text := '';
  cbbIsStop.ItemIndex := 0;
  edtRemark.Text := '';
end;

end.

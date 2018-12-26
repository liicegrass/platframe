unit UFrmMain;

interface

uses
  Windows, SysUtils, Forms, Controls, ExtCtrls, Classes, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxStatusBarPainter, dxSkinscxPCPainter, cxPC, StdCtrls,
  cxButtons, dxGDIPlusClasses, dxStatusBar, jpeg, ActnList, Graphics,
  dxNavBar, dxNavBarCollns, cxSplitter, dxSkinsdxNavBarAccordionViewPainter,
  dxNavBarViewsFact, cxClasses, dxNavBarBase, dxNavBarStyles, DBClient, Menus;

type
  TFrmMain = class(TForm)
    dxstsbr1: TdxStatusBar;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    btnPassEdit: TcxButton;
    btnChangeUser: TcxButton;
    btnAbout: TcxButton;
    btnExit: TcxButton;
    imgLogo: TImage;
    lblAppTitle: TLabel;
    NavBar: TdxNavBar;
    pnlClient: TPanel;
    cxspltr1: TcxSplitter;
    nbsGroupStyle: TdxNavBarStyleItem;
    nbsItemStyle: TdxNavBarStyleItem;
    shpTopLine: TShape;
    img_bg: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnPassEditClick(Sender: TObject);
    procedure btnChangeUserClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure NavBarLinkClick(Sender: TObject; ALink: TdxNavBarItemLink);
    procedure imgLogoClick(Sender: TObject);
    procedure dxstsbr1Panels3Click(Sender: TObject);
  private
    FRightList: TStrings;
    FLibList: TStrings;
    FFormName: string;
    function LoadUserRoleRight: Boolean;
    procedure AddDevelportRight;
    procedure InitUserInfoShow;
    procedure ClearUserRoleRight;
    procedure InitUIData;
    procedure ShowForm(ATag: Integer; ACaption: string);
    procedure LoadUserRoleRightMenu;
    procedure ClearUserRoleRightMenu;
    procedure InitNarBarStyle;
    procedure LoadSelfPackage(ALibName: string);
  public

  end;

  TdxNavBarModernizedAccordionGroupViewInfo = class(TdxNavBarAccordionGroupViewInfo)
  public
    procedure CalculateBounds(var X, Y: Integer); override;
  end;

  TdxNavBarModernizedAccordionViewInfo = class(TdxNavBarAccordionViewInfo)
  protected
    function CanHasSignInGroupCaption: Boolean; override;
  end;

  TdxNavBarModernizedAccordionViewPainter = class(TdxNavBarAccordionViewPainter)
  protected
    class function GetGroupViewInfoClass: TdxNavBarGroupViewInfoClass; override;
    class function GetViewInfoClass: TdxNavBarViewInfoClass; override;
  end;

var
  FrmMain: TFrmMain;

implementation

uses HJYDialogs, HJYUserInfos, HJYDataProviders, UFrmPassEdit,
  UFrmLogin, UFrmAbout, UDmImage, HJYVersionInfos, HJYValidationChecks,
  HJYForms, UFrmRightInfo, HJYUtils;

{$R *.dfm}

const
  dxNavBarModernizedAccordionViewID = 1000;

{ TdxNavBarModernizedAccordionGroupViewInfo }

procedure TdxNavBarModernizedAccordionGroupViewInfo.CalculateBounds(var X, Y: Integer);
begin
  inherited CalculateBounds(X, Y);
  if IsCaptionVisible and (NavBar.OptionsImage.SmallImages = nil) then
    FCaptionTextRect.Left := X + (ViewInfo as TdxNavBarModernizedAccordionViewInfo).GetItemCaptionOffsets.Left;
end;

{ TdxNavBarModernizedAccordionViewInfo }

function TdxNavBarModernizedAccordionViewInfo.CanHasSignInGroupCaption: Boolean;
begin
  Result := False;
end;

{ TdxNavBarModernizedAccordionViewPainter }

class function TdxNavBarModernizedAccordionViewPainter.GetGroupViewInfoClass:
  TdxNavBarGroupViewInfoClass;
begin
  Result := TdxNavBarModernizedAccordionGroupViewInfo;
end;

class function TdxNavBarModernizedAccordionViewPainter.GetViewInfoClass:
  TdxNavBarViewInfoClass;
begin
  Result := TdxNavBarModernizedAccordionViewInfo;
end;

procedure TFrmMain.btnPassEditClick(Sender: TObject);
begin
  TFrmPassEdit.ShowPassEdit;
end;

procedure TFrmMain.btnChangeUserClick(Sender: TObject);
begin
  if ShowLogin then
  begin
    if FFormName <> '' then
    begin
      HJYFormMgr.ReleaseForm(FFormName);
      FFormName := '';
    end;
    InitUserInfoShow;
  end;
end;

procedure TFrmMain.btnAboutClick(Sender: TObject);
begin
  TFrmAbout.ShowAbout;
end;

procedure TFrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ShowConfirm('您确定要退出“' + Application.Title + '”吗？');
end;

procedure TFrmMain.InitUIData;
var
  lVer: THJYVersionInfo;
begin
  lVer := THJYVersionInfo.Create;
  try
    lVer.FilePath := Application.ExeName;
    dxstsbr1.Panels[0].Text := '版本：V' + lVer.FileVersion;
  finally
    lVer.Free;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Self.Caption := Application.Title;
  Self.Width := 1024;
  Self.Height := 768;
  Self.WindowState := wsMaximized;
  NavBar.View := dxNavBarModernizedAccordionViewID;
  FRightList := TStringList.Create;
  FLibList := TStringList.Create;
  InitUIData;
  InitUserInfoShow;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  if FFormName <> '' then
    HJYFormMgr.ReleaseForm(FFormName);
  ClearUserRoleRight;
  FreeAndNil(FRightList);
  for I := 0 to FLibList.Count - 1 do
    UnloadPackage(StrToInt(FLibList.ValueFromIndex[I]));
  FreeAndNil(FLibList);
end;

procedure TFrmMain.imgLogoClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to NavBar.Groups.Count - 1 do
    NavBar.Groups[I].Expanded := False;
end;

procedure TFrmMain.LoadUserRoleRightMenu;
var
  I, J: Integer;
  lRightInfo: THJYRightInfo;
  lGrp: TdxNavBarGroup;
  lItem: TdxNavBarItem;
begin
  NavBar.BeginUpdate;
  try
    // 首先加载分组节点
    for I := 0 to FRightList.Count - 1 do
    begin
      lRightInfo := THJYRightInfo(FRightList.Objects[I]);
      if (lRightInfo.ParentGuid = '') or (lRightInfo.ParentGuid = '-1') then
      begin
        lGrp := NavBar.Groups.Add;
        lGrp.Caption := lRightInfo.RightName;
        lGrp.Tag := I;
        lGrp.SmallImageIndex := lRightInfo.ImageIndex;
      end;
    end;

    // 加载分组功能项节点
    for I := 0 to FRightList.Count - 1 do
    begin
      lRightInfo := THJYRightInfo(FRightList.Objects[I]);
      if (lRightInfo.ParentGuid = '') or (lRightInfo.ParentGuid = '-1') then
        Continue;
      for J := 0 to NavBar.Groups.Count - 1 do
      begin
        lGrp := NavBar.Groups.Items[J];
        if THJYRightInfo(FRightList.Objects[lGrp.Tag]).Guid = lRightInfo.ParentGuid then
        begin
          lItem := NavBar.Items.Add;
          lItem.Tag := I;
          lItem.Caption := lRightInfo.RightName;
          lItem.SmallImageIndex := lRightInfo.ImageIndex;
          lGrp.CreateLink(lItem);
        end;
      end;
    end;

    // 清除没有功能项节点的分组
    for I := 0 to NavBar.Groups.Count - 1 do
      if NavBar.Groups.Items[I].LinkCount = 0 then
        NavBar.Groups.Items[I].Free;
  finally
    NavBar.EndUpdate;
  end;
end;

procedure TFrmMain.ClearUserRoleRight;
var
  I: Integer;
begin
  FRightList.BeginUpdate;
  try
    for I := 0 to FRightList.Count - 1 do
      THJYRightInfo(FRightList.Objects[I]).Free;
    FRightList.Clear;
  finally
    FRightList.EndUpdate;
  end;
end;

procedure TFrmMain.ClearUserRoleRightMenu;
var
  I: Integer;
begin
  NavBar.BeginUpdate;
  try
    for I := NavBar.Groups.Count - 1 downto 0 do
      NavBar.Groups.Items[I].ClearLinks;
    NavBar.Items.Clear;
    NavBar.Groups.Clear;
  finally
    NavBar.EndUpdate;
  end;
end;

procedure TFrmMain.dxstsbr1Panels3Click(Sender: TObject);
var
  lReportRemark: string;
begin
  lReportRemark := Trim(dxstsbr1.Panels[3].Text);
  if lReportRemark <> '' then
    ShowMsg(lReportRemark);
end;

procedure TFrmMain.InitUserInfoShow;
begin
  dxstsbr1.Panels[1].Text := '用户名称：' + DataProvider.UserInfo.UserName;
  dxstsbr1.Panels[2].Text := '所属部门：' + DataProvider.UserInfo.DeptName;
  ClearUserRoleRightMenu;
  ClearUserRoleRight;
  if LoadUserRoleRight then
  begin
    LoadUserRoleRightMenu;
  end;
  InitNarBarStyle;
end;

procedure TFrmMain.AddDevelportRight;
var
  lGroupGuid: string;

  procedure AddOneRight(AGuid, AParentGuid, ARightName, AFunName,
    ALibName: string; ASerialId: Integer; AImageIndex: Integer = 0);
  var
    lRightInfo: THJYRightInfo;
  begin
    lRightInfo := THJYRightInfo.Create;
    with lRightInfo do
    begin
      Guid := AGuid;
      ParentGuid := AParentGuid;
      SerialId := ASerialId;
      RightName := ARightName;
      FunName := AFunName;
      IsHide := False;
      IsModal := False;
      IsAdmin := True;
      ImageIndex := AImageIndex;
      LibName := ALibName;
    end;
    FRightList.AddObject(lRightInfo.Guid, lRightInfo);
  end;
begin
  if DataProvider.UserInfo.IsAdmin then
  begin
    if DataProvider.Config.ReadInteger('developer', 'Enabled', 0) = 1 then
    begin
      lGroupGuid := CreateGuidStr;
      AddOneRight(lGroupGuid, '', '开发者管理', '', '', 999, 18);
      AddOneRight(CreateGuidStr, lGroupGuid, '功能列表', 'TFrmRightInfo', '', 1, 19);
    end;
  end;
end;

function TFrmMain.LoadUserRoleRight: Boolean;
const
  cGetWorkerRightSQL = 'select a.* from RightInfo a '+
    ' inner join UserRight b on b.RightGuid=a.Guid '+
    ' where (a.IsHide=0 or a.IsHide is null) and b.RoleGuid=''%s''' +
    ' order by a.ParentGuid, a.SerialId';

  cGetAdminWorkerRightSQL = 'select * from RightInfo '+
    ' where IsHide=0 or IsHide is null order by ParentGuid, SerialId';
var
  lStrSql: string;
  lQuery: TClientDataSet;
  lRightInfo: THJYRightInfo;
begin
  Result := False;
  AddDevelportRight;
  lQuery := TClientDataSet.Create(nil);
  try
    if DataProvider.UserInfo.IsAdmin or DataProvider.UserInfo.IsAdminRole then
      lStrSql := cGetAdminWorkerRightSQL
    else
      lStrSql := Format(cGetWorkerRightSQL, [DataProvider.UserInfo.RoleGuid]);
    if not DataProvider.DBAccess.Query(lQuery, lStrSql) then
    begin
      ShowMsg('用户权限加载失败！');
      Exit;
    end;
    FRightList.BeginUpdate;
    try
      lQuery.First;
      while not lQuery.Eof do
      begin
        lRightInfo := THJYRightInfo.Create;
        with lRightInfo, lQuery do
        begin
          Guid := FindField('Guid').AsString;
          ParentGuid := FindField('ParentGuid').AsString;
          SerialId := FindField('SerialId').AsInteger;
          RightName := FindField('RightName').AsString;
          FunName := FindField('FunName').AsString;
          IsHide := FindField('IsHide').AsInteger = 1;
          IsModal := FindField('IsModal').AsInteger = 1;
          IsAdmin := FindField('IsAdmin').AsInteger = 1;
          ImageIndex := FindField('ImageIndex').AsInteger;
          LibName := FindField('LibName').AsString;
        end;
        FRightList.AddObject(lRightInfo.Guid, lRightInfo);
        lQuery.Next;
      end;
      Result := True;
    finally
      FRightList.EndUpdate;
    end;
  finally
    FreeAndNil(lQuery);
  end;
end;

procedure TFrmMain.LoadSelfPackage(ALibName: string);
var
  lHandle: Cardinal;
  LibIdx: Integer;
begin
  if ALibName <> '' then
  begin
    LibIdx := FLibList.IndexOfName(ALibName);
    if LibIdx = -1 then
    begin
      lHandle := LoadPackage(DataProvider.AppPath + ALibName);
      FLibList.Add(ALibName + '=' + IntToStr(lHandle));
    end;
  end;
end;

procedure TFrmMain.ShowForm(ATag: Integer; ACaption: string);
var
  lOldFormName: string;
  lFunName, lLibName: string;
  lRightInfo: THJYRightInfo;
begin
  if (ATag >= 0) and (ATag < FRightList.Count) then
  begin
    lRightInfo := THJYRightInfo(FRightList.Objects[ATag]);
    lFunName := Trim(lRightInfo.FunName);
    if lFunName = '' then
    begin
      ShowMsg('【' + lRightInfo.RightName + '】功能还未实现！');
      Exit;
    end;
    if DataProvider.UserInfo.IsAdmin and not lRightInfo.IsAdmin then
    begin
      ShowMsg('【admin】用户不允许操作此功能！');
      Exit;
    end;
    if SameText(FFormName, lFunName) then Exit;
    lOldFormName := FFormName;
    FFormName := lFunName;
    lLibName := Trim(lRightInfo.LibName);
    LoadSelfPackage(lLibName);
    if lOldFormName <> '' then
      HJYFormMgr.ReleaseForm(lOldFormName);
    if lRightInfo.IsModal then
      HJYFormMgr.ShowAsModal(FFormName, Self)
    else
      HJYFormMgr.ShowAsParent(FFormName, pnlClient);
  end;
end;

procedure TFrmMain.NavBarLinkClick(Sender: TObject; ALink: TdxNavBarItemLink);
begin
  if ALink.Item.Tag > 0 then
    ShowForm(ALink.Item.Tag, ALink.Item.Caption);
end;

procedure TFrmMain.InitNarBarStyle;
var
  I: Integer;
  lGroup: TdxNavBarGroup;
begin
  NavBar.BeginUpdate;
  try
    for I := 0 to NavBar.Groups.Count - 1 do
    begin
      lGroup := NavBar.Groups[I];
      with lGroup do
      begin
        CustomStyles.Header := nbsGroupStyle;
        CustomStyles.HeaderActive := nbsGroupStyle;
        CustomStyles.HeaderActiveHotTracked := nbsGroupStyle;
        CustomStyles.HeaderActivePressed := nbsGroupStyle;
        CustomStyles.HeaderHotTracked := nbsGroupStyle;
        CustomStyles.HeaderPressed := nbsGroupStyle;
      end;
    end;
    for I := 0 to NavBar.Items.Count - 1 do
    begin
      with NavBar.Items[I] do
      begin
        CustomStyles.Item := nbsItemStyle;
        CustomStyles.ItemDisabled := nbsItemStyle;
        CustomStyles.ItemHotTracked := nbsItemStyle;
        CustomStyles.ItemPressed := nbsItemStyle;
      end;
    end;
  finally
    NavBar.EndUpdate;
  end;
end;

initialization
  dxNavBarViewsFactory.RegisterView(dxNavBarModernizedAccordionViewID,
    'ModernizedAccordionView', TdxNavBarModernizedAccordionViewPainter);

finalization
  dxNavBarViewsFactory.UnRegisterView(dxNavBarModernizedAccordionViewID);

end.

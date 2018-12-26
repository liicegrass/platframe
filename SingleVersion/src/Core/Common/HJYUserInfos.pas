unit HJYUserInfos;

interface

uses SysUtils;

type
  THJYUserInfo = class(TObject)
  private
    FGuid: string;
    FUserCode: string;
    FUserName: string;
    FUserPass: string;
    FPhone: string;
    FAddress: string;
    FIsStop: Integer;
    FRemark: string;

    FDeptGuid: string;
    FDeptCode: string;
    FDeptName: string;

    FRoleGuid: string;
    FRoleCode: string;
    FRoleName: string;
  public
    function IsAdmin: Boolean;
    function IsAdminRole: Boolean;
    property Guid: string read FGuid write FGuid;
    property UserCode: string read FUserCode write FUserCode;
    property UserName: string read FUserName write FUserName;
    property UserPass: string read FUserPass write FUserPass;
    property Phone: string read FPhone write FPhone;
    property Address: string read FAddress write FAddress;
    property IsStop: Integer read FIsStop write FIsStop;
    property Remark: string read FRemark write FRemark;

    property DeptGuid: string read FDeptGuid write FDeptGuid;
    property DeptCode: string read FDeptCode write FDeptCode;
    property DeptName: string read FDeptName write FDeptName;

    property RoleGuid: string read FRoleGuid write FRoleGuid;
    property RoleCode: string read FRoleCode write FRoleCode;
    property RoleName: string read FRoleName write FRoleName;
  end;

  THJYRightInfo = class
  private
    FGuid: string;
    FParentGuid: string;
    FSerialId: Integer;
    FRightName: string;
    FFunName: string;
    FLibName: string;
    FIsModal: Boolean;
    FIsHide: Boolean;
    FIsAdmin: Boolean;
    FImageIndex: Integer;
  public
    property Guid: string read FGuid write FGuid;
    property ParentGuid: string read FParentGuid write FParentGuid;
    property SerialId: Integer read FSerialId write FSerialId;
    property RightName: string read FRightName write FRightName;
    property FunName: string read FFunName write FFunName;
    property LibName: string read FLibName write FLibName;
    property IsHide: Boolean read FIsHide write FIsHide;
    // 是否弹窗显示
    property IsModal: Boolean read FIsModal write FIsModal;
    // 是否允许 admin 用户操作，业务功能不建议admin操作
    property IsAdmin: Boolean read FIsAdmin write FIsAdmin;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
  end;

implementation

{ THJYUserInfo }

function THJYUserInfo.IsAdmin: Boolean;
begin
  Result := SameText(FUserCode, 'admin');
end;

function THJYUserInfo.IsAdminRole: Boolean;
begin
  Result := SameText(FRoleCode, 'admin');
end;

end.

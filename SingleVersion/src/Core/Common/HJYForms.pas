unit HJYForms;

interface

uses Classes, SysUtils, Forms, Controls;

type
  THJYFormClass = class of THJYForm;

  THJYForm = class(TForm)
  private
    FData: Pointer;
  protected
    procedure SetData(const Value: Pointer); virtual;
  public
    function BeforeClose(Sender: TObject): Boolean; virtual;
    procedure BeforeActivate; virtual;
    property Data: Pointer read FData write SetData;
  end;

  THJYFormManager = class(TObject)
  private
    FFormList: TStrings;
    FRegistry: TStrings;
    procedure ClearForms;
    function FindFormClass(const AName: string): THJYFormClass;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function ShowAsParent(AName: string; AParent: TWinControl): THJYForm;
    function ShowAsModal(AName: string; AOwner: TComponent = nil): Boolean; overload;
    function ShowAsModal(AName: string; AData: Pointer;
      AOwner: TComponent = nil): Boolean; overload;
    procedure ReleaseForm(AName: string);
    procedure RegisterFormClass(AFormClass: THJYFormClass; AName: string = '');
  end;

function HJYFormMgr: THJYFormManager;

implementation

var
  FHJYFormManager: THJYFormManager;

function HJYFormMgr: THJYFormManager;
begin
  if not Assigned(FHJYFormManager) then
    FHJYFormManager := THJYFormManager.Create;
  Result := FHJYFormManager;
end;

{ THJYFormManager }

procedure THJYFormManager.RegisterFormClass(AFormClass: THJYFormClass; AName: string);
var
  lName: string;
begin
  Assert(Assigned(AFormClass));
  if SameText(AName, EmptyStr) then
    lName := AFormClass.ClassName
  else
    lName := AName;
  if FRegistry.IndexOf(lName) >= 0 then
    raise Exception.CreateFmt('HJYForm class "%s" already registered!',
      [AFormClass.ClassName]);
  FRegistry.AddObject(lName, TObject(AFormClass));
end;

procedure THJYFormManager.ClearForms;
var
  I: Integer;
begin
  for I := FFormList.Count - 1 downto 0 do
    THJYForm(FFormList.Objects[I]).Free;
  FFormList.Clear;
end;

constructor THJYFormManager.Create;
begin
  FRegistry := TStringList.Create;
  FFormList := TStringList.Create;
end;

destructor THJYFormManager.Destroy;
begin
  ClearForms;
  FFormList.Free;
  FRegistry.Free;
  inherited;
end;

procedure THJYFormManager.ReleaseForm(AName: string);
var
  Idx: Integer;
begin
  Idx := FFormList.IndexOf(AName);
  if Idx >= 0 then
  begin
    THJYForm(FFormList.Objects[Idx]).Free;
    FFormList.Delete(Idx);
  end;
end;

function THJYFormManager.FindFormClass(const AName: string): THJYFormClass;
var
  Index: Integer;
begin
  Index := FRegistry.IndexOf(AName);
  if Index >= 0 then
    Result := THJYFormClass(FRegistry.Objects[Index])
  else
    Result := nil;
  if not Assigned(Result) then
    raise Exception.Create('Î´×¢²á¡¾' + AName + '¡¿²å¼þ£¡');
end;

function THJYFormManager.ShowAsModal(AName: string; AOwner: TComponent): Boolean;
var
  FormClass: THJYFormClass;
  Form: THJYForm;
begin
  FormClass := FindFormClass(AName);
  Form := FormClass.Create(AOwner);
  try
    Result := Form.ShowModal = mrOk;
  finally
    FreeAndNil(Form);
  end;
end;

function THJYFormManager.ShowAsModal(AName: string;
  AData: Pointer; AOwner: TComponent): Boolean;
var
  FormClass: THJYFormClass;
  Form: THJYForm;
begin
  FormClass := FindFormClass(AName);
  Form := FormClass.Create(AOwner);
  try
    Form.Data := AData;
    Result := Form.ShowModal = mrOk;
  finally
    FreeAndNil(Form);
  end;
end;

function THJYFormManager.ShowAsParent(AName: string;
  AParent: TWinControl): THJYForm;
const
  CFormNameFmt = '%s_%d';
var
  FormClass: THJYFormClass;
begin
  FormClass := FindFormClass(AName);
  Result := FormClass.Create(AParent);
  Result.Name := Format(CFormNameFmt, [Result.Name, Result.Handle]);
  Result.BorderStyle := bsNone;
  Result.Parent := AParent;
  Result.Align := alClient;
  Result.Show;
  FFormList.AddObject(AName, Result);
end;

{ THJYForm }

procedure THJYForm.BeforeActivate;
begin

end;

function THJYForm.BeforeClose(Sender: TObject): Boolean;
begin
  Result := True;
end;

procedure THJYForm.SetData(const Value: Pointer);
begin
  FData := Value;
end;

initialization

finalization
  if Assigned(FHJYFormManager) then
    FreeAndNil(FHJYFormManager);

end.

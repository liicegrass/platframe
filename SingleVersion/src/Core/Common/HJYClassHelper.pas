unit HJYClassHelper;

interface

uses Windows, SysUtils, dxSpreadSheetCore, cxGridTableView, cxCurrencyEdit, cxSpinEdit,
  cxGridCustomTableView, Variants, Generics.Collections, cxTL;

type
  TdxSpreadSheetCellHelper = class helper for TdxSpreadSheetCell
  public
    procedure ClearFormula;
  end;

  TdxSpreadSheetTableColumnHelper = class helper for TdxSpreadSheetTableColumn
  public
    procedure ApplyBestFitEx;
  end;

  TdxSpreadSheetTableViewHelper = class helper for TdxSpreadSheetTableView
  public
    function FindRowIndexByTagName(ATagName: string;
      AColumnIndex: Integer = 0): Integer;

    function GetCellString(ARow, ACol: Integer; ADefault: string = ''): string;
    function GetCellFloat(ARow, ACol: Integer; ADefault: Double = 0): Double;
    function GetCellCurrency(ARow, ACol: Integer; ADefault: Currency = 0): Currency;
    function GetCellInteger(ARow, ACol: Integer; ADefault: Integer = 0): Integer;
    function GetCellVariant(ARow, ACol: Integer): Variant;

    function GetCellDateTimeStr(ARow, ACol: Integer): string;
    function GetCellDateStr(ARow, ACol: Integer): string;

    function CellIsNull(ARow, ACol: Integer): Boolean;
    function DoGetCells(ARow, ACol: Integer): TdxSpreadSheetCell;
    procedure ClearCellFormula(ARow, ACol: Integer);
    procedure SetCellLocked(ARow, ACol: Integer; ALocked: Boolean = True);

    function GetFirstCellInMergeArea(ARow, ACol: Integer): TdxSpreadSheetCell;
    function GetMergeCellString(ARow, ACol: Integer; ADefault: string = ''): string;
  end;

  TcxGridTableViewHelper = class helper for TcxGridTableView
  private
    procedure ColumnGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
  public
    procedure HideZero;
  end;

  TcxTreeListHelper = class helper for TcxCustomTreeList
  public
    procedure ShowCheckBox(AShow: Boolean = True);
    function Search(AText: string; AColumn: TcxTreeListColumn; ACycle: Boolean = True): Boolean;
  end;

implementation

{ TdxSpreadSheetCellHelper }

procedure TdxSpreadSheetCellHelper.ClearFormula;
begin
  if IsFormula then
    PObject(@FData)^.Free;
end;

{ TdxSpreadSheetTableColumnHelper }

procedure TdxSpreadSheetTableColumnHelper.ApplyBestFitEx;
var
  ASize: Integer;
begin
  if Visible then
  begin
    ASize := CalculateBestFit;
    if ASize = 0 then
      ASize := Owner.DefaultSize;
    if ASize > Size then
      SetSize(ASize);
    IsCustomSize := False;
  end;
end;

{ TdxSpreadSheetTableViewHelper }

function TdxSpreadSheetTableViewHelper.CellIsNull(ARow, ACol: Integer): Boolean;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) then
    Result := VarIsEmpty(lCell.AsVariant) or VarIsNull(lCell.AsVariant)
  else
    Result := True;
end;

procedure TdxSpreadSheetTableViewHelper.ClearCellFormula(ARow, ACol: Integer);
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  lCell.ClearFormula;
end;

function TdxSpreadSheetTableViewHelper.DoGetCells(ARow,
  ACol: Integer): TdxSpreadSheetCell;
begin
  Result := Cells[ARow, ACol];
  if Result = nil then
    Result:= CreateCell(ARow, ACol);
end;

function TdxSpreadSheetTableViewHelper.FindRowIndexByTagName(ATagName: string;
  AColumnIndex: Integer): Integer;
var
  I: Integer;
  lCell: TdxSpreadSheetCell;
begin
  for I := 0 to Rows.Count - 1 do
  begin
    lCell := GetFirstCellInMergeArea(I, AColumnIndex); //Cells[I, AColumnIndex];
    if Assigned(lCell) and SameText(ATagName, Trim(lCell.AsString)) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TdxSpreadSheetTableViewHelper.GetCellCurrency(ARow, ACol: Integer;
  ADefault: Currency): Currency;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) then
    Result := lCell.AsCurrency
  else
    Result := ADefault;
end;

function TdxSpreadSheetTableViewHelper.GetCellDateTimeStr(ARow, ACol: Integer): string;
var
  lStr: string;
  lDt: TDateTime;
begin
  lStr := Trim(GetCellString(ARow, ACol));
  if (lStr <> '') and TryStrToDateTime(lStr, lDt) then
    Result := QuotedStr(DateTimeToStr(lDt))
  else
    Result := 'null';
end;

function TdxSpreadSheetTableViewHelper.GetCellDateStr(ARow, ACol: Integer): string;
var
  lStr: string;
  lDt: TDateTime;
  lCell: TdxSpreadSheetCell;
begin
  Result := 'null';
  lCell := Cells[ARow, ACol];
  if not Assigned(lCell) then
    Exit;
  lStr := Trim(lCell.AsString);
  if (lStr <> '') then
  begin
    if TryStrToDate(lStr, lDt) then
      Result := QuotedStr(DateToStr(lDt))
    else
    begin
      try
        Result := QuotedStr(DateToStr(lCell.AsDateTime));
      except
        Result := 'null';
      end;
    end;
  end;
end;

function TdxSpreadSheetTableViewHelper.GetCellFloat(ARow, ACol: Integer;
  ADefault: Double): Double;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) and (Trim(lCell.AsString) <> '#DIV/0!') then
    Result := lCell.AsFloat
  else
    Result := ADefault;
end;

function TdxSpreadSheetTableViewHelper.GetCellInteger(ARow, ACol: Integer;
  ADefault: Integer): Integer;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) then
    Result := lCell.AsInteger
  else
    Result := ADefault;
end;

function TdxSpreadSheetTableViewHelper.GetCellString(ARow, ACol: Integer;
  ADefault: string): string;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) then
    Result := lCell.AsString
  else
    Result := ADefault;
end;

function TdxSpreadSheetTableViewHelper.GetCellVariant(ARow, ACol: Integer): Variant;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := Cells[ARow, ACol];
  if Assigned(lCell) then
    Result := lCell.AsVariant
  else
    Result := Null;
end;

function TdxSpreadSheetTableViewHelper.GetFirstCellInMergeArea(ARow,
  ACol: Integer): TdxSpreadSheetCell;
var
  ACoordinates: TPoint;
begin
  if Assigned(MergedCells) then
  begin
    ACoordinates := MergedCells.CheckCell(ARow, ACol).TopLeft;
    Result := Cells[ACoordinates.Y, ACoordinates.X];
  end
  else
    Result := nil;
end;

function TdxSpreadSheetTableViewHelper.GetMergeCellString(ARow, ACol: Integer;
  ADefault: string): string;
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := GetFirstCellInMergeArea(ARow, ACol);
  if Assigned(lCell) then
    Result := lCell.AsString
  else
    Result := ADefault;
end;

procedure TdxSpreadSheetTableViewHelper.SetCellLocked(ARow, ACol: Integer;
  ALocked: Boolean);
var
  lCell: TdxSpreadSheetCell;
begin
  lCell := DoGetCells(ARow, ACol);
  lCell.Style.Locked := ALocked;
end;

{ TcxGridTableViewHelper }

procedure TcxGridTableViewHelper.ColumnGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
var
  lValue: Variant;
begin
  lValue := ARecord.Values[Sender.Index];
  if VarIsNull(lValue) or VarIsEmpty(lValue) then
    AText := ''
  else if lValue = 0 then
    AText := '';
end;

procedure TcxGridTableViewHelper.HideZero;
var
  I: Integer;
  lColumn: TcxGridColumn;
begin
  for I := 0 to ColumnCount - 1 do
  begin
    lColumn := Columns[I];
    if (lColumn.PropertiesClass = TcxCurrencyEditProperties)
      or (lColumn.PropertiesClass = TcxSpinEditProperties) then
    begin
      if not Assigned(lColumn.OnGetDisplayText) then
        lColumn.OnGetDisplayText := ColumnGetDisplayText;
    end;
  end;
end;

{ TcxTreeListHelper }

function TcxTreeListHelper.Search(AText: string;
  AColumn: TcxTreeListColumn; ACycle: Boolean): Boolean;
var
  lNode: TcxTreeListNode;

  function FindNode(ABeginNode: TcxTreeListNode): TcxTreeListNode;
  begin
    Result := Self.FindNodeByText('%' + AText + '%', AColumn,
      ABeginNode, False, True, False, tlfmLike, nil, True);
  end;

begin
  lNode := FindNode(Self.FocusedNode);
  Result := Assigned(lNode);
  if (Result = False) and (ACycle = True) then
  begin
    lNode := FindNode(Self.Root);
    Result := Assigned(lNode);
    if not Result then Exit;
  end;
  Self.FocusedNode := lNode;
  Self.FocusedNode.MakeVisible;
end;

procedure TcxTreeListHelper.ShowCheckBox(AShow: Boolean);
var
  lvNode: TcxTreeListNode;
begin
  Self.BeginUpdate;
  try
    OptionsView.CheckGroups := AShow;
    Root.CheckGroupType := ncgCheckGroup;
    lvNode := Root.getFirstChild;
    while Assigned(lvNode) do
    begin
      if lvNode.HasChildren then
        lvNode.CheckGroupType := ncgCheckGroup;
      lvNode := lvNode.GetNext;
    end;
  finally
    Self.EndUpdate;
  end;
end;

end.

unit UFrmPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxDesgn, frxDBSet, DB, frxExportImage, frxExportCSV,
  frxExportRTF, frxExportXLS, frxExportHTML, frxExportPDF, frxGradient,
  frxChBox, frxCross, frxOLE, frxRich, frxBarcode;

type
  TFrmPrint = class(TForm)
    frxrprt1: TfrxReport;
    frxdsgnr1: TfrxDesigner;
    frxbrcdbjct1: TfrxBarCodeObject;
    frxrchbjct1: TfrxRichObject;
    frxlbjct1: TfrxOLEObject;
    frxcrsbjct1: TfrxCrossObject;
    frxchckbxbjct1: TfrxCheckBoxObject;
    frxgrdntbjct1: TfrxGradientObject;
    frxpdfxprt1: TfrxPDFExport;
    frxhtmlxprt1: TfrxHTMLExport;
    frxlsxprt1: TfrxXLSExport;
    frxrtfxprt1: TfrxRTFExport;
    frxcsvxprt1: TfrxCSVExport;
    frxtfxprt1: TfrxTIFFExport;
    frxjpgxprt1: TfrxJPEGExport;
    frxbmpxprt1: TfrxBMPExport;
  private
    FFileName: string;
  public
    procedure SetDataSet(DataSet: TDataSet; UserName: string = '';
      FieldAliases: TStrings = nil);
    function LoadFromFile(const FileName: string): Boolean;
    procedure ShowReport; stdcall;
    procedure DesignReport; stdcall;
    function Print: Boolean; stdcall;
  end;

var
  FrmPrint: TFrmPrint;

implementation

{$R *.dfm}

function TFrmPrint.Print: Boolean;
begin
  frxrprt1.PrepareReport;
  Result := frxrprt1.Print;
end;

procedure TFrmPrint.SetDataSet(DataSet: TDataSet; UserName: string;
  FieldAliases: TStrings);
var
  tmp: TfrxDBDataset;
begin
  tmp := TfrxDBDataset.Create(nil);
  tmp.DataSet := DataSet;
  tmp.Name := 'frxdbdtst' + DataSet.Name;
  if UserName <> '' then
    tmp.UserName := UserName;
  if Assigned(FieldAliases) and (FieldAliases.Count > 0) then
    tmp.FieldAliases.AddStrings(FieldAliases);
  InsertComponent(tmp);
end;

procedure TFrmPrint.DesignReport;
begin
  frxrprt1.DesignReport;
end;

procedure TFrmPrint.ShowReport;
begin
  frxrprt1.ShowReport;
end;

function TFrmPrint.LoadFromFile(const FileName: string): Boolean;
begin
  FFileName := FileName;
  Result := frxrprt1.LoadFromFile(FileName);
end;

end.

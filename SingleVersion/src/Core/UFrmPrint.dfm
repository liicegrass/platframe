object FrmPrint: TFrmPrint
  Left = 0
  Top = 0
  Caption = #25171#21360#31383#20307
  ClientHeight = 302
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object frxrprt1: TfrxReport
    Version = '4.10.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41810.602375277800000000
    ReportOptions.LastChange = 41812.507844976860000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 88
    Top = 16
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        Height = 26.456710000000000000
        Top = 234.330860000000000000
        Width = 718.110700000000000000
        DataSetName = #32467#31639#21333
        RowCount = 0
        Stretched = True
        object Memo11: TfrxMemoView
          Width = 94.488250000000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'GoodsID'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."GoodsID"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo12: TfrxMemoView
          Left = 94.488250000000000000
          Width = 134.283550000000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'GoodsName'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '['#32467#31639#21333'."GoodsName"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo13: TfrxMemoView
          Left = 228.535560000000000000
          Width = 83.149606300000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'LeaseDate'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."LeaseDate"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo14: TfrxMemoView
          Left = 311.803340000000000000
          Width = 83.149606300000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'ReturnDate'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."ReturnDate"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo15: TfrxMemoView
          Left = 394.953000000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'TotalDays'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."TotalDays"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo16: TfrxMemoView
          Left = 471.102660000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'Num'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."Num"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo17: TfrxMemoView
          Left = 547.252320000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'Price'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."Price"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo18: TfrxMemoView
          Left = 622.622450000000000000
          Width = 94.488250000000000000
          Height = 26.456710000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DataField = 'Amount'
          DataSetName = #32467#31639#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#32467#31639#21333'."Amount"]')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object ReportTitle1: TfrxReportTitle
        Height = 90.708720000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Left = 268.346630000000000000
          Top = 3.779530000000001000
          Width = 181.417440000000000000
          Height = 30.236240000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = #23435#20307
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            #24314#26448#31199#36161#32467#31639#21333)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo20: TfrxMemoView
          Left = 434.645950000000000000
          Top = 37.795300000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[Date]')
        end
        object Memo21: TfrxMemoView
          Left = 94.708720000000000000
          Top = 37.795300000000000000
          Width = 200.315090000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '['#32467#31639#29992#25143'."ClientName"]')
        end
        object Memo22: TfrxMemoView
          Left = 22.677180000000000000
          Top = 37.795300000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #31199#36161#21333#20301#65306)
        end
        object Memo23: TfrxMemoView
          Left = 362.834880000000000000
          Top = 37.795300000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #25171#21360#26085#26399#65306)
        end
        object Memo24: TfrxMemoView
          Left = 438.425480000000000000
          Top = 68.031540000000010000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '['#32467#31639#29992#25143'."ClassName"]')
        end
        object Memo25: TfrxMemoView
          Left = 94.488250000000000000
          Top = 68.031540000000010000
          Width = 200.315090000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '['#32467#31639#29992#25143'."Address"]')
        end
        object Memo26: TfrxMemoView
          Left = 22.456710000000000000
          Top = 68.031540000000010000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #21333#20301#22320#22336#65306)
        end
        object Memo27: TfrxMemoView
          Left = 366.614410000000000000
          Top = 68.031540000000010000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #21333#20301#36127#36131#20154#65306)
        end
        object BarCode1: TfrxBarCodeView
          Left = 570.709030000000000000
          Top = 3.779530000000001000
          Width = 129.000000000000000000
          Height = 41.574830000000000000
          ShowHint = False
          BarType = bcCode39
          DataField = 'ClientID'
          DataSetName = #32467#31639#29992#25143
          Rotation = 0
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
        end
      end
      object Header1: TfrxHeader
        Height = 26.456710000000000000
        Top = 177.637910000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Width = 94.488250000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #26448#26009#32534#21495)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          Left = 94.488250000000000000
          Width = 134.283550000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #26448#26009#21517#31216)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo4: TfrxMemoView
          Left = 228.535560000000000000
          Width = 83.149606300000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #31199#36161#26085#26399)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo5: TfrxMemoView
          Left = 311.803340000000000000
          Width = 83.149606300000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #24402#36824#26085#26399)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo6: TfrxMemoView
          Left = 394.953000000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #22825#25968)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo7: TfrxMemoView
          Left = 471.102660000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #25968#37327)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo8: TfrxMemoView
          Left = 547.252320000000000000
          Width = 75.590551180000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #21333#20215)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo9: TfrxMemoView
          Left = 622.622450000000000000
          Width = 94.488250000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #37329#39069)
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Footer1: TfrxFooter
        Height = 26.456710000000000000
        Top = 291.023810000000000000
        Width = 718.110700000000000000
        object Memo10: TfrxMemoView
          Width = 94.488250000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #21512#35745#65306)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo19: TfrxMemoView
          Left = 94.488250000000000000
          Width = 622.866141730000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[SUM(<'#32467#31639#21333'."Amount">,MasterData1)]')
          ParentFont = False
          VAlign = vaCenter
        end
      end
    end
  end
  object frxdsgnr1: TfrxDesigner
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    GradientEnd = 11982554
    GradientStart = clWindow
    TemplatesExt = 'fr3'
    Restrictions = []
    RTLLanguage = False
    MemoParentFont = False
    Left = 152
    Top = 16
  end
  object frxbrcdbjct1: TfrxBarCodeObject
    Left = 48
    Top = 88
  end
  object frxrchbjct1: TfrxRichObject
    Left = 96
    Top = 88
  end
  object frxlbjct1: TfrxOLEObject
    Left = 144
    Top = 88
  end
  object frxcrsbjct1: TfrxCrossObject
    Left = 192
    Top = 88
  end
  object frxchckbxbjct1: TfrxCheckBoxObject
    Left = 248
    Top = 88
  end
  object frxgrdntbjct1: TfrxGradientObject
    Left = 304
    Top = 88
  end
  object frxpdfxprt1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 48
    Top = 160
  end
  object frxhtmlxprt1: TfrxHTMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    FixedWidth = True
    Background = False
    Centered = False
    EmptyLines = True
    Print = False
    Left = 112
    Top = 152
  end
  object frxlsxprt1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 160
    Top = 152
  end
  object frxrtfxprt1: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 224
    Top = 152
  end
  object frxcsvxprt1: TfrxCSVExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Separator = ';'
    OEMCodepage = False
    NoSysSymbols = True
    ForcedQuotes = False
    Left = 216
    Top = 224
  end
  object frxtfxprt1: TfrxTIFFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 160
    Top = 224
  end
  object frxjpgxprt1: TfrxJPEGExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 112
    Top = 224
  end
  object frxbmpxprt1: TfrxBMPExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 56
    Top = 224
  end
end

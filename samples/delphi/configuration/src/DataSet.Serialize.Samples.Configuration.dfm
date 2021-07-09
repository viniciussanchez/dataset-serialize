object FrmSamples: TFrmSamples
  Left = 0
  Top = 0
  Caption = 'DataSet-Serialize - Samples'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 984
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Configuration'
    Color = 16091980
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 984
    Height = 165
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 242
      Top = 8
      Width = 248
      Height = 13
      Caption = 'Format date (for export field type equals ftDate):'
    end
    object Label4: TLabel
      Left = 242
      Top = 56
      Width = 289
      Height = 13
      Caption = 'Format currency (for export field type equals ftCurrency):'
    end
    object Label2: TLabel
      Left = 242
      Top = 102
      Width = 112
      Height = 13
      Caption = 'Case name definition:'
    end
    object Label3: TLabel
      Left = 601
      Top = 8
      Width = 247
      Height = 13
      Caption = 'Format time (for export field type equals ftTime):'
    end
    object Label5: TLabel
      Left = 601
      Top = 56
      Width = 297
      Height = 13
      Caption = 'Format DateTime (for export field type equals ftDateTime):'
    end
    object chkDateInputIsUTC: TCheckBox
      Left = 10
      Top = 6
      Width = 207
      Height = 17
      Caption = 'Date input is UTC (time zone)'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkDateInputIsUTCClick
    end
    object chkExportNullValues: TCheckBox
      Left = 10
      Top = 29
      Width = 207
      Height = 17
      Caption = 'Export null values'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkExportNullValuesClick
    end
    object chkExportOnlyFieldsVisible: TCheckBox
      Left = 10
      Top = 52
      Width = 207
      Height = 17
      Caption = 'Export only fields visible'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkExportOnlyFieldsVisibleClick
    end
    object edtFormatDate: TEdit
      Left = 242
      Top = 27
      Width = 289
      Height = 21
      TabOrder = 3
      Text = 'YYYY-MM-DD'
    end
    object btnApplyFormatDate: TButton
      Left = 537
      Top = 25
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 4
      OnClick = btnApplyFormatDateClick
    end
    object edtFormatCurrency: TEdit
      Left = 242
      Top = 75
      Width = 289
      Height = 21
      TabOrder = 5
      Text = '0.00##'
    end
    object btnFormatCurrency: TButton
      Left = 537
      Top = 73
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 6
      OnClick = btnFormatCurrencyClick
    end
    object chkImportOnlyFieldsVisible: TCheckBox
      Left = 10
      Top = 77
      Width = 207
      Height = 17
      Caption = 'Import only fields visible'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = chkImportOnlyFieldsVisibleClick
    end
    object chkExportEmptyDataSet: TCheckBox
      Left = 10
      Top = 100
      Width = 207
      Height = 17
      Caption = 'Export empty dataset'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = chkExportEmptyDataSetClick
    end
    object chkExportChildDataSetAsJsonObject: TCheckBox
      Left = 10
      Top = 121
      Width = 207
      Height = 17
      Hint = 
        'Child dataset needs to have just one record, if child dataset ha' +
        's more than one record it became an jsonarray again'
      Caption = 'Export child dataset as json object'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = chkExportChildDataSetAsJsonObjectClick
    end
    object cbxCaseNameDefinition: TComboBox
      Left = 242
      Top = 121
      Width = 289
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 10
      Text = 'lowerCamelCase'
      Items.Strings = (
        'None'
        'lower case'
        'UPPER CASE'
        'lowerCamelCase'
        'UpperCamelCase')
    end
    object btnCaseNameDefinition: TButton
      Left = 537
      Top = 119
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 11
      OnClick = btnCaseNameDefinitionClick
    end
    object btnApplyFormatTime: TButton
      Left = 896
      Top = 25
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 12
      OnClick = btnApplyFormatTimeClick
    end
    object edtFormatTime: TEdit
      Left = 601
      Top = 27
      Width = 289
      Height = 21
      TabOrder = 13
      Text = 'hh:nn:ss.zzz'
    end
    object edtFormatDateTime: TEdit
      Left = 601
      Top = 75
      Width = 289
      Height = 21
      TabOrder = 14
      Text = 'yyyy-mm-dd hh:nn:ss.zzz'
    end
    object btnApplyFormatDateTime: TButton
      Left = 896
      Top = 73
      Width = 58
      Height = 25
      Caption = 'Apply'
      TabOrder = 15
      OnClick = btnApplyFormatDateTimeClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 190
    Width = 984
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 200
      Height = 371
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  Fields visbile'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object chbFields: TCheckListBox
        Left = 0
        Top = 25
        Width = 200
        Height = 346
        Align = alClient
        ItemHeight = 13
        TabOrder = 1
        OnClick = chbFieldsClick
      end
    end
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 202
      Top = 0
      Width = 439
      Height = 371
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 439
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  Records'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 25
        Width = 439
        Height = 152
        Align = alTop
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Name'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_BIRTH'
            Title.Caption = 'Birthday'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SALARY'
            Title.Caption = 'Salary'
            Width = 100
            Visible = True
          end>
      end
      object Button1: TButton
        Left = 0
        Top = 336
        Width = 439
        Height = 35
        Align = alBottom
        Caption = 'ToJSONArray'
        TabOrder = 2
        OnClick = Button1Click
      end
      object DBGrid2: TDBGrid
        Left = 0
        Top = 177
        Width = 439
        Height = 159
        Align = alClient
        DataSource = dsLog
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOG'
            Title.Caption = 'Log'
            Width = 324
            Visible = True
          end>
      end
    end
    object Panel8: TPanel
      AlignWithMargins = True
      Left = 643
      Top = 0
      Width = 341
      Height = 371
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 341
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '  JSON'
        Color = 16091980
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object memoJSON: TMemo
        Left = 0
        Top = 25
        Width = 341
        Height = 346
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object dsUsers: TDataSource
    DataSet = mtUsers
    Left = 840
    Top = 375
  end
  object mtUsers: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 896
    Top = 375
    object mtUsersID: TIntegerField
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'Id'
      FieldName = 'ID'
    end
    object mtUsersNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object mtUsersDATE_BIRTH: TDateField
      FieldName = 'DATE_BIRTH'
    end
    object mtUsersSALARY: TCurrencyField
      FieldName = 'SALARY'
    end
  end
  object dsLog: TDataSource
    DataSet = mtLog
    Left = 840
    Top = 431
  end
  object mtLog: TFDMemTable
    IndexFieldNames = 'ID_USER'
    MasterSource = dsUsers
    MasterFields = 'ID'
    DetailFields = 'ID_USER'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 896
    Top = 431
    object mtLogID: TIntegerField
      FieldName = 'ID'
    end
    object mtLogID_USER: TIntegerField
      FieldName = 'ID_USER'
    end
    object mtLogLOG: TStringField
      FieldName = 'LOG'
      Size = 250
    end
  end
end
